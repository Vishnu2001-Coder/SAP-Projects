const cds = require('@sap/cds');
const { SELECT, INSERT, UPDATE } = require('@sap/cds/lib/ql/cds-ql');

module.exports = cds.service.impl(async function () {
    const { SalesOrders, Customers, Products, OrderItems, ExternalProducts } = this.entities;

    const s4= await cds.connect.to('API_PRODUCT_SRV');

    function getID(req) {
        console.log(`[getID] req.params:`, JSON.stringify(req.params));
        const p = req.params && req.params[0];
        if (!p) return null;
        if (typeof p === 'string') return p;
        return p.ID || p.id || null;
    }

   
    function isDraft(req) {
        const p = req.params && req.params[0];
        if (!p || typeof p === 'string') return false;
        return p.IsActiveEntity === false || p.IsActiveEntity === 'false';
    }

    
    function getDiscount(quantity) {
        if      (quantity >= 10) return 600;
        else if (quantity >= 5)  return 400;
        else if (quantity >= 3)  return 150;
        else                     return 0;
    }

   
    function getTax(quantity, unitPrice, taxRate) {
        return parseFloat((quantity * unitPrice * taxRate / 100).toFixed(2));
    }

    
    function getLineTotal(quantity, unitPrice, taxAmount, discount) {
        return parseFloat((quantity * unitPrice + taxAmount - discount).toFixed(2));
    }


    this.on('READ',ExternalProducts,async (req) => {
          try{
            //    const products = await s4.run(SELECT.from(ExternalProducts));
            const products = await s4.run(req.query);
               return products;
          }
          catch(err){
              return req.error(500, err.message);
          }
    })

    this.on('addCustomer', async (req) => {
        try{
            const reqData = req.data;
            const tc = cds.tx(req);
             console.log(reqData);

            for(let field in reqData){
                if(reqData[field] === null || reqData[field] === undefined || reqData[field] === "")
                    return req.error(400, `Empty field cant accept ${field}`);     
             }
             const res = await tc.run(INSERT.into(Customers).entries(reqData));
             return  req.info('Successfully added customer.');
    }
    catch(err){
        return req.error(500, err.message);
    }
});

    this.on('addProduct', async (req) => {
         try{
            const reqData = req.data;
            console.log(reqData);
            
            const tc = cds.tx(req);

            for(let field in reqData){
                if(reqData[field] === null || reqData[field] === undefined || reqData[field] === "")
                    return req.error(400, `Empty field cant accept ${field}`);     
             }
             const res = await tc.run(INSERT.into(Products).entries(reqData));
             return  req.info('Successfully added product.');
    }
    catch(err){
        return req.error(500, err.message);
    }

    });
 
    this.before(['CREATE', 'UPDATE'], 'MyService.OrderItems.drafts', async (req) => {
        try {
            const data = req.data;
            const tc   = cds.tx(req);
            const isCreate = req.event === 'CREATE';

            let product_ID = data.product_ID;
            let quantity   = data.quantity;

            // On UPDATE only — fetch existing draft to fill missing fields
            if (!isCreate && req.data.ID && (!product_ID || !quantity)) {
                const existing = await tc.run(
                    SELECT.from('MyService.OrderItems.drafts')
                        .where({ ID: req.data.ID })
                );
                if (existing && existing.length > 0) {
                    product_ID = product_ID || existing[0].product_ID;
                    quantity   = quantity   || existing[0].quantity;
                }
            }

         
            if (!product_ID || !quantity) {
                console.log(`[OrderItem DRAFT] Skipping — missing product_ID or quantity`);
                return;
            }

          
            const productInfo = await tc.run(
                SELECT.from(Products).where({ ID: product_ID })
            );
            if (!productInfo || productInfo.length === 0) {
                console.log(`[OrderItem DRAFT] Product not found: ${product_ID}`);
                return;
            }

            const product = productInfo[0];

          
            data.unitPrice = product.unitPrice;
            data.discount  = getDiscount(quantity);
            data.taxAmount = getTax(quantity, product.unitPrice, product.taxRate);
            data.lineTotal = getLineTotal(quantity, data.unitPrice, data.taxAmount, data.discount);

            console.log(
                `[OrderItem DRAFT] ${product.name} | Qty:${quantity} | ` +
                `Price:${data.unitPrice} | Tax:${data.taxAmount} | ` +
                `Discount:${data.discount} | Total:${data.lineTotal}`
            );

        } catch (err) {
         
            console.error(`[OrderItem DRAFT] Error:`, err.message);
        }
    });


    this.before('SAVE', SalesOrders, async (req) => {
        try {
            const data = req.data;
            const tc   = cds.tx(req);

            console.log(`[SAVE] SalesOrder customer_ID: ${data.customer_ID}`);

          
            if (data.customer_ID) {
                const customerInfo = await tc.run(
                    SELECT.from(Customers).where({ ID: data.customer_ID })
                );
                if (customerInfo && customerInfo.length > 0) {
                    data.shippingAddress = customerInfo[0].shippingAddress;
                }
            }

        
            data.status            = 'WaitingForConfirmation';
            data.statusCriticality = 2;
            data.orderDate         = new Date().toISOString().split('T')[0];

           
            const items = data.items;
            if (!items || items.length === 0) {
                data.totalAmount = 0;
                return;
            }

            let totalAmount = 0;

            for (let item of items) {
                if (!item.product_ID) continue;

                const productInfo = await tc.run(
                    SELECT.from(Products).where({ ID: item.product_ID })
                );
                if (!productInfo || productInfo.length === 0) {
                    return req.error(404, `Product ${item.product_ID} not found`);
                }

                const product = productInfo[0];

                item.unitPrice = product.unitPrice;
                item.discount  = getDiscount(item.quantity);
                item.taxAmount = getTax(item.quantity, product.unitPrice, product.taxRate);
                item.lineTotal = getLineTotal(item.quantity, item.unitPrice, item.taxAmount, item.discount);

                totalAmount += item.lineTotal;

                console.log(
                    `[SAVE] ${product.name} | Qty:${item.quantity} | ` +
                    `Price:${item.unitPrice} | Tax:${item.taxAmount} | ` +
                    `Discount:${item.discount} | Total:${item.lineTotal}`
                );
            }

            data.totalAmount = parseFloat(totalAmount.toFixed(2));
            console.log(`[SAVE] OrderTotal: ${data.totalAmount} | Status: ${data.status}`);

        } catch (err) {
            console.error(`[SAVE] Error:`, err.message);
            return req.error(500, err.message);
        }
    });


  
    this.on('confirmOrder', SalesOrders, async (req) => {
        try {
            const tc = cds.tx(req);
            const id = getID(req);
            console.log(`[confirmOrder] ID: ${id}`);

            if (!id)       return req.error(400, `Order ID is missing`);
            if (isDraft(req)) return req.error(400, `Please save the draft first before confirming`);

            const [order] = await tc.run(SELECT.from(SalesOrders).where({ ID: id }));
            if (!order) return req.error(404, `Order not found`);

            if (order.status !== 'WaitingForConfirmation')
                return req.error(400, `Cannot confirm. Status: '${order.status}'. Need 'WaitingForConfirmation'.`);

            const orderItems = await tc.run(SELECT.from(OrderItems).where({ order_ID: id }));
            if (!orderItems || orderItems.length === 0)
                return req.error(400, `Order has no items`);

            const [customer] = await tc.run(SELECT.from(Customers).where({ ID: order.customer_ID }));
            if (!customer) return req.error(404, `Customer not found`);

            if (Number(order.totalAmount) > Number(customer.creditLimit))
                return req.error(400, `Credit limit insufficient. Order: ₹${order.totalAmount}, Limit: ₹${customer.creditLimit}`);

            for (let item of orderItems) {
                const [product] = await tc.run(SELECT.from(Products).where({ ID: item.product_ID }));
                if (!product) return req.error(404, `Product not found`);
                if (product.stockQty < item.quantity)
                    return req.error(400, `Insufficient stock for '${product.name}'. Available: ${product.stockQty}, Requested: ${item.quantity}`);
            }

            // Reduce stock
            for (let item of orderItems) {
                const [product] = await tc.run(SELECT.from(Products).where({ ID: item.product_ID }));
                await tc.run(
                    UPDATE(Products)
                        .set({ stockQty: product.stockQty - item.quantity })
                        .where({ ID: item.product_ID })
                );
            }

            await tc.run(
                UPDATE(SalesOrders)
                    .set({
                        status           : 'Confirmed',
                        statusCriticality: 3,
                        trackingNumber   : `TRK-${Date.now()}`,                 //unique number for every  Milliseconds
                    })
                    .where({ ID: id })
            );

            return req.info(`Order confirmed! Stock updated.`);

        } catch (err) {
            console.error(`[confirmOrder] Error:`, err.message);
            return req.error(500, err.message);
        }
    });



    this.on('shipOrder', SalesOrders, async (req) => {
        try {
            const tc = cds.tx(req);
            const id = getID(req);
            console.log(`[shipOrder] ID: ${id}`);

            if (!id)       return req.error(400, `Order ID is missing`);
            if (isDraft(req)) return req.error(400, `Please save the draft first`);

            const [order] = await tc.run(SELECT.from(SalesOrders).where({ ID: id }));
            if (!order) return req.error(404, `Order not found`);

            if (order.status !== 'Confirmed')
                return req.error(400, `Cannot ship. Status: '${order.status}'. Need 'Confirmed'.`);

            await tc.run(
                UPDATE(SalesOrders)
                    .set({ status: 'Shipped', statusCriticality: 5 })
                    .where({ ID: id })
            );

            return req.info(`Order shipped!`);

        } catch (err) {
            console.error(`[shipOrder] Error:`, err.message);
            return req.error(500, err.message);
        }
    });


   
    this.on('deliverOrder', SalesOrders, async (req) => {
        try {
            const tc = cds.tx(req);
            const id = getID(req);
            console.log(`[deliverOrder] ID: ${id}`);

            if (!id)       return req.error(400, `Order ID is missing`);
            if (isDraft(req)) return req.error(400, `Please save the draft first`);

            const [order] = await tc.run(SELECT.from(SalesOrders).where({ ID: id }));
            if (!order) return req.error(404, `Order not found`);

            if (order.status !== 'Shipped')
                return req.error(400, `Cannot deliver. Status: '${order.status}'. Need 'Shipped'.`);

            const orderItems = await tc.run(SELECT.from(OrderItems).where({ order_ID: id }));
            const totalTax = orderItems.reduce((sum, i) => sum + Number(i.taxAmount || 0), 0);           //?

            const today      = new Date().toISOString().split('T')[0];
            const dueDate    = new Date();
            dueDate.setDate(dueDate.getDate() + 30);                                        //
            const dueDateStr = dueDate.toISOString().split('T')[0];

            await tc.run(
                UPDATE(SalesOrders)
                    .set({ status: 'Delivered', statusCriticality: 3, deliveryDate: today })
                    .where({ ID: id })
            );

            await tc.run(                                                                            //!!!
                INSERT.into('CustomerOrderDb.Invoices').entries({
                    salesOrder_ID: id,
                    invoiceDate  : today,
                    dueDate      : dueDateStr,
                    totalAmount  : order.totalAmount,
                    taxAmount    : parseFloat(totalTax.toFixed(2)),
                    status       : 'Pending',
                })
            );

            return req.info(`Order delivered! Invoice created (due: ${dueDateStr}).`);

        } catch (err) {
            console.error(`[deliverOrder] Error:`, err.message);
            return req.error(500, err.message);
        }
    });


  
    this.on('cancelOrder', SalesOrders, async (req) => {
        try {
            const tc = cds.tx(req);
            const id = getID(req);
            console.log(`[cancelOrder] ID: ${id}`);

            if (!id)       return req.error(400, `Order ID is missing`);
            if (isDraft(req)) return req.error(400, `Please save the draft first`);

            const [order] = await tc.run(SELECT.from(SalesOrders).where({ ID: id }));
            if (!order) return req.error(404, `Order not found`);

            if (['Delivered', 'Cancelled'].includes(order.status))
                return req.error(400, `Cannot cancel. Order is already '${order.status}'.`);

           
            if (['Confirmed', 'Shipped'].includes(order.status)) {
                const orderItems = await tc.run(SELECT.from(OrderItems).where({ order_ID: id }));
                for (let item of orderItems) {
                    const [product] = await tc.run(SELECT.from(Products).where({ ID: item.product_ID }));
                    if (product) {
                        await tc.run(
                            UPDATE(Products)
                                .set({ stockQty: product.stockQty + item.quantity })
                                .where({ ID: item.product_ID })
                        );
                    }
                }
                console.log(`[cancelOrder] Stock restored`);
            }

            await tc.run(
                UPDATE(SalesOrders)
                    .set({ status: 'Cancelled', statusCriticality: 1 })
                    .where({ ID: id })
            );

            return req.info(`Order cancelled. Stock restored.`);

        } catch (err) {
            console.error(`[cancelOrder] Error:`, err.message);
            return req.error(500, err.message);
        }
    });

});

//Note:
/*
1.composition retriving
2.every query returns an array, even if its single record, so we need to do [0] to get the first record. or we can do destructuring like const [order] = await tc.run(SELECT.from(SalesOrders).where({ ID: id })); and then use order instead of order[0]
3.if condition do opposite .
4.define and create a object and then set the values and then update or insert instead of directly updating or inserting
5.


*/




// const cds = require('@sap/cds');
// const { SELECT, INSERT, UPDATE } = require('@sap/cds/lib/ql/cds-ql');

// module.exports = cds.service.impl(async function () {
//     const { SalesOrders, Customers, Products, OrderItems, Categories } = this.entities;

//     // =====================================================================
//     // DRAFT — OrderItems: calculate on CREATE/UPDATE (when user clicks Apply)
//     // =====================================================================
//     this.before(['CREATE', 'UPDATE'], 'MyService.OrderItems.drafts', async (req) => {
//         try {
//             const data = req.data;
//             const tc = cds.tx(req);

//             let product_ID = data.product_ID;
//             let quantity   = data.quantity;

//             // Fetch missing fields from existing draft record
//             if (!product_ID || !quantity) {
//                 const existing = await tc.run(
//                     SELECT.from('MyService.OrderItems.drafts')
//                         .where({ ID: req.data.ID })
//                 );
//                 if (existing && existing.length > 0) {
//                     product_ID = product_ID || existing[0].product_ID;
//                     quantity   = quantity   || existing[0].quantity;
//                 }
//             }

//             if (!product_ID || !quantity) return;

//             // Fetch product FRESH every time
//             const productInfo = await tc.run(
//                 SELECT.from(Products).where({ ID: product_ID })
//             );
//             if (!productInfo || productInfo.length === 0) return;

//             const product = productInfo[0];

//             // ✅ Always calculate fresh from product master
//             data.unitPrice = product.unitPrice;

//             // ✅ Tax as percentage
//             data.taxAmount = parseFloat(
//                 (quantity * product.unitPrice * product.taxRate / 100).toFixed(2)
//             );

//             // Discount tiers
//             if      (quantity >= 10) data.discount = 600;
//             else if (quantity >= 5)  data.discount = 400;
//             else if (quantity >= 3)  data.discount = 150;
//             else                     data.discount = 0;

//             // ✅ lineTotal always fresh
//             data.lineTotal = parseFloat(
//                 (quantity * data.unitPrice + data.taxAmount - data.discount).toFixed(2)
//             );

//             console.log(`[OrderItem DRAFT] ${product.name} | Qty:${quantity} | Price:${data.unitPrice} | Tax:${data.taxAmount} | Discount:${data.discount} | Total:${data.lineTotal}`);

//         } catch (err) {
//             console.error(`[OrderItem DRAFT] Error:`, err.message);
//         }
//     });

//     // =====================================================================
//     // SAVE SalesOrders — recalculate everything + set status
//     // =====================================================================
//     this.before('SAVE', SalesOrders, async (req) => {
//         try {
//             const data = req.data;
//             const tc = cds.tx(req);

//             // 1. Get customer shipping address
//             if (data.customer_ID) {
//                 const customerInfo = await tc.run(
//                     SELECT.from(Customers).where({ ID: data.customer_ID })
//                 );
//                 if (customerInfo && customerInfo.length > 0) {
//                     data.shippingAddress = customerInfo[0].shippingAddress;
//                 }
//             }

//             // 2. Calculate items
//             const items = data.items;
//             if (!items || items.length === 0) {
//                 console.log(`[SAVE] No items, skipping`);
//                 return;
//             }

//             let totalAmount = 0;

//             for (let item of items) {
//                 if (!item.product_ID) continue;

//                 const productInfo = await tc.run(
//                     SELECT.from(Products).where({ ID: item.product_ID })
//                 );
//                 if (!productInfo || productInfo.length === 0) {
//                     return req.error(404, `Product ${item.product_ID} not found`);
//                 }

//                 const product = productInfo[0];

//                 item.unitPrice = product.unitPrice;

//                 // ✅ Tax as percentage
//                 item.taxAmount = parseFloat(
//                     (item.quantity * product.unitPrice * product.taxRate / 100).toFixed(2)
//                 );

//                 if      (item.quantity >= 10) item.discount = 600;
//                 else if (item.quantity >= 5)  item.discount = 400;
//                 else if (item.quantity >= 3)  item.discount = 150;
//                 else                          item.discount = 0;

//                 item.lineTotal = parseFloat(
//                     (item.quantity * item.unitPrice + item.taxAmount - item.discount).toFixed(2)
//                 );

//                 totalAmount += item.lineTotal;

//                 console.log(`[SAVE] ${product.name} | Qty:${item.quantity} | Price:${item.unitPrice} | Tax:${item.taxAmount} | Discount:${item.discount} | Total:${item.lineTotal}`);
//             }

//             // 3. Order-level fields
//             data.totalAmount      = parseFloat(totalAmount.toFixed(2));
//             data.status           = 'WaitingForConfirmation';
//             data.statusCriticality = 2;
//             data.orderDate        = new Date().toISOString().split('T')[0];

//             console.log(`[SAVE] OrderTotal: ${data.totalAmount} | Status: ${data.status}`);

//         } catch (err) {
//             console.error(`[SAVE] Error:`, err.message);
//             return req.error(500, err.message);
//         }
//     });

//     // =====================================================================
//     // BOUND ACTIONS
//     // =====================================================================

//     this.on('confirmOrder', SalesOrders, async (req) => {
//         try {
//             const tc = cds.tx(req);
//             const id = req.params[0].ID;

//             const orderDetails = await tc.run(SELECT.from(SalesOrders).where({ ID: id }));
//             if (!orderDetails?.length) return req.error(404, `Order ${id} not found`);
//             const order = orderDetails[0];

//             if (order.status !== 'WaitingForConfirmation')
//                 return req.error(400, `Cannot confirm. Status is '${order.status}'`);

//             const orderItems = await tc.run(SELECT.from(OrderItems).where({ order_ID: id }));
//             if (!orderItems?.length)
//                 return req.error(400, `Order has no items`);

//             const customer = await tc.run(SELECT.from(Customers).where({ ID: order.customer_ID }));
//             if (!customer?.length) return req.error(404, `Customer not found`);

//             if (Number(order.totalAmount) > Number(customer[0].creditLimit))
//                 return req.error(400, `Credit limit insufficient. Order: ₹${order.totalAmount}, Limit: ₹${customer[0].creditLimit}`);

//             for (let item of orderItems) {
//                 const [product] = await tc.run(SELECT.from(Products).where({ ID: item.product_ID }));
//                 if (!product) return req.error(404, `Product not found`);
//                 if (product.stockQty < item.quantity)
//                     return req.error(400, `Insufficient stock for '${product.name}'. Available: ${product.stockQty}, Requested: ${item.quantity}`);
//                 await tc.run(UPDATE(Products).set({ stockQty: product.stockQty - item.quantity }).where({ ID: item.product_ID }));
//             }

//             await tc.run(UPDATE(SalesOrders).set({
//                 status           : 'Confirmed',
//                 statusCriticality: 3,
//                 trackingNumber   : `TRK-${Date.now()}`,
//             }).where({ ID: id }));

//             return req.info(`Order confirmed! Stock updated.`);
//         } catch (err) {
//             return req.error(500, err.message);
//         }
//     });

//     this.on('shipOrder', SalesOrders, async (req) => {
//         try {
//             const tc = cds.tx(req);
//             const id = req.params[0].ID;
//             const [order] = await tc.run(SELECT.from(SalesOrders).where({ ID: id }));
//             if (!order) return req.error(404, `Order not found`);
//             if (order.status !== 'Confirmed')
//                 return req.error(400, `Cannot ship. Status is '${order.status}'`);
//             await tc.run(UPDATE(SalesOrders).set({ status: 'Shipped', statusCriticality: 5 }).where({ ID: id }));
//             return req.info(`Order shipped!`);
//         } catch (err) {
//             return req.error(500, err.message);
//         }
//     });

//     this.on('deliverOrder', SalesOrders, async (req) => {
//         try {
//             const tc = cds.tx(req);
//             const id = req.params[0].ID;
//             const [order] = await tc.run(SELECT.from(SalesOrders).where({ ID: id }));
//             if (!order) return req.error(404, `Order not found`);
//             if (order.status !== 'Shipped')
//                 return req.error(400, `Cannot deliver. Status is '${order.status}'`);

//             const orderItems = await tc.run(SELECT.from(OrderItems).where({ order_ID: id }));
//             const totalTax = orderItems.reduce((sum, i) => sum + Number(i.taxAmount || 0), 0);
//             const today = new Date().toISOString().split('T')[0];
//             const dueDate = new Date();
//             dueDate.setDate(dueDate.getDate() + 30);

//             await tc.run(UPDATE(SalesOrders).set({ status: 'Delivered', statusCriticality: 3, deliveryDate: today }).where({ ID: id }));
//             await tc.run(INSERT.into('CustomerOrderDb.Invoices').entries({
//                 salesOrder_ID: id, invoiceDate: today,
//                 dueDate: dueDate.toISOString().split('T')[0],
//                 totalAmount: order.totalAmount,
//                 taxAmount: parseFloat(totalTax.toFixed(2)),
//                 status: 'Pending',
//             }));
//             return req.info(`Order delivered! Invoice created (Net-30).`);
//         } catch (err) {
//             return req.error(500, err.message);
//         }
//     });

//     this.on('cancelOrder', SalesOrders, async (req) => {
//         try {
//             const tc = cds.tx(req);
//             const id = req.params[0].ID;
//             const [order] = await tc.run(SELECT.from(SalesOrders).where({ ID: id }));
//             if (!order) return req.error(404, `Order not found`);
//             if (['Delivered', 'Cancelled'].includes(order.status))
//                 return req.error(400, `Cannot cancel. Order is '${order.status}'`);

//             if (['Confirmed', 'Shipped'].includes(order.status)) {
//                 const orderItems = await tc.run(SELECT.from(OrderItems).where({ order_ID: id }));
//                 for (let item of orderItems) {
//                     const [product] = await tc.run(SELECT.from(Products).where({ ID: item.product_ID }));
//                     if (product) await tc.run(UPDATE(Products).set({ stockQty: product.stockQty + item.quantity }).where({ ID: item.product_ID }));
//                 }
//             }

//             await tc.run(UPDATE(SalesOrders).set({ status: 'Cancelled', statusCriticality: 1 }).where({ ID: id }));
//             return req.info(`Order cancelled. Stock restored.`);
//         } catch (err) {
//             return req.error(500, err.message);
//         }
//     });

// });//     const cds = require('@sap/cds');
//     const { SELECT, INSERT, UPDATE } = require('@sap/cds/lib/ql/cds-ql');
//     module.exports = cds.service.impl(async function () {
//     const { SalesOrders, Customers, Products, OrderItems, Categories } = this.entities;

    // this.before('CREATE', ['Customers' ,'Products' ,'Categories'], async (req) => {
    //     const entityname = req.target.name;
    //     console.log(`This is a Entity ${entityname}`);

    //     const data = req.data;
    //     for (let field in data) {
    //         if (data[field] === null || data[field] === undefined || data[field] === "") {
    //             req.error(500, `Empty field cant accept ${field}`);
    //         }
    //     }

    //     if (req.target.name === "MyService.Customers") {
    //         req.data.name = req.data.name.toUpperCase();
    //         req.data.creditLimit = 50000.00;                                              //Injecting a Value in Customers
    //     }

    //     else if (req.target.name === "MyService.Products") {
    //         const categoryInfo = await SELECT.from(Categories).where({ name: req.data.category });
    //         taxPercentage = categoryInfo[0].taxPercentage;                          //Injecting tax rate in products based on category  
    //         req.data.taxRate = req.data.unitPrice * taxPercentage / 100;
    //     }
    // })

    
    //     this.before('CREATE', 'SalesOrders', async (req) => {
    //     try {
    //         console.log(`hi this is create SalesOrders entity`);

        
    //     //   const user = req.user;
    //     //   if (!user.is('SalesManager') && !user.is('SalesRep')) {
    //     //       return req.error(403, `Access Denied: You do not have permission to create Sales Orders`);
    //     //   }

    //         const data = req.data;
    //         const tc = cds.tx(req);
    //         console.log(data);

    //         let totalAmount = 0;
    //         const items = data.items;
    //         for (let order of items) {
    //             const productInfo = await tc.run(SELECT.from(Products).where({ ID: order.product_ID }));
    //             if (!productInfo.length) {
    //                 return req.error(500, `Product with ID ${order.product_ID} does not exist`);
    //             }
    //             order.unitPrice = productInfo[0].unitPrice;

    //             const cat= productInfo[0].category;
    //             console.log(cat);
                
                
    //             order.taxAmount = order.quantity * productInfo[0].taxRate;

    //             if (order.quantity >= 3 && order.quantity < 5) {
    //                 order.discount = 150;
    //             } else if (order.quantity >= 5 && order.quantity < 10) {
    //                 order.discount = 400;
    //             } else if (order.quantity >= 10 && order.quantity < 15) {
    //                 order.discount = 600;
    //             } else {
    //                 order.discount = 0;
    //             }

    //             order.lineTotal = order.quantity * order.unitPrice + order.taxAmount - order.discount;
    //             totalAmount += order.lineTotal;
    //         }

    //         const customerInfo = await SELECT.from('Customers').where({ ID: data.customer_ID });
    //         data.shippingAddress = customerInfo[0].shippingAddress;
    //         data.totalAmount = totalAmount;
    //         data.status='WaitingForConfirmation'
    //         data.statusCriticality=2;
    //     //   await tc.run(INSERT.into(SalesOrders).entries(data));

    //         return data; 

    //     } catch (err) {
    //         return req.error(500, err.message);
    //     }
    // })

    // this.before('UPDATE', 'SalesOrders', async (req) => {
    //     try{
    //         console.log(`hi this is update SalesOrders entity`);
    //             const data = req.data;
    //         const tc = cds.tx(req);
    //         console.log(data);

    //         let totalAmount = 0;
    //         const items = data.items;
    //         for (let order of items) {
    //             const productInfo = await tc.run(SELECT.from(Products).where({ ID: order.product_ID }));
    //             if (!productInfo.length) {
    //                 return req.error(500, `Product with ID ${order.product_ID} does not exist`);
    //             }
    //             order.unitPrice = productInfo[0].unitPrice;

    //             const cat= productInfo[0].category;
    //             console.log(cat);
                
                
    //             order.taxAmount = order.quantity * productInfo[0].taxRate;

    //             if (order.quantity >= 3 && order.quantity < 5) {
    //                 order.discount = 150;
    //             } else if (order.quantity >= 5 && order.quantity < 10) {
    //                 order.discount = 400;
    //             } else if (order.quantity >= 10 && order.quantity < 15) {
    //                 order.discount = 600;
    //             } else {
    //                 order.discount = 0;
    //             }

    //             order.lineTotal = order.quantity * order.unitPrice + order.taxAmount - order.discount;
    //             totalAmount += order.lineTotal;
    //         }

    //         const customerInfo = await SELECT.from('Customers').where({ ID: data.customer_ID });
    //         data.shippingAddress = customerInfo[0].shippingAddress;
    //         data.totalAmount = totalAmount;
    //     //   await tc.run(INSERT.into(SalesOrders).entries(data));

    //         return data; 
    //         }
    //     catch(err){
    //         return req.error(500, err.message);
    //     }

    // });
    
    // //Action Handlers
    // this.on('confirmOrder', async (req) => {
    //     try {
    //         const tc = cds.tx(req);
    //         const id = req.data.orderID;
    //         console.log(id);

          
    //         if (!id) {
    //             return req.error(400, `Order ID is required`);
    //         }

    //         const orderDetails = await SELECT.from('SalesOrders').where({ ID: id });

            
    //         if (!orderDetails || orderDetails.length === 0) {
    //             return req.error(404, `Order ID ${id} not found`);
    //         }

      
    //         if (orderDetails[0].status !== 'Draft') {
    //             return req.error(400, `Order cannot be confirmed. Current status is '${orderDetails[0].status}'. Only Draft orders can be confirmed`);
    //         }

    //         console.log(orderDetails);

    //         const customer_ID = orderDetails[0].customer_ID;
    //         console.log(customer_ID);

    //         const customer = await SELECT.from(Customers).where({ ID: customer_ID });

      
    //         if (!customer || customer.length === 0) {
    //             return req.error(404, `Customer ${customer_ID} not found`);
    //         }

    //         const creditLimit = Number(customer[0].creditLimit);
    //         const orderAmount = Number(orderDetails[0].totalAmount);
    //         console.log(creditLimit, orderAmount);

           
    //         if (!orderAmount || orderAmount <= 0) {
    //             return req.error(400, `Order total amount is invalid: ${orderAmount}`);
    //         }

    //         const orderItemInfo = await SELECT.from('OrderItems').where({ order_ID: id });

           
    //         if (!orderItemInfo || orderItemInfo.length === 0) {
    //             return req.error(400, `Order ${id} has no items. Cannot confirm an empty order`);
    //         }

    //         let length = orderItemInfo.length;
    //         console.log(length);

    //         let boolean = false;

    //         if (orderAmount <= creditLimit) {
    //             for (let i = 0; i < length; i++) {
    //                 const productInfo = await SELECT.from('Products').where({ ID: orderItemInfo[i].product_ID });

                   
    //                 if (!productInfo || productInfo.length === 0) {
    //                     return req.error(404, `Product ${orderItemInfo[i].product_ID} not found`);
    //                 }

                    
    //                 if (productInfo[0].stockQty >= orderItemInfo[i].quantity) {
    //                     boolean = true;
    //                 } else {
    //                     boolean = false;
    //                     return req.error(400, `Stock is not sufficient for product '${productInfo[0].name}'. Available: ${productInfo[0].stockQty}, Requested: ${orderItemInfo[i].quantity}`);
    //                 }
    //             }
    //         } else {
    //             return req.error(400, `Credit limit is not sufficient. Order Amount: ${orderAmount}, Credit Limit: ${creditLimit}`);
    //         }

    //         if (boolean == true) {
    //             await reduceStockQty(orderItemInfo);
    //             await setOrderDate(orderDetails);
    //             return req.info(`Order is confirmed successfully`);
    //         }

    //         async function reduceStockQty(orderItemInfo) {
    //             for (let item of orderItemInfo) {
    //                 console.log(item);
    //                 const productInfo = await SELECT.from('Products').where({ ID: item.product_ID });
    //                 await tc.run(
    //                     UPDATE('Products')
    //                         .set({ stockQty: productInfo[0].stockQty - item.quantity })
    //                         .where({ ID: item.product_ID })
    //                 );
    //             }
    //         }

    //         async function setOrderDate(orderDetails) {
    //             console.log('Setting order date');
    //             const date = new Date().toISOString().split('T')[0];
    //             console.log(date);
    //             await tc.run(
    //                 UPDATE('SalesOrders')
    //                     .set({ orderDate: date, status: 'CONFIRMED' })
    //                     .where({ ID: orderDetails[0].ID })
    //             );
    //         }

    //     } catch (err) {
    //         return req.error(500, err.message);
    //     }
    // })

    // // this.after('')

    // this.on('cancelOrder', async (req) => {
    //     try{
    //     const id=req.data.orderID;
    //     const tc=cds.tx(req);
    //     const orderDetails=await SELECT.from(SalesOrders).where({ID:id});

    //     const orderItemInfo=await SELECT.from('OrderItems').where({order_ID:id});
    //     let length=orderItemInfo.length;

    //     for(let orderItem of orderItemInfo)
    //     {
    //         const quantity=orderItem.quantity;
    //         const productInfo =await SELECT.from('Products').where({ID:orderItem.product_ID});
    //         const updatedStockQty=await tc.run(UPDATE('Products').set({stockQty:productInfo[0].stockQty+quantity}).where({ID:orderItem.product_ID}));
    //     }
    //         const updatedStatus= await UPDATE('SalesOrders').set({status:'CANCELLED'}).where({ID:orderDetails[0].ID});
    //     return req.info(`Order is cancelled successfully and stock quantity is updated`);
    // }
    // catch(err){
    //     return req.error(500, err.message);
    // }
    // })


    // this.on('deliverOrder', async (req) => {
    //     try{
    //     const id = req.data.orderID;

    //     // 1. Fetch the order
    //     const orderDetails = await SELECT.from('SalesOrders').where({ ID: id });
    //     if (!orderDetails || orderDetails.length === 0) {
    //         return req.error(404, `Order ${id} not found`);
    //     }

    //     const order = orderDetails[0];

    //     // 2. Guard: only confirm-status orders can be delivered
    //     if (order.status !== 'ORDER CONFIRMED') {
    //         return req.error(400, `Only confirmed orders can be delivered. Current status: ${order.status}`);
    //     }

    //     // 3. Calculate total tax from all order items
    //     const orderItems = await SELECT.from('OrderItems').where({ order_ID: id });
    //     const totalTax = orderItems.reduce((sum, item) => sum + Number(item.taxAmount || 0), 0);

    //     // 4. Set delivery date on SalesOrder + update status
    //     const today = new Date().toISOString().split('T')[0]; // YYYY-MM-DD
    //     await UPDATE('SalesOrders')
    //         .set({
    //             status: 'ORDER DELIVERED',
    //             deliveryDate: today
    //         })
    //         .where({ ID: id });

    //     // 5. Auto-create Invoice record
    //     const dueDate = new Date();
    //     dueDate.setDate(dueDate.getDate() + 30); 
    //     const dueDateStr = dueDate.toISOString().split('T')[0];

    //     await INSERT.into('Invoices').entries({
    //         salesOrder_ID: id,
    //         invoiceDate: today,
    //         dueDate: dueDateStr,
    //         totalAmount: order.totalAmount,
    //         taxAmount: totalTax,
    //         status: 'Pending'
    //         // ID is UUID, CDS auto-generates it
    //     });
        
    //     return req.info(`Order delivered successfully. Invoice auto-created with Net-30 due date.`);
    // }
    // catch(err){
    //     return req.error(500, err.message);
    // }
    // });


    // this.on('shipOrder',async (req)=>{

    // })




    // this.on('addProducts',async (req)=>{
    //     console.log('hi');
        
    //     const customer=req.data.cus;
    //     console.log(customer);
        
    //     const res=await INSERT.into(Categories).entries(customer);
    //     return "success";

    // })
    // });


    //   if (!invoice) {
    //         return req.error(404, `Invoice ${invoiceID} not found`);
    //     }

    //cutoffDate.setDate(cutoffDate.getDate() - daysOverdue); const cutoffDateStr = cutoffDate.toISOString().split('T')[0];


    //see the nodejs
    //req.data => returns obj
    //req.data.id-=> particular data
    //const {id}=req.data particular obj

    //req.target => entity structure
    //req.target.name => servicename.entityname

    //In action ,we do array of students => req.data.students

    //Entity having 10 feilds you're sending 5 same fields in payload it will accept. extra one not maching throw error.

    //Querys
    // 1. every where query returns an array
    

    //draft entity -> entity MyService.SalesOrders.drafts (Servicename.EntityName.drafts)
    //SalesOrders(ID=9b861509-3ec7-47fe-8b56-4e8e94d586db,IsActiveEntity=false)/draftActivate

    //for sales and orderitems in UI
    // GET /SalesOrders(ID=69bbbfd4-b9e3-409e-97ac-6b09add58a2c,IsActiveEntity=false)/items(ID=28f95562-485e-496e-b612-30970322c1f8,IsActiveEntity=false) {
    //   '$select': 'DraftMessages,HasActiveEntity,HasDraftEntity,ID,IsActiveEntity,discount,lineTotal,product_ID,quantity,taxAmount,unitPrice',
    //   '$expand': 'DraftAdministrativeData($select=DraftIsCreatedByMe,DraftUUID)'
    // }



    const cds = require('@sap/cds');
    const { SELECT, INSERT, UPDATE } = require('@sap/cds/lib/ql/cds-ql');
    module.exports = cds.service.impl(async function () {
    const { SalesOrders, Customers, Products, OrderItems, Categories } = this.entities;

    this.before('CREATE', ['Customers' ,'Products' ,'Categories'], async (req) => {
        const entityname = req.target.name;
        console.log(`This is a Entity ${entityname}`);

        const data = req.data;
        for (let field in data) {
            if (data[field] === null || data[field] === undefined || data[field] === "") {
                req.error(500, `Empty field cant accept ${field}`);
            }
        }

        if (req.target.name === "MyService.Customers") {
            req.data.name = req.data.name.toUpperCase();
            req.data.creditLimit = 50000.00;                                              //Injecting a Value in Customers
        }

        else if (req.target.name === "MyService.Products") {
            const categoryInfo = await SELECT.from(Categories).where({ name: req.data.category });
            taxPercentage = categoryInfo[0].taxPercentage;                          //Injecting tax rate in products based on category  
            req.data.taxRate = req.data.unitPrice * taxPercentage / 100;
        }
    })
        this.before('CREATE', 'SalesOrders', async (req) => {
        try {
            console.log(`hi this is create SalesOrders entity`);

        
        //   const user = req.user;
        //   if (!user.is('SalesManager') && !user.is('SalesRep')) {
        //       return req.error(403, `Access Denied: You do not have permission to create Sales Orders`);
        //   }

            const data = req.data;
            const tc = cds.tx(req);
            console.log(data);

            let totalAmount = 0;
            const items = data.items;
            for (let order of items) {
                const productInfo = await tc.run(SELECT.from(Products).where({ ID: order.product_ID }));
                if (!productInfo.length) {
                    return req.error(500, `Product with ID ${order.product_ID} does not exist`);
                }
                order.unitPrice = productInfo[0].unitPrice;

                const cat= productInfo[0].category;
                console.log(cat);
                
                
                order.taxAmount = order.quantity * productInfo[0].taxRate;

                if (order.quantity >= 3 && order.quantity < 5) {
                    order.discount = 150;
                } else if (order.quantity >= 5 && order.quantity < 10) {
                    order.discount = 400;
                } else if (order.quantity >= 10 && order.quantity < 15) {
                    order.discount = 600;
                } else {
                    order.discount = 0;
                }

                order.lineTotal = order.quantity * order.unitPrice + order.taxAmount - order.discount;
                totalAmount += order.lineTotal;
            }

            const customerInfo = await SELECT.from('Customers').where({ ID: data.customer_ID });
            data.shippingAddress = customerInfo[0].shippingAddress;
            data.totalAmount = totalAmount;
        //   await tc.run(INSERT.into(SalesOrders).entries(data));

            return data; 

        } catch (err) {
            return req.error(500, err.message);
        }
    })

    this.before('UPDATE', 'SalesOrders', async (req) => {
        try{
            console.log(`hi this is update SalesOrders entity`);
                const data = req.data;
            const tc = cds.tx(req);
            console.log(data);

            let totalAmount = 0;
            const items = data.items;
            for (let order of items) {
                const productInfo = await tc.run(SELECT.from(Products).where({ ID: order.product_ID }));
                if (!productInfo.length) {
                    return req.error(500, `Product with ID ${order.product_ID} does not exist`);
                }
                order.unitPrice = productInfo[0].unitPrice;

                const cat= productInfo[0].category;
                console.log(cat);
                
                
                order.taxAmount = order.quantity * productInfo[0].taxRate;

                if (order.quantity >= 3 && order.quantity < 5) {
                    order.discount = 150;
                } else if (order.quantity >= 5 && order.quantity < 10) {
                    order.discount = 400;
                } else if (order.quantity >= 10 && order.quantity < 15) {
                    order.discount = 600;
                } else {
                    order.discount = 0;
                }

                order.lineTotal = order.quantity * order.unitPrice + order.taxAmount - order.discount;
                totalAmount += order.lineTotal;
            }

            const customerInfo = await SELECT.from('Customers').where({ ID: data.customer_ID });
            data.shippingAddress = customerInfo[0].shippingAddress;
            data.totalAmount = totalAmount;
        //   await tc.run(INSERT.into(SalesOrders).entries(data));

            return data; 
            }
        catch(err){
            return req.error(500, err.message);
        }

    });
    
    //Action Handlers
    this.on('confirmOrder', async (req) => {
        try {
            const tc = cds.tx(req);
            const id = req.data.orderID;
            console.log(id);

            // ✅ Validation 1: Order ID must be provided
            if (!id) {
                return req.error(400, `Order ID is required`);
            }

            const orderDetails = await SELECT.from('SalesOrders').where({ ID: id });

            // ✅ Validation 2: Order must exist
            if (!orderDetails || orderDetails.length === 0) {
                return req.error(404, `Order ID ${id} not found`);
            }

            // ✅ Validation 3: Order must be in Draft status to confirm
            if (orderDetails[0].status !== 'Draft') {
                return req.error(400, `Order cannot be confirmed. Current status is '${orderDetails[0].status}'. Only Draft orders can be confirmed`);
            }

            console.log(orderDetails);

            const customer_ID = orderDetails[0].customer_ID;
            console.log(customer_ID);

            const customer = await SELECT.from(Customers).where({ ID: customer_ID });

            // ✅ Validation 4: Customer must exist
            if (!customer || customer.length === 0) {
                return req.error(404, `Customer ${customer_ID} not found`);
            }

            const creditLimit = Number(customer[0].creditLimit);
            const orderAmount = Number(orderDetails[0].totalAmount);
            console.log(creditLimit, orderAmount);

            // ✅ Validation 5: Order must have a valid total amount
            if (!orderAmount || orderAmount <= 0) {
                return req.error(400, `Order total amount is invalid: ${orderAmount}`);
            }

            const orderItemInfo = await SELECT.from('OrderItems').where({ order_ID: id });

            // ✅ Validation 6: Order must have at least one item
            if (!orderItemInfo || orderItemInfo.length === 0) {
                return req.error(400, `Order ${id} has no items. Cannot confirm an empty order`);
            }

            let length = orderItemInfo.length;
            console.log(length);

            let boolean = false;

            if (orderAmount <= creditLimit) {
                for (let i = 0; i < length; i++) {
                    const productInfo = await SELECT.from('Products').where({ ID: orderItemInfo[i].product_ID });

                    //  Validation 7: Product must exist
                    if (!productInfo || productInfo.length === 0) {
                        return req.error(404, `Product ${orderItemInfo[i].product_ID} not found`);
                    }

                    //  Validation 8: Stock must be sufficient for the ordered quantity (not just >= 1)
                    if (productInfo[0].stockQty >= orderItemInfo[i].quantity) {
                        boolean = true;
                    } else {
                        boolean = false;
                        return req.error(400, `Stock is not sufficient for product '${productInfo[0].name}'. Available: ${productInfo[0].stockQty}, Requested: ${orderItemInfo[i].quantity}`);
                    }
                }
            } else {
                return req.error(400, `Credit limit is not sufficient. Order Amount: ${orderAmount}, Credit Limit: ${creditLimit}`);
            }

            if (boolean == true) {
                await reduceStockQty(orderItemInfo);
                await setOrderDate(orderDetails);
                return req.info(`Order is confirmed successfully`);
            }

            async function reduceStockQty(orderItemInfo) {
                for (let item of orderItemInfo) {
                    console.log(item);
                    const productInfo = await SELECT.from('Products').where({ ID: item.product_ID });
                    await tc.run(
                        UPDATE('Products')
                            .set({ stockQty: productInfo[0].stockQty - item.quantity })
                            .where({ ID: item.product_ID })
                    );
                }
            }

            async function setOrderDate(orderDetails) {
                console.log('Setting order date');
                const date = new Date().toISOString().split('T')[0];
                console.log(date);
                await tc.run(
                    UPDATE('SalesOrders')
                        .set({ orderDate: date, status: 'CONFIRMED' })
                        .where({ ID: orderDetails[0].ID })
                );
            }

        } catch (err) {
            return req.error(500, err.message);
        }
    })

    // this.after('')

    this.on('cancelOrder', async (req) => {
        try{
        const id=req.data.orderID;
        const tc=cds.tx(req);
        const orderDetails=await SELECT.from(SalesOrders).where({ID:id});

        const orderItemInfo=await SELECT.from('OrderItems').where({order_ID:id});
        let length=orderItemInfo.length;

        for(let orderItem of orderItemInfo)
        {
            const quantity=orderItem.quantity;
            const productInfo =await SELECT.from('Products').where({ID:orderItem.product_ID});
            const updatedStockQty=await tc.run(UPDATE('Products').set({stockQty:productInfo[0].stockQty+quantity}).where({ID:orderItem.product_ID}));
        }
            const updatedStatus= await UPDATE('SalesOrders').set({status:'CANCELLED'}).where({ID:orderDetails[0].ID});
        return req.info(`Order is cancelled successfully and stock quantity is updated`);
    }
    catch(err){
        return req.error(500, err.message);
    }
    })


    this.on('deliverOrder', async (req) => {
        try{
        const id = req.data.orderID;

        // 1. Fetch the order
        const orderDetails = await SELECT.from('SalesOrders').where({ ID: id });
        if (!orderDetails || orderDetails.length === 0) {
            return req.error(404, `Order ${id} not found`);
        }

        const order = orderDetails[0];

        // 2. Guard: only confirm-status orders can be delivered
        if (order.status !== 'ORDER CONFIRMED') {
            return req.error(400, `Only confirmed orders can be delivered. Current status: ${order.status}`);
        }

        // 3. Calculate total tax from all order items
        const orderItems = await SELECT.from('OrderItems').where({ order_ID: id });
        const totalTax = orderItems.reduce((sum, item) => sum + Number(item.taxAmount || 0), 0);

        // 4. Set delivery date on SalesOrder + update status
        const today = new Date().toISOString().split('T')[0]; // YYYY-MM-DD
        await UPDATE('SalesOrders')
            .set({
                status: 'ORDER DELIVERED',
                deliveryDate: today
            })
            .where({ ID: id });

        // 5. Auto-create Invoice record
        const dueDate = new Date();
        dueDate.setDate(dueDate.getDate() + 30); 
        const dueDateStr = dueDate.toISOString().split('T')[0];

        await INSERT.into('Invoices').entries({
            salesOrder_ID: id,
            invoiceDate: today,
            dueDate: dueDateStr,
            totalAmount: order.totalAmount,
            taxAmount: totalTax,
            status: 'Pending'
            // ID is UUID, CDS auto-generates it
        });
        
        return req.info(`Order delivered successfully. Invoice auto-created with Net-30 due date.`);
    }
    catch(err){
        return req.error(500, err.message);
    }
    });


    this.on('shipOrder',async (req)=>{

    })




    this.on('addProducts',async (req)=>{
        console.log('hi');
        
        const customer=req.data.cus;
        console.log(customer);
        
        const res=await INSERT.into(Categories).entries(customer);
        return "success";

    })
    });


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



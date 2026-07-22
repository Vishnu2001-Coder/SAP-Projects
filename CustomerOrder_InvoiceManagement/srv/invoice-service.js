const cds = require('@sap/cds');
const { SELECT, UPDATE, INSERT } = require('@sap/cds/lib/ql/cds-ql');

module.exports = cds.service.impl(async function () {
    const { Invoices, SalesOrders, Customers, OrderItems, Products } = this.entities;

    const invoiceAPI = await cds.connect.to('InvoiceApi');
    console.log("Hi Invoice",invoiceAPI);
    

    this.on('markAsPaid', async (req) => {
        try {
            const tc = cds.tx(req);


            const id = req.params?.[0]?.ID || req.params?.[0];
            const { paymentRef } = req.data;

            if (!id) return req.error(400, 'Invoice ID is missing');
            if (!paymentRef) return req.error(400, 'paymentRef is required');


            const [invoice] = await tc.run(
                SELECT.from(Invoices).where({ ID: id })
            );
            if (!invoice) return req.error(404, `Invoice ${id} not found`);
            if (invoice.status === 'Paid') return req.error(400, 'Invoice is already paid');
            if (invoice.status === 'Cancelled') return req.error(400, 'Cancelled invoice cannot be marked as paid');

            const today = new Date().toISOString().split('T')[0];

            await tc.run(
                UPDATE(Invoices)
                    .set({ status: 'Paid', paidOn: today, paymentreference: paymentRef ,statusCriticality:3})
                    .where({ ID: id })
            );

            console.log(`[markAsPaid] Invoice: ${id} | Ref: ${paymentRef} | Date: ${today}`);
            return `Invoice marked as paid successfully. Ref: ${paymentRef}`;

        } catch (err) {
            console.error('[markAsPaid] Error:', err.message);
            return req.error(500, err.message);
        }
    });

    this.on('createInvoice', async (req) => {
        try {
            const tc = cds.tx(req);
            const id = req.params[0].ID;
            console.log(id);


            if (!id) return req.error(400, 'Invoice ID is missing');

            const [invoice] = await tc.run(SELECT.from(Invoices).where({ ID: id }));
            if (!invoice) return req.error(404, `Invoice ${id} not found`);
            console.log('hi Invoice', invoice);

            console.log(invoice.salesOrder_ID);

            const salesOrderdatas = await tc.run(SELECT.one.from('SalesOrders').where({ ID: invoice.salesOrder_ID }));     //not expose in this servvice
            console.log(salesOrderdatas);

            if (!salesOrderdatas) return req.error(404, `Invoice ${invoice.salesOrder_ID} not found`);
            console.log('Hi Sales');


            const [customerdats] = await tc.run(SELECT.from('Customers').where({ ID: salesOrderdatas.customer_ID }));
            if (!customerdats) return req.error(404, `Invoice ${salesOrderdatas.customer_ID} not found`);
            console.log('Hi cust');


            const orderdatas = await tc.run(SELECT.from('OrderItems').columns(['*', { ref: ['product'], expand: ['*'] }]).where({ order_ID: invoice.salesOrder_ID }));  //Association_Name 
            if (!orderdatas) return req.error(404, `Invoice ${invoice.salesOrder_ID} not found`);
            console.log(orderdatas);


            const orderdata = orderdatas.map(item => ({
                productName: item.product.name,
                category: item.product.category,
                quantity: item.quantity,
                unitPrice: item.product.unitPrice,
                discount: item.discount,
                taxAmount: item.taxAmount,
                total: item.lineTotal
            }));

            const payload = {
                invoice_no: invoice.ID,
                invoice_date: invoice.invoiceDate,
                due_date: invoice.dueDate,
                invoice_status: invoice.status,
                tracking_no: salesOrderdatas.trackingNumber,
                payment_ref: invoice.paymentreference,
                customer_name: customerdats.name,
                customer_email: customerdats.email,
                customer_phone: customerdats.phone,
                billing_address: customerdats.billingAddress,
                items: orderdata,
                totalAmount: salesOrderdatas.totalAmount
            }
            console.log(payload);
            //  console.log("Hi Invoice",invoiceAPI);

            genInvoice(payload);

        async function genInvoice(payload){
          const res=  await invoiceAPI.send({
                method: "POST",
                path: '/v2/create-pdf?template_id=f2e77b232773cd58',
                data: payload,
                headers: {
                    "Content-Type": "application/json"
                }
            })                                                           //succesfuly send the data to pdf and rerurn a promise
        
            console.log("RESPONSE",res,"URL LINK",res.download_url);
           const url=res.download_url;
           console.log(url);

            const updat=await UPDATE(Invoices).set({invoiceLink:url}).where({ID: id});
             return req.info(`Invoice Link Generated`);
           
        }           


        } catch (err) {
            console.error('[createInvoice] Error:', err.message);
            return req.error(500, err.message);
        }
    });


    this.on('getOverdueInvoices', async (req) => {
        try {
            const { daysOverdue } = req.data;
            if (!daysOverdue || daysOverdue < 0)
                return req.error(400, 'daysOverdue must be a positive number');

            const tc = cds.tx(req);
            // const cutoff = new Date();
            // cutoff.setDate(cutoff.getDate() - daysOverdue);
            // const cutoffStr = cutoff.toISOString().split('T')[0];

              console.log(daysOverdue);
              

            const [overdueInvoices] = await tc.run(
                SELECT.from(Invoices)
                    .where({ status: 'Pending' })
                    .and('dueDate >', daysOverdue)
            );

            console.log(overdueInvoices);
            

            console.log(`[getOverdueInvoices] Found: ${overdueInvoices.length} | DueDate: ${daysOverdue} |Status :${overdueInvoices.status}`);
             req.info (`InvoiceId: ${overdueInvoices.ID} , InvoiceDate: ${overdueInvoices.invoiceDate} , DueDate :${overdueInvoices.dueDate} , Status :${overdueInvoices.status} ` )

        } catch (err) {
            console.error('[getOverdueInvoices] Error:', err.message);
            return req.error(500, err.message);
       }
    });
});

/* DSA
1.craeting seperate objects for (composition entity) Like orderItem use map.
2.In orderTem have another association entity like product use expand query , so its easy ... OR
3.Analyse which entity have forignkey or backlink, then only we fetch the entity











*/




//= (equals)     → use object  { }
//< > <= >=      → use template literal ``




/*new Date()
// → 2026-05-19T10:30:45.123Z   (full datetime object)

.toISOString()
// → "2026-05-19T10:30:45.123Z"  (converts to string)

.split('T')
// → ["2026-05-19", "10:30:45.123Z"]  (splits at 'T')

[0]
// → "2026-05-19"   (takes only DATE part, ignores time) 
// 
// HANA/SQLite date field expects this format:
"2026-05-19"        // ✅ correct
"2026-05-19T10:30"  // ❌ wrong — has time part
new Date()          // ❌ wrong — JS date object, not string*/

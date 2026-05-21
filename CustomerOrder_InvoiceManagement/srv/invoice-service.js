const cds = require('@sap/cds');
module.exports = cds.service.impl(async function (srv) {
    const { Invoices } = this.entities;



    this.on('markAsPaid', async (req) => {
        const { invoiceID, paymentRef } = req.data;
            const tc = cds.tx(req);
       
        const invoice = await SELECT.one.from('Invoices').where({ ID: invoiceID });
        if (!invoice) {
            return req.error(404, `Invoice ${invoiceID} not found`);
        }
   
        if (invoice.status === 'Paid') {
            return req.error(400, `Invoice is already paid`);
        }

        if (invoice.status === 'Cancelled') {
            return req.error(400, `Cancelled invoice cannot be marked as paid`);
        }

        const today = new Date().toISOString().split('T')[0];                                               //!!!

        await tc.run(UPDATE('Invoices')
            .set({
                status: 'Paid',
                paidOn: today,
                paymentreference: paymentRef   // field name from your schema
            })
            .where({ ID: invoiceID }));

        return req.info(`Invoice marked as paid successfully. Ref: ${paymentRef}`);
})
   


    this.on('getOverdueInvoices', async (req) => {
    const { daysOverdue } = req.data;
    console.log('hi');
    
    const cutoffDate = new Date();
    cutoffDate.setDate(cutoffDate.getDate() - daysOverdue);
    const cutoffDateStr = cutoffDate.toISOString().split('T')[0];                                       //!!!

    const overdueInvoices = await SELECT.from('Invoices')
        .where({ status: 'Pending' })
        .and(`dueDate < '${cutoffDateStr}'`);
     return overdueInvoices;
});
});




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

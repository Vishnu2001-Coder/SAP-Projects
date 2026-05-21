
using { CustomerOrderDb as db } from '../db/schema';

@(path: 'InvoiceService') 
service MyService1 @(impl: './invoice-service.js') {

    entity Invoices as projection on db.Invoices;
    action markAsPaid(invoiceID: UUID, paymentRef: String) returns String;

    function getOverdueInvoices(daysOverdue : Integer) returns array of Invoices;
}






//  @(restrict :[
//         {grant:['READ'],to :'SalesManager'},
//         {grant:'*',to :'Finance'},
//         {grant:'*',to :'Admins'}
//     ])
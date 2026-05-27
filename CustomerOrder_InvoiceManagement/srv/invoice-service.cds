using { CustomerOrderDb as db } from '../db/schema';

@(path: 'InvoiceService') 
service MyService1 @(impl: './invoice-service.js') {

    @(restrict: [
        {
            grant: ['READ'],
            to   : ['SalesManager']
        },
        {
            grant: '*',
            to   : ['Finance', 'Adminstrator']
        }
    ])
    entity Invoices as projection on db.Invoices;

    @(restrict: [{
        grant: ['markAsPaid'],
        to   : ['Finance', 'Adminstrator']
    }])
    action markAsPaid(invoiceID: UUID, paymentRef: String) returns String;

    @(restrict: [{
        grant: ['getOverdueInvoices'],
        to   : ['Finance', 'Adminstrator']
    }])
    function getOverdueInvoices(daysOverdue: Integer) returns array of Invoices;
}





//  @(restrict :[
//         {grant:['READ'],to :'SalesManager'},
//         {grant:'*',to :'Finance'},
//         {grant:'*',to :'Admins'}
//     ])
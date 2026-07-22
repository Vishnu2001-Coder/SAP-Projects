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
    entity Invoices as projection on db.Invoices actions{
        action markAsPaid( paymentRef: String) returns String;
        action createInvoice() returns String;
    };
    

    @(restrict: [{
        grant: ['getOverdueInvoices'],
        to   : ['Finance', 'Adminstrator']
    }])
    function getOverdueInvoices(daysOverdue: Date) returns array of Invoices;
  
}





//  @(restrict :[
//         {grant:['READ'],to :'SalesManager'},
//         {grant:'*',to :'Finance'},
//         {grant:'*',to :'Admins'}
//     ])
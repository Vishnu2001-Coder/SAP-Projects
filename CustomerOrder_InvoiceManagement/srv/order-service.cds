using { CustomerOrderDb as db } from '../db/schema';

@(path: 'OrderService')
service MyService @(impl: './order-service.js') {

    entity Customers as projection on db.Customers;

    entity Products  as projection on db.Products;

    @odata.draft.enabled
    entity SalesOrders as projection on db.SalesOrders
        actions {
            action confirmOrder() returns String;
            action cancelOrder()  returns String;
            action shipOrder()    returns String;
            action deliverOrder() returns String;
        };

    entity OrderItems  as projection on db.OrderItems;

    entity Categories  as projection on db.Categories;

    action addProducts(cus: array of Categories) returns String;
}





// @(restrict: [
//         {
//             grant: [
//                 'READ',
//                 'CREATE'
//             ],
//             to   : 'SalesRep'
//         },
//         {
//             grant: '*',
//             to   : 'SalesManager'
//         },
//         {
//             grant: '*',
//             to   : 'Admins'
//         }
//     ])  
using { CustomerOrderDb as db } from '../db/schema';


@(path: 'OrderService')  //service name
service MyService @(impl: './order-service.js') { //mapping to logic.js file

    entity Customers  as projection on db.Customers;

    entity Products   as projection on db.Products;

    @odata.draft.enabled
    entity SalesOrders  as projection on db.SalesOrders;

    entity OrderItems as projection on db.OrderItems;

      entity Categories as projection on db.Categories;

            action addProducts(cus: array of Categories) returns String;
    
            action confirmOrder(orderID: UUID) returns String;

            action cancelOrder(orderID: UUID)  returns String;

            action shipOrder(orderID: UUID)    returns String;

            action deliverOrder1(orderID: UUID) returns String;


            
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
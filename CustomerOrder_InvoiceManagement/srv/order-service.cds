using { CustomerOrderDb as db } from '../db/schema';

@(path: 'OrderService')
service MyService @(impl: './order-service.js') {

    entity ExternalProducts as projection on db.ExternalProducts;

    entity Customers as projection on db.Customers ;
       
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

    // type customer{
    //     customerCode: String;
    //     name:String;
    //     email:String;
    //     phone:String;
    //     billingAddress:String;
    //     shippingAddress:String;
    // }

    action addCustomer(customerCode: String,
        name:String,
        email:String,
        phone:String,
        billingAddress:String,
        shippingAddress:String) returns String;


    // type prod {
    //     productCode:String;
    //     name:String;
    //     unitPrice:Decimal(15, 2);
    //     category:String;
    //     taxRate:Decimal(15, 2);
    //     stockQty:Integer;
    //     rating:Integer;
    //     imageUrl:String;
    // }
    action addProduct( productCode:String,
        name:String,
        unitPrice:Decimal(15, 2),
        category:String,
        taxRate:Decimal(15, 2),
        stockQty:Integer,
        rating:Integer,
        imageUrl:String) returns String;

    // entity Categories  as projection on db.Categories;

 
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
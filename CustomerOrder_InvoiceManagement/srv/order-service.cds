using {CustomerOrderDb as db} from '../db/schema';

@(path: 'OrderService')
service MyService @(impl: './order-service.js') {

    entity ExternalProducts as projection on db.ExternalProducts;

    @(restrict: [
        {
            grant: [
                'READ',
                'CREATE'
            ], 
            to   : 'SalesRep'                      //add actions for sales rep only.
        },
        {
            grant: '*',
            to   : 'SalesManager'
        },
        {
            grant: '*',
            to   : 'Adminstrator'
        },

    ])
    entity Customers as projection on db.Customers;

   @(restrict:[{
             grant: ['addCustomer'],
             to   : ['SalesRep','SalesManager', 'Adminstrator']
        }])  
     action addCustomer(customerCode: String,
                       name: String,
                       email: String,
                       phone: String,
                       billingAddress: String,
                       shippingAddress: String) returns String;



   @(restrict:[
        {
            grant: [
                'READ',
                'CREATE',
                'UPDATE'
            ], 
            to   : 'SalesRep'                      //add actions for sales rep only.
        },
        {
            grant: '*',
            to   : 'SalesManager'
        },
        {
            grant: '*',
            to   : 'Adminstrator'
        },
   ])
    entity Products as projection on db.Products;

   @(restrict:[{
             grant: ['addProduct'],
             to   : ['SalesRep','SalesManager', 'Adminstrator']
        }])  
        action addProduct(productCode: String,
                      name: String,
                      unitPrice: Decimal(15, 2),
                      category: String,
                      taxRate: Decimal(15, 2),
                      stockQty: Integer,
                      rating: Integer,
                      imageUrl: String)         returns String;


    @odata.draft.enabled
    entity SalesOrders  @(restrict:[
        {
            grant: [
                'READ',
                'CREATE',
            ], 
            to   : 'SalesRep'                      //add actions for sales rep only.
        },
        {
            grant: '*',
            to   : 'SalesManager'
        },
        {
            grant: '*',
            to   : 'Adminstrator'
        },
   ]) as projection on db.SalesOrders
        actions { 
            action confirmOrder() returns String;
            action cancelOrder()  returns String;
            action shipOrder()    returns String;
            action deliverOrder() returns String;
     };

    entity OrderItems @(restrict:[
        {
            grant: [
                'READ',
                'CREATE',
                'UPDATE'
            ], 
            to   : 'SalesRep'    
        },
        {
            grant: '*',
            to   : 'SalesManager'
        },
        {
            grant: '*',
            to   : 'Adminstrator'
        }                                                    //add
    ])      as projection on db.OrderItems;


    action autoShipOrders() returns String;
    action autoDeliverOrders() returns String;

    // type customer{
    //     customerCode: String;
    //     name:String;
    //     email:String;
    //     phone:String;
    //     billingAddress:String;
    //     shippingAddress:String;
    // }

   

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


action addDats (datas: array of Products) returns String;


}




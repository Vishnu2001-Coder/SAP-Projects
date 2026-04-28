using { vehicle.db.Vehicles,vehicle.db.States} from './schema';

entity statesView as select from States { stateId };
entity vehiclesView as select from Vehicles { vehicleId };


// namespace ViewsSampleview;
 
// using {sampleviews as view} from './Schema';
 
// //Alias name
 
// entity OrderWithCustomer as select from view.Orders {
//     ID,
//     product,
//     customer.name as customerName :String
// };
 
// //Filter
 
// entity HighValueOrders as select from view.Orders {
//     ID,
//     product,
//     amount,
// } where amount > 20;
 
 
// //Like operator
 
// entity likeop as select from view.Customers {
//     ID,
//     name,
//     city,
//     //orders.product as customerProduct
// } where name like 'S%';
 
// // 'S%' --> starts with
// // '%an%' --> Middle
// // '%k' --> ends with
 
 
// //INNER JOINS  --->  return the common values which is matched in both entity
 
// entity orderjoins as select from view.Orders as O inner join view.Customers as C on O.customer_ID = C.ID {
//     O.ID as order__ID,
//     C.ID as customer_ID,
//     C.name as customerName,
//     O.product as Product_name,
//     O.amount
// };
 
// //LEFT OUTER JOIN
 
// entity leftouterjoin as select from view.Customers as C left join view.Orders as O on O.customer_ID = C.ID{
//     O.ID as order__ID,
//     C.name as Customer_Name,
//     O.product as Product_Name,
//     O.amount
// }
 
 
// //RIGHT OUTER JOIN
 
// entity rightouterjoin as select from view.Customers as C right join view.Orders as O on O.customer_ID = C.ID {
//     O.ID as Order_ID,
//     C.name as customerName,
//     O.product as Product
// }
 
 
// //FULL OUTER JOIN
 
// entity fullouterjoin as select from view.Customers as C full join view.Orders as O on C.ID = O.customer_ID{
//     O.ID as Order_ID,
//     C.name as customerName,
//     O.product as Product_Name
// }
 
 
// //CROSS JOIN
 
// entity crossjoin as select from view.Customers as C cross join view.Orders as O {
//     O.customer_ID,
//     C.name,
//     O.ID,
//     O.product
// }
 
 
// //AGGREGATION
 
// entity aggre as select from view.Orders as O {
//     O.customer_ID,
//     sum(O.amount) as totalSales,
//     count(O.customer_ID) as OrderCount
// } group by O.customer_ID;                !!! group the records -> count , sum , min, max, avg



entity aggre as select from Vehicles {
   
}
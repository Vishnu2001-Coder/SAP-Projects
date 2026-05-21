using {bookshop as db} from '../db/model';

@path: '/bookstore'
@impl: 'srv/logics.js'
service MyService {
    
    @odata.draft.enabled
    entity Customers     as projection on db.Customers;

    entity Categories    as projection on db.Categories;

    entity Authors       as projection on db.Authors;

    entity Publishers    as projection on db.Publishers;

    @odata.draft.enabled 
    entity Books         as projection on db.Books;

    @odata.draft.enabled
    entity Orders        as projection on db.Orders;

    entity OrderItems    as projection on db.OrderItems;

    entity Reviews       as projection on db.Reviews;

    entity Payments      as projection on db.Payments;

    entity Deliveries    as projection on db.Deliveries;

    entity Coupons       as projection on db.Coupons;

    entity WishlistItems as projection on db.WishlistItems;

    entity InventoryLogs as projection on db.InventoryLogs;
}

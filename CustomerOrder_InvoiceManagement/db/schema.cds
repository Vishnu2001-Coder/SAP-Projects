namespace CustomerOrderDb;

using {managed} from '@sap/cds/common';





type Category      : String enum { //!!!
    Electronics;
    Clothing;
    HomeAppliances;
    Books;
    Toys;
    Sports;
    Beauty;
    Automotive;
    Grocery;
    Health;
}

type OrderStatus   : String enum {
    Draft;
    WaitingForConfirmation;
    Confirmed;
    Shipped;
    Delivered;
    Cancelled;
}

type InvoiceStatus : String enum {
    Pending;
    Paid;
    Overdue;
    Cancelled;
}


// =========================
// CUSTOMERS
// =========================

entity Customers : managed {

    key ID              : UUID;

        customerCode    : String(20)   @assert.unique;

        name            : String(100)  @mandatory;

        email           : String(100)  @mandatory  @assert.format: '^[a-z0-9._%+-]+@(gmail\.com|yahoo\.com|outlook\.com)$';

        phone           : String(15)   @mandatory  @assert.unique  @assert.format: '^[0-9]{10}$';

        billingAddress  : String(500)  @mandatory;

        shippingAddress : String(500)  @mandatory;

        creditLimit     : Decimal(15, 2) not null default 50000.00;

        orders          : Association to many SalesOrders
                              on orders.customer = $self;
}

annotate Customers with @assert.unique: {
    customerCode: [ customerCode ],
    phone: [ phone ]
};


// =========================
// PRODUCTS
// =========================

entity Products : managed {

    key ID          : UUID;

        productCode : String(20) @readonly ;

        name        : String(100)  @readonly  ;

        unitPrice   : Decimal(15, 2) @readonly;

        @assert.range      : [
            'Electronics',
            'Clothing',
            'HomeAppliances',
            'Books',
            'Toys',
            'Sports',
            'Beauty',
            'Automotive',
            'Grocery',
            'Health'
        ]
        category    : Category      @readonly; //!!!

        taxRate     : Decimal(15, 2) @readonly;

        stockQty    : Integer      @readonly;

        rating      : Decimal(2, 1);       // 4.5 

        imageUrl    : String(500);  
}

// Unique constraint at entity level
annotate Products with @assert.unique: {
    productCode: [ productCode ]
};


// =========================
// SALES ORDERS
// =========================

entity SalesOrders : managed {

    key ID              : UUID;

        customer        : Association to Customers @mandatory;

        items           : Composition of many OrderItems
                              on items.order = $self;

        shippingAddress : String(500) @readonly;

        totalAmount     : Decimal(15, 2) @readonly;

        status          : OrderStatus default 'Draft';

        orderDate       : Date default null @readonly;

        trackingNumber  : String(50) default 'not confirm order' @readonly;

        deliveryDate    : Date default null @readonly;

        statusCriticality : Integer default 5; 

        invoice         : Association to one Invoices
                              on invoice.salesOrder = $self;
}


// =========================
// ORDER ITEMS
// =========================

entity OrderItems {

    key ID        : UUID;

        order     : Association to SalesOrders @mandatory;        

        product   : Association to Products    @mandatory;

        quantity  : Integer default 1;

        unitPrice : Decimal(15, 2) ;

        discount  : Decimal(15, 2) ;

        taxAmount : Decimal(15, 2) ;

        lineTotal : Decimal(15, 2) ;
}




// =========================
// INVOICES
// =========================

entity Invoices : managed {

    key ID          : UUID;

        salesOrder  : Association to one SalesOrders;

        invoiceDate : Date not null;

        dueDate     : Date  ;

        totalAmount : Decimal(15, 2) not null;

        taxAmount   : Decimal(15, 2);

        status      : InvoiceStatus default 'Pending';

        paidOn      : Date;

        paymentreference : String(100);
}

entity Categories {
    key ID            : UUID;
        name          : String(50) @assert.unique;
        taxPercentage : String not null;

}


/* not null (Without @)                            @mandatory,@assert.unique
1.Db level validation                              1.Service level Validate .unique ->checks the db datas while coming to payload

*/

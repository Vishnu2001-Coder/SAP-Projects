namespace bookshop;

using { managed } from '@sap/cds/common';

entity Customers : managed {

    key ID             : String;

    firstName          : localized String(50);

    lastName           : localized String(50);

    email              : String(100);

    phone              : String(15);

    password           : String(255);

    orders             : Association to many Orders
                             on orders.customer = $self;  

    reviews            : Association to many Reviews
                             on reviews.customer = $self;

    wishlistItems      : Association to many WishlistItems
                             on wishlistItems.customer = $self;
}

entity Categories : managed {

    key ID             : String;

    name               : localized String(100);

    description        : localized String(500);

    books              : Association to many Books
                             on books.category = $self;
}

entity Authors : managed {

    key ID             : String;

    name               : localized String(100);

    biography          : localized String(1000);

    email              : String(100);

    imageUrl           : String(500);

    books              : Association to many Books
                             on books.author = $self;
}

entity Publishers : managed {

    key ID             : String;

    name               : localized String(100);

    email              : String(100);

    phone              : String(15);

    address            : localized String(255);

    books              : Association to many Books
                             on books.publisher = $self;
}

entity Books : managed {

    key ID             : String;

    title              : localized String(200);

    isbn               : String(20);

    description        : localized String(2000);

    language           : String(30);

    publishDate        : Date;

    price              : Decimal(10,2);

    stock              : Integer;

    pages              : Integer;

    imageUrl           : String(500);

    averageRating      : Decimal(2,1);

    category           : Association to Categories;

    author             : Association to Authors;

    publisher          : Association to Publishers;

    reviews            : Composition of many Reviews
                             on reviews.book = $self;
}

entity Orders : managed {

    key ID             : String;

    orderNumber        : String(30);

    orderDate          : Timestamp;

    totalAmount        : Decimal(10,2);

    status             : String(30);

    paymentStatus      : String(30);

    deliveryStatus     : String(30);

    customer           : Association to Customers;

    OrderItem          :Composition of  many OrderItems on OrderItem.order=$self;
}

entity OrderItems : managed {

    key ID             : String;

    order              : Association to Orders;

    book               : Association to Books;

    quantity           : Integer;

    unitPrice          : Decimal(10,2);

    totalPrice         : Decimal(10,2);
}

entity Reviews : managed {

    key ID             : String;

    reviewText         : localized String(1000);

    rating             : Integer;

    reviewDate         : Timestamp;

    customer           : Association to Customers;

    book               : Association to Books;
}

entity Payments : managed {

    key ID             : String;

    paymentMethod      : String(30);

    paymentDate        : Timestamp;

    transactionId      : String(100);

    amount             : Decimal(10,2);

    paymentStatus      : String(30);

    order              : Association to Orders;
}

entity Deliveries : managed {

    key ID             : String;

    order              : Association to Orders;

    deliveryPartner    : localized String(100);

    trackingNumber     : String(100);

    deliveryStatus     : String(30);
}

entity Coupons : managed {

    key ID             : String;

    code               : String(20);

    description        : localized String(255);

    discountPercent    : Decimal(5,2);

    isActive           : Boolean;
}

entity WishlistItems : managed {

    key ID             : String;

    customer           : Association to Customers;

    book               : Association to Books;
}

entity InventoryLogs : managed {

    key ID             : String;

    book               : Association to Books;

    changeType         : String(20);

    quantity           : Integer;

    previousStock      : Integer;

    currentStock       : Integer;
}
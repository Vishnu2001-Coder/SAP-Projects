namespace vehicle.db;

entity Dealers {
    key dealerId   : String;
        dealerName : String;
        stateId    : String;
        state      : Association to States on state.stateId = stateId; 

        vehicles   : Association to many Vehicles on vehicles.dealer = $self;
}

entity Customers {
    key customerId      : String;
        customerName    : String;
        phn             : Integer;
        dealerId        : String;

        dealer          : Association to Dealers on dealer.dealerId = dealerId;
        
}

entity Delivery {
    key deliveryId : String;
        status     : String;

        order      : Association to Orders;
        dealer     : Association to Dealers;
}

entity Vehicles {
    key vehicleId  : String;
        modelName  : String not null;
        cur_price  : Decimal(10, 2) @mandatory;
        old_price  : Decimal(10, 2) default 0;

        dealer     : Association to Dealers;
                   
        orders     : Composition of many VehicleOrders on orders.vehicle = $self   //@assert.target;    , @assert.integerity
}

entity Orders {
    key orderId    : String;
        quantity   : Integer;

        Vehicle    : Association to many VehicleOrders on Vehicle.order=$self;
}

entity VehicleOrders {
    key id :UUID;
    vehicle :Association to Vehicles;
    order   :Association to  Orders;
}


entity States {
    key stateId      : String;
        stateName    : String;
        stateCode    : String;
}



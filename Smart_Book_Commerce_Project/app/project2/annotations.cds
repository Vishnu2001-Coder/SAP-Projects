using MyService as service from '../../srv/service';

annotate service.Orders with @(
    UI.FieldGroup #GeneratedGroup: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Label: 'ID',
                Value: ID,
            },
            {
                $Type: 'UI.DataField',
                Label: 'orderNumber',
                Value: orderNumber,
            },
            {
                $Type: 'UI.DataField',
                Label: 'orderDate',
                Value: orderDate,
            },
            {
                $Type: 'UI.DataField',
                Label: 'totalAmount',
                Value: totalAmount,
            },
            {
                $Type: 'UI.DataField',
                Label: 'status',
                Value: status,
            },
            {
                $Type: 'UI.DataField',
                Label: 'paymentStatus',
                Value: paymentStatus,
            },
            {
                $Type: 'UI.DataField',
                Label: 'deliveryStatus',
                Value: deliveryStatus,
            },
            {
                $Type: 'UI.DataField',
                Label: 'customer_ID',
                Value: customer_ID,
            },
        ],
    },
    UI.Facets                    : [
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'GeneratedFacet1',
            Label : 'General Information',
            Target: '@UI.FieldGroup#GeneratedGroup',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'GeneratedFacet2',
            Label : 'OrderItems Information',
            Target: 'OrderItem/@UI.LineItem',

        }
    ],
    UI.LineItem                  : [
        {
            $Type: 'UI.DataField',
            Label: 'ID',
            Value: ID,
        },
        {
            $Type: 'UI.DataField',
            Label: 'orderNumber',
            Value: orderNumber,
        },
        {
            $Type: 'UI.DataField',
            Label: 'orderDate',
            Value: orderDate,
        },
        {
            $Type: 'UI.DataField',
            Label: 'totalAmount',
            Value: totalAmount,
        },
        {
            $Type: 'UI.DataField',
            Label: 'status',
            Value: status,
        },
    ],
);

annotate service.Orders with {
    customer @Common.ValueList: {
        $Type         : 'Common.ValueListType',
        CollectionPath: 'Customers',
        Parameters    : [
            {
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: customer_ID,
                ValueListProperty: 'ID',
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'firstName',
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'lastName',
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'email',
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'phone',
            },
        ],
    }
};

annotate service.OrderItems with @(UI.LineItem: [
    {
        $Type: 'UI.DataField',
        Label: 'OrderItemID',
        Value: ID,
        
    },
    {
        $Type: 'UI.DataField',
        Label: 'OrderID',
        Value: order_ID,
    },
    {
        $Type: 'UI.DataField',
        Label: 'BookID',
        Value: book_ID,
    },
    {
        $Type: 'UI.DataField',
        Label: 'quantity',
        Value: quantity,
    },
    {
        $Type: 'UI.DataField',
        Label: 'UnitPrice',
        Value: unitPrice,
    },
    {
        $Type: 'UI.DataField',
        Label: 'Total',
        Value: totalPrice,
    }

])

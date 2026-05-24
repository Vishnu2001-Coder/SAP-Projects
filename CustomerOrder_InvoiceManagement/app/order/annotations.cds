using MyService as service from '../../srv/order-service';

annotate service.SalesOrders actions {

    confirmOrder @(
        Common.IsActionCritical: true,
        Common.SideEffects     : {
            TargetProperties: [
                'in/status',
                'in/statusCriticality',
                'in/trackingNumber',
                'in/orderDate',
                'in/totalAmount'
            ]
        }
    );

    shipOrder @(
        Common.IsActionCritical: true,
        Common.SideEffects     : {
            TargetProperties: [
                'in/status',
                'in/statusCriticality'
            ]
        }
    );

    deliverOrder @(
        Common.IsActionCritical: true,
        Common.SideEffects     : {
            TargetProperties: [
                'in/status',
                'in/statusCriticality',
                'in/deliveryDate'
            ]
        }
    );

    cancelOrder @(
        Common.IsActionCritical: true,
        Common.SideEffects     : {
            TargetProperties: [
                'in/status',
                'in/statusCriticality'
            ]
        }
    );
};

annotate service.SalesOrders with {
    customer @(
        Common.ValueList               : {
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
                    ValueListProperty: 'customerCode',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'name',
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
        },
        Common.ValueListWithFixedValues: false,
    );

    status @(
        Common.ValueListWithFixedValues: true,
        Common.ValueList               : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'SalesOrders',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: status,
                    ValueListProperty: 'status',
                },
            ],
        },
    );
};

annotate service.SalesOrders with @(

    UI.SelectionFields: [
        customer_ID,
        status,
        orderDate,
        totalAmount,
    ],

    UI.LineItem: [
        {
            $Type: 'UI.DataField',
            Label: 'Customer',
            Value: customer.name,
            @HTML5.CssDefaults: {width: '200px'}
        },
        {
            $Type: 'UI.DataField',
            Label: 'Total Amount (₹)',
            Value: totalAmount,
            @HTML5.CssDefaults: {width: '200px'}
        },
        {
            $Type      : 'UI.DataField',
            Label      : 'Status',
            Value      : status,
            Criticality: statusCriticality,
            @HTML5.CssDefaults: {width: '250px'}
        },
        {
            $Type: 'UI.DataField',
            Label: 'Order Date',
            Value: orderDate,
            @HTML5.CssDefaults: {width: '200px'}
        },
        {
            $Type: 'UI.DataField',
            Label: 'Tracking Number',
            Value: trackingNumber,
            @HTML5.CssDefaults: {width: '250px'}
        },
        {
            $Type             : 'UI.DataFieldForAction',
            Label             : 'Confirm',
            Action            : 'MyService.confirmOrder',
            ![@UI.Emphasized] : true,
        },
        {
            $Type : 'UI.DataFieldForAction',
            Label : 'Ship',
            Action: 'MyService.shipOrder',
        },
        {
            $Type : 'UI.DataFieldForAction',
            Label : 'Deliver',
            Action: 'MyService.deliverOrder',
        },
        {
            $Type : 'UI.DataFieldForAction',
            Label : 'Cancel',
            Action: 'MyService.cancelOrder',
        },
    ],

    UI.HeaderInfo: {
        TypeName      : 'Sales Order',
        TypeNamePlural: 'Sales Orders',
        Title         : {
            $Type: 'UI.DataField',
            Value: customer.name,
        },
        Description   : {
            $Type      : 'UI.DataField',
            Value      : status,
            Criticality: statusCriticality,
        },
        ImageUrl      : items.product.imageUrl,
    },

    UI.HeaderFacets: [
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'TotalAmountKPI',
            Target: '@UI.DataPoint#TotalAmount',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'StatusKPI',
            Target: '@UI.DataPoint#OrderStatus',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'DeliveryDateKPI',
            Target: '@UI.DataPoint#DeliveryDate',
        },
    ],

    UI.DataPoint #TotalAmount: {
        Value      : totalAmount,
        Title      : 'Total Amount (₹)',
        Criticality: statusCriticality,
    },

    UI.DataPoint #OrderStatus: {
        Value      : status,
        Title      : 'Order Status',
        Criticality: statusCriticality,
    },

    UI.DataPoint #DeliveryDate: {
        Value: deliveryDate,
        Title: 'Delivery Date',
    },

    UI.Facets: [
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'OrderInfoFacet',
            Label : 'Order Information',
            Target: '@UI.FieldGroup#OrderInfo',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'DeliveryFacet',
            Label : 'Delivery Information',
            Target: '@UI.FieldGroup#Delivery',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'ItemsFacet',
            Label : 'Order Items',
            Target: 'items/@UI.LineItem#OrderItemsTable',
        },
    ],

    UI.FieldGroup #OrderInfo: {
        $Type: 'UI.FieldGroupType',
        Label: 'Order Information',
        Data : [
            {
                $Type: 'UI.DataField',
                Label: 'Customer',
                Value: customer_ID,
            },
            {
                $Type      : 'UI.DataField',
                Label      : 'Status',
                Value      : status,
                Criticality: statusCriticality,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Order Date',
                Value: orderDate,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Total Amount (₹)',
                Value: totalAmount,
            },
        ],
    },

    UI.FieldGroup #Delivery: {
        $Type: 'UI.FieldGroupType',
        Label: 'Delivery Information',
        Data : [
            {
                $Type: 'UI.DataField',
                Label: 'Shipping Address',
                Value: shippingAddress,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Tracking Number',
                Value: trackingNumber,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Delivery Date',
                Value: deliveryDate,
            },
        ],
    },
);

annotate service.OrderItems with {
    product { imageUrl @UI.IsImageURL; }

    product @(
        Common.Text                    : product.name,
        Common.TextArrangement         : #TextOnly,
        Common.ValueList               : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'Products',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: product_ID,
                    ValueListProperty: 'ID',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'productCode',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'name',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'unitPrice',
                },
            ],
        },
        Common.ValueListWithFixedValues: false,
    );
};

annotate service.OrderItems with @Common.SideEffects#itemChange: {
    SourceProperties: ['product_ID', 'quantity'],
    TargetProperties: ['unitPrice', 'taxAmount', 'discount', 'lineTotal']
};

annotate service.OrderItems with @(

    UI.LineItem #OrderItemsTable: [
        {
            $Type : 'UI.DataField',
            Label : 'Product Image',
            Value : product.imageUrl,
            @HTML5.CssDefaults: {width: '150px'}
        },
        {
            $Type: 'UI.DataField',
            Label: 'Product',
            Value: product.name,
            @HTML5.CssDefaults: {width: '150px'}
        },
        {
            $Type: 'UI.DataField',
            Label: 'Quantity',
            Value: quantity,
            @HTML5.CssDefaults: {width: '150px'}
        },
        {
            $Type: 'UI.DataField',
            Label: 'Unit Price (₹)',
            Value: unitPrice,
            @HTML5.CssDefaults: {width: '150px'}
        },
        {
            $Type: 'UI.DataField',
            Label: 'Discount (₹)',
            Value: discount,
            @HTML5.CssDefaults: {width: '150px'}
        },
        {
            $Type: 'UI.DataField',
            Label: 'Tax Amount (₹)',
            Value: taxAmount,
            @HTML5.CssDefaults: {width: '150px'}
        },
        {
            $Type: 'UI.DataField',
            Label: 'Line Total (₹)',
            Value: lineTotal,
            @HTML5.CssDefaults: {width: '150px'}
        },
    ],

    UI.HeaderInfo: {
        TypeName      : 'Order Item',
        TypeNamePlural: 'Order Items',
        Title         : {
            $Type: 'UI.DataField',
            Value: product.name,
        },
        Description   : {
            $Type: 'UI.DataField',
            Value: product.productCode,
        },
        ImageUrl      : product.imageUrl,
    },

    UI.HeaderFacets: [
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'LineTotalKPI',
            Target: '@UI.DataPoint#LineTotal',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'QuantityKPI',
            Target: '@UI.DataPoint#Quantity',
        },
    ],

    UI.DataPoint #LineTotal: {
        Value: lineTotal,
        Title: 'Line Total (₹)',
    },

    UI.DataPoint #Quantity: {
        Value: quantity,
        Title: 'Quantity',
    },

    UI.Facets: [
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'OrderItemFacet',
            Label : 'Item Details',
            Target: '@UI.FieldGroup#OrderItem',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'ProductInfoFacet',
            Label : 'Product Information',
            Target: '@UI.FieldGroup#ProductInformation',
        },
    ],

    UI.FieldGroup #OrderItem: {
        $Type: 'UI.FieldGroupType',
        Label: 'Item Details',
        Data : [
            {
                $Type: 'UI.DataField',
                Label: 'Product',
                Value: product_ID,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Quantity',
                Value: quantity,
            }
        ],
    },

    UI.FieldGroup #ProductInformation: {
        $Type: 'UI.FieldGroupType',
        Label: 'Product Information',
        Data : [
            {
                $Type: 'UI.DataField',
                Label: 'Product Code',
                Value: product.productCode,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Product Name',
                Value: product.name,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Unit Price (₹)',
                Value: product.unitPrice,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Category',
                Value: product.category,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Tax Rate (%)',
                Value: product.taxRate,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Stock Quantity',
                Value: product.stockQty,
            },
        ],
    },
);
// using MyService as service from '../../srv/order-service';

// annotate service.SalesOrders with {


//     //  Value Help for Customer
//     customer @(
//         Common.ValueList               : {
//             $Type         : 'Common.ValueListType',
//             CollectionPath: 'Customers',
//             Parameters    : [
//                 {
//                     $Type            : 'Common.ValueListParameterInOut',
//                     LocalDataProperty: customer_ID,
//                     ValueListProperty: 'ID',
//                 },
//                 {
//                     $Type            : 'Common.ValueListParameterDisplayOnly',
//                     ValueListProperty: 'customerCode',
//                 },
//                 {
//                     $Type            : 'Common.ValueListParameterDisplayOnly',
//                     ValueListProperty: 'name',
//                 },
//                 {
//                     $Type            : 'Common.ValueListParameterDisplayOnly',
//                     ValueListProperty: 'email',
//                 },
//                 {
//                     $Type            : 'Common.ValueListParameterDisplayOnly',
//                     ValueListProperty: 'phone',
//                 },
//             ],
//         },
//         Common.ValueListWithFixedValues: false,

        
//     );

//     //  Status — fixed dropdown
//     status @(
//         Common.ValueListWithFixedValues: true,
//         Common.ValueList               : {
//             $Type         : 'Common.ValueListType',
//             CollectionPath: 'SalesOrders',
//             Parameters    : [
//                 {
//                     $Type            : 'Common.ValueListParameterInOut',
//                     LocalDataProperty: status,
//                     ValueListProperty: 'status',
//                 },
//             ],
//         },
//     );

    
// };


// annotate service.SalesOrders with @(


//     UI.SelectionFields: [
//         customer_ID,
//         status,
//         orderDate,
//         totalAmount,
//     ],


//     UI.LineItem: [
//         {
//             $Type: 'UI.DataField',
//             Label: 'Customer',
//             Value: customer.name,
//         },
//         {
//             $Type: 'UI.DataField',
//             Label: 'Image',
//             Value: items.product.imageUrl,
//         },
//         {
//             $Type: 'UI.DataField',
//             Label: 'Total Amount (₹)',
//             Value: totalAmount,
//         },
//         //  CRITICALITY — status colored
//         {
//             $Type      : 'UI.DataField',
//             Label      : 'Status',
//             Value      : status,
//             Criticality: statusCriticality,
//         },
//         //  DATE FORMATTING — auto formatted by Fiori
//         {
//             $Type: 'UI.DataField',
//             Label: 'Order Date',
//             Value: orderDate,
//         },
//         {
//             $Type: 'UI.DataField',
//             Label: 'Tracking Number',
//             Value: trackingNumber,
//         },
//         {
//             $Type: 'UI.DataField',
//             Label: 'Delivery Date',
//             Value: deliveryDate,
//         },
//         // BOUND ACTIONS — action buttons
//         {
//             $Type             : 'UI.DataFieldForAction',
//             Label             : 'Confirm Order',
//             Action            : 'MyService.EntityContainer/confirmOrder',
//             ![@UI.Emphasized] : true, // highlighted button
//         },
//         {
//             $Type : 'UI.DataFieldForAction',
//             Label : 'Ship Order',
//             Action: 'MyService.EntityContainer/shipOrder',
//         },
//         {
//             $Type : 'UI.DataFieldForAction',
//             Label : 'Deliver Order',
//             Action: 'MyService.EntityContainer/deliverOrder',
//         },
//         {
//             $Type : 'UI.DataFieldForAction',
//             Label : 'Cancel Order',
//             Action: 'MyService.EntityContainer/cancelOrder',
//         },
//     ],

//     UI.HeaderInfo: {
//         TypeName      : 'Sales Order',
//         TypeNamePlural: 'Sales Orders',
//         Title         : {
//             $Type: 'UI.DataField',
//             Value: customer_ID,
//         },
//         Description   : {
//             $Type      : 'UI.DataField',
//             Value      : status,
//             Criticality: statusCriticality,
//         },
//     },

  
//     UI.HeaderFacets: [
//         {
//             $Type : 'UI.ReferenceFacet',
//             ID    : 'TotalAmountKPI',
//             Target: '@UI.DataPoint#TotalAmount',
//         },
//         {
//             $Type : 'UI.ReferenceFacet',
//             ID    : 'StatusKPI',
//             Target: '@UI.DataPoint#OrderStatus',
//         },
//     ],

//     UI.DataPoint #TotalAmount: {
//         Value      : totalAmount,
//         Title      : 'Total Amount (₹)',
//         Criticality: statusCriticality,
//     },

//     UI.DataPoint #OrderStatus: {
//         Value      : status,
//         Title      : 'Order Status',
//         Criticality: statusCriticality,
//     },

 
//     UI.Facets: [
//         {
//             $Type : 'UI.ReferenceFacet',
//             ID    : 'OrderInfoFacet',
//             Label : 'Order Information',
//             Target: '@UI.FieldGroup#OrderInfo',
//         },
//         {
//             $Type : 'UI.ReferenceFacet',
//             ID    : 'DeliveryFacet',
//             Label : 'Delivery Information',
//             Target: '@UI.FieldGroup#Delivery',
//         },
//         //  ORDER ITEMS composition table
//         {
//             $Type : 'UI.ReferenceFacet',
//             ID    : 'ItemsFacet',
//             Label : 'Order Items',
//             Target: 'items/@UI.LineItem#line1',
//         },
//     ],

 

//     // Facet 1 — Order Information
//     UI.FieldGroup #OrderInfo: {
//         $Type: 'UI.FieldGroupType',
//         Label: 'Order Information',
//         Data : [
//             {
//                 $Type: 'UI.DataField',
//                 Label: 'Customer',
//                 Value: customer_ID,
//             },
//             {
//                 $Type      : 'UI.DataField',
//                 Label      : 'Status',
//                 Value      : status,
//                 Criticality: statusCriticality,
//             },
//             {
//                 $Type: 'UI.DataField',
//                 Label: 'Order Date',
//                 Value: orderDate,
//             },
//             {
//                 $Type: 'UI.DataField',
//                 Label: 'Total Amount (₹)',
//                 Value: totalAmount,
//             },
//         ],
//     },

//     // Facet 2 — Delivery Information
//     UI.FieldGroup #Delivery: {
//         $Type: 'UI.FieldGroupType',
//         Label: 'Delivery Information',
//         Data : [
//             {
//                 $Type: 'UI.DataField',
//                 Label: 'Shipping Address',
//                 Value: shippingAddress,
//             },
//             {
//                 $Type: 'UI.DataField',
//                 Label: 'Tracking Number',
//                 Value: trackingNumber,
//             },
//             {
//                 $Type: 'UI.DataField',
//                 Label: 'Delivery Date',
//                 Value: deliveryDate,
//             },
//         ],
//     },
// );



// annotate service.OrderItems with {

//     // Product Value Help 
//     product @(
//         Common.ValueList               : {
//             $Type         : 'Common.ValueListType',
//             CollectionPath: 'Products',
//             Parameters    : [
//                 {
//                     $Type            : 'Common.ValueListParameterInOut',
//                     LocalDataProperty: product_ID,
//                     ValueListProperty: 'ID',
//                 },
//                 {
//                     $Type            : 'Common.ValueListParameterDisplayOnly',
//                     ValueListProperty: 'productCode',
//                 },
//                 {
//                     $Type            : 'Common.ValueListParameterDisplayOnly',
//                     ValueListProperty: 'name',
//                 },
//                 {
//                     $Type            : 'Common.ValueListParameterDisplayOnly',
//                     ValueListProperty: 'unitPrice',
//                 }
//             ],
//         },
//         Common.ValueListWithFixedValues: false,
//     );
// };
// annotate service.OrderItems with @(

//     UI.LineItem #line1: [
//         {
//             $Type: 'UI.DataField',
//             Label: 'Product',
//             Value: product_ID,
//         },
//         {
//             $Type: 'UI.DataField',
//             Label: 'Quantity',
//             Value: quantity,
//         },
//         {
//             $Type: 'UI.DataField',
//             Label: 'Unit Price (₹)',
//             Value: unitPrice,
//         },
//         {
//             $Type: 'UI.DataField',
//             Label: 'Discount (₹)',
//             Value: discount,
//         },
//         {
//             $Type: 'UI.DataField',
//             Label: 'Tax Amount (₹)',
//             Value: taxAmount,
//         },
//         {
//             $Type: 'UI.DataField',
//             Label: 'Line Total (₹)',
//             Value: lineTotal,
//         },
//     ],

//     UI.HeaderFacets: [
//         {
//             $Type : 'UI.ReferenceFacet',
//             ID    : 'OrderItemHeader',
//             Label : 'Order Item Information',
//             Target: '@UI.FieldGroup#OrderItemInformation',
//         },
//     ],

//     UI.Facets: [
//         {
//             $Type : 'UI.ReferenceFacet',
//             ID    : 'OrderItemFacet',
//             Label : 'Order Item Details',
//             Target: '@UI.FieldGroup#OrderItem',
//         },
//         {
//             $Type : 'UI.ReferenceFacet',
//             ID    : 'ProductInfoFacet',
//             Label : 'Product Information',
//             Target: '@UI.FieldGroup#ProductInformation',
//         },
//     ],

//     UI.FieldGroup #OrderItemInformation: {
//         $Type: 'UI.FieldGroupType',
//         Data : [
//             {
//                 $Type: 'UI.DataField',
//                 Label: 'Product',
//                 Value: product_ID,
//             },
//             {
//                 $Type: 'UI.DataField',
//                 Label: 'Quantity',
//                 Value: quantity,
//             },
//             {
//                 $Type: 'UI.DataField',
//                 Label: 'Unit Price',
//                 Value: unitPrice,
//             },
//             {
//                 $Type: 'UI.DataField',
//                 Label: 'Discount',
//                 Value: discount,
//             },
//             {
//                 $Type: 'UI.DataField',
//                 Label: 'Tax Amount',
//                 Value: taxAmount,
//             },
//             {
//                 $Type: 'UI.DataField',
//                 Label: 'Line Total',
//                 Value: lineTotal,
//             },
//         ],
//     },

//     UI.FieldGroup #OrderItem: {
//         $Type: 'UI.FieldGroupType',
//         Data : [
//             {
//                 $Type: 'UI.DataField',
//                 Label: 'Product',
//                 Value: product_ID,
//             },
//             {
//                 $Type: 'UI.DataField',
//                 Label: 'Quantity',
//                 Value: quantity,
//             },
//         ],
//     },

//     UI.FieldGroup #ProductInformation: {
//         $Type: 'UI.FieldGroupType',
//         Data : [
//             {
//                 $Type: 'UI.DataField',
//                 Label: 'Product Code',
//                 Value: product.productCode,
//             },
//             {
//                 $Type: 'UI.DataField',
//                 Label: 'Product Name',
//                 Value: product.name,
//             },
//             {
//                 $Type: 'UI.DataField',
//                 Label: 'Unit Price',
//                 Value: product.unitPrice,
//             },
//             {
//                 $Type: 'UI.DataField',
//                 Label: 'Category',
//                 Value: product.category,
//             },
//             {
//                 $Type: 'UI.DataField',
//                 Label: 'Tax Rate',
//                 Value: product.taxRate,
//             },
//             {
//                 $Type: 'UI.DataField',
//                 Label: 'Stock Quantity',
//                 Value: product.stockQty,
//             },
//         ],
//     },
// );
using MyService1 as service from '../../srv/invoice-service';

// annotate service.Invoices with {
//     @ Common.Label: 'Invoice',
//     Common.Text: 'Invoice for Sales Order',
//     Common.ValueList: {
//         $Type         : 'Common.ValueListType',
//         CollectionPath: 'Invoices',
//         Parameters    : [
//             {
//                 $Type            : 'Common.ValueListParameterInOut',
//                 LocalDataProperty: ID,
//                 ValueListProperty: 'ID',
//             },
//             {
//                 $Type            : 'Common.ValueListParameterDisplayOnly',
//                 ValueListProperty: 'invoiceNumber',
//             },
//             {
//                 $Type            : 'Common.ValueListParameterDisplayOnly',
//                 ValueListProperty: 'totalAmount',
//             },
//         ],
//     },
//     Common.ValueListWithFixedValues: false,
// }

annotate service.Invoices with @(
     UI.FieldGroup #GeneratedGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Label : 'invoiceDate',
                Value : invoiceDate,
            },
            {
                $Type : 'UI.DataField',
                Label : 'dueDate',
                Value : dueDate,
            },
            {
                $Type : 'UI.DataField',
                Label : 'totalAmount',
                Value : totalAmount,
            },
            {
                $Type : 'UI.DataField',
                Label : 'taxAmount',
                Value : taxAmount,
            },
            {
                $Type : 'UI.DataField',
                Label : 'status',
                Value : status,
            },
            {
                $Type : 'UI.DataField',
                Label : 'paidOn',
                Value : paidOn,
            },
            {
                $Type : 'UI.DataField',
                Label : 'paymentreference',
                Value : paymentreference,
            },
        ],
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'GeneratedFacet1',
            Label : 'General Information',
            Target : '@UI.FieldGroup#GeneratedGroup',
        },
    ],
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Label : 'ID',
            Value : ID,
        },  
        {
            $Type : 'UI.DataField',
            Label : 'invoiceDate',
            Value : invoiceDate,
        },
        {
            $Type : 'UI.DataField',
            Label : 'dueDate',
            Value : dueDate,
        },
        {
            $Type : 'UI.DataField',
            Label : 'totalAmount',
            Value : totalAmount,
        },
        {
            $Type : 'UI.DataField',
            Label : 'taxAmount',
            Value : taxAmount,
        },
        {
            $Type : 'UI.DataField',
            Label : 'status',
            Value : status,
        },
        {
            $Type : 'UI.DataFieldForAction',
            Label : 'Mark as Paid',
            Action : 'MyService1.EntityContainer/markAsPaid',
        }
    ],
);


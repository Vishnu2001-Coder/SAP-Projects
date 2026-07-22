

using { MyService as service } from '../../srv/order-service';

// =============================================
// Field-level annotations for Customers
// =============================================
annotate service.Customers with {

    customerCode @(
        Common.Label        : 'Customer Code',
        Common.FieldControl : #Mandatory
    );

    name @(
        Common.Label        : 'Customer Name',
        Common.FieldControl : #Mandatory,
        Common.ValueList: {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'Customers',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: name,
                    ValueListProperty: 'name',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'customerCode',
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

    email @(
        Common.Label        : 'Email Address',
        Common.FieldControl : #Mandatory,
        Validation.Pattern  : '^[a-zA-Z0-9._%+\-]+@(gmail\.com|yahoo\.com|outlook\.com)$',
        Common.ValueList: {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'Customers',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: email,
                    ValueListProperty: 'email',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'name',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'customerCode',
                },
            ],
        },
        Common.ValueListWithFixedValues: false,
    );

    phone @(
        Common.Label        : 'Phone Number',
        Common.FieldControl : #Mandatory,
        Validation.Pattern  : '^[6-9][0-9]{9}$',
        Common.ValueList: {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'Customers',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: phone,
                    ValueListProperty: 'phone',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'name',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'customerCode',
                },
            ],
        },
        Common.ValueListWithFixedValues: false,
    );

    billingAddress @(
        Common.Label        : 'Billing Address',
        Common.FieldControl : #Mandatory
    );

    shippingAddress @(
        Common.Label        : 'Shipping Address',
        Common.FieldControl : #Mandatory
    );

    creditLimit @(
        Common.Label: 'Credit Limit (₹)'
    );
};


// =============================================
// UI annotations for Customers
// =============================================
annotate service.Customers with @(

    UI.SelectionFields: [
        name,
        email,
        phone,
    ],

    UI.LineItem: [
        {
            $Type: 'UI.DataField',
            Label: 'Customer Code',
            Value: customerCode,
        },
        {
            $Type: 'UI.DataField',
            Label: 'Name',
            Value: name,
        },
        {
            $Type: 'UI.DataField',
            Label: 'Email',
            Value: email,
        },
        {
            $Type: 'UI.DataField',
            Label: 'Phone',
            Value: phone,
        },
        {
            $Type: 'UI.DataField',
            Label: 'Credit Limit (₹)',
            Value: creditLimit,
        },
        {
            $Type : 'UI.DataFieldForAction',
            Label : 'Add Customer',
            Action: 'MyService.EntityContainer/addCustomer',
        },
    ],

    UI.HeaderInfo: {
        TypeName      : 'Customer',
        TypeNamePlural: 'Customers',
        Title: {
            $Type: 'UI.DataField',
            Value: name,
        },
        Description: {
            $Type: 'UI.DataField',
            Value: customerCode,
        },
    },

    UI.HeaderFacets: [
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'CreditLimitKPI',
            Target: '@UI.DataPoint#CreditLimit',
        },
    ],

    UI.DataPoint #CreditLimit: {
        Value        : creditLimit,
        Title        : 'Credit Limit (₹)',
        Criticality  : #Neutral,
    },

    UI.Facets: [
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'CustomerInfoFacet',
            Label : 'Customer Information',
            Target: '@UI.FieldGroup#CustomerInfo',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'AddressFacet',
            Label : 'Address Information',
            Target: '@UI.FieldGroup#AddressInfo',
        },
    ],

    UI.FieldGroup #CustomerInfo: {
        $Type: 'UI.FieldGroupType',
        Label: 'Customer Information',
        Data : [
            {
                $Type: 'UI.DataField',
                Label: 'Customer Code',
                Value: customerCode,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Name',
                Value: name,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Email',
                Value: email,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Phone',
                Value: phone,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Credit Limit (₹)',
                Value: creditLimit,
            },
        ],
    },

    UI.FieldGroup #AddressInfo: {
        $Type: 'UI.FieldGroupType',
        Label: 'Address Information',
        Data : [
            {
                $Type: 'UI.DataField',
                Label: 'Billing Address',
                Value: billingAddress,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Shipping Address',
                Value: shippingAddress,
            },
        ],
    },
);
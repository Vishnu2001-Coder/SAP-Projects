using MyService1 as service from '../../srv/invoice-service';

// ─── STATUS VALUE HELP ───────────────────────────────────────────────
annotate service.Invoices with {
    status @(
        Common.ValueListWithFixedValues: true,
        Common.ValueList               : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'Invoices',
            Parameters    : [{
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: status,
                ValueListProperty: 'status',
            }],
        },
    );

    salesOrder @(
        Common.Text          : salesOrder.ID,
        Common.TextArrangement: #TextOnly,
    );
};


annotate service.Invoices actions {
    markAsPaid @(
        Common.IsActionCritical: true,
        Common.SideEffects     : {TargetProperties: [
            'in/status',
            'in/statusCriticality',
            'in/paidOn',
            'in/paymentreference',
        ]}
    );

    createInvoice @(
        Common.IsActionCritical: true,
        Common.SideEffects     : {TargetProperties: [
            'in/invoiceLink',
        ]}
    );
};

// ─── MAIN ANNOTATION ─────────────────────────────────────────────────
annotate service.Invoices with @(

    // ── FILTER BAR ──────────────────────────────────────────────────
    UI.SelectionFields: [
        status,
        invoiceDate,
        dueDate,
        salesOrder_ID,
    ],

    // ── LIST PAGE (LineItem) ─────────────────────────────────────────
    UI.LineItem: [
        {
            $Type             : 'UI.DataField',
            Label             : 'Invoice Date',
            Value             : invoiceDate,
            @HTML5.CssDefaults: {width: '150px'}
        },
        {
            $Type             : 'UI.DataField',
            Label             : 'Due Date',
            Value             : dueDate,
            @HTML5.CssDefaults: {width: '150px'}
        },
        {
            $Type             : 'UI.DataField',
            Label             : 'Total Amount (₹)',
            Value             : totalAmount,
            @HTML5.CssDefaults: {width: '150px'}
        },
        {
            $Type             : 'UI.DataField',
            Label             : 'Tax Amount (₹)',
            Value             : taxAmount,
            @HTML5.CssDefaults: {width: '150px'}
        },
        {
            $Type             : 'UI.DataField',
            Label             : 'Status',
            Value             : status,
            Criticality       : statusCriticality,   // ✅ colored status
            @HTML5.CssDefaults: {width: '150px'}
        },
        {
            $Type             : 'UI.DataFieldWithUrl',
            Label             : 'Invoice Link',
            Value             : invoiceLink,
            Url               : invoiceLink,
            @HTML5.CssDefaults: {width: '400px'}
        },
        {
            $Type            : 'UI.DataFieldForAction',
            Label            : 'Mark as Paid',
            Action           : 'MyService1.markAsPaid',
            ![@UI.Emphasized]: true,
        },
        {
            $Type : 'UI.DataFieldForAction',
            Label : 'Generate Bill',
            Action: 'MyService1.createInvoice',
        },
        {
            $Type : 'UI.DataFieldForAction',
            Label : 'Get OverDue Invoice',
            Action: 'MyService1.EntityContainer/getOverdueInvoices',
        },
    ],

    // ── HEADER INFO ──────────────────────────────────────────────────
    UI.HeaderInfo: {
        TypeName      : 'Invoice',
        TypeNamePlural: 'Invoices',
        Title         : {
            $Type: 'UI.DataField',
            Value: ID,
        },
        Description   : {
            $Type      : 'UI.DataField',
            Value      : status,
            Criticality: statusCriticality,
        },
    },

    // ── HEADER KPI FACETS ────────────────────────────────────────────
    UI.HeaderFacets: [
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'TotalAmountKPI',
            Target: '@UI.DataPoint#TotalAmount',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'StatusKPI',
            Target: '@UI.DataPoint#InvoiceStatus',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'PaidOnKPI',
            Target: '@UI.DataPoint#PaidOn',
        },
    ],

    UI.DataPoint #TotalAmount: {
        Value      : totalAmount,
        Title      : 'Total Amount (₹)',
        Criticality: 2,
    },

    UI.DataPoint #InvoiceStatus: {
        Value      : status,
        Title      : 'Invoice Status',
        Criticality: statusCriticality,   // ✅ colored KPI
    },

    UI.DataPoint #PaidOn: {
        Value: paidOn,
        Title: 'Paid On',
    },

    // ── DETAIL PAGE FACETS ───────────────────────────────────────────
    UI.Facets: [
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'InvoiceInfoFacet',
            Label : 'Invoice Information',
            Target: '@UI.FieldGroup#InvoiceInfo',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'PaymentFacet',
            Label : 'Payment Information',
            Target: '@UI.FieldGroup#Payment',
        },
    ],

    UI.FieldGroup #InvoiceInfo: {
        $Type: 'UI.FieldGroupType',
        Label: 'Invoice Information',
        Data : [
            {
                $Type: 'UI.DataField',
                Label: 'Invoice Date',
                Value: invoiceDate,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Due Date',
                Value: dueDate,
            },
            {
                $Type      : 'UI.DataField',
                Label      : 'Status',
                Value      : status,
                Criticality: statusCriticality,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Total Amount (₹)',
                Value: totalAmount,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Tax Amount (₹)',
                Value: taxAmount,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Invoice Link',
                Value: invoiceLink,
            },
        ],
    },

    UI.FieldGroup #Payment: {
        $Type: 'UI.FieldGroupType',
        Label: 'Payment Information',
        Data : [
            {
                $Type: 'UI.DataField',
                Label: 'Paid On',
                Value: paidOn,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Payment Reference',
                Value: paymentreference,
            },
        ],
    },
);
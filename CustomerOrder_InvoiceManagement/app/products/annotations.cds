using MyService as service from '../../srv/order-service';


annotate service.Products with {

    imageUrl @UI.IsImageURL;

    // category -> FixedValues TRUE (has enum)
    category @(
        Common.ValueList               : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'Products',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: category,
                    ValueListProperty: 'category',
                },
            ],
        },
        Common.ValueListWithFixedValues: true, // ← dropdown ▼
    );

    // name → FixedValues FALSE 
    name @(
        Common.ValueList               : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'Products',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: name,
                    ValueListProperty: 'name',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'productCode',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'category',
                },
            ],
        },
        Common.ValueListWithFixedValues: true, // ← popup 🔍
    );

    // ✅ rating → FixedValues FALSE (popup with search)
    rating @(
        Common.ValueList               : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'Products',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: rating,
                    ValueListProperty: 'rating',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'name',
                },
            ],
        },
        Common.ValueListWithFixedValues: false, // ← popup 🔍
    );

    // ✅ unitPrice → FixedValues FALSE
    unitPrice @(
        Common.ValueList               : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'Products',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: unitPrice,
                    ValueListProperty: 'unitPrice',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'name',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'category',
                },
            ],
        },
        Common.ValueListWithFixedValues: false, // ← popup 🔍
    );

    // ✅ stockQty → FixedValues FALSE
    stockQty @(
        Common.ValueList               : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'Products',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: stockQty,
                    ValueListProperty: 'stockQty',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'name',
                },
            ],
        },
        Common.ValueListWithFixedValues: false, // ← popup 🔍
    );
};

annotate service.Products with @(

    UI.SelectionFields         : [
        name,
        category,
        rating,
        unitPrice,
        stockQty,
    ],

    UI.LineItem                : [
        {
            $Type             : 'UI.DataField',
            Label             : 'ID',
            Value             : ID,
            @HTML5.CssDefaults: {width: '150px'}
        },
        {
            $Type             : 'UI.DataField',
            Label             : 'Image',
            Value             : imageUrl,
            @HTML5.CssDefaults: {width: '100px'}
        },
        {
            $Type             : 'UI.DataField',
            Label             : 'ProductCode ',
            Value             : productCode,
            @HTML5.CssDefaults: {width: '150px'}
        },
        {
            $Type             : 'UI.DataField',
            Label             : 'name',
            Value             : name,
            @HTML5.CssDefaults: {width: '150px'}
        },
        {
            $Type             : 'UI.DataField',
            Label             : 'unitPrice',
            Value             : unitPrice,
            @HTML5.CssDefaults: {width: '100px'}
        },
        {
            $Type             : 'UI.DataField',
            Label             : 'category',
            Value             : category,
            @HTML5.CssDefaults: {width: '150px'}
        },
        {
            $Type             : 'UI.DataField',
            Label             : 'TaxAmount',
            Value             : taxRate,
            @HTML5.CssDefaults: {width: '100px'}
        },
        {
            $Type             : 'UI.DataFieldForAnnotation',
            Label             : 'Stock Level',
            Target            : '@UI.DataPoint#StockProgress',
            @HTML5.CssDefaults: {width: '100px'}
        },
        {
            $Type             : 'UI.DataFieldForAnnotation',
            Label             : 'Rating',
            Target            : '@UI.DataPoint#Rating',
            @HTML5.CssDefaults: {width: '150px'}
        },

    ],
    // ================================
    // HEADER INFO (top of object page)
    // ================================
    UI.HeaderInfo              : {
        TypeName      : 'Product',
        TypeNamePlural: 'Products',
        Title         : {
            $Type: 'UI.DataField',
            Value: name, // big title
        },
        Description   : {
            $Type: 'UI.DataField',
            Value: productCode, // subtitle
        },
        ImageUrl      : imageUrl, // header image
    },

    // ================================
    // FACETS (tabs in object page)
    // ================================
    UI.Facets                  : [
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'ProductInfoFacet',
            Label : 'Product Information',
            Target: '@UI.FieldGroup#ProductInfo',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'PricingFacet',
            Label : 'Pricing & Tax',
            Target: '@UI.FieldGroup#Pricing',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'StockFacet',
            Label : 'Stock & Rating',
            Target: '@UI.FieldGroup#StockRating',
        },
    ],

    // ================================
    // FIELD GROUPS
    // ================================

    // Facet 1 — Product Information
    UI.FieldGroup #ProductInfo : {
        $Type: 'UI.FieldGroupType',
        Label: 'Product Information',
        Data : [
            {
                $Type: 'UI.DataField',
                Label: 'Product Code',
                Value: productCode,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Product Name',
                Value: name,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Category',
                Value: category,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Image URL',
                Value: imageUrl,
            },
        ],
    },

    // Facet 2 — Pricing & Tax
    UI.FieldGroup #Pricing     : {
        $Type: 'UI.FieldGroupType',
        Label: 'Pricing & Tax',
        Data : [
            {
                $Type: 'UI.DataField',
                Label: 'Unit Price (₹)',
                Value: unitPrice,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Tax Rate (₹)',
                Value: taxRate,
            },
        ],
    },

    // Facet 3 — Stock & Rating
    UI.FieldGroup #StockRating : {
        $Type: 'UI.FieldGroupType',
        Label: 'Stock & Rating',
        Data : [
            // PROGRESS BAR — rating as progress
            {
                $Type : 'UI.DataFieldForAnnotation',
                Label : 'Stock Level',
                Target: '@UI.DataPoint#StockProgress',
            },

            //  DATA POINT — rating as star
            {
                $Type : 'UI.DataFieldForAnnotation',
                Label : 'Rating',
                Target: '@UI.DataPoint#Rating',
            },

        ],
    },


    // ================================
    //  DATA POINT — Rating as Stars
    // ================================
    UI.DataPoint #Rating       : {
        Value        : rating,
        Title        : 'Rating',
        TargetValue  : 5,
        Visualization: #Rating,
         // ✅ color based on rating value
        CriticalityCalculation: {
        ImprovementDirection  : #Maximize,
        ToleranceRangeLowValue: 3,   // below 3 = red
        DeviationRangeLowValue: 2,   // below 2 = orange
    },

    },


    // ================================
    //  PROGRESS BAR — Stock Level
    // ================================
    UI.DataPoint #StockProgress: {
        Value        : stockQty,
        Title        : 'Stock Level',
        TargetValue  : 500,
        // max stock = 500
        Visualization: #Progress,
        // shows as progress bar
        Criticality  : stockCriticality, // color based on stock
    },
);



using { MyService as service } from '../../srv/order-service';


annotate service.Products with {

    //  productCode @UI.Placeholder: 'e.g. PROD-031';
    //      name        @UI.Placeholder: 'e.g. Dell Inspiron Laptop';

    //  productCode @Core.Description: 'e.g. PROD-031';
    // name        @Core.Description: 'e.g. Dell Inspiron Laptop';

  
    imageUrl @UI.IsImageURL;

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
        Common.ValueListWithFixedValues: true,
    );

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
        Common.ValueListWithFixedValues: true,
    );

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
        Common.ValueListWithFixedValues: false,
    );

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
        Common.ValueListWithFixedValues: false,
    );

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
        Common.ValueListWithFixedValues: false,
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
         {
            $Type             : 'UI.DataFieldForAction',
            Label             : 'Create Product',
            Action            : 'MyService.EntityContainer/addProduct',
            @HTML5.CssDefaults: {width: '150px'}
        },
    ],


    UI.HeaderInfo              : {
        TypeName      : 'Product',
        TypeNamePlural: 'Products',
        Title         : {
            $Type: 'UI.DataField',
            Value: name,
        },
        Description   : {
            $Type: 'UI.DataField',
            Value: productCode,
        },
        ImageUrl      : imageUrl,
    },

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

    UI.FieldGroup #StockRating : {
        $Type: 'UI.FieldGroupType',
        Label: 'Stock & Rating',
        Data : [
            {
                $Type : 'UI.DataFieldForAnnotation',
                Label : 'Stock Level',
                Target: '@UI.DataPoint#StockProgress',
            },
            {
                $Type : 'UI.DataFieldForAnnotation',
                Label : 'Rating',
                Target: '@UI.DataPoint#Rating',
            },
        ],
    },

    UI.DataPoint #Rating       : {
        Value        : rating,
        Title        : 'Rating',
        TargetValue  : 5,
        Visualization: #Rating,
        CriticalityCalculation: {
            ImprovementDirection  : #Maximize,
            ToleranceRangeLowValue: 3,
            DeviationRangeLowValue: 2,
        },
    },

    UI.DataPoint #StockProgress: {
        Value        : stockQty,
        Title        : 'Stock Level',
        TargetValue  : 500,
        Visualization: #Progress,
       // Criticality  : stockCriticality,
    },

        UI.PresentationVariant                : {
        Visualizations: ['@UI.LineItem'],
        MaxItems      : 2
    },
);
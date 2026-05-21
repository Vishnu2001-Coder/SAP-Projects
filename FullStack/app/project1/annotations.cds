using MyService as service from '../../srv/service';

annotate service.Books with @(

    UI.SelectionFields           : [
        author_name,
        book_name,
        stock_stocks
    ],

    UI.FieldGroup #GeneratedGroup: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Label: 'id',
                Value: id,
            },
            {
                $Type: 'UI.DataField',
                Label: 'author_name',
                Value: author_name,
            },
            {
                $Type: 'UI.DataField',
                Label: 'book_name',
                Value: book_name,
            },
            {
                $Type: 'UI.DataField',
                Value: Date,
            },
            {
                $Type: 'UI.DataField',
                Label: 'stock_stocks',
                Value: stock_stocks,
            },
        ],
    },
    UI.Facets                    : [{
        $Type : 'UI.ReferenceFacet',
        ID    : 'GeneratedFacet1',
        Label : 'General Information',
        Target: '@UI.FieldGroup#GeneratedGroup',
    }, ],
    UI.LineItem                  : [
        {
            $Type             : 'UI.DataField',
            Label             : 'id',
            Value             : id,
            @HTML5.CssDefaults: {width: '150px'}
        },
        {
            $Type             : 'UI.DataField',
            Label             : 'author_name',
            Value             : author_name,
            @HTML5.CssDefaults: {width: '150px'}
        },
        {
            $Type             : 'UI.DataField',
            Label             : 'book_name',
            Value             : book_name,
            @HTML5.CssDefaults: {width: '150px'}
        },
        {
            $Type             : 'UI.DataField',
            Value             : Date,
            @HTML5.CssDefaults: {width: '150px'}
        },
        {
            $Type             : 'UI.DataField',
            Label             : 'stock_stocks',
            Value             : stock_stocks,
            @HTML5.CssDefaults: {width: '150px'}
        },
    ],
);

annotate service.Books with {
    stock @Common.ValueList: {
        $Type         : 'Common.ValueListType',
        CollectionPath: 'status',
        Parameters    : [
            {
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: stock_stocks,
                ValueListProperty: 'stocks',
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'criticality',
            },
        ],
    }
};

using MyService as service from '../../srv/service';
annotate service.Books with @(
    UI.FieldGroup #GeneratedGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Label : 'id',
                Value : id,
            },
            {
                $Type : 'UI.DataField',
                Label : 'author_name',
                Value : author_name,
            },
            {
                $Type : 'UI.DataField',
                Label : 'book_name',
                Value : book_name,
            },
            {
                $Type : 'UI.DataField',
                Value : Date,
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
            Label : 'id',
            Value : id,
        },
        {
            $Type : 'UI.DataField',
            Label : 'author_name',
            Value : author_name,
        },
        {
            $Type : 'UI.DataField',
            Label : 'book_name',
            Value : book_name,
        },
        {
            $Type : 'UI.DataField',
            Value : Date,
        },
    ],
);


using MyService as service from '../../srv/service';
annotate service.Customers with @(
    UI.FieldGroup #GeneratedGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Label : 'ID',
                Value : ID,
            },
            {
                $Type : 'UI.DataField',
                Label : 'firstName',
                Value : firstName,
            },
            {
                $Type : 'UI.DataField',
                Label : 'lastName',
                Value : lastName,
            },
            {
                $Type : 'UI.DataField',
                Label : 'email',
                Value : email,
            },
            {
                $Type : 'UI.DataField',
                Label : 'phone',
                Value : phone,
            },
            {
                $Type : 'UI.DataField',
                Label : 'password',
                Value : password,
            },
        ],
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'GeneratedFacet1',
            Label : 'Customer Information',
            Target : '@UI.FieldGroup#GeneratedGroup',
        },
            {
            $Type : 'UI.ReferenceFacet',
            ID : 'GeneratedFacet2',
            Label : 'Reviews',
            Target : 'reviews/@UI.LineItem#line',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'GeneratedFacet3',
            Label : 'Books',
            Target : '',
        }
    ],
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Label : 'ID',
            Value : ID,
        },
        {
            $Type : 'UI.DataField',
            Label : 'firstName',
            Value : firstName,
        },
        {
            $Type : 'UI.DataField',
            Label : 'lastName',
            Value : lastName,
        },
        {
            $Type : 'UI.DataField',
            Label : 'email',
            Value : email,
        },
        {
            $Type : 'UI.DataField',
            Label : 'phone',
            Value : phone,
        },
    ],
);
annotate service.Reviews with @(
      UI.LineItem #line          : [
        {
            $Type             : 'UI.DataField',
            Label             : 'ReviewID',
            Value             : ID,
            @HTML5.CssDefaults: {width: '200px'}
        },
        {
            $Type             : 'UI.DataField',
            Label             : 'reviewText',
            Value             : reviewText,
            @HTML5.CssDefaults: {width: '200px'}
        },
        {
            $Type             : 'UI.DataField',
            Label             : 'rating',
            Value             : rating,
            @HTML5.CssDefaults: {width: '200px'}
        },
         {
            $Type             : 'UI.DataField',
            Label             : 'ReviewDate',
            Value             : reviewDate,
            @HTML5.CssDefaults: {width: '200px'}
        },
          {
            $Type             : 'UI.DataField',
            Label             : 'BookName',
            Value             : book.title,
            @HTML5.CssDefaults: {width: '200px'},
        },
    
       ]
);

annotate service.Books with @(
    UI.LineItem1 :[
        {
            $Type             : 'UI.DataField',
            Label             : 'Book',
            Value             : ID,
            @HTML5.CssDefaults: {width: '200px'}
        },
        {
            $Type             : 'UI.DataField',
            Label             : 'Title',
            Value             : title,
            @HTML5.CssDefaults: {width: '200px'}
        },
        {
            $Type             : 'UI.DataField',
            Label             : 'rating',
            Value             : price,
            @HTML5.CssDefaults: {width: '200px'}
        },
         {
            $Type             : 'UI.DataField',
            Label             : 'ReviewDate',
            Value             : pages,
            @HTML5.CssDefaults: {width: '200px'}
        },
          {
            $Type             : 'UI.DataField',
            Label             : 'BookName',
            Value             : imageUrl,
            @HTML5.CssDefaults: {width: '200px'},
        },
    ]
);

// annotate service.Books with {
//    imageUrl @UI.IsImageUrl 
// }



using MyService as service from '../../srv/service';

annotate service.Books with @(
    UI.FieldGroup #GeneratedBook          : {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Label: 'ID',
                Value: ID,
            },
            {
                $Type: 'UI.DataField',
                Label: 'title',
                Value: title,
            },
            {
                $Type: 'UI.DataField',
                Label: 'isbn',
                Value: isbn,
            },
            {
                $Type: 'UI.DataField',
                Label: 'description',
                Value: description,
            },
            {
                $Type: 'UI.DataField',
                Label: 'language',
                Value: language,
            },
            {
                $Type: 'UI.DataField',
                Label: 'publishDate',
                Value: publishDate,
            },
            {
                $Type: 'UI.DataField',
                Label: 'price',
                Value: price,
            },
            {
                $Type: 'UI.DataField',
                Label: 'stock',
                Value: stock,
            },
            {
                $Type: 'UI.DataField',
                Label: 'pages',
                Value: pages,
            },
            {
                $Type: 'UI.DataField',
                Label: 'imageUrl',
                Value: imageUrl,
            },
            {
                $Type      : 'UI.DataField',
                Label      : 'averageRating',
                Value      : averageRating,
                Criticality: 3
            },
            {
                $Type: 'UI.DataField',
                Label: 'category_ID',
                Value: category_ID,
            },
            {
                $Type: 'UI.DataField',
                Label: 'author_ID',
                Value: author_ID,
            },
            {
                $Type: 'UI.DataField',
                Label: 'publisher_ID',
                Value: publisher_ID,
            },
        ],
    },
    UI.Facets                             : [
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'GeneratedFacet1',
            Label : 'General Information',
            Target: '@UI.FieldGroup#GeneratedBook',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'GeneratedFacet2',
            Label : 'Author Informaiton',
            Target: '@UI.FieldGroup#GeneratedGroupAuthor',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'GeneratedFacet3',
            Label : 'Author Informaiton',
            Target: '@UI.FieldGroup#GeneratedGroupAuthor',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'GeneratedFacet3',
            Label : 'Publisher Details',
            Target: '@UI.FieldGroup#GeneratedGroupPublisher',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'GeneratedFacet4',
            Label : 'Review Information',
            Target: 'reviews/@UI.LineItem#line1',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'GeneratedFacet5',
            Label : 'Review Feild',
            Target: '@UI.FieldGroup#GeneratedGroup1',
        },
    ],
    UI.LineItem                           : [
        {
            $Type: 'UI.DataField',
            Label: 'ID',
            Value: ID,
        },
        {
            $Type: 'UI.DataField',
            Label: 'title',
            Value: title,
        },
        // {
        //     $Type : 'UI.DataField',
        //     Label : 'isbn',
        //     Value : isbn,
        // },
        {
            $Type: 'UI.DataField',
            Label: 'description',
            Value: description,
        },
        {
            $Type: 'UI.DataField',
            Label: 'language',
            Value: language,
        },
        {
            $Type      : 'UI.DataField',
            Label      : 'averageRating',
            Value      : averageRating,
            Criticality: 3
        },
    ],
    UI.SelectionFields                    : [
        category_ID,
        author_ID,
        publisher_ID
    ],
    UI.HeaderInfo :{
        TypeName:'Books',
        Title:{Value:title},
        Description:{Value:description},
        ImageUrl:imageUrl
    },

    UI.FieldGroup #GeneratedGroup1        : {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Label: 'ID',
                Value: reviews.ID,
            },
            {
                $Type      : 'UI.DataField',
                Label      : 'ratings',
                Value      : reviews.rating,
                Criticality: 3
            },
            {
                $Type: 'UI.DataField',
                Label: 'Date',
                Value: reviews.reviewDate
            }
        ]
    },
    UI.FieldGroup #GeneratedGroupAuthor   : {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Label: 'ID',
                Value: author_ID,
            },
            {
                $Type: 'UI.DataField',
                Label: 'ratings',
                Value: author.name
            },
            {
                $Type: 'UI.DataField',
                Label: 'Date',
                Value: author.biography
            },
            {
                $Type: 'UI.DataField',
                Label: 'Date',
                Value: author.email
            },
            {
                $Type: 'UI.DataField',
                Label: 'Date',
                Value: author.imageUrl
            }
        ]
    },
    UI.FieldGroup #GeneratedGroupPublisher: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Label: 'ID',
                Value: publisher_ID,
            },
            {
                $Type: 'UI.DataField',
                Label: 'ratings',
                Value: publisher.name,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Date',
                Value: publisher.email,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Date',
                Value: publisher.phone,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Date',
                Value: publisher.address,
            }
        ]
    },
    UI.PresentationVariant                : {
        Visualizations: ['@UI.LineItem'],
        MaxItems      : 2
    },

);

annotate service.Books with {
    imageUrl @UI.IsImageURL;
};


annotate service.Books with {
    category @Common.ValueList: { //use a propertyname
        $Type         : 'Common.ValueListType',
        CollectionPath: 'Categories',
        Parameters    : [
            {
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: category,
                ValueListProperty: 'ID',
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'name',
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'description',
            },
        ],
    }
};

//Note -> ValueList only for Main entity properties , Ex:(category_id )not for Category.name
//Tips -> Every Association entity , craete a Value Help also a solo property (price)
//forign key is display in UI as a Label name.(Defaulty) in selection Feilds

annotate service.Books with {
    author @Common.ValueList: {
        $Type         : 'Common.ValueListType',
        CollectionPath: 'Authors',
        Parameters    : [
            {
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: author_ID,
                ValueListProperty: 'ID',
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'name',
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'biography',
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'email',
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'imageUrl',
            },
        ],
    }
};

annotate service.Books with {
    publisher @Common.ValueList: {
        $Type         : 'Common.ValueListType',
        CollectionPath: 'Publishers',
        Parameters    : [
            {
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: publisher_ID,
                ValueListProperty: 'ID',
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
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'address',
            },
        ],
    }
};

annotate service.Reviews with @(
    UI.LineItem #line1          : [
        {
            $Type             : 'UI.DataField',
            Label             : 'ReviewID',
            Value             : ID,
            @HTML5.CssDefaults: {width: '150px'}
        },
        {
            $Type             : 'UI.DataField',
            Label             : 'reviewText',
            Value             : reviewText,
            @HTML5.CssDefaults: {width: '150px'}
        },
        {
            $Type             : 'UI.DataField',
            Label             : 'rating',
            Value             : rating,
            @HTML5.CssDefaults: {width: '150px'}
        }

    ],
    UI.FieldGroup #Reviews      : {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Label: 'ReviewID',
                Value: ID,
            },
            {
                $Type: 'UI.DataField',
                Label: 'reviewText',
                Value: reviewText,
            },
            {
                $Type: 'UI.DataField',
                Label: 'rating',
                Value: rating
            },
            {
                $Type: 'UI.DataField',
                Label: 'Reviewdate',
                Value: reviewDate,
            }
        ]
    },
    UI.FieldGroup #Customer          : {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Label: 'CustomerId',
                Value: customer_ID,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Firstnamename',
                Value: customer.firstName,
            },
            {
                $Type: 'UI.DataField',
                Label: 'LastName',
                Value: customer.lastName,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Mail-ID',
                Value: customer.email,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Phone',
                Value: customer.password,
            },
        ]
    },
    UI.Facets                   : [
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'Facet1',
            Label : 'review Info',
            Target: '@UI.FieldGroup#Reviews'
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'Facet2',
            Label : 'customer Info',
            Target: '@UI.FieldGroup#Customer'


        }

    ]

)

//Note->
//Basic Things :additional annote service (Line Item) only accept for root entity UI
//Others like feildgroup are cant map. Feilds groups for only for own entity
//Main rule : have to Many then only appear.
//note , while mapping use Property name not annotateservicename , they didnt suggest   !!!


/*Fiori
1.Valuehelp ->
2.selection feilds
3.LineItem                (see the feild name correctly) other wise we det a data slowly
4.Feildgroup               (see the feild name correctly) everything should be suggest
5.ObjectPageLineItem    !!!
6.HeaderInfo (ObjectPage)  {title:Value:propertyname,description : propertyname,ImageUrl(propertyname):property}


Feautres:
1.Criticality -> Works on LineItem as well as Feild group
                 Only wrks on , root entity properties               !!!
             for icon -> CriticalityRepresentation : #WithoutIcon,


2.Pagination -> UI.PresentationVariant:{Visualization:[@Ui.LineItem]}

3.Valuehelp  ->  @Common.ValueListWithFixedValues: true; see above ,(create annoate service without@)

4.ImageUrl -> create annoate service without@ -> {propertyname @UI.IsImageUrl;}

5.


 */


/*
Note:In flexy layout column 3 pages -> in routes list, object ,object */
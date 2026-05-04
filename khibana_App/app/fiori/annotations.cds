using MyService as service from '../../srv/service';

annotate service.Books with @(

    UI.SelectionFields           : [
        book_name,
        Person.P_name
    ],                                                                   //note -> Object.propertyname

    UI.LineItem                  : [
        {
            $Type: 'UI.DataField',
            Label: 'id',
            Value: id,
             @HTML5.CssDefaults:{width:'150px'}
 
        },
        {
            $Type: 'UI.DataField',
            Label: 'author_name',
            Value: author_name,
             @HTML5.CssDefaults:{width:'150px'}
 
        },
        {
            $Type: 'UI.DataField',
            Label: 'book_name',
            Value: book_name,
             @HTML5.CssDefaults:{width:'150px'}
 
        },
        // {
        //     $Type: 'UI.DataField',
        //     Label: 'stock',
        //     Value: stock,
        // },
        {
            $Type: 'UI.DataField',
            Label: 'Person',
            Value: Person_id ,//forignkey,
             @HTML5.CssDefaults:{width:'150px'}
 
        },
        {
            $Type:'UI.DataField',
            Label:'Stock',
            Value: stock ,
             @HTML5.CssDefaults:{width:'150px'}
 
        },
        {
            $Type: 'UI.DataField',
            Label: 'p_name',
            Value: Person.name, //linked table,
             @HTML5.CssDefaults:{width:'150px'}
 

        },
        {
            $Type : 'UI.DataFieldForAction',
            Label : 'Update Button',
            Action: 'MyService.EntityContainer/update1'      ,          //!!! Service name
             @HTML5.CssDefaults:{width:'150px'}
 
        },
        {
            $Type : 'UI.DataFieldForAction',
            Label : 'Update Button',
            Action: 'MyService.EntityContainer/update1'  ,                 //Bound action
            Inline :true
        }
    ],


     UI.HeaderInfo:{
       TypeName:'Order',
       TypeNamePlural:'Orders',                                   //lineite,
       TypeImageUrl:'sap-icon://accelerated',
       Title:{Value:'Order Page'},
       Description:{Value:'This is Page For Single Record'},
    //    @UI.Hidden:true
    },
 



    UI.FieldGroup #GeneratedGroup: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Label: 'id',
                Value: id,
              //  @UI.Hidden:true                                        //!!!working apart header
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
                Label: 'stock',
                Value: stock,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Person',
                Value: Person_id //forignkey
            },
        // {
        //     $Type: 'UI.DataField',
        //     Label: 'PersonName',
        //     Value: Person.P_name                   //Like Object -> Entityname.Propertyname even fiori added on a dif entity
        // }
        ]
    },
    UI.HeaderFacets              : [
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'Facet1',
            Label : 'General',
            Target: '@UI.FieldGroup#GeneratedGroup',

        },
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'Facet2',
            Label : 'General',
            Target: '@UI.FieldGroup#GeneratedGroup',

        }
    ],
    UI.Facets                    : [
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'Generated1',
            Label : 'General Information',
            Target: '@UI.FieldGroup#GeneratedGroup',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'Generated2',
            Label : 'Normal',
            Target: 'Person/@UI.LineItem',
        },
    ]

);

annotate service.Person with @(UI.LineItem: [
    {
        $Type: 'UI.DataField',
        Label: 'ID',
        Value: id
    },
    {
        $Type: 'UI.DataField',
        Label: 'Name',
        Value: P_name
    },
    {
        $Type: 'UI.DataField',
        Label: 'Age',
        Value: P_age

    },
])

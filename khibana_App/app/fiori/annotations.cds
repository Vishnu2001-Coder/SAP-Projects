using MyService as service from '../../srv/service';

annotate service.Books with{                                  //ValueHelp not  for Selection Feilds used for every sides use this property
    Person @Common.ValueList: {                                     //which property need a valuehelp (Property of book ->not a key)
        $Type: 'Common.ValueListType',
        CollectionPath: 'Person',                                       //which entity from
        Parameters: [
            {
                $Type: 'Common.ValueListParameterInOut',             
                LocalDataProperty: Person ,                       //books property
                ValueListProperty: 'id'                          //Exact propertyname in Person, and this column name will display as a column in value help
            }
            //  {
            //     $Type: 'Common.ValueListParameterInOut',
            //     LocalDataProperty: author_name,
            //     ValueListProperty: 'author_name'
            // },
        ],
       
    };
    //Note -> forign key is display in UI as a Label name.
    Person @Common.ValueListWithFixedValues: true;       // Initially in input box appears filter icon that is valuehelp dailougebox , if no need a filter only dropdown use this. 
    
}
annotate service.Books with{                                  //ValueHelp not  for Selection Feilds used for every sides use this property
    stock @Common.ValueList: {                                     //which property need a valuehelp (Property of book ->not a key)
        $Type: 'Common.ValueListType',
        CollectionPath: 'status',                                       //which entity from
        Parameters: [
            {
                $Type: 'Common.ValueListParameterInOut',             
                LocalDataProperty: stock  ,                       //books property
                ValueListProperty: 'stocks'                          //property
            }
            //  {
            //     $Type: 'Common.ValueListParameterInOut',
            //     LocalDataProperty: author_name,
            //     ValueListProperty: 'author_name'
            // },
        ],
       
    };
    stock @Common.ValueListWithFixedValues: true;       // Initially in input box appears filter icon that is valuehelp dailougebox , if no need a filter only dropdown use this. 
    
}


annotate service.Books with @(

    UI.SelectionFields           : [
        book_name,
        // Person.P_name ,                               //note -> Object.propertyname
        Person_id
    ],                                                                 


 

    UI.LineItem : [
       {
            $Type: 'UI.DataField',
            Label: 'ID',
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
        //     Label: 'Person',
        //     Value: Person_id ,//forignkey,
        //      @HTML5.CssDefaults:{width:'150px'}
 
        // },
        {
            $Type:'UI.DataField',
            Label:'Stock',
            Value: stock_stocks ,
            Criticality:stock.criticality,
             @HTML5.CssDefaults:{width:'150px'}
 
        },   
         {
            $Type:'UI.DataField',
            Label:'Date',
            Value: Date ,
             @HTML5.CssDefaults:{width:'150px'}
 
        },
        
        //  {
        //     $Type:'UI.DataField',
        //     Label:'Criticality',
        //     Value: stock.criticality ,             // use ?$expand to check linked double sides or not
        //      @HTML5.CssDefaults:{width:'150px'}
 
        // },
        // {
        //     $Type: 'UI.DataField',
        //     Label: 'p_name',
        //     Value: Person.name,     //linked table,
        //      @HTML5.CssDefaults:{width:'150px'}
 

        // },
        {
            $Type : 'UI.DataFieldForAction',
            Label : 'Update Button',
            Action: 'MyService.EntityContainer/update1'      ,          //!!! Service name ,Unbound . otehrwise directly we can give
             @HTML5.CssDefaults:{width:'150px'}
 
        },
        {
            $Type : 'UI.DataFieldForAction',
            Label : 'Update Button',
            Action: 'MyService.EntityContainer/update1'  ,                 //Bound action
            Inline :true
        },
    ],


     UI.HeaderInfo:{
       TypeName:'Order',
       TypeNamePlural:'Orders',                                   //lineitem,
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
                Value: stock_stocks,
            },
            {
            $Type:'UI.DataField',
            Label:'Date',
            Value: Date ,
             @HTML5.CssDefaults:{width:'150px'}
 
        },
            // {
            //     $Type: 'UI.DataField',
            //     Label: 'Person',
            //     Value: Person_id //forignkey
            // },
        // {
        //     $Type: 'UI.DataField',
        //     Label: 'PersonName',
        //     Value: Person.P_name                   //Like Object -> Entityname.Propertyname even fiori added on a dif entity
        // }
        

         {
            $Type: 'UI.DataFieldWithUrl',
            Label: 'Trigger Url',
            Value: 'Google',
            Url:'https://www.google.com/'
        }
    ]},
    UI.HeaderFacets              : [
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'Facet1',
            Label : 'General',
            Target: '@UI.FieldGroup#GeneratedGroup',

        },
        // {
        //     $Type:'UI.ReferenceFacet',
        //     ID:'Facet3',
        //     Label :'Person',
        //     Target:'Person/@UI.FieldGroup#GeneratedGroup1'
        // }
    ],
    UI.Facets  : [
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'Generated1',
            Label : 'General Information',
            Target: '@UI.FieldGroup#GeneratedGroup',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Normal',
            ID : 'Normal',
            Target : '@UI.FieldGroup#Normal',
        },
          {
            $Type:'UI.ReferenceFacet',
            ID:'Facet3',
            Label :'Person',
            Target:'Person/@UI.LineItem#line1'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Table',
            ID : 'Table',
            Target : 'Person/@UI.LineItem',
        },
    ],
    Communication.Contact #contact : {
        $Type : 'Communication.ContactType',
        fn : id,   
    },
    UI.FieldGroup #Normal : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : Person.id,
                Label : 'id',
            },
            {
                $Type : 'UI.DataField',
                Value : Person.P_age,
                Label : 'P_age',
            },
            {
                $Type : 'UI.DataField',
                Value : Person.P_name,
                Label : 'P_name',
            },
        ],
    },

);

annotate service.Person with @(      // service name
                             
    UI.FieldGroup #GeneratedGroup1: {     //Extra table appear in Object page
        $Type: 'UI.FieldGroupType',
        Data : [                        
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
    ]},
   UI.LineItem #line1:[
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

    }

    ],  
);

annotate service.Books with @(
    UI.PresentationVariant:{
        Visualizations:['@UI.LineItem'],
        MaxItems:2
    }
);
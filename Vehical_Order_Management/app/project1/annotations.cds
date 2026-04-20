using VehicleService as service from '../../srv/service';
annotate service.Vehicles with @(
    UI.FieldGroup #GeneratedGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Label : 'vehicleId',
                Value : vehicleId,
            },
            {
                $Type : 'UI.DataField',
                Label : 'modelName',
                Value : modelName,
            },
            {
                $Type : 'UI.DataField',
                Label : 'cur_price',
                Value : cur_price,
            },
            {
                $Type : 'UI.DataField',
                Label : 'old_price',
                Value : old_price,
            },
            {
                $Type : 'UI.DataField',
                Label : 'dealer_dealerId',
                Value : dealer_dealerId,
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
            Label : 'vehicleId',
            Value : vehicleId,
        },
        {
            $Type : 'UI.DataField',
            Label : 'modelName',
            Value : modelName,
        },
        {
            $Type : 'UI.DataField',
            Label : 'cur_price',
            Value : cur_price,
        },
        {
            $Type : 'UI.DataField',
            Label : 'old_price',
            Value : old_price,
        },
        {
            $Type : 'UI.DataField',
            Label : 'dealer_dealerId',
            Value : dealer_dealerId,
        },
    ],
);

annotate service.Vehicles with {
    dealer @Common.ValueList : {
        $Type : 'Common.ValueListType',
        CollectionPath : 'Dealers',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : dealer_dealerId,
                ValueListProperty : 'dealerId',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'dealerName',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'stateId',
            },
        ],
    }
};


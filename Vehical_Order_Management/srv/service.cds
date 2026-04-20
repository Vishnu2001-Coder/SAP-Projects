using { vehicle.db as db } from '../db/schema';
using {  vehiclesView,statesView} from '../db/views';


service VehicleService {
    @cds.redirection.target 
 
    entity Vehicles as projection on db.Vehicles;
    entity Dealers as projection on db.Dealers;
 
   
    entity Orders as projection on db.Orders;

    @cds.redirection.target
    entity States as projection on db.States;

    entity VeiwVehicles as projection on vehiclesView;
    entity ViewStates as projection on statesView;

    // action addData(state:array of statees) returns String;
    // action adddata(dealer:array of Dealers) returns String;

    // type statees{
    //     stateId: String;
    //    stateName: String;
    //    stateCode  :String;

    // }

}












//whenever we expose a multiple enties based on the same source entity , that time the capm confuse which is associte table . so , its throw an redirection conflict error.
//In order to overcome that , we use one Annotation.

// which is this annotation used to overcome the rediretcional error . sometimes we whenevr we have a one table , that table act as assocition for anotrher , and also that table have a view .
//coming to service layer we expose a veiws table and expose a that assoacite table . this time the cap confusing 
// which is associate table , because the same table have a view also. that time we getting redirect 
   

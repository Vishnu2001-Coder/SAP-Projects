using {sap.capire.incidents as my} from '../db/schema';


service ProcessorService {
    entity Incidents as projection on my.Incidents;

    @readonly
    entity Customers as projection on my.Customers;
}

annotate ProcessorService.Incidents with @odata.draft.enabled;

annotate ProcessorService with @(requires: 'support');

service AdminService {
    entity Customers as projection on my.Customers;
    entity Incidents as projection on my.Incidents;
}

annotate AdminService with @(requires: 'admin');


//Tips
//In service layer , if i expose one enitity , that one have a assoicate table na , that also expose automattically


// aspect CodeList {
//   key code : String;
//   name     : localized String;
// }
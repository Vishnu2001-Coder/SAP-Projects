namespace sample.srv;
using { sample.db as db } from '../db/schema';


service MyService {
    entity MaterialValuationSet as projection on db.MaterialValuationSet;

    @cds.redirection.target
    entity PhysInventoryDocHeader as projection on db.PhysInventoryDocHeader; 
   
    function getCopyData() returns array of String;  //retrive the hana DB
}
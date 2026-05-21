using {sample.db as db  } from '../db/schema';



service MyService {
    
    @odata.draft.enabled
     entity Books as projection on db.Books {
        *  
    }
    actions {
        action update(name : String) returns String;
    };


    action update1(id:String,name:String,) returns String;
    entity Person as projection on db.Person;

    entity status as projection on db.status;

}
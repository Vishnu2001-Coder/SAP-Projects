namespace sample.db;
using { API_BUSINESS_SITUATION_SRV as busiApi } from '../srv/external/API_BUSINESS_SITUATION_SRV';

@cds.persistence.table
entity SitnDataContext as projection on busiApi.A_SitnDataContext{
   key SitnDataContextID,
    SitnInstceActivityID,
    CreationDateTime,

    Mines:Association to many Mine
     on Mines.SitnDataContext_id=$self.SitnDataContextID
}

entity Mine {
    key id:String;
      name :String;

      SitnDataContext_id:String;
      SitnDataContexts :Association to SitnDataContext 
      on SitnDataContexts.SitnDataContextID=$self.SitnDataContext_id;
    
}

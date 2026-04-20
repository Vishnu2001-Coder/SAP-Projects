namespace entity.db;
using {API_SERVICE_ORDER_SRV as api} from '../srv/external/API_SERVICE_ORDER_SRV';

 entity  MasterDataServiceOrderDefect as projection on api.A_ServiceOrderDefect {    // only those entity should have in BTP
   key ServiceOrder,
  key SrvcDocTypeDefectCodeProfType,
  key ServiceDefectSequence,
      SrvcDocTypeDefectCodeProfile,
      ServiceDefectCodeCatalog
}

entity CopyData{                                          //these feild only for storing storing purpose.
     key ServiceOrder                  :String;
     key SrvcDocTypeDefectCodeProfType :String;
     key ServiceDefectSequence         :Integer;
         SrvcDocTypeDefectCodeProfile   :String;
}

entity  CopyService{
  key ServiceConfirmation :String;
}

entity MyData{
  key Id        : String;
      dataname   :String;
     
      masterData :Association to MasterDataServiceOrderDefect;
}
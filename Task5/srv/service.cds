namespace ser.srv;
using { entity.db as db } from '../db/schema';
using {  API_SERVICE_ORDER_SRV as ServApi} from './external/API_SERVICE_ORDER_SRV';

service MyService {
 entity ServiceOrderConfirmation as projection on ServApi.A_ServiceOrderConfirmation;  // direct projection

 entity MasterDataServiceOrderDefect as  projection on db.MasterDataServiceOrderDefect;
 entity CopyData as projection on db.CopyData;
    
}

namespace external.srv;
using { API_BUSINESS_PARTNER as api } from './external/API_BUSINESS_PARTNER';
using { external.db as db } from '../db/external';



service MyService {
    entity AddressEmailAddress as projection on api.A_AddressEmailAddress{   // directly derived from csn .doesnt store
        key AddressID,
        key Person,
        OrdinalNumber
    }

    entity MasterAddressFaxNumber as projection on db.AddressFaxNumber1;     //dervied from db 
    // entity CopyAddressFaxNumber as projection on db.CopyAddressFaxNumber;
    

}
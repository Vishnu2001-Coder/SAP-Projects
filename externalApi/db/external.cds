namespace external.db;

using {API_BUSINESS_PARTNER as externaldata  } from '../srv/external/API_BUSINESS_PARTNER';

entity AddressFaxNumber1 as projection on externaldata.A_AddressFaxNumber{ 
   key AddressID,
   key Person,
   key OrdinalNumber,
   IsDefaultFaxNumber,
   FaxCountry,
   FaxNumber
}


// @cds.persistence.exists
// entity V_AddressFaxNumber {
//     key AddressID : String(50);
//     key Person : String(50);
//     key OrdinalNumber : String(10);
//     FaxCountry : String(10);
//     FaxNumber : String(50);
// }




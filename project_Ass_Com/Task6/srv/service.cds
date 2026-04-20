type GeoData {
    latitude  : Decimal;
    longitude : Decimal;
    name      : String;
}


service MyService {
     function getGeoInfoCity     (city : String)  returns GeoData;
     function getGeoInfoPincode  (pincode:String) returns GeoData;
     function getGeoInfoState    (state:String)   returns GeoData;  
}
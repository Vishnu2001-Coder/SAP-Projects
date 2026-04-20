// type GeoResult {
//   latitude  : Double;
//   longitude : Double;
//   Name      : String;
// }

// type District {
//   distName : String;
//   lat      : Double;
//   lon      : Double;
// }


service MyService {
  function getGeoInfo(datas : String) returns array of String;
  function getDistrictsByState(state:String) returns array of String;
}
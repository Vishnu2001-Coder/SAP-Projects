const cds = require('@sap/cds');
const axios=require('axios');           //its an lib used to call ythe api and fetch the data.
const { response } = require('express');
module.exports = cds.service.impl(async function() {

  //find the city lat and long
    this.on('getGeoInfo', async (req) => {
        const {datas} = req.data;     //like number 600077

        const check=isNaN(Number(datas))
         if(check){   
             const url =`https://nominatim.openstreetmap.org/search?q=${datas}&format=json&addressdetails=1&limit=22`;
             const response = await axios.get(url, {
                headers: {
                    'User-Agent': 'SAP-CAP-Location-Service'
                }})
                const data=response.data[0];

                const type=data.addresstype;
                console.log(type);
                

                switch(type){
                  case "city"           : return getGeo(datas);
                                          break;
                  case "state_district" : return getOpenStreet(datas)
                                          break;
                  case "state"          : return getOpenStreet(datas)
                                          break;
                  case "country"        : return getAllStates(datas);
                                          break;
                  default              : return req.error("Unsupported location type");
                }              
           
         }
         else{
               return  getPincode(datas);
         }


        async function getPincode(pincode){
          try{
         if(pincode.length===6){
               const url=`https://api.postalpincode.in/pincode/${pincode}`;
               const res=await fetch(url);
               const data=await res.json();

               if(data[0].Status==='Error'){
                return req.error(`THERE IS NO DATA ,KINDLY CHECK THE PINCODE AGAIN`)
                }
                else{
                       const city=data[0].PostOffice[0].District;
                       return getGeo(city)   ;  
                }
            } 
      else{
           return req.error(`THIS NUMBER IS INVALID ,KINDLY CHECK THE TOTAL NUMBER IS 6 BUT YOUR PINCODE IS ->${pincode} ` )
          }}
          catch(err){
               return req.error(`SORRY ${err.message}`)
          }

        }

      async function getGeo(city) {
       try{
           if (city && city.trim() !== ""){
             const url = `https://geocoding-api.open-meteo.com/v1/search?name=${city}&count=1&language=en&format=json`;
             let res = await fetch(url);
             res=await res.json();

             if(!res.results){
                   return req.error(`THERE IS NO DATA IN THIS NAME -> ${city}`)
               }
               else{
                     const url = `https://geocoding-api.open-meteo.com/v1/search?name=${city}&count=1&language=en&format=json`;
                     let res = await fetch(url);
                     res=await res.json();
                     let data = res.results[0];

                     let result = {
                     latitude    : data.latitude,
                     longitude   : data.longitude,
                      Name    : data.name
                     }

                     return result;
                    }
             }
            else{
            return req.error(`KIDLY FILL A RIGHT CITY ${city}`)
            }

       }
       catch(err)
       {
        return req.error(err.message)
       }

      }

      async function getOpenStreet(state_district) {
       try{
        const url =`https://nominatim.openstreetmap.org/search?q=${state_district}&format=json&addressdetails=1&limit=22`;
        const response = await axios.get(url, {
                headers: {
                    'User-Agent': 'SAP-CAP-Location-Service'
                }})
                const data=response.data[0];
                console.log(data);
                const result={
                  name :data.name,
                  lat : data.lat,
                  lon :data.lon,
                  type :data.addresstype
                }
                return result
          }
          catch(err){
             return req.error(err.message);
          }
      }
   

      async function getAllStates(countrycode) {
        try{
             if(countrycode.length===2)
             {              
                  const url = `https://api.countrystatecity.in/v1/countries/${countrycode}/states`;
                  const res = await axios.get(url, {
                  headers: { 'X-CSCAPI-KEY': '59b26accbf3a038e7b55dc0b2d99bddba581ac2bdbd0fad556ef1970947c0fe9' }
                  });

                 const data=res.data;
                 const result=data.map(e=>({
                  name:e.name,
                  longitude:e.longitude,
                  latitude:e.latitude
                 }))
                 console.log(result);
                 return result
             }
             else{
              return req.error('KINDLY, ENTER A COUNTRY CODE LIKE THIS-> (IN) TO FETCH THE ALL STATES')
             }
        }
        catch(err)
        {
           return req.error(err.message);
        }
        
      }

})
  
      //this for get all district given by state
      this.on('getDistrictsByState', async (req) => {
 
      const {state} = req.data;
 
      try{
 
        const url = `http://api.geonames.org/searchJSON?q=${state}&maxRows=1&featureCode=ADM1&username=ramila`
        const response = await axios.get(url);
        const geonameId=(response.data.geonames[0].geonameId);
    
 
        const DistUrl = `http://api.geonames.org/childrenJSON?geonameId=${geonameId}&username=ramila`;
        const distResponse = await axios.get(DistUrl);
        console.log(distResponse.data.geonames,distResponse.data.totalResultsCount);


        const datas = distResponse.data.geonames;
        const results= datas.map(ele=> ({
          distName : ele.name,
          lat : ele.lat,
          lon : ele.lng
        }));
        console.log(results);
        return results;
        
      }catch(err){
        console.log('Error fetching states:', err.message);
        return [];
       
      }
 
  })
 

// this.on('getGeoInfo', async(req)=>{
//   const {datas}= req.data
//   console.log(datas);
  
//      const url = `https://geocoding-api.open-meteo.com/v1/search?name=${datas}&count=1&language=en&format=json`;
//              let res = await fetch(url);
//              res=await res.json();
//             const result=res.results[0];
//             return result;
// })
     
    
 
   })
 

 


 
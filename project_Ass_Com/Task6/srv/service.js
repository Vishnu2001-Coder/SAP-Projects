const cds = require('@sap/cds');
module.exports = cds.service.impl(async function name( ) {

    this.on('getGeoInfoCity', async (req) => {
        const city = req.data.city;

        if(city===null||city===''||city===undefined)
        {
              return req.error("Empty is not allowed");
        }

        const url = `https://geocoding-api.open-meteo.com/v1/search?name=${city}&count=1&language=en&format=json`;
        let res = await fetch(url);
        res = await res.json();  

        if(!res.results){
            return req.error(`There is no Data in this name -> ${city}`)
        }

        let data = res.results[0];
        let result = {
                latitude    : data.latitude,
                longitude   : data.longitude,
                 Name    : data.name
            }
        return result;
    })

    this.on('getGeoInfoPincode',async (req)=>{
      const pincode = req.data.pincode;
      if(pincode.length!=6){
        return req.error(`pincode need totaly 6 number but your gave ${pincode}`)
      }
      const url=`https://api.postalpincode.in/pincode/${pincode}`;
      const res=await fetch(url);
      const data=await res.json();
       
      if(data[0].Status==='Error'){
         return req.error(`There is no details in ${pincode}`)
      }
      
      const city=data[0].PostOffice[0].District;
      console.log("hi");
      
      console.log(data[0].PostOffice[0]);
   
      const url1=`https://geocoding-api.open-meteo.com/v1/search?name=${city}&language=en&format=json`;
      let res1=await fetch(url1);
         res1=await res1.json();
         console.log(res1);
         
         const obj= {
           name: res1.results[0].name,
           latitude:res1.results[0].latitude,
           longitude:res1.results[0].longitude
         }

         return obj;
    })



    this.on('getGeoInfoState',async (req)=>{
        const state=req.data.state;



    })
})
 

 


 
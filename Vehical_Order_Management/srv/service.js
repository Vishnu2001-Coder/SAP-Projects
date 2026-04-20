const cds=require('@sap/cds');
const { path } = require('@sap/cds/lib/compile/parse');
const { INSERT, SELECT, UPDATE } = require('@sap/cds/lib/ql/cds-ql');

  module.exports=cds.service.impl(async function() {
     const{Vehicles,Dealers,Orders,States}=this.entities;

     const des=await cds.connect.to('cordinates');
   

     //Validate the payload value , any entity came
     this.before('CREATE','*', async (req) => {
        const entityName = req.target.name; 
        console.log(`Creating record in entity: ${entityName}`);
        const data = req.data;
        for (const field in data) {    
            if (data[field] === null || data[field] === undefined || data[field]==="") {
                req.error(400, `Field ${field} cannot be empty`);
            }
        }
    });

//      const stateMap = new Map([ 
//        ["Andhra_Pradesh", { prefix: "AP", tax: 0.16 }],
//        ["Arunachal_Pradesh", { prefix: "AR", tax: 0.15 }],
//        ["Assam", { prefix: "AS", tax: 0.16 }],
//        ["Bihar", { prefix: "BR", tax: 0.17 }],
//        ["Chhattisgarh", { prefix: "CG", tax: 0.18 }],
//        ["Goa", { prefix: "GA", tax: 0.19 }],
//        ["Gujarat", { prefix: "GJ", tax: 0.20 }],
//        ["Haryana", { prefix: "HR", tax: 0.20 }],
//        ["Himachal_Pradesh", { prefix: "HP", tax: 0.17 }],
//        ["Jharkhand", { prefix: "JH", tax: 0.18 }],
//        ["Karnataka", { prefix: "KA", tax: 0.20 }],
//        ["Kerala", { prefix: "KL", tax: 0.17 }],
//        ["Madhya_Pradesh", { prefix: "MP", tax: 0.18 }],
//        ["Maharashtra", { prefix: "MH", tax: 0.21 }],
//        ["Manipur", { prefix: "MN", tax: 0.16 }],
//        ["Meghalaya", { prefix: "ML", tax: 0.16 }],
//        ["Mizoram", { prefix: "MZ", tax: 0.16 }],
//        ["Nagaland", { prefix: "NL", tax: 0.16 }],
//        ["Odisha", { prefix: "OD", tax: 0.17 }],
//        ["Punjab", { prefix: "PB", tax: 0.19 }],
//        ["Rajasthan", { prefix: "RJ", tax: 0.18 }],
//        ["Sikkim", { prefix: "SK", tax: 0.15 }],
//        ["Tamil_Nadu", { prefix: "TN", tax: 0.18 }],
//        ["Telangana", { prefix: "TS", tax: 0.19 }],
//        ["Tripura", { prefix: "TR", tax: 0.16 }],
//        ["Uttar_Pradesh", { prefix: "UP", tax: 0.19 }],
//        ["Uttarakhand", { prefix: "UK", tax: 0.17 }],
//        ["West_Bengal", { prefix: "WB", tax: 0.18 }]
//  ]);


//   this.on("CREATE","Vehicles",(req)=>{
//       const state= req.data.state;
//       let  {vehicleId,currentPrice}=req.data;  
//       const stateInfo = stateMap.get(state);  

//      if(!stateInfo){
//       req.error("Invalid State");
//     } 
     
//        vehicleId = stateInfo.prefix + "-" + vehicleId;
//        currentPrice += (currentPrice * stateInfo.tax);

//        const obj={
//         vehicleId,    
//         modelName    :req.data.modelName,
//         currentPrice,
//         state          :req.data.state,
//         dealer_dealerId  :req.data.dealer_dealerId }

//       const tx=cds.tx(req);
//       const result =tx.run(INSERT.into(Vehicles).entries(obj));
//       return result;
// })

                                        
    this.on('CREATE', '*', async (req) => {
      try{
        const entity = req.target.name;
        console.log(entity);
        
        const data = req.data;
        const tc = cds.tx(req);

        if(entity === 'VehicleService.Vehicles'){

            const updatedData = await getUpdatedVehicleI(data);
            await tc.run(INSERT.into(entity).entries(updatedData));
            return updatedData;    
        }
        else if(entity==='VehicleService.Dealers')
        {    
              console.log("hi");    
             const {stateId}=req.data 
             const stateInfo=await SELECT.one.from(States).where({stateId});
             const city=stateInfo.stateName;
             console.log(city);
             
             await tc.run(INSERT.into(Dealers).entries(data));
             
             const res=await des.send({
              method:'GET',
              path :`/odata/v4/my/getGeoInfo(datas='${city}')`
             })
             console.log(res);
             
            return res;
        }
        await tc.run(INSERT.into(entity).entries(data));
      }
      catch(err){
        return req.error(err.message)
      }
    });

    

     async function getUpdatedVehicleI(vehicle){
        
        let updatedVechicleId = "";
        const dealerId = vehicle.dealer_dealerId;
        const randomId = Math.round(Math.random()* (9999 - 1000) + 1000);


        const dealer = await SELECT.one.from(Dealers).where({ dealerId });
        const stateId = dealer.stateId;
        const stateInfo = await SELECT.one.from(States).where({ stateId });

        updatedVechicleId += stateInfo.stateCode;
        updatedVechicleId += randomId;
        vehicle.vehicleId = updatedVechicleId;
        
        return vehicle;
    }

    this.on('UPDATE','Vehicles',async (req)=>{
      const {vehicleId,cur_price}=req.data;
      console.log(cur_price);
      console.log(vehicleId);
      
      if(!vehicleId)
      {
        req.error(501,'vehicleId is not there');
      }
      
      const vehiData = await SELECT.one.from(Vehicles).where({vehicleId});
       console.log(vehiData);
       const result=await UPDATE(Vehicles).set({old_price:vehiData.cur_price,cur_price:cur_price}).where({vehicleId});
       console.log(result);
      return result;
})

  // this.on('addData',async (req)=>{
  //   console.log("hi");
  //  const  state =req.data.state
  //  console.log(state);
   
    
  //   const res=await INSERT.into(States).entries(state);
  //   return res;

  // })
  //  this.on('adddata',async (req)=>{
  //   const dealer=req.data.dealer;
  //   console.log(dealer);
  //   const res= await INSERT.into(Dealers).entries(dealer);

  // })
  
     // const datas=req.data.datas -> tamilnadu / const {datas}=req.data -> tamilnadu
     // const data=req.data -> store the Full Objects


});



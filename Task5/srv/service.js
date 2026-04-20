const cds = require ('@sap/cds');
const { INSERT, SELECT } = require('@sap/cds/lib/ql/cds-ql');

module.exports =cds.service.impl(async function(){
 const {ServiceOrderConfirmation,MasterDataServiceOrderDefect,CopyData,CopyService}=this.entities;
 const s4=await cds.connect.to('API_SERVICE_ORDER_SRV');
   
//    this.on('READ', '*', async (req,next) => {
//     const isExternal = req.target['@cds.external'];  
//     console.log(req.target);
//     console.log(req.query);
    
//     if (isExternal) {
//         const result = await s4.run(req.query);
//          console.log(req.query);
//         return result;
//     } 
//     else {
//         // const result = await SELECT.from(req.target);
//         // const res    = cds.run(req.query);
//          console.log(req.query);
//         return next();


//     }

// });



    // this.on('READ',ServiceOrderConfirmation,async (req)=>{
    //     console.log("hi");
    //    const result= await s4.run(req.query);
    //    console.log(result);
    //    console.log(req.target);
    //     console.log(req.target.name);
    //    return result;
    // })

     this.on('READ',(MasterDataServiceOrderDefect,ServiceOrderConfirmation),async (req)=>{
        console.log("hi");
       const masterres= await s4.run(req.query);
       console.log(masterres);
       const res=await INSERT.into(CopyService).entries(masterres); // also use send or emit
       console.log(res);
       return masterres;
    })


    // this.on('*',async (req)=>{           // this will wrk on any event , any entities
    //   console.log(req);
      
    // })



    // this.on('READ',CopyData,async (req)=>{
    //    console.log(req.target);
    //    const result= await SELECT.from(CopyData);
    //    console.log(result);
    //    console.log(req.target);
    //     console.log(req.target.name);
    //    return result;
    // })

})

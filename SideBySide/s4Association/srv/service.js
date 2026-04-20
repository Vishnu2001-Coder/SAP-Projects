const cds=require('@sap/cds');
const { SELECT,UPSERT} = require('@sap/cds/lib/ql/cds-ql');
module.exports=cds.service.impl(async function(){
    const {SitnDataContext,SitnDataInstance,Mine}=this.entities;
    const s4=await cds.connect.to('API_BUSINESS_SITUATION_SRV');

    this.on('READ',SitnDataContext,async (req)=>{
        console.log("hi");  
        const data=await s4.run(req.query);
        const res=await UPSERT.into('SitnDataContext').entries(data)
        return data;
    })

    this.on('READ',Mine,async(req)=> {
        return cds.run(req.query);
    })
})
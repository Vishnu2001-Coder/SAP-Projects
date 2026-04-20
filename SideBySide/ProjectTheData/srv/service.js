const cds = require('@sap/cds');
const { SELECT } = require('@sap/cds/lib/ql/cds-ql');

module.exports=cds.service.impl(async function(){
    const {MaintOrderConfirmation,LongText}=this.entities;
    const s4 = await cds.connect.to('API_MAINTORDERCONFIRMATION');
    this.on('READ','*',async (req,next)=>{
     const res= await s4.run(req.query);                    //direct query
      const result= await s4.run(SELECT.from(LongText))     //custom query
       return res;
    })
});
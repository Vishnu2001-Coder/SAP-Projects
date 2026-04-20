const cds=require('@sap/cds');
const { SELECT,UPSERT} = require('@sap/cds/lib/ql/cds-ql');
module.exports=cds.service.impl(async function () {
    const s4=await cds.connect.to('API_PHYSICAL_INVENTORY_DOC_SRV');
    const {PhysInventoryDocHeader,PhysInventoryDocItem}=this.entities;
 
    this.on('READ',PhysInventoryDocHeader, async(req)=>{
        const tc=cds.tx(req);
        if(req.target['@cds.external']){   
        const data= await s4.run(req.query);
        const res=await tc.run(UPSERT.into(PhysInventoryDocHeader).entries(data));
        console.log(res);
        return data;
    }
    })
  
    this.on('getCopyData',async (req)=>{
       const res= await cds.run(SELECT.from(PhysInventoryDocHeader));
       return res;
    })

})
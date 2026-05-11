const cds=require('@sap/cds');
const { INSERT, SELECT } = require('@sap/cds/lib/ql/cds-ql');
module.exports=cds.service.impl(async function(){
  
 


    this.on('CREATE','*',async (req)=>{
           const entityName=req.target.name;
           console.log(entityName);       

           const data=req.data;
           console.log(data);

           const res=await INSERT.into('Orders').entries(data);                  //Storing in activeEntity
         //  const response= await INSERT.into(entityName).entries(data);
           
          
           
           return "DATA CREATED"                         
    })

    this.on('getData',async (req)=>{
            const draft  = await SELECT.from('CatalogService.Orders_drafts');
            console.log(draft);
            
            const data = await SELECT.from('Orders');
            console.log(data);
            
            let result=[data,draft]
            console.log(result);
            
            // console.log(result)
            return result;
});
    })



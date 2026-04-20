// const cds=require('@sap/cds');
const { INSERT } = require('@sap/cds/lib/ql/cds-ql');

module.exports=cds.service.impl(async function () {
    const {Books}=this.entities

    this.on('CREATE',Books,async(req ,next)=>{
        try{
          console.log("hi");
          const data=req.data;
          console.log(data);
          const res= await cds.run(next);// INSERT.into(Books).entries(data)//
        }        
       catch(err)
         {
               return req.error(err.message);
         }
         })


    this.on('addData',async(req ,next)=>{
        try{
          console.log("hi");
          const data=req.data.data;
          console.log(data);
         // const res= await cds.run(next);// INSERT.into(Books).entries(data)//
         const res=await INSERT.into(Books).entries(data);
        }        
        catch(err)
        {
              return req.error(err.message);
        }


    })



    
})
const cds=require('@sap/cds');
const { SELECT,UPSERT} = require('@sap/cds/lib/ql/cds-ql');
module.exports=cds.service.impl(async function () {
    const s4=await cds.connect.to('API_SUPLR_EVAL_SCORECARD_SRV');
    const db = await cds.connect.to('db');
    const  {SuplrEvalSccrdSection,SuplrEvalSccrdSection1,SupplierEvalScorecardSectionDB}=this.entities;

    //THIS FOR Projected feilds and storedata in hana
    this.on('READ',SuplrEvalSccrdSection,async(req)=>{
        if(req.target['@cds.external']){
          const data =  await s4.run(req.query);
          const res  =  await UPSERT.into(SupplierEvalScorecardSectionDB).entries(data);
          return s4.run(req.query);
        }
       else{
        return cds.run(req.query)
       }
    })

    //THIS for feilds are not projected  , so we only create a objects
    this.on('READ',SuplrEvalSccrdSection1,async(req)=>{
        const data =  await s4.run(req.query);
        const obj=fetchData(data);  
        await this.emit('addData',obj);
        return data;
        })

   function fetchData(data){
       let obj= data.map(prop=>({
        SuplrEvalSccrdSectionUUID     : prop.SuplrEvalSccrdSectionUUID,
        SuplrEvalSccrdUUID            : prop.SuplrEvalSccrdUUID ,
        SuplrEvalRspQuestionnaireUUID : prop.SuplrEvalRspQuestionnaireUUID,
        SupplierEvalScorecardSection  : prop.SupplierEvalScorecardSection,
        SupplierEvalScorecardSctnAltv : prop.SupplierEvalScorecardSctnAltv,
        QuestionnaireSectionName      : prop.QuestionnaireSectionName
        }))
        return obj;
    }


    this.on('addData',async (req)=>{
      const res=await UPSERT.into(SupplierEvalScorecardSectionDB).entries(req.data);
    })

});

    



//1.wherver we use UPSERT ia always refer a db.Entity not service projection . so cap dosnt convert automattically.
//2.
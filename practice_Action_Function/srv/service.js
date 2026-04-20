const cds=require("@sap/cds");
const { INSERT, UPDATE, DELETE, SELECT } = require("@sap/cds/lib/ql/cds-ql");
module.exports=cds.service.impl(async function () {

 const {Student,Courses,StudentCourse}= this.entities;

 this.on('addStudent',async (req)=>{
    const tx=cds.tx(req);
    const {students}=req.data;

    const result=await tx.run(INSERT.into(Student).entries(students));
    if(!result){
        req.error("500,Something db Issue");  
    }
    console.log(result);                                                                     //cds.ql { INSERT: { into: { ref: [Array] }, entries: [ [Object], [Object] ] } ?
    return result;                                                                           // return the odata response  -> "results": {"changes": 2}
    
 })

 this.on('addCourse',async (req)=>{
    const tx=cds.tx(req);
    const {course}= req.data;     

    const result=await tx.run(INSERT.into(Courses).entries(course));
    if(!result)
    {
        req.error(500,"Something Issue");
    }
    return "Success";
 })

this.on('enrollment', async (req)=>{
         const tx=cds.tx(req);
        const {enroll}= req.data;

        const result =await tx.run(INSERT.into(StudentCourse).entries(enroll));
        if(!result)
    {
        req.error(500,"Something Issue");
    }
    return "Success";

})

this.on('putName', async (req)=>{
    const tx=cds.tx(req);
    const {name,stuId}=req.data;
    
    const result= await tx.run(UPDATE(Student).set({name}).where({ id: stuId }));
     if(!result)
    {
        req.error(500,"Something Issue");
    }
    console.log(result);                                  //1
    
    return result;                                        // {"@odata.context": "$metadata#Edm.String","value": } in console 1

})

this.on('delName',async(req)=>{
    try{
    const tx=cds.tx(req);
    const {stuId}=req.data;

    const result=await tx.run(DELETE.from(Student).where({id:stuId}));
     if(!result)
    {
        req.error(500,"Something Issue");
    }  
    console.log(result);                                        //1
    return result;                                              //{"@odata.context": "$metadata#Edm.String","value": 1 }
}
  catch(err)
  {
    return req.error(err.message);
  }
})
    

//Function
 this.on('getStuCourse',async(req)=>{
    const {stuId}=req.data;

  const result = await SELECT
    .from('StudentCourse as sc')
    .join('Courses as c')
    .on('sc.course = c.id')
    .where({ 'sc.student': stuId })
    .columns('c.c_name');

  return result;

});


 //Trigger
 this.on('addStudentCourse',async (req)=>{
 try{
    const {students,course}=req.data;

   await this.emit({                                                                       // its used to trigger the another on handler , where we can already gave that event and send a req datas
       event :'addStud',
       data : {students}
    })
   await  this.emit({
        event:'addCour',
        data:{course}
    })

    return"Succussfully Saved All Data";
} catch(err)
{
    return req.error(500,"Hi",err.message);
}

 })


 this.on('addStud',async(req)=>{
    const tx=cds.tx(req);
    const {students}=req.data;
    const result=await tx.run(INSERT.into(Student).entries(students));
    if(!result)
    {
         return req.error(500,"Something Issue In Student DB")
    }
    return 'SuccesFull Saved In Student DB';
 })

  this.on('addCour',async(req)=>{
    const tx=cds.tx(req);
    const {course}=req.data;
    const result=await tx.run(INSERT.into(Courses).entries(course));
    if(!result)
    {
         return req.error(500,"Something Issue In Course DB")
    }
    return 'SuccesFull Saved In DB';
 })
 
})

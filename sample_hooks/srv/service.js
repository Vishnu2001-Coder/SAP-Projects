const cds=require('@sap/cds');      //CapFrameWork -> without this hooks will not work
const { SELECT, INSERT } = cds.ql;

module.exports=cds.service.impl(function(){    // we want to import that service projection , to write custom logics
    const{Students} =this.entities;            // this.entities refers the service  inside see the all service

    this.before('CREATE',Students,(req)=>{     // (3 parameter -> 'Event' , entity , req )
    if(req.data.name)
       req.data.name=req.data.name.toUpperCase();
        console.log(req.data);
        console.log(req.data.name);
    }) 

     this.on('CREATE', Students, async (req, next) => {  // Overided the default generic handler
        console.log("On Hook Triggered");
        try{
        // Call default DB insert
          const result = await next();     // im calling the default handler inside this hooks function.
        //  const result = await INSERT.into(Students).entries(req.data);   
         console.log(result);  // it return the InsertResult {results: { changes: 1 }} 
         if (result.results.changes === 1)
             {
                return "Insert successful";
            }
            else(
                   req.error(500,"not valid")
            )}
         catch(err)
        {
            console.log(err);
            return req.error(err.message);    
         } 
    });

    //  this.after('CREATE', Students, (data, req) => {
    //     console.log("After Hook Triggered");          
    //     console.log(data);                           // after db executes , use data
    //     data.name = data.name + " (Created)";
    //     return data;
    // });









    //filter the records in get
    this.on('READ',Students,async (req)=>{
        try{
             const id=req.data.id;
            if(id){
                let result= await ( (SELECT.from(Students).where({id})));   //cds.run is for execute , other wise we only Build the Query
                console.log(result);
                return result;
            }
                
            //     if(!result.length)
            //     {
            //         return req.error(404,"No Records")
            //     }
            //     else{
            //         return result;
            //     }
            // }
            else{
                 return await (SELECT.from(Students));
            }
        }
        catch(err)
        {
            return req.error(404,err.message);
        }
   })


   this.on('getByStudentsId',async (req)=>{
    const {empid}=req.data;
    console.log(empid);
    console.log(Students);
    const fetch=await SELECT.from(Students).where({id:empid})   // return a array of single objects.
    console.log(fetch);
    return fetch; 
   })


   this.on('addStudents',async (req)=>
{
    try{
       
        const {Stu} =req.data.Students1;                       //1
        const result= await INSERT.into(Students).entries(Stu);
        console.log(result);
    
        if(result)
    {
        return "DATA INSERTED"
    }
    else{
        return req.error(500,"Something error");
    }
}

catch(err)
{
    return req.error(500,err.message)
}
    
})








})


//  note
//  1. 1st parameter in hooks sholud be in Uppercase ->'CREATE','READ','UPDATE','DELETE'.
//  2. CONSOLE -> before send to the server (see browser console)
//  2. CONSOLE -> before send to the server (see cap terminal)

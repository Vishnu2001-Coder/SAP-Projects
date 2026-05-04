module.exports=cds.service.impl(async function (srv){
    

    this.on('update1',async (req)=>{
        try{
            console.log("hello");
            
        const data=req.data;
        console.log(data,data.id,data.name);
        
        const tc=cds.tx(req);
        const res= await tc.run(UPDATE('Books').set({author_name:data.name}).where({id:data.id}));
        console.log("Hello");
        return 'Succes'
        }
        catch(err)
        {
            return req.error(err.message);
        }
    })

    
})
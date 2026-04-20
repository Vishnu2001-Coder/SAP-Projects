// const cds =require('@sap/cds');
// module.exports=cds.service.impl(async function(){
//     const openStreet=cds.connect.to('OPEN_STREETMAP')
   
//     this.on('getDataApi',async (req)=>{
//         console.log("hi");
        
//         const {data}=req.data
//         console.log(data);
        
//           const response=await openStreet.send({
//             method:'GET',
//             path:`/search?q=${data}&format=json&addressdetails=1&limit=22`
//            })
//               console.log(data);          
//               console.log(response);
//               return response;
//     })


// } )
const cds = require('@sap/cds');

module.exports = cds.service.impl(async function () {

    const openStreet = await cds.connect.to('OPEN_STREETMAP');

    this.on('getDataApi', async (req) => {
        console.log("hi");

        const { data } = req.data;
        console.log(data);

        const response = await openStreet.send({
            method: 'GET',
            path: `/search?q=${data}&format=json&addressdetails=1&limit=22`
        });

        

        const rese = await openStreet.send({
            method: 'POST',
            path: `/odata/v4/my/addmy`,
            data: {input :req.data}
        });

         const resp = await openStreet.send({
            method: 'GET',
            path: `/odata/v4/my/addmy(input=${req.data})`
        });

        console.log(response);

        return response;   
    });

});
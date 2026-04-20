const cds  = require('@sap/cds');
 
module.exports = cds.service.impl(async function () {
 
  this.before("CREATE", "Incidents", (req) => changeUrgencyDueToSubject(req.data));
  this.before("UPDATE", "Incidents", (req) => onUpdate(req));
 
});
 
function changeUrgencyDueToSubject(data) {
    let urgent = data.title?.match(/urgent/i)
    if (urgent) data.urgency_code = 'H'
}
 
async function onUpdate (req) {
  console.log("hi");
   console.log( req.subject.ref[0].where);
   
  //console.log(req.subject);
    let closed = await SELECT.one(1) .from (req.subject) .where `status.code = 'C'`
    console.log('hi');
    console.log(closed);
    if (closed) req.reject `Can't modify a closed incident!`
}


// { ref: [ { id: 'ProcessorService.Incidents', where: [Array] } ] }
// undefined
// [odata] [INFO] POST /odata/v4/processor/$batch 
// [odata] [INFO] > GET /Incidents(ID=3ccf474c-3881-44b7-99fb-59a2a4668418,IsActiveEntity=true)/conversation {
//   '$count': 'true',
//   '$select': 'HasActiveEntity,ID,IsActiveEntity,author,message,timestamp,up__ID',
//   '$skip': '0',
//   '$top': '10'
// }
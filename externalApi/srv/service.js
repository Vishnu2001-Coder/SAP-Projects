const cds = require('@sap/cds');
const { INSERT } = require('@sap/cds/lib/ql/cds-ql');

module.exports = cds.service.impl(async function () {
  const { AddressEmailAddress, MasterAddressFaxNumber,CopyAddressFaxNumbers } = this.entities;

  const s4 = await cds.connect.to('API_BUSINESS_PARTNER'); !!!

    this.on('READ', AddressEmailAddress, async (req) => {
      const data = await s4.run(req.query);
      //   console.log(s4);
      //   console.log(req.query);
      //   console.log(data);
      return data;
    })

  this.on('READ', MasterAddressFaxNumber, async (req) => {
    try {
      const data = await s4.run(req.query);
      console.log(data);
      
      this.send({
        event: 'adddataAddressFaxNumber',
        data
      })
      return data;
    }
    catch (err) {
      return req.err(500, err.message)
    }

  })

  this.on('adddataAddressFaxNumber', async (req, next) => {
    const { data } = req.data;

    const result = await INSERT.into(CopyAddressFaxNumber).entries(data);
    if (!result) {
      return req.error(500);
    }
  })
})


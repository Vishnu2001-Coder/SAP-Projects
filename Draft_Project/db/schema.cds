namespace sample.db;
using { cuid } from '@sap/cds/common';


entity Orders : cuid {
    orderNo     : String;
    customer    : String;
    amount      : Decimal(10,2);
}




/* “Draft fields like IsActiveEntity appear only when records exist. 
If the entity is empty, CAP returns an empty array without draft metadata.” 


 "HasActiveEntity": false,
 "HasDraftEntity": false, ❌ No draft exists -> draft la illa
 "IsActiveEntity": true   ->✅ This is a final saved (active) record/ This is a draft (temporary) record
      
      
    URL:
POST /odata/v4/catalog/Orders(ID=ddc01212-4021-4b01-99e2-13defd58f89d,IsActiveEntity=true)/draftEdit ?
  RESPONSE:
  {
	"@odata.context": "../$metadata#Orders/$entity",
	"ID": "dd9abe49-1f87-4f3c-839c-b1a3751b8bd4",
	"orderNo": "1001",
	"customer": "Vishnu",
	"amount": 5000,
	"HasActiveEntity": true,                      !!!
	"DraftMessages": [],
	"HasDraftEntity": false,
	"IsActiveEntity": false
}

AFTER GET :
{
  "@odata.context": "$metadata#Orders",
  "value": [
    {
      "ID": "dd9abe49-1f87-4f3c-839c-b1a3751b8bd4",
      "orderNo": "1001",
      "customer": "Vishnu",
      "amount": 5000,
      "HasActiveEntity": false,
      "HasDraftEntity": true,                 !!!
      "IsActiveEntity": true
    }
  ]
}

| Action         | URL                            |
| -------------- | ------------------------------ |
| Create Draft   | `/draftEdit`                   |
| Update Draft   | `PATCH (IsActiveEntity=false)` |
| Activate Draft | `/draftActivate`               |
| Delete Draft   | `/draftDiscard`                |


3. Correct Key Format
Orders(ID=<UUID>,IsActiveEntity=true)

✔ IsActiveEntity=true is mandatory
👉 because you are editing the active record

🔥 Alternative Draft Actions (Useful)
✅ Activate Draft
POST /odata/v4/catalog/Orders(ID=<UUID>,IsActiveEntity=false)/draftActivate
❌ Delete Draft
POST /odata/v4/catalog/Orders(ID=<UUID>,IsActiveEntity=false)/draftDiscard
✏️ Update Draft
PATCH /odata/v4/catalog/Orders(ID=<UUID>,IsActiveEntity=false)

Body:

{
  "amount": 9000
}     
*/
namespace sample.db;
using {  API_MATERIAL_VALUATION_SRV as matApi} from '../srv/external/API_MATERIAL_VALUATION_SRV';
using { API_PHYSICAL_INVENTORY_DOC_SRV as phyApi } from '../srv/external/API_PHYSICAL_INVENTORY_DOC_SRV';


entity MaterialValuationSet as projection on matApi.MaterialValuationSet;

@cds.persistence.table
entity PhysInventoryDocHeader as projection on phyApi.A_PhysInventoryDocHeader;   //first time fetch and store same DB

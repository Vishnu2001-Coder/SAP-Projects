namespace sample.srv;
using {sample.db as Manage_api} from '../db/schema';

service MyService {
entity SuplrEvalSccrdSection as projection on Manage_api.SuplrEvalSccrdSection;
entity SuplrEvalSccrdSection1 as projection on Manage_api.SuplrEvalSccrdSection1;
entity SupplierEvalScorecardSectionDB as projection on Manage_api.SupplierEvalScorecardSectionDB;

    

}
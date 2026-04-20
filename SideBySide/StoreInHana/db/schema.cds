namespace sample.db;
using { API_SUPLR_EVAL_SCORECARD_SRV as api } from '../srv/external/API_SUPLR_EVAL_SCORECARD_SRV';

entity SuplrEvalSccrdSection as projection on api.A_SuplrEvalSccrdSection{
    key SuplrEvalSccrdSectionUUID ,
        SuplrEvalSccrdUUID ,
        SuplrEvalRspQuestionnaireUUID ,
        SupplierEvalScorecardSection ,
        SupplierEvalScorecardSctnAltv,
        QuestionnaireSectionName
}

entity SupplierEvalScorecardSectionDB {
   key SuplrEvalSccrdSectionUUID      : UUID not null;
    SuplrEvalSccrdUUID                 : UUID;
    SuplrEvalRspQuestionnaireUUID      : UUID;

    SupplierEvalScorecardSection       : String(20);
    SupplierEvalScorecardSctnAltv      : Integer;
    QuestionnaireSectionName           : String(60);
}


entity SuplrEvalSccrdSection1 as projection on api.A_SuplrEvalSccrdSection;

namespace sample.srv;

using {sample.db as db} from '../db/schema';

service MyService {
entity SitnDataContext as projection on db.SitnDataContext;
//entity SitnDataInstance as projection on db.SitnInstance;
entity Mine as projection on db.Mine;
    
}
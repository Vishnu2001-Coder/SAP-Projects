namespace sample.srv;
using {API_MAINTORDERCONFIRMATION as api  } from './external/API_MAINTORDERCONFIRMATION';
using { sampel.db as db} from '../db/schema';

service MyService {
entity MaintOrderConfirmation as projection on db.MaintOrderConfirmation;
entity LongText as projection on api.LongText;
}

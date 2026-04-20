using { sample.db as db } from '../db/schema';

service MyService {
entity Order as projection on db.Order;

}


using {  sample.db as db} from '../db/schema';

//@requires:['Users', 'Admins','Dealers'] -> wrong because already we grant the authorization , so as per grant based authorization which will be work
//@requires:['Dealers']                   -> they can access the entire service, entity, or action 
@requires:['authenticated-user'] 
service MyService {

    entity Employee as projection on db.Employee;
    entity Person as projection on db.Person;



}
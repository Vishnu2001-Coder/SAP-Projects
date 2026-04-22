using {  sample.db as db} from '../db/schema';

@requires:['authenticated-user'] 
service MyService {


    @restrict:[{grant:['READ'],to :'Users'},
               {grant :['*'],to :'Admins'}]
    entity Employee as projection on db.Employee;


    entity Person as projection on db.Person;




}
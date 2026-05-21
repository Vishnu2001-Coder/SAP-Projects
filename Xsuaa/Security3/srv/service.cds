using {  sample.db as db} from '../db/schema';
authenticated-user
@requires:[''] 
service MyService {


    @restrict:[{grant:['READ'],to :'Users'},
               {grant :['*'],to :'Admins'}]
    entity Employee as projection on db.Employee;


    entity Person as projection on db.Person;




}
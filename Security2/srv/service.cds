using {  sample.db as db} from '../db/schema';

service MyService {

    @restrict:[{grant:['READ'],to :'Users'},
               {grant :['*'],to :'Admins'}]
    entity Employee as projection on db.Employee;

    @restrict:[{grant :['READ'],to :'Users'},
    {grant:['*'], to :'Admins'}]
    entity Person as projection on db.Person;

}
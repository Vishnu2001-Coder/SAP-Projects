using {  my.db as db} from '../db/schema';

service EmployeeService {

    entity Employees as projection on db.Employee ;
    entity Departments as projection on db.Department;
    entity Projects as projection on db.Project;
    entity Tasks as projection on db.Task ;
    entity Addresses as projection on db.Address;

}

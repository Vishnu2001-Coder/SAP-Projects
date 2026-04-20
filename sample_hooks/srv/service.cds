namespace sample.srv;

using { Order_Management.db as db } from '../db/schema';   

service Myapi{                                               

 entity Students as projection on db.Students;            

 function getByStudentsId(empid:String) returns Students;
 
 action addStudents(Students1:Students) returns String;


}
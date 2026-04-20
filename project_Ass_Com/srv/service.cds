namespace Relation.srv;

using {Relation.db as db  } from '../db/schema';

service MyService {
   entity Students as projection on db.Students;
   entity Courses as projection on db.Courses;
   entity StudentCourse as projection on db.StudentCourse;

   entity Employees as projection on db.Employees;
   entity Projects as projection on db.Projects;
   entity EmpProject as projection on db.EmpProject;

   entity Users as projection on db.Users;
   entity Roles as projection on db.Roles;
   entity UserRole as projection on db.UserRole;
   
   entity Orders as projection on db.Orders;
   entity Products as projection on db.Products;
   entity OrderProduct as projection on db.OrderProduct;

}
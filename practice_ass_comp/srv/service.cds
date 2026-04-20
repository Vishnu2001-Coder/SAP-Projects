namespace college.srv;
using {college.db as db} from '../db/schema';
using {comp.db as com } from '../db/schema1';



service CollegeApi{                                        //api boundry
    entity Emp as projection on db.Emp ;                   //end api
    entity Dep as projection on db.Dep;
    entity Students as projection on db.Students;
    entity Courses as projection on db.Courses;
    entity StudentCourse as projection on db.StudentCourse;

    entity Person as projection on com.Person;
    entity Identity as projection on com.Identity;
}
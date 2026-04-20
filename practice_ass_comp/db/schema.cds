namespace college.db;

entity Emp{
   key id:String;
      name:String;                         
     dept:Association to Dep;                 //One to One -> one employee for one dept
}

entity Dep{
    key id:String;
        color:String;                           
        emp:Association to many Emp on emp.dept=$self   //one to many , one department many employee
}



entity Students {
    key id:String;
        name:String;
        age:String;   
        Course:Association to many StudentCourse on Course.Student=$self;
}


entity Courses {
    key id:String;
        c_name:String;
        Student : Association to many StudentCourse on Student.Course=$self;

}

entity StudentCourse{
    key Student:Association to Students;
    key Course : Association to Courses;
}


//MANY TO MANY
//1.first analyse the both relation -> many  to many
//2.Create Junction table and create that primary Key ,and associate that junctiontable 



//Conclusion
//1.association to one -> camp create a forign key (NOT FOR MANY)
//2.Backlink is always want to a association table


//One to one ()
//1.Single side relation is enough
//2.no $self because , one to one only
//3.we manage and also capm manage. we manage na create forign key assign to relation Entity Id

//One to Many (Dept ,Emp)
//1.Both the sides is mandatory . so , first do (to one) entity , after do (to many).
//2.(to one) entity craete forign key and link to relation enityID.
//3.(to many) mandatory we manage and use $self(Refer the current entity primary key)
//4. Final tip ✔ Foreign key in many side , not both the sides.

//Many to Many
//1.craete the junction table. and craete a forign key ,like one to one  .
//2.now 


// DATA Inserting Order.
// 1st Forign key Table and then which table having forign key so, that table.     !!!


// 1️⃣ Insert Identy
// 2️⃣ Insert Person

// 1️⃣ Insert Dept
// 2️⃣ Insert Emp


// 1️⃣ Insert Student
// 2️⃣ Insert Course
// 3️⃣ Insert StuCour


// not recommed nested json , insert a forign key table.
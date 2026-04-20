namespace sample.db;
//Association 
//one to one ->  Person and Passport 
entity Person {
    id: String;
    name: String;
    age:String;
    // pass_No:String;
    passport:Association to Passport //on passport.id=pass_No; 
}

entity Passport{
    id:String;
    passport_No:String;

}


//tips
//1.Analysis the Mapping RelationShip for the both sides :1 per -> 1 Passport  ,1passport -> 1 person  ->1:1 
//2.create a forign key our choice to choose a entity.
//3. capm manage a fkey foe a 1:1 / we also manage .


// formula for both sides 
// 1 to 1 , 1 to 1 -> 1:1
// 1 to 1 ,m to 1  -> m:1
// m to 1 , 1 to 1 -> m:1
// m to m , m to m -> m:m


//one to many = many to one

entity EMP{ 
    id: String;
    name: String;                      
    age:String; 
    dept_no:String;
    dep:Association to Dept on dep.id=dept_no ; 
}


entity Dept{    
    id:String;
    dept_no:String;
    Emp:Association to many EMP on Emp.dept_no=id;

}

//1.Analysis the Mapping RelationShip for the both sides :1 per -> 1 Passport  ,1passport -> 1 person  ->m:1 
//2.create a forign key its not our choice to choose a entity. Its create a many side table
//3.1. single side connect internaly , and many keywod doesnt create a  forign key , in many side we only manage., without self also wrk but we have to set a current entity pKey


//many to many
entity Student{ 
  key id: String;
    name: String;
    age:String; 
    studentCourse : Association to many StudentCourse on studentCourse.student=$self;
}

entity Course{  
   key id: String;
    C_name: String;
     studentCourse : Association to many StudentCourse on studentCourse.course=$self;
}

entity StudentCourse{
   key student :Association to Student;
   key course  :Association to Course;
}

//m:m -> we mandatory to create a junction to generate a Fkey

// ex:1st type
// emp{
//     id : E101;
//     name : Priyan;
//     age :23;
//     dep:D101;
// }

// ex:2nd type  -> nested json is not recommed for Assocoition
// emp{
//     id : E101;
//     name : Priyan;
//     age :23;
//     dep:  {
//      id:123;
//      dept_no:D101;
//       }
// }


//Composition 
//one to one
entity Persons {
    id: String;
    name: String;
    age:String;
    identity:Composition of Identity on identity.persons=$self;
}

entity Identity{
    id:String;
    Aadhar_no:String;
    persons :Association to Persons;
}


//one to many-> 1:m
entity Order{
      key ID    : UUID;
      customer  : String;
      orderDetails :Composition of many OrderDetails on orderDetails.Order_Id=ID;
}

entity OrderDetails{
      key ID     : UUID;
     product    : String;
     quantity   : Integer;
     Order_Id:String;
     order    :Association to Order on order.ID=Order_Id;  
}




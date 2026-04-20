namespace comp.db;

entity Person{
    key id:String;
        name:String;
         Ident:Composition of one Identity on Ident.parent=$self;
        // Ident:Composition of many Identity on Ident.parent=$self;
}

entity Identity {
    key id:String;
    Identity_name:String;
    parent:Association to Person;     // this is use for internally connected  
}  



//no need
entity Students {
    key id : String;
    name   : String;
     
    courses : Composition of many StudentCourse
              on courses.student = $self;
}

entity Courses {
    key id : String;
    c_name : String;

    students : Association to many StudentCourse
               on students.course = $self;
}

entity StudentCourse {
    key student : Association to Students;
    key course  : Association to Courses;
}

//Both sides analyse for relation and give its an biderectional
//1.one to one naa , its our choice where we can parent.we only manage the composition.
//2.we manage and not declare the extra feild , instead of use backlink thats only internally connect



//Composition -> Both the sides are mandatory , because composition
//1.
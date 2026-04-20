namespace order.db;

entity Students {
    key id : String;
    name   : String;
    age    :  String;
    phn    :  String;

    courses : Association to many StudentCourse
              on courses.student = $self;
}

entity Courses {
    key id : String;
    c_name : String;
    c_price: String;

    students : Association to many StudentCourse
               on students.course = $self;
}

entity StudentCourse {
    key student : Association to Students;
    key course  : Association to Courses;
}



entity Person{
    key id:String;
        name:String;
        age:String;
        Ident:Composition of many Identity on Ident.parent=$self;
}

entity Identity {
    key id:String;
    Identity_name:String;
    parent:Association to Person;     // this is use for internally connected
    
}
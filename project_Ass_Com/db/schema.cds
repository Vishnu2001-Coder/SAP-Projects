namespace Relation.db;
//1.
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


 using { managed } from '@sap/cds/common'; 

//2
entity Employees :managed{
    key id : String;
    name   : String;
    age :String;
    e_mail:String;

    projects : Association to many EmpProject
               on projects.employee = $self;
}

entity Projects {
    key id : String;
    title  : String;

    employees : Association to many EmpProject
                on employees.project = $self;
}

entity EmpProject {
    key employee : Association to Employees;
    key project  : Association to Projects;
}


//3
entity Users {
    key id : String;
    name   : String;

    roles : Association to many UserRole
            on roles.user = $self;
}


aspect ExtraInfo {
    status : String;              // NO need to import ,Won’t work unless you write logic , doesn't autofill.
}

entity Roles :ExtraInfo{
    key id : String;
    role_name : String;

    users : Association to many UserRole
            on users.role = $self;
}

entity UserRole {
    key user : Association to Users;
    key role : Association to Roles;
}


//4
entity Orders {
    key id : String;
    order_date : Date;
    order_time :Time;

    products : Association to many OrderProduct
               on products.order = $self;
}

entity Products {
    key id : String;
    name   : String;
    price  : Decimal;
    quantity:String;

    orders : Association to many OrderProduct
             on orders.product = $self;
}

entity OrderProduct {
    key order   : Association to Orders;
    key product : Association to Products;
}
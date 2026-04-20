namespace order.srv;

using { order.db as db } from '../db/schema';

service OrderService {       //service defnition name ?Service name
    entity Student as projection on db.Students;   //projection entity/ Entity projection /
    entity Courses as projection on db.Courses;
    entity StudentCourse as projection on db.StudentCourse;
    entity Person as projection on db.Person;
    entity Identity as projection on db.Identity;
  

    action addStudent(students:array of Student) returns String;
    action addCourse(course:array of Courses) returns String;
    action enrollment(enroll: StudentCourse) returns String; 
    action putName(stuId:String,name:String) returns String;
    action delName(stuId:String) returns String;

    action addStudentCourse(students:array of Student,course:array of Courses) returns String;  //emit


    function getStuCourse(stuId:String) returns String;
   
   //Composition
   action addPersonIdentity(data: Person) returns String;    //using parent ->Person 

}










//Association MAny to MAny
//1.IN action give right  parameter for Accepting the values eg: (string ,array of String, Student , array of student).
//2.In logic side,we use right key to destuctricture.
//3.Sending Objects to action ->want caution to use key in url endpoint.
//4.sending datas or Objects to action in echo api, mandatory want same key for normal entities. see below
//5.In normal entity projection we send flat payload, not for association entity see below.
//6.Except projection entity , like datatypes like String ,Integer we give directly
 



/*
4.
single Objects
{
  "students": {
    "id": "S1",
    "name": "Vishnu",
    "age": "23",
    "phn": "9876543210"
  }
}
{
  "students": [
    {
      "id": "S1",
      "name": "Vishnu",
      "age": "23",
      "phn": "9876543210"
    },
    {
      "id": "S2",
      "name": "Arun",
      "age": "24",
      "phn": "9123456780"
    }
  ]
}*/ 


/*
5.Association Entity no flat payload mention the primary key
{
  "enroll": {
    "student": { "id": "S1" },
    "course": { "id": "C1" }                mention ,ID for association junction table
  }
}   

NOT 
{
  "enroll": {
    "student": "S1",
    "course": "C1"
  }
}*/

/*
6.
{
  "stuId": "S1",
  "name": "Updated Vishnu"
}
*/
/*
{
  Students:[{},{},{},{},{}],
  Course:  [{},{},{},{},{}]


}
/*{
  "students": [
    {
      "id": "S101",
      "name": "Vishnu",
      "age": "22",
      "phn": "9876543210"
    },
    {
      "id": "S102",
      "name": "Arun",
      "age": "23",
      "phn": "9123456781"
    },
    {
      "id": "S103",
      "name": "Karthik",
      "age": "21",
      "phn": "9123456782"
    },
    {
      "id": "S104",
      "name": "Rahul",
      "age": "22",
      "phn": "9123456783"
    },
    {
      "id": "S105",
      "name": "Ajay",
      "age": "24",
      "phn": "9123456784"
    }
  ],

  "course": [
    {
      "id": "C101",
      "c_name": "SAP CAP",
      "c_price": "5000"
    },
    {
      "id": "C102",
      "c_name": "NodeJS",
      "c_price": "4500"
    },
    {
      "id": "C103",
      "c_name": "SAP UI5",
      "c_price": "4000"
    },
    {
      "id": "C104",
      "c_name": "JavaScript",
      "c_price": "3500"
    },
    {
      "id": "C105",
      "c_name": "HANA DB",
      "c_price": "6000"
    }
  ]
} */



//Composition 

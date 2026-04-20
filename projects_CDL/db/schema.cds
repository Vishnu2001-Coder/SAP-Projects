namespace sample.db;

using { cuid,managed,sap.common.CodeList } from '@sap/cds/common';

entity Customer : cuid,managed {
    name:String;
    age:String;
    date:type of managed:createdAt;
    stage:stage1 @assert.range;                  
}

entity Employee : cuid,CodeList {
        age:String;
        add:Address;
        stage:stage1;
}



type Address{             // type is used foe one is for entity property ,and action
    old:String;
    new1:String;
    latest:String;
    
}


entity Employees as Select from Employee{
    age,
 //   Dept.name as deptname:String
}


type stage : String enum{                 // camelCase
    pending;
    complete;
    failed;
};


type stage1 : String enum{            //Value should quotes->''
   P= 'pending';                      //left no need quotes-> P
   C= 'complet';                      //always send a Value in payload and value only store in DB
   F= 'Failed';
};
namespace sample.db;
using {managed  } from '@sap/cds/common';

entity Books{
 key id          :String @mandatory;
    author_name  :String not null;
    book_name    :String;
    Date         :type of managed:createdAt @UI.DateTimeStyle:'short';                                                   //:['Available','OutOfStock','Discontinued'];
    Person   :Association to many Person on Person.Books =$self;
}

entity Person{
   key id:String;
    P_name:String;
    P_age:String;
    Books:Association to  Books ;
}
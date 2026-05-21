namespace sample.db;
using {managed  } from '@sap/cds/common';

entity Books{
 key id          :String @mandatory;
    author_name  :String not null;
    book_name    :String;
    Date         :type of managed:createdAt @UI.DateTimeStyle:'short';
   // @assert.range 
    // stock        :stocks  ;        
    stock    :Association to status;                                                                         //:['Available','OutOfStock','Discontinued'];
    Person   :Association to many Person on Person.Books =$self;
}

entity Person{
   key id:String;
    P_name:String;
    P_age:String;
    Books:Association to  Books ;
}

// type stocks: String enum{
//   Available;
//   OutOfStock;
//   Discontinued;
// }

entity status{
@assert.range
key stocks: String enum{
  Available;
  OutOfStock;
  Discontinued;
}
criticality:Integer;
Books:Association to many Books on Books.stock=$self;
}
namespace sample.db;
entity Books{
 key id          :String @mandatory;
    author_name  :String not null;
    book_name    :String;
    @assert.range 
    stock        :stocks  ;                                                                                 //:['Available','OutOfStock','Discontinued'];
    Person       :Association to one Person;
}

entity Person{
   key id:String;
    P_name:String;
    P_age:String;
}

type stocks: String enum{
  Available;
  OutOfStock;
  Discontinued;
}
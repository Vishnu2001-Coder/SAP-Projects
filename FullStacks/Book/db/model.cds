namespace sample.db;

entity Books{
 key id          :String @mandatory;
    author_name  :String not null;
    book_name    :String;
    stock        :String;
   // level        :code  @assert.range:['H','M','L'];
    line :Association to Line;
   
}

entity Line{
   key id:String;
   name:String;
}
  



 type code : String enum {
        high = 'H';
        medium = 'M';
        low = 'L';
      };

// type , aspects ,view , presistent.skip / presistent .table , assert range, codelist(aspects)
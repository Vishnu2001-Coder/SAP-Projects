namespace sample.db;

entity Books{
 key id          :String @mandatory;
    author_name  :String not null;
    book_name    :String;
    stock        :String;
}


// type , aspects ,view , presistent.skip / presistent .table , assert range, codelist(aspects)
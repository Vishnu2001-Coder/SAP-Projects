using {sample.db as db} from '../db/model';

service MyService @(impl:'./book.js')
{
    entity Books as projection on db.Books;
   action addData(data: Books) returns String;

   

    

}

//Projection,veiws, @cds.redirection.target , @odata.draft.enabled, custom handler(action,function),





//normal post http://localhost:4004/odata/v4/my/Books
/* {
        "id": "B104",
        "author_name": "SIVA",
        "book_name": "ENcylopedia",
        "stock": "AVAILABLE"
    }
*/


//action ->http://localhost:4004/odata/v4/my/Books 
/* {"data":{
        "id": "B104",
        "author_name": "SIVA",
        "book_name": "ENcylopedia",
        "stock": "AVAILABLE"
    }}*/

//logic  ->  const data=req.data.data;
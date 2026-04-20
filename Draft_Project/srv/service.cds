using {sample.db as my} from '../db/schema';

service CatalogService {
    @odata.draft.enabled
    entity Orders as projection on my.Orders;
    action  postData(name: String);
    function getData() returns array of String;

    

}

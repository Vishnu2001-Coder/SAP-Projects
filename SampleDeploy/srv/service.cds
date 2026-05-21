using {sample.db as db} from '../db/schema';

service MyService {

    @restrict: [
        {
            grant: 'READ',
            to   : 'Viewer'
        },
        {
            grant: [
                'CREATE',
                'UPDATE'
            ],
              to   : 'admin'
        }
    ]
    entity Books as projection on db.Books;


@restrict: [
    {
        grant: 
    entity Person as projection on db.Person;

}

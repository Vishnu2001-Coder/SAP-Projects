using { Leave.db as db } from '../db/model';

service MyService {
   
   entity Employees  @(restrict:[
        {grant:['READ'], to :'Employee'},
        {grant :['*'],to :'Admins'}
        ])as projection on db.Employees;


   entity LeaveRequests @(restrict:[
        {grant :['*'],to :'Admins'}
        ] )as projection on db.LeaveRequests;


        @restrict:[
        {grant:['READ'], to :'Employee'},
        {grant :['READ'],to :'Admins'}
        ]
   entity ViewRoles as select from Employees{
    role
   }
    

}

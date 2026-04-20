namespace sample.srv;
using { elms.db as db } from '../db/schema';

service Myservice{

    entity Employee      as projection on db.Employee;
    entity Department    as projection on db.Department;
    entity Role          as projection on db.Role;
    entity LeaveRequest  as projection on db.LeaveRequest;
    entity LeaveInfo     as projection on db.LeaveInfo;
    entity Policy        as projection on db.Policy;
    entity leaveApproved as projection on db.leaveApproved;
    entity leaveBalance  as projection on db.leaveBalance;
    entity Attendance    as projection on db.Attendance;
    entity User          as projection on db.User ;
    entity Holiday       as projection on db.Holiday;

    function login(username:String,password:String) returns String;
    function getLeaveBalance(EmpId:String) returns leaveBalance;
    function getEmployeeDetails(EmpId:String) returns Employee;
    action ApplyLeave(data : LeaveRequest) returns String;
    function getPendingLeaveRequest(Status:String) returns array of String;


   




    //action for posting the datas.
    


}
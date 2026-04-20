namespace elms.db;
entity Employee {
    key EmpId: String;
    firstname: String;
    lastname:String;
    email:String;
    phone: Integer;
    dept: Association to Department;
    doj:Date;
    ReportingManager: Association to Employee;
    role : Association to Role;
}
 
entity Department {
    key deptId: String;
    deptName:String;
    branch: String;
    manager:Association to Employee;
    phone:Integer;
    deptMail:String
}
 
entity Role{
    key roleId:String;
        roleName: String;
        roleType:String;
        dept: Association to Department;
 
}
 
entity LeaveRequest{
   key lrId:String;                  
    startDate: Date;
    endDate: Date;
    policy: Association to Policy;
    leaveStatus:String;
    empId:Association to one Employee;
    leaveDetails: composition of one LeaveInfo on leaveDetails.id=$self;  
   
}
entity LeaveInfo {
    key leaveId:String;
    leaveType:String;
    Reason:String;
    noOfDay:Integer;
    empId:Association to one Employee;
    id :Association to one LeaveRequest;
}
 
entity Policy{
    key policyid: Integer;
    desc:String;
    carryforwardlimit: Integer;
    maxleave:Integer;
    expNeeded:Integer;
    wfhallowed:Integer;
}
entity leaveApproved{
    key iaId: Integer;
    irId: Association to one LeaveRequest;
    approverid:Association to one Employee;
    startDate: Date;
    endDate: Date;
    isPaid: Boolean;
}
entity leaveBalance{
    key balanceId : Integer;
    empID: Association to one Employee;
    leaveBalance:Integer;
    leaveTaken:Integer;
    lossOfPay:Integer;
    attendanceId:Association to one Attendance;
}
entity Attendance {
    key attendanceId:Integer;
    empId:Association to one Employee;
    doj:Date;
    totalDays:Integer;
    daysPresent: Integer;
    daysAbsent:Integer;
    wfhtaken:Integer;
    permission:Integer;
    }
    entity User {
       key userId: String;
       empId:Association to one Employee;
       userName:String;
       password:String;
       secQuestion:String;
       secAnswer: String;
    }
 
    entity Holiday{
        key holidayId :String;
        holidayDate:String;
        holidayName:String;
        holidayType:String;
        status:String
    }
   
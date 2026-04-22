namespace Leave.db;
using { managed } from '@sap/cds/common';


entity Employees {
  key ID      : String;
      name    : String;
      role    : String;
}

entity LeaveRequests {
  key ID        : String;
      fromDate  : Date ;                  //Date (yyyy-mm--dd) or  type of managed : createdAt;
      toDate    : Date;
      status    : String; // Pending, Approved, Rejected

  employee : Association to Employees;
}


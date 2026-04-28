namespace my.db;

entity Department {
    key ID     : UUID;
    name       : String(100);
}
entity Employee {
    key ID     : UUID;
    name       : String(100);
    role       : String(50);

    department : Association to Department;
}
entity Project {
    key ID     : UUID;
    title      : String(100);

    manager    : Association to Employee;
}
entity Task {
    key ID     : UUID;
    title      : String(100);

    project    : Association to Project;
    assignedTo : Association to Employee;
}
entity Address {
    key ID     : UUID;
    city       : String(50);
    pincode    : String(10);

    employee   : Association to Employee;
}
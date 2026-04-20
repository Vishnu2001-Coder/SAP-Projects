const cds = require('@sap/cds');
 
module.exports = cds.service.impl( function(){
     const { User,leaveBalance,Employee,LeaveRequest,LeaveInfo} = this.entities;
     this.on('Login',async(req)=>{
        const { userName,password} = req.data;
        console.log(req.data);
        console.log(userName);
        console.log(password);
        const emp = await SELECT.one.from('User')
           .where({ userName, password });
           if (!emp) {
        req.error(401, 'Invalid credentials');
                     }
  return 'Login successful';
     });
 
 
     this.on('getLeaveBalance',async(req)=>{
        const {EmpId} = req.data;
        const Balance = await SELECT.from(leaveBalance).where({empID_EmpId:EmpId});
                if (!Balance) {
        req.error(400, 'Enter the correct Employee ID to check the leave Balance');
                     }
               return Balance;
           });

      this.on('getEmployeeDetails',async(req)=>{
        const {EmpId} = req.data;
        const empdetails = await SELECT.from(Employee).where({EmpId:EmpId});
        if (!empdetails) {
        req.error(404, 'Employee Not Found');
                     }
                    return empdetails;
           });
 
       this.on('applyLeave', async (req) => {
        const {lrId, empId,startDate, endDate, leaveType, leaveStatus, leaveDetails } = req.data.data;
        const start = new Date(startDate);
        const end = new Date(endDate);
        console.log("enddate",end);
        const noOfDays = Math.ceil((end - start)/(1000*60*60*24)) + 1;
 
            const leaveRequestData = {
            lrId,
            startDate,
            endDate,
            leaveType,
            leaveStatus,
            //policy_policyid: policy?.policyid,
            empId_EmpId: empId?.EmpId,
            leaveDetails: {
                Reason: leaveDetails?.Reason,
                noOfDay: noOfDays
            }
        };
 
        await INSERT.into(LeaveRequest).entries(leaveRequestData);
 
        return `Leave applied successfully. Total days: ${noOfDays}`;
    });
   


    this.on('getPendingLeaveRequest', async(req)=>{
        let arr = [];
        const leaveStatus = req.data.Status;
        const PendingRequest = await SELECT.from(LeaveRequest).where({leaveStatus:leaveStatus});
        console.log(PendingRequest);
        PendingRequest.forEach(element => {
           
           // console.log(element);
            arr.push(element);
            console.log(arr);
        });
        return arr;
    });










    //all postion action
    });
 
 
     
 
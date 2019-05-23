trigger ConsultantTargetMonthly on Consultant_Target_Monthly__c (after update,after delete) {
    
   new TH_ConsultantTargetMonthly().run();
}
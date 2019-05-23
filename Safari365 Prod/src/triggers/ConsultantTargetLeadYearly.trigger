trigger ConsultantTargetLeadYearly on Consultant_Target_Lead_Yearly__c (after update) {
    
   new  TH_ConsultantTargetLeadYearly().run();

}
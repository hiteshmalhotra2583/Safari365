@isTest
private class  Test_TH_ConsultantTargetLeadYearly {

   public static List<Consultant_Target_Lead_Yearly__c>  consultantTargetLeadYearlys = new List<Consultant_Target_Lead_Yearly__c>();
   
   static Integer recordCount = 1; 
   
   @testSetup 
   static void setupInsertData()
   {
       User us = TestDataFactory.createUser(true, '', true);
       System.runAs(us)
       {
            Map<String,Object> consultantTargetLeadYearlyMap = new Map<String,Object>();
            consultantTargetLeadYearlyMap.put('Consultant_Target_Lead_Achieved__c',420);
            consultantTargetLeadYearlyMap.put('Consultant_Total_Lead_Target__c',42);
            consultantTargetLeadYearlyMap.put('Consultant__c',us.id);
            consultantTargetLeadYearlyMap.put('Year__c','2019');
            for(Integer i = 0 ; i <recordCount; i++)
            {
                consultantTargetLeadYearlys.add((Consultant_Target_Lead_Yearly__c) TestDataFactory.operationOnObjectRecord(null, 'Consultant_Target_Lead_Yearly__c', consultantTargetLeadYearlyMap));
            }
            DAL_BaseObject.InsertDBObjects(consultantTargetLeadYearlys);
            
       }
    }

    static testMethod void updateYearlyTargetTest() {
      Test.startTest();
      setupInsertData();
      List<Consultant_Target_Lead_Yearly__c>  updateconsultantTargetLeadYearlys = new List<Consultant_Target_Lead_Yearly__c>();
      for(Consultant_Target_Lead_Yearly__c ct:consultantTargetLeadYearlys)
      {
         ct.Consultant_Total_Lead_Target__c =300;
          updateconsultantTargetLeadYearlys.add(ct);
         
      }
      
      update updateconsultantTargetLeadYearlys;
      Test.stopTest();
        
    }
}
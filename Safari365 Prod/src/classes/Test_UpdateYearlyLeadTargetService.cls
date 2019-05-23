@isTest
private class Test_UpdateYearlyLeadTargetService
{

   public static List<Consultant_Target_Lead_Monthly__c>  consultantTargetLeadMonthlys = new List<Consultant_Target_Lead_Monthly__c>();
   static Integer recordCount = 1; 
   
   @testSetup 
   static void setupInsertData()
   {
       User us = TestDataFactory.createUser(true, '', true);
       System.runAs(us)
       {
            Map<String,Object> consultantTargetLeadMonthlyMap = new Map<String,Object>();
            consultantTargetLeadMonthlyMap.put('Month__c',String.valueof(system.today().month()));
            consultantTargetLeadMonthlyMap.put('Year__c',String.valueof(system.today().year()));
            consultantTargetLeadMonthlyMap.put('Consultant__c',us.id);
            consultantTargetLeadMonthlyMap.put('Consultant_Leads_Target__c',100);
            consultantTargetLeadMonthlyMap.put('Override__c',true);
            for(Integer i = 0 ; i <recordCount; i++)
            {
                consultantTargetLeadMonthlys.add((Consultant_Target_Lead_Monthly__c) TestDataFactory.operationOnObjectRecord(null, 'Consultant_Target_Lead_Monthly__c', consultantTargetLeadMonthlyMap));
            }
            DAL_BaseObject.InsertDBObjects(consultantTargetLeadMonthlys);
            
       }
    }

    static testMethod void updateYearlyTargetTest() {
      Test.startTest();
      setupInsertData();
      UpdateYearlyLeadTargetService.updateYearlyTarget(consultantTargetLeadMonthlys);
      Test.stopTest();
        
    }
}
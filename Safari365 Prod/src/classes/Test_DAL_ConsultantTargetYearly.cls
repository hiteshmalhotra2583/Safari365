@isTest
private class Test_DAL_ConsultantTargetYearly{

   public static List<Consultant_Target_Yearly__c>  consultantTargetYears = new List<Consultant_Target_Yearly__c>();
   static Integer recordCount = 1; 
   public static Integer count =5;
   
   @testSetup 
   static void setupInsertData()
   {
       User us = TestDataFactory.createUser(true, '', true);
       System.runAs(us)
       {
            Map<String,Object> consultantTargetYearlyMap = new Map<String,Object>();
            consultantTargetYearlyMap.put('Year__c','2019');
            consultantTargetYearlyMap.put('Consultant__c',us.id);
            for(Integer i = 0 ; i <recordCount; i++)
            {
                consultantTargetYears.add((Consultant_Target_Yearly__c) TestDataFactory.operationOnObjectRecord(null, 'Consultant_Target_Yearly__c', consultantTargetYearlyMap));
            }
            DAL_BaseObject.InsertDBObjects(consultantTargetYears);
            
       }
    }
    
    static testMethod void getByConsultantIdAndYearTest() 
    {
      Test.startTest();
      Set<Id> consultantId = new Set<Id>();
      Set<Id> recordIds = new Set<Id>();
      Set<String> years = new Set<String>();
      for(Consultant_Target_Yearly__c ac: consultantTargetYears)
      {
        consultantId.add(ac.Consultant__c);
        years.add(ac.Year__c);
        recordIds.add(ac.Id);
        
      }
      DAL_ConsultantTargetYearly.getByConsultantIdandYear(consultantId,years);
      DAL_ConsultantTargetYearly.getByIds(recordIds);
      DAL_ConsultantTargetYearly.getByYearSet(recordIds);
      Test.stopTest();
    }
}
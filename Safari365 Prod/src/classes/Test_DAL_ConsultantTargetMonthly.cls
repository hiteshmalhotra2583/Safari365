@isTest
private class Test_DAL_ConsultantTargetMonthly{

   public static List<Consultant_Target_Monthly__c>  consultantTargetMonthlys = new List<Consultant_Target_Monthly__c>();
   public static List<Consultant_Target_Lead_Monthly__c>  consultantTargetLeadMonthlys = new List<Consultant_Target_Lead_Monthly__c>();
   static Integer recordCount = 1; 
   
   @testSetup 
   static void setupInsertData()
   {
       User us = TestDataFactory.createUser(true, '', true);
       System.runAs(us)
       {
            Map<String,Object> consultantTargetMonthlyMap = new Map<String,Object>();
            consultantTargetMonthlyMap.put('Month__c',String.valueof(system.today().month()));
            consultantTargetMonthlyMap.put('Year__c',String.valueof(system.today().year()));
            consultantTargetMonthlyMap.put('Consultant__c',us.id);
            consultantTargetMonthlyMap.put('Override__c',true);
            for(Integer i = 0 ; i <recordCount; i++)
            {
                consultantTargetMonthlys.add((Consultant_Target_Monthly__c) TestDataFactory.operationOnObjectRecord(null, 'Consultant_Target_Monthly__c', consultantTargetMonthlyMap));
            }
            DAL_BaseObject.InsertDBObjects(consultantTargetMonthlys);
            
            Map<String,Object> consultantTargetLeadMonthlyMap = new Map<String,Object>();
            consultantTargetLeadMonthlyMap.put('Month__c',String.valueof(system.today().month()));
            consultantTargetLeadMonthlyMap.put('Year__c',String.valueof(system.today().year()));
            consultantTargetLeadMonthlyMap.put('Consultant__c',us.id);
            consultantTargetLeadMonthlyMap.put('Override__c',true);
            for(Integer i = 0 ; i <recordCount; i++)
            {
                consultantTargetLeadMonthlys.add((Consultant_Target_Lead_Monthly__c) TestDataFactory.operationOnObjectRecord(null, 'Consultant_Target_Lead_Monthly__c', consultantTargetLeadMonthlyMap));
            }
            DAL_BaseObject.InsertDBObjects(consultantTargetLeadMonthlys);
            
       }
    }
    
    static testMethod void getByConsultantIdAndYearTest() 
    {
      Test.startTest();
      Set<Id> consultantId = new Set<Id>();
      Set<String> months = new Set<String>();
      Set<String> years = new Set<String>();
      for(Consultant_Target_Monthly__c ac: consultantTargetMonthlys)
      {
        consultantId.add(ac.Consultant__c);
        months.add(ac.Month__c);
        years.add(ac.Year__c);
        
      }
      DAL_ConsultantTargetMonthly.getByConsultantIdAndYear(consultantId,months,years);
      DAL_ConsultantTargetMonthly.getSumOfLeadMonthyTarget(years,consultantId);
      DAL_ConsultantTargetMonthly.getSumOfLeadMonthyTargetAchieved(years,consultantId);
      DAL_ConsultantTargetMonthly.getCountConsultantTargetMonthly(years,consultantId);
      DAL_ConsultantTargetMonthly.getSumOfAverageConsultantTargetMonthly(years,consultantId);
      Test.stopTest();
    }

}
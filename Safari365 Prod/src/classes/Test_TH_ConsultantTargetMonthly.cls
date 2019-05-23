@isTest
private class Test_TH_ConsultantTargetMonthly{
  
  public static Consultant_Target_Yearly__c consultantTargetYearlys = new Consultant_Target_Yearly__c();    
  public static List<Consultant_Target_Monthly__c>  consultantTargetMonthlys = new List<Consultant_Target_Monthly__c>();
   static Integer recordCount = 1; 
   public static Integer count =5;
   
   @testSetup 
   static void setupInsertData()
   {
       User us = TestDataFactory.createUser(true, '', true);
       System.runAs(us)
       {
            consultantTargetYearlys = (Consultant_Target_Yearly__c) TestDataFactory.operationOnObjectRecord(null,'Consultant_Target_Yearly__c', null);
            insert consultantTargetYearlys;
            Map<String,Object> consultantTargetMonthlyMap = new Map<String,Object>();
            consultantTargetMonthlyMap.put('Month__c',String.valueof(system.today().month()));
            consultantTargetMonthlyMap.put('Year__c',String.valueof(system.today().year()));
            consultantTargetMonthlyMap.put('Consultant__c',us.id);
            consultantTargetMonthlyMap.put('Override__c',true);
            consultantTargetMonthlyMap.put('Gross_Profit_Target__c',1000);
            consultantTargetMonthlyMap.put('Consultant_Gross_Profit_Target__c',10);
            consultantTargetMonthlyMap.put('Consultant_Gross_Profit_Target__c',10);
            consultantTargetMonthlyMap.put('Consultant_Target_Yearly__c', consultantTargetYearlys.Id);
            for(Integer i = 0 ; i <recordCount; i++)
            {
                consultantTargetMonthlys.add((Consultant_Target_Monthly__c) TestDataFactory.operationOnObjectRecord(null, 'Consultant_Target_Monthly__c', consultantTargetMonthlyMap));
            }
            system.debug('consultantTargetMonthlys:::'+consultantTargetMonthlys);
            DAL_BaseObject.InsertDBObjects(consultantTargetMonthlys);
            
       }
    }
    
    static testMethod void updateCTMTest() 
    {
      setupInsertData();
      Test.startTest();
      List<Consultant_Target_Monthly__c> ctms = new List<Consultant_Target_Monthly__c>();
      for(Consultant_Target_Monthly__c ac: consultantTargetMonthlys)
      {
        ac.Consultant_Gross_Profit_Target_Achieved__c= 100;
        ctms.add(ac);
        
      }
     update ctms;
      
     Test.stopTest();
    }
  
   static testMethod void deleteCTMTest() 
    {
      setupInsertData();
      Test.startTest();
      List<Consultant_Target_Monthly__c> ctms = new List<Consultant_Target_Monthly__c>();
      for(Consultant_Target_Monthly__c ac: consultantTargetMonthlys)
      {
        ac.Consultant_Gross_Profit_Target_Achieved__c= 100;
        ctms.add(ac);
        
      }
      update ctms;
      delete ctms;
      Test.stopTest();
      
    }
}
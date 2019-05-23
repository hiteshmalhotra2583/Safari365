@isTest
private class Test_TH_LeadService {

   public static List<Consultant_Target_Lead_Monthly__c>  consultantTargetLeadMonthlys = new List<Consultant_Target_Lead_Monthly__c>();
   public static List<Lead>  leads = new List<Lead>();
   static Integer recordCount = 1; 
   public static User us2;
   @testSetup 
   static void setupInsertData()
   {
       User us = TestDataFactory.createUser(true, '', true);
       us2 = TestDataFactory.createUser(true, '', true);
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
                consultantTargetLeadMonthlys.add((Consultant_Target_Lead_Monthly__c) TestDataFactory.operationOnObjectRecord(null,
                                                                                    'Consultant_Target_Lead_Monthly__c',
                                                                                     consultantTargetLeadMonthlyMap));
            }
           
            Map<String,Object> consultantTargetLeadMonthlyMap2 = new Map<String,Object>();
            consultantTargetLeadMonthlyMap2.put('Month__c',String.valueof(system.today().month()));
            consultantTargetLeadMonthlyMap2.put('Year__c',String.valueof(system.today().year()));
            consultantTargetLeadMonthlyMap2.put('Consultant__c',us2.id);
            consultantTargetLeadMonthlyMap2.put('Consultant_Leads_Target__c',100);
            consultantTargetLeadMonthlyMap2.put('Override__c',true);
            for(Integer i = 0 ; i <recordCount; i++)
            {
                consultantTargetLeadMonthlys.add((Consultant_Target_Lead_Monthly__c) TestDataFactory.operationOnObjectRecord(null,
                                                                                    'Consultant_Target_Lead_Monthly__c',
                                                                                     consultantTargetLeadMonthlyMap2));
            }
            DAL_BaseObject.InsertDBObjects(consultantTargetLeadMonthlys);
            
            
            Map<String,Object> leadMonthlyMap = new Map<String,Object>();
            leadMonthlyMap.put('OwnerId',us.id);
            leadMonthlyMap.put('IsConverted',false);
            for(Integer i = 0 ; i <recordCount; i++)
            {
                leads.add((Lead) TestDataFactory.operationOnObjectRecord(null,'Lead',leadMonthlyMap));
            }
           //DAL_BaseObject.InsertDBObjects(consultantTargetLeadMonthlys);
       }
    }
    
    static testMethod void insertLeadTest() 
    {
      setupInsertData();
      Test.startTest();
      DAL_BaseObject.InsertDBObjects(leads);
     Test.stopTest();
    }
    
    static testMethod void updateLeadTest() 
    {
      setupInsertData();
      BaseTriggerHandler.byPass('TH_Lead');
      DAL_BaseObject.InsertDBObjects(leads);
       BaseTriggerHandler.clearBypass('TH_Lead');
       Test.startTest();
      List<Lead> leadsToupate = new List<Lead>();
      for(Lead l: leads)
      {
          l.OwnerId = us2.Id;
          leadsToupate.add(l);
      }
      
      update leadsToupate;
      
     Test.stopTest();
    }
}
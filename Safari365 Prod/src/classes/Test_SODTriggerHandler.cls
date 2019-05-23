@isTest
private class Test_SODTriggerHandler {
    
    public static List<CRM__c>  crms = new List<CRM__c>();
    public static List<SOD__c>  sods= new List<SOD__c>();
    public static Integer count =1;
    
    static void setupInsertData(){
        
        for(Integer i = 0 ; i <count; i++)
        {
            crms.add((CRM__c) TestDataFactory.operationOnObjectRecord(null, 'CRM__c', null));
        }
        insert crms;
        
        Map<String,Object> keyValueMap = new Map<String,Object>();
        for(CRM__c crm:crms)
        {
            keyValueMap.put('SOD_ID__c', crm.SOD_ID__c);
        }
    
        for(Integer i = 0 ; i <count; i++)
        sods.add((SOD__c) TestDataFactory.operationOnObjectRecord(null, DAL_SOD.OBJECT_NAME, keyValueMap));
        
    }
    
    static void setupUpdateData(){
        setupInsertData();
        insert sods;
    }

   @isTest  
  static void testBeforeInsert() {
      
      setupInsertData();
      
      Test.startTest();
      insert sods;
      List<SOD__c> sodsList=[select Id,CRM_Lookup__c,SOD_ID__c from SOD__c where SOD_ID__c=: crms[0].SOD_ID__c];
      system.assert(sodsList[0].CRM_Lookup__c <> null);
      Test.stopTest();
      
  }
  
   @isTest  
  static void testBeforeUpdate() {
      
      Trigger_PAD.deactivateTrigger('SODTriggerHandler');
      setupUpdateData();
      Trigger_PAD.activateTrigger('SODTriggerHandler');
      
      Test.startTest();
      
      update sods;
      List<SOD__c> sodsList=[select Id,CRM_Lookup__c,SOD_ID__c from SOD__c where SOD_ID__c=: crms[0].SOD_ID__c];
      system.assert(sodsList[0].CRM_Lookup__c <> null);
      
      Test.stopTest();
      
  }
}
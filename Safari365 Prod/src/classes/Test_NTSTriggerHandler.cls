@isTest
private class Test_NTSTriggerHandler {
  // contexts tests
    public static List<NTS__c>  nts = new List<NTS__c>();
    public static List<NCT__c>  ncts= new List<NCT__c>();
    public static List<CRM__c>  crms= new List<CRM__c>();
    public static List<NTS__c>  crmsnts = new List<NTS__c>();
    public static Integer count =1;
    
    static void setupInsertData(){
        
        for(Integer i = 0 ; i <count; i++)
        {
            ncts.add((NCT__c) TestDataFactory.operationOnObjectRecord(null, 'NCT__c', null));
        }
        insert ncts;
        
        Map<String,Object> keyValueMap = new Map<String,Object>();
        for(NCT__c nct:ncts)
        {
            keyValueMap.put('CATEGORY__c', nct.NOTECATEGORY__c);
        }
    
        for(Integer i = 0 ; i <=count; i++)
        nts.add((NTS__c) TestDataFactory.operationOnObjectRecord(null, 'NTS__c', keyValueMap));
        
    }
    
    
    static void setupCRMInsertData(){
        
        for(Integer i = 0 ; i <count; i++)
        {
            crms.add((CRM__c) TestDataFactory.operationOnObjectRecord(null, 'CRM__c', null));
        }
        insert crms;
        
        Map<String,Object> keyValueMap = new Map<String,Object>();
        for(CRM__c crm:crms)
        {
            keyValueMap.put('SUPPLIER_CODE__c', crm.CODE__c);
        }
    
        for(Integer i = 0 ; i <=count; i++)
        crmsnts.add((NTS__c) TestDataFactory.operationOnObjectRecord(null, 'NTS__c', keyValueMap));
        
    }
    
    static void setupUpdateData(){
        setupInsertData();
        insert nts;
    }
    
     static void setupCRMUpdateData(){
        setupCRMInsertData();
        insert crmsnts;
    }

   @isTest  
  static void testCRMBeforeInsert() {
      
      setupCRMInsertData();
      
      Test.startTest();
      insert crmsnts;
      List<NTS__c> osrlist=[select Id,CRM_Lookup__c from NTS__c where SUPPLIER_CODE__c=: crms[0].CODE__c];
      system.assert(osrlist[0].CRM_Lookup__c <> null);
      Test.stopTest();
      
  }
  
  
  @isTest  
  static void testBeforeInsert() {
      
      setupInsertData();
      
      Test.startTest();
      insert nts;
     
      List<NTS__c> osrlist=[select Id,NCT_Lookup__c from NTS__c where CATEGORY__c=: ncts[0].NOTECATEGORY__c];
      system.assert(osrlist[0].NCT_Lookup__c <> null);
      Test.stopTest();
      
  }
  
   @isTest  
  static void testBeforeUpdate() {
      
      Trigger_PAD.deactivateTrigger('NTSTriggerHandler');
      setupUpdateData();
      Trigger_PAD.activateTrigger('NTSTriggerHandler');
      
      Test.startTest();
      
      update nts;
      List<NTS__c> osrlist=[select Id,NCT_Lookup__c from NTS__c where CATEGORY__c=: ncts[0].NOTECATEGORY__c];
      System.assert(osrlist[0].NCT_Lookup__c <> null);
      
      Test.stopTest();
      
  }
  
  
  @isTest  
  static void testBeforeCRMUpdate() {
      
      Trigger_PAD.deactivateTrigger('NTSTriggerHandler');
      setupCRMUpdateData();
      Trigger_PAD.activateTrigger('NTSTriggerHandler');
      Test.startTest();
      update crmsnts;
      List<NTS__c> osrlist=[select Id,CRM_Lookup__c from NTS__c where SUPPLIER_CODE__c=: crms[0].CODE__c];
      system.assert(osrlist[0].CRM_Lookup__c <> null);
      Test.stopTest();
      
  }


}
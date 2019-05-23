@isTest
private class Test_OPDTiggerHandler {
  // contexts tests
    public static List<OSR__c>  opts = new List<OSR__c>();
    public static List<OPD__c>  osrs= new List<OPD__c>();
    public static Integer count =1;
    
    static void setupInsertData(){
        
        for(Integer i = 0 ; i <count; i++)
        {
            opts.add((OSR__c) TestDataFactory.operationOnObjectRecord(null, 'OSR__c', null));
        }
        insert opts;
        
        Map<String,Object> keyValueMap = new Map<String,Object>();
        for(OSR__c opt:opts)
        {
            keyValueMap.put('OSR_ID__c', opt.OSR_ID__c);
        }
    
        for(Integer i = 0 ; i <=count; i++)
        osrs.add((OPD__c) TestDataFactory.operationOnObjectRecord(null, 'OPD__c', keyValueMap));
        
    }
    
    static void setupUpdateData(){
        
        for(Integer i = 0 ; i <count; i++)
        {
            opts.add((OSR__c) TestDataFactory.operationOnObjectRecord(null, 'OSR__c', null));
        }
        insert opts;
        
        Map<String,Object> keyValueMap = new Map<String,Object>();
        for(OSR__c opt:opts)
        {
            keyValueMap.put('OSR_ID__c', opt.OSR_ID__c);
        }
    
        for(Integer i = 0 ; i <count; i++)
        osrs.add((OPD__c) TestDataFactory.operationOnObjectRecord(null, 'OPD__c', keyValueMap));
        
        insert osrs;
    }

   @isTest  
  static void testBeforeInsert() {
      
      setupInsertData();
      insert osrs;
      List<OPD__c> osrlist=[select Id,OSR_Lookup__c from OPD__c where OSR_ID__c=: opts[0].OSR_ID__c];
      Test.startTest();
      System.assert(osrlist[0].OSR_Lookup__c <> null);
      
      Test.stopTest();
      
  }
  
 /*  @isTest  
  static void testBeforeUpdate() {
      
      Trigger_PAD.deactivateTrigger('OPDTriggerHandler');
      setupUpdateData();
      Trigger_PAD.activateTrigger('OPDTriggerHandler');
      
      Test.startTest();
      
      //update osrs;
      //List<OPD__c> opdlist=[select Id,OSR_Lookup__c from OPD__c where OSR_ID__c=: opts[0].OSR_ID__c];
      system.assert(opdlist[0].OSR_Lookup__c <> null);
      
      Test.stopTest();
      
  }*/


}
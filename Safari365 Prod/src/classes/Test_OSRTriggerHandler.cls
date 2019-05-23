@isTest
private class Test_OSRTriggerHandler {
  // contexts tests
    public static List<OPT__c>  opts = new List<OPT__c>();
    public static List<OSR__c>  osrs= new List<OSR__c>();
    public static List<OPC__c>  opcs= new List<OPC__c>();
    public static List<OSR__c>  osrOPCs= new List<OSR__c>(); 
   
    public static Integer count = 1;
    
    static void setupInsertData(){
        
        for(Integer i = 0 ; i <count; i++)
        {
            opts.add((OPT__c) TestDataFactory.operationOnObjectRecord(null, 'OPT__c', null));
        }
        insert opts;
        
        Map<String,Object> keyValueMap = new Map<String,Object>();
        for(OPT__c opt:opts)
        {
            keyValueMap.put('Opt_Id__c', opt.OPT_ID__c);
        }
        
        for(Integer i = 0 ; i <count; i++)
        osrs.add((OSR__c) TestDataFactory.operationOnObjectRecord(null, 'OSR__c', keyValueMap));
        
    }
    
    
     static void setupInsertDataForOPC(){
        
        for(Integer i = 0 ; i <count; i++)
        {
            opcs.add((OPC__c) TestDataFactory.operationOnObjectRecord(null, 'OPC__c', null));
        }
        insert opcs;
        
        Map<String,Object> keyOPCValueMap = new Map<String,Object>();
        for(OPC__c opt:opcs)
        {
            keyOPCValueMap.put('PRICE_CODE__c',opt.CODE__c);
        }
        
        for(Integer i = 0 ; i <count; i++)
        osrOPCs.add((OSR__c) TestDataFactory.operationOnObjectRecord(null, 'OSR__c', keyOPCValueMap));
        
    }
    
    static void setupUpdateData(){
        
        for(Integer i = 0 ; i <count; i++)
        {
            opts.add((OPT__c) TestDataFactory.operationOnObjectRecord(null, 'OPT__c', null));
        }
        insert opts;
        
        Map<String,Object> keyValueMap = new Map<String,Object>();
        for(OPT__c opt:opts)
        {
            keyValueMap.put('Opt_Id__c', opt.OPT_ID__c);
        }
    
        for(Integer i = 0 ; i <=count; i++)
        osrs.add((OSR__c) TestDataFactory.operationOnObjectRecord(null, 'OSR__c', keyValueMap));
        
        insert osrs;
    }

   @isTest  
  static void testBeforeInsert() {
      
      setupInsertData();
      insert osrs;
      List<OSR__c> osrlist=[select Id,OPT_Lookup__c from OSR__c where OPT_ID__c=: opts[0].OPT_ID__c];
      Test.startTest();
      System.assert(osrlist[0].OPT_Lookup__c <> null);
      
      Test.stopTest();
      
  }
  
  @isTest  
  static void testBeforeInsert2() {
      
      setupInsertDataForOPC();
      insert osrOPCs;
      List<OSR__c> osr2=[select Id,OPC_Lookup__c from OSR__c where PRICE_CODE__c =: opcs[0].CODE__c];
      Test.startTest();
      system.assert(osr2[0].OPC_Lookup__c <> null);
      Test.stopTest();
      
  }
  
   @isTest  
  static void testBeforeUpdate() {
      
      Trigger_PAD.deactivateTrigger('OPDTriggerHandler');
      setupUpdateData();
      Trigger_PAD.activateTrigger('OPDTriggerHandler');
      Test.startTest();
      update osrs;
      List<OSR__c> osrlist=[select Id,OPT_Lookup__c from OSR__c where OPT_ID__c=: opts[0].OPT_ID__c];
      System.assert(osrlist[0].OPT_Lookup__c <> null);
      Test.stopTest();
      
  }


}
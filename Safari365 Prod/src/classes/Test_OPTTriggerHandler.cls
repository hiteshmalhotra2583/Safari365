@isTest
private class Test_OPTTriggerHandler {
  // contexts tests
    public static List<OPT__c>  db4opts = new List<OPT__c>();
    public static List<DB4__c>  db4s= new List<DB4__c>();
    public static List<OPT__c>  crmopts = new List<OPT__c>();
    public static List<CRM__c>  crms= new List<CRM__c>();
    public static List<OPT__c>  lclopts = new List<OPT__c>();
    public static List<LCL__c>  lcls= new List<LCL__c>();
    public static List<OPT__c>  srvopts = new List<OPT__c>();
    public static List<SRV__c>  srvs= new List<SRV__c>();
    public static List<SOD__c>  sods= new List<SOD__c>();
    public static List<OPT__c>  sodopts = new List<OPT__c>();
    public static Integer count = 1;
    
    static void setupSODInsertData(){
        
        for(Integer i = 0 ; i <count; i++)
        {
            sods.add((SOD__c) TestDataFactory.operationOnObjectRecord(null, 'SOD__c', null));
        }
        insert sods;
        
        Map<String,Object> sodkeyValueMap = new Map<String,Object>();
        for(SOD__c sod:sods)
        {
            sodkeyValueMap.put('SOD_ID__c', sod.SOD_ID__c);
        }
    
        for(Integer i = 0 ; i <count; i++)
        sodopts.add((Opt__c) TestDataFactory.operationOnObjectRecord(null, 'Opt__c', sodkeyValueMap));
        
    }
    
    
     static void setupSODUpdateData(){
        setupSODInsertData();
        insert sodopts;
    }
    
    
    static void setupDB4InsertData(){
        
        for(Integer i = 0 ; i <count; i++)
        {
            db4s.add((DB4__c) TestDataFactory.operationOnObjectRecord(null, 'DB4__c', null));
        }
        insert db4s;
        
        Map<String,Object> db4keyValueMap = new Map<String,Object>();
        for(DB4__c db4:db4s)
        {
            db4keyValueMap.put('ANALYSIS4__c', db4.CODE__c);
        }
    
        for(Integer i = 0 ; i <count; i++)
        db4opts.add((Opt__c) TestDataFactory.operationOnObjectRecord(null, 'Opt__c', db4keyValueMap));
        
    }
    
    static void setupCRMInsertData(){
        
        for(Integer i = 0 ; i <count; i++)
        {
            crms.add((CRM__c) TestDataFactory.operationOnObjectRecord(null, 'CRM__c', null));
        }
        insert crms;
        
        Map<String,Object> crmkeyValueMap = new Map<String,Object>();
        for(CRM__c crm:crms)
        {
            crmkeyValueMap.put('Supplier__c', crm.CODE__c);
        }
    
        for(Integer i = 0 ; i <count; i++)
        crmopts.add((Opt__c) TestDataFactory.operationOnObjectRecord(null, 'Opt__c', crmkeyValueMap));
        
    }
    
    static void setupLCLInsertData(){
        
        for(Integer i = 0 ; i <count; i++)
        {
            lcls.add((LCL__c) TestDataFactory.operationOnObjectRecord(null, 'LCL__c', null));
        }
        insert lcls;
        
        Map<String,Object> keyValueMap = new Map<String,Object>();
        for(LCL__c opt:lcls)
        {
            keyValueMap.put('LOCALITY__c', opt.CODE__c);
        }
    
        for(Integer i = 0 ; i <count; i++)
        lclopts.add((Opt__c) TestDataFactory.operationOnObjectRecord(null, 'Opt__c', keyValueMap));
        
    }
    
      static void setupSRVInsertData(){
        
        for(Integer i = 0 ; i <count; i++)
        {
            srvs.add((SRV__c) TestDataFactory.operationOnObjectRecord(null, 'SRV__c', null));
        }
        insert srvs;
        
        Map<String,Object> keyValueMap = new Map<String,Object>();
        for(SRV__c opt:srvs)
        {
            keyValueMap.put('Service__c', opt.CODE__c);
        }
    
        for(Integer i = 0 ; i <count; i++)
        srvopts.add((Opt__c) TestDataFactory.operationOnObjectRecord(null, 'Opt__c', keyValueMap));
        
    }

 @isTest  
  static void testBeforeInsertSODLookUp() {
      
      setupSODInsertData();
      Test.startTest();
      insert sodopts;
      List<Opt__c> optList=[select Id,SOD_Lookup__c from Opt__c where SOD_ID__c=: sods[0].SOD_ID__c];
     
      System.assert(optList[0].SOD_Lookup__c <> null);
      
      Test.stopTest();
      
  }


   @isTest  
  static void testBeforeInsertDB4LookUp() {
      
      setupDB4InsertData();
      Test.startTest();
      insert db4opts;
      List<Opt__c> optList=[select Id,ANALYSIS4__c,DB4_Lookup__c from Opt__c where ANALYSIS4__c=: db4s[0].CODE__c];
      
      System.assert(optList[0].DB4_Lookup__c <> null);
      
      Test.stopTest();
      
  }
  
   @isTest  
  static void testBeforeInsertCRMLookUp() {
      
      setupCRMInsertData();
       Test.startTest();
      insert crmopts;
      List<Opt__c> osrlist=[select Id,Supplier__c,CRM_Lookup__c from Opt__c where Supplier__c=: crms[0].CODE__c];
     
      System.assert(osrlist[0].CRM_Lookup__c <> null);
      
      Test.stopTest();
      
  }
  
   @isTest  
  static void testBeforeInsertSRVLookUp() {
      
      setupSRVInsertData();
      Test.startTest();
      insert srvopts;
      List<Opt__c> osrlist=[select Id,ANALYSIS4__c,SRV_Lookup__c from Opt__c where Service__c=: srvs[0].CODE__c];
     
      System.assert(osrlist[0].SRV_Lookup__c <> null);
      
      Test.stopTest();
      
  }
  
   @isTest  
  static void testBeforeInsertlclsLookUp() {
      
      setupLCLInsertData();
      Test.startTest();
      insert lclopts;
      List<Opt__c> osrlist=[select Id,ANALYSIS4__c,LCL_Lookup__c from Opt__c where LOCALITY__c=: lcls[0].CODE__c];
      
      System.assert(osrlist[0].LCL_Lookup__c <> null);
      
      Test.stopTest();
      
  }
  
  @isTest  
  static void testBeforeUpdate() {
      
      Trigger_PAD.deactivateTrigger('OPTTriggerHandler');
      setupSODUpdateData();
      Trigger_PAD.activateTrigger('OPTTriggerHandler');
      
      Test.startTest();
      
      update sodopts;
      
      
      Test.stopTest();
      
  }

}
@isTest
private class  Test_PBKTriggerHandler {
	
	public static List<PBK__c>  pbksCTT = new List<PBK__c>();
    public static List<CTT__c>  ctts= new List<CTT__c>();
    public static List<Opt__c>  crmopts = new List<Opt__c>();
    
    public static Integer count = 1;
    
    static void setupPBKCTTInsertData(){
        
        for(Integer i = 0 ; i <count; i++)
        {
            ctts.add((CTT__c) TestDataFactory.operationOnObjectRecord(null, 'CTT__c', null));
        }
        insert ctts;
        
        Map<String,Object> db4keyValueMap = new Map<String,Object>();
        for(CTT__c db4:ctts)
        {
            db4keyValueMap.put('CONTACTTYPE__c', db4.CODE__c);
        }
    
        for(Integer i = 0 ; i <count; i++)
        pbksCTT.add((PBK__c) TestDataFactory.operationOnObjectRecord(null, 'PBK__c', db4keyValueMap));
        
    }
    static void setupPBKCTTUpdateData(){
        setupPBKCTTInsertData();
        insert pbksCTT;
    }
    
    @isTest  
  static void testBeforeInsertPBKLookUp() {
      
      setupPBKCTTInsertData();
      insert pbksCTT;
      List<PBK__c> optList=[select Id,CTT_Lookup__c from PBK__c where CONTACTTYPE__c=: ctts[0].CODE__c];
      Test.startTest();
      System.assert(optList[0].CTT_Lookup__c <> null);
      
      Test.stopTest();
      
  }
  
   @isTest  
  static void testBeforeUpdate() {
      
      Trigger_PAD.deactivateTrigger('PBKTriggerHandler');
      setupPBKCTTUpdateData();
      Trigger_PAD.activateTrigger('PBKTriggerHandler');
      
      Test.startTest();
      
      update pbksCTT;
      
      
      Test.stopTest();
      
  }
    
}
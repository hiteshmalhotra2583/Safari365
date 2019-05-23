@isTest
private class Test_DAL_OPD {
	
  private static final String CLASS_NAME = Test_DAL_OPD.class.getName();
  public static List<OPD__c>  opds = new List<OPD__c>();
  public static List<OSR__c>  osrs = new List<OSR__c>();
  public static Integer count =1;
 
  static void setupInsertData(){
        
         Map<String,Object> keyValueMap1 = new Map<String,Object>();
         keyValueMap1.put('OSR_ID__c', String.valueof(1));
        for(Integer i = 0 ; i <count; i++)
        osrs.add((OSR__c) TestDataFactory.operationOnObjectRecord(null, DAL_OSR.OBJECT_NAME, keyValueMap1));
         
        insert osrs;
        
        Map<String,Object> keyValueMap = new Map<String,Object>();
         keyValueMap.put('OSR_ID__c', String.valueof(1));
        
        for(Integer i = 0 ; i <count; i++)
        {
            opds.add((OPD__c) TestDataFactory.operationOnObjectRecord(null, DAL_OPD.OBJECT_NAME, keyValueMap));
        }
         insert opds;
         
         
    }
    
    static testMethod void getByIdTest() {
     
      UTIL_LogGenerator logger = new UTIL_LogGenerator();
      logger.start(CLASS_NAME,'Test_DAL_OPD'); 
      Test.startTest();
      setupInsertData();
      Set<Id> opdsIds = new Set<Id>();
      for(OPD__c ac: opds)
      {
      	opdsIds.add(ac.Id);
      }
      Map<Id, OPD__c> opdsIdsMap = DAL_OPD.getById(opdsIds);
      logger.log('opdsIdsMap size',opdsIdsMap.size());
      system.assertEquals(opdsIdsMap.size(),count);
      
      logger.log('opds[0]',opds[0]);
       logger.log('osrs[0]',osrs[0]);
      List<OPD__c> opds = DAL_OPD.GetOpdbyOsrId(osrs[0]);
      logger.log('opds size',opds.size());
      system.assertEquals(opds.size(),count);
      Test.stopTest();
      logger.end();
    }
}
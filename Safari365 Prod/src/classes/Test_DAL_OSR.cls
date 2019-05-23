@isTest
private class Test_DAL_OSR {

   public static List<OSR__c>  osrs = new List<OSR__c>();
   public static List<Opt__c>  opts = new List<Opt__c>();
   
   public static Integer count =1;
    
    static void setupInsertData(){
        
        for(Integer i = 0 ; i <count; i++)
        {
            opts.add((OPT__c) TestDataFactory.operationOnObjectRecord(null, DAL_OPT.OBJECT_NAME, null));
        }
        insert opts;
        
        Map<String,Object> keyValueMap = new Map<String,Object>();
        for(OPT__c opt:opts)
        {
            keyValueMap.put('Opt_Id__c', opt.OPT_ID__c);
        }
        
        for(Integer i = 0 ; i <count; i++)
        osrs.add((OSR__c) TestDataFactory.operationOnObjectRecord(null, DAL_OSR.OBJECT_NAME, keyValueMap));
         
        insert osrs;
    }
    
    
    static testMethod void getByIdsTest() {
     
      setupInsertData();
      Test.startTest();
      Set<Id> osrIds = new Set<Id>();
      for(OSR__c ac: osrs)
      {
      	osrIds.add(ac.Id);
      }
      
      Map<Id,OSR__c> osrListIds = DAL_OSR.getById(osrIds);
      system.assertEquals(osrListIds.size(),count);
      
      Map<String,Object> keyValue= DAL_OSR.getStayFreeValueMap(osrIds);
      Test.stopTest();
    }
    
    
   static testMethod void  getOsrbyOPTIdTest()
   {
     setupInsertData();
      Test.startTest();
      Set<Id> optsId = new Set<Id>();
      for(OPT__c ac: opts)
      {
      	optsId.add(ac.Id);
      }
      
      List<OSR__c> osrListIds = DAL_OSR.getOsrbyOPTId(optsId);
      system.assertEquals(osrListIds.size(),count);
      Test.stopTest();
   }
}
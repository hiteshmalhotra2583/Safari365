@isTest
private class Test_DAL_SOD {

     public static List<SOD__c>  sods = new List<SOD__c>();
     public static Integer count =5;
    
    static void setupInsertData(){
        
        for(Integer i = 0 ; i <count; i++)
        {
            sods.add((SOD__c) TestDataFactory.operationOnObjectRecord(null, DAL_SOD.OBJECT_NAME, null));
        }
        insert sods;
        
    }
    
    
    static testMethod void getByIdsTest() {
     
      setupInsertData();
      Test.startTest();
      Set<Id> sodIds = new Set<Id>();
      for(SOD__c ac: sods)
      {
      	sodIds.add(ac.Id);
      }
      
      Map<Id,SOD__c> osrListIds = DAL_SOD.getById(sodIds);
      system.assertEquals(osrListIds.size(),count);
      Map<String,SOD__c> policyTypes=  DAL_SOD.getSODSPolicyType(sodIds);
      system.assertEquals(osrListIds.size(),count);
      Test.stopTest();
    }
    
    
}
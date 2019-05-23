@isTest
private class Test_DAL_OPT {

   public static List<Opt__c>  opts = new List<Opt__c>();
   public static List<CRM__c>  crms = new List<CRM__c>();
   public static Integer count =5;
    static void setupInsertData(){
        
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
        {
            opts.add((Opt__c) TestDataFactory.operationOnObjectRecord(null, DAL_OPT.OBJECT_NAME, crmkeyValueMap));
        }
         insert opts;
         
         
       
    }
    
    static testMethod void getByIdTest() {
     
      setupInsertData();
      Test.startTest();
      Set<Id> optIds = new Set<Id>();
      for(Opt__c ac: opts)
      {
      	optIds.add(ac.Id);
      }
      
      List<Opt__c> optIdsMap = DAL_OPT.getById(optIds);
       system.assertEquals(optIdsMap.size(),count);
      Test.stopTest();
    }
    
    
    static testMethod void getOptIdsForServiceLineItemTest() {
     
      setupInsertData();
      Test.startTest();
      
      String serviceType=opts[0].CRM_Name__c;
      String serviceLocation=opts[0].SRV_Name__c;
      String supplierName=opts[0].LOC_Name__c;
      String selectedCode = opts[0].Code__c;
      String selectedServiceDetails= opts[0].Description__c;
      String supplierComments= opts[0].Comment__c;
    
      OPT__c opt = DAL_OPT.GetOptIdsForServiceLineItem(serviceType,serviceLocation,supplierName,selectedServiceDetails,supplierComments);
         
      OPT__c fetchedopt =DAL_OPT.getOptFromOPTCode(selectedCode);
      
      Test.stopTest();
    }
}
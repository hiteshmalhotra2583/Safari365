@isTest
private class Test_DAL_NTS {

   public static List<NTS__c>  nts = new List<NTS__c>();
   public static List<Opt__c>  opts = new List<Opt__c>();
   public static List<CRM__c>  crms = new List<CRM__c>();
   public static Integer count =1;
   
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
        
        Map<String,Object> crmkeyValueMap2 = new Map<String,Object>();
        for(CRM__c crm:crms)
        {
            crmkeyValueMap2.put('SUPPLIER_CODE__c', crm.CODE__c);
        }
        for(Integer i = 0 ; i <count; i++)
        {
            nts.add((NTS__c) TestDataFactory.operationOnObjectRecord(null, 'NTS__c', crmkeyValueMap2));
        }
         insert nts;
    }
    
    static testMethod void getByIdTest() {
       setupInsertData(); 
      Test.startTest();
       DAL_NTS.GetNtsForServiceLineItems(crms);
      Test.stopTest();
    }
}
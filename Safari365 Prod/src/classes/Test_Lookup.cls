@isTest
private class Test_Lookup {

    public static List<CRM__c>  crms = new List<CRM__c>();
    public static List<SOD__c>  sods= new List<SOD__c>();
    public static List<OPT__c>  opts= new List<OPT__c>();
    public static List<SRV__c>  srvs= new List<SRV__c>();
    public static List<LCL__c>  lcls= new List<LCL__c>();
    public static Integer count =1;
    
    static void setupInsertData(){
        
        for(Integer i = 0 ; i <count; i++)
        {
            crms.add((CRM__c) TestDataFactory.operationOnObjectRecord(null, 'CRM__c', null));
        }
        insert crms;
        
        Map<String,Object> keyValueMap = new Map<String,Object>();
        for(CRM__c crm:crms)
        {
            keyValueMap.put('SOD_ID__c', crm.SOD_ID__c);
            keyValueMap.put('POLICY_TYPE__c', 'O');
        }
    
        for(Integer i = 0 ; i <count; i++)
        sods.add((SOD__c) TestDataFactory.operationOnObjectRecord(null, DAL_SOD.OBJECT_NAME, keyValueMap));
        
        insert sods;
        Map<String,Object> LclkeyValueMap1 = new Map<String,Object>();
        LclkeyValueMap1.put('CODE__c','TIM');
        LclkeyValueMap1.put('DESCR__c','Timbavati Game Reserve');
        
        lcls.add((LCL__c) TestDataFactory.operationOnObjectRecord(null, 'LCL__c', LclkeyValueMap1));
        
        insert lcls;
        
        Map<String,Object> SrvkeyValueMap1 = new Map<String,Object>();
        SrvkeyValueMap1.put('NAME__c','Accommodation');
        srvs.add((SRV__c) TestDataFactory.operationOnObjectRecord(null, 'SRV__c', SrvkeyValueMap1));
        
        insert srvs;  
        
        Map<String,Object> optkeyValueMap1 = new Map<String,Object>();
        optkeyValueMap1.put('ANALYSIS1__c','PF');
        optkeyValueMap1.put('CRM_Lookup__c',crms[0].Id);
        optkeyValueMap1.put('SRV_Lookup__c',srvs[0].Id);
        optkeyValueMap1.put('LCL_Lookup__c',lcls[0].Id);
        
    	for(Integer i = 0 ; i <count; i++)
        {
            opts.add((OPT__c) TestDataFactory.operationOnObjectRecord(null, DAL_OPT.OBJECT_NAME, optkeyValueMap1));
        }
        insert opts;
        
        
    }
    

    static testMethod void searchDBTest() {
    	
    	setupInsertData();
    	Test.startTest();
    	String result = Lookup.searchDB(DAL_SOD.OBJECT_NAME,'SOD_ID__c','POLICY_TYPE__c',10,'POLICY_TYPE__c','O',false);
    	
    	Test.stopTest();
        
    }

    
    static testMethod void searchDBWithPreferredSupplierTest() {
    	
    	setupInsertData();
    	Test.startTest();
    	String result = Lookup.searchDB(DAL_SOD.OBJECT_NAME,'SOD_ID__c','POLICY_TYPE__c',10,'POLICY_TYPE__c','O',true);
    	
    	Test.stopTest();
        
    }
    
    static testMethod void searchSupplierTest() {
    	
    	setupInsertData();
    	Test.startTest();
         
        String result = Lookup.searchSupplier(DAL_SOD.OBJECT_NAME,'SOD_ID__c','POLICY_TYPE__c',10,'POLICY_TYPE__c','O','','',false);
    	
    	Test.stopTest();
        
    }
    
    static testMethod void searchSupplierWithParamTest() {
    	
    	setupInsertData();
    	Test.startTest();
        
        String result = Lookup.searchSupplier(DAL_SOD.OBJECT_NAME,'SOD_ID__c','POLICY_TYPE__c',10,'POLICY_TYPE__c','O','Accommodation','Timbavati Game Reserve',false);
    	
    	Test.stopTest();
        
    }
    
    static testMethod void searchDbWithParamTest() {
    	
    	setupInsertData();
    	Test.startTest();
        
    	String result = Lookup.searchDbWithParam(DAL_SOD.OBJECT_NAME,'SOD_ID__c','POLICY_TYPE__c',10,'POLICY_TYPE__c','O','Accommodation','Timbavati Game Reserve',false);
    	
    	Test.stopTest();
        
    }
    
    static testMethod void searchDbWithParamWithPreferredSupplierTest() {
    	
    	setupInsertData();
    	Test.startTest();
        
    	String result = Lookup.searchDbWithParam(DAL_SOD.OBJECT_NAME,'SOD_ID__c','POLICY_TYPE__c',10,'POLICY_TYPE__c','O','Accommodation','Timbavati Game Reserve',true);
    	
    	Test.stopTest();
        
    }
}
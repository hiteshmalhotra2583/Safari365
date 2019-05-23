@isTest
private class Test_ServiceLineItem {

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
    
    static List<Quotations__c> Quotations = new List<Quotations__c>();
    static List<Opportunity> opportunitys = new List<Opportunity>();
    static List<Account> accounts = new List<Account>();
    
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
    
    static void setupQuotationInsertData(){
       
       User us = TestDataFactory.createUser(true, '', true);
       System.runAs(us){
       Account accountRec = new Account();
       accountRec.Name = 'Unit Test Account';
       accountRec.BillingStreet = '123 Unit Test Street';
       accountRec.BillingCity='Dallas';
       accountRec.BillingState = 'TX';
       accountRec.BillingPostalCode = '75006';
       accountRec.BillingCountry='US';
       accountRec.Industry = 'Commerical';
       accountRec.Newsletter__c= true;
       accounts.add(accountRec);
       
       DAL_BaseObject.InsertDBObjects(accounts);
        
        Map<String,Object>  accountOpportunityMap = new Map<String,Object>();
        Date arrivaleDate = Date.newInstance(2008,1,1);
        Date closeDate = Date.newInstance(2008,1,1); 
        for(Account acc:accounts)
        {
            accountOpportunityMap.put('AccountId', acc.ID);
            accountOpportunityMap.put('StageName', 'Money in the Bank');
            accountOpportunityMap.put('CloseDate',closeDate);
            accountOpportunityMap.put('Arrival_Date__c',arrivaleDate);
        }
        
        for(Integer i = 0 ; i <count; i++)
        {
            opportunitys.add((Opportunity) TestDataFactory.operationOnObjectRecord(null, 'Opportunity', accountOpportunityMap));
        }
        DAL_BaseObject.InsertDBObjects(opportunitys);
        
        Map<String,Object>  opportunityQuotationMap = new Map<String,Object>();
        for(Opportunity opp:opportunitys)
        {
            opportunityQuotationMap.put('Opportunity__c', opp.ID);
        }
        
        for(Integer i = 0 ; i <count; i++)
        {
            Quotations.add((Quotations__c) TestDataFactory.operationOnObjectRecord(null, 'Quotations__c', opportunityQuotationMap));
        }
        DAL_BaseObject.InsertDBObjects(Quotations);
    }
        
    }
    
}
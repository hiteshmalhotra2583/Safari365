@isTest
private class Test_DAL_Opportunity {
   
   static List<Quotations__c> Quotations = new List<Quotations__c>();
   static List<Opportunity> opportunitys = new List<Opportunity>();
   static List<Account> accounts = new List<Account>();
   public static Integer OpportunityCount = 4;

    @testSetup static void setupInsertData(){
       
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
        for(Account acc:accounts)
        {
            accountOpportunityMap.put('AccountId', acc.ID);
            accountOpportunityMap.put('StageName', 'Prospect');
        }
        
        for(Integer i = 0 ; i <OpportunityCount; i++)
        {
            opportunitys.add((Opportunity) TestDataFactory.operationOnObjectRecord(null, 'Opportunity', accountOpportunityMap));
        }
        DAL_BaseObject.InsertDBObjects(opportunitys);
        
    }
        
    }
    
    @isTest static void getAllOpportunityTest() {
        setupInsertData();
        Set<Id> opportunityIds = new Set<Id>();
        for(Opportunity o: opportunitys)
        {
       		 opportunityIds.add(o.id);
        }
        Test.startTest();
        	Map<Id,Opportunity> opps = DAL_Opportunity.getAllOpportunity(opportunityIds);
        	system.assertEquals(OpportunityCount, opps.size());
        	DAL_Opportunity.getByIds(opportunityIds);
        	DAL_Opportunity.getConfirmedOpportunity(opportunityIds);
        	DAL_Opportunity.getActiveOpportunity(opportunitys[0].Id);
        	DAL_Opportunity.getById(opportunitys[0].Id);
        	DAL_Opportunity.getOpportunityById(opportunitys[0].Id);
        Test.StopTest();
        
    }
}
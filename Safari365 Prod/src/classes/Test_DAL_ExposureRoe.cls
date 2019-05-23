@isTest
private class Test_DAL_ExposureRoe {
	
   static List<Quotations__c> Quotations = new List<Quotations__c>();
   static List<Opportunity> opportunitys = new List<Opportunity>();
   static List<Exposure_ROE__c> ExposureROEs = new List<Exposure_ROE__c>();
   static List<Account> accounts = new List<Account>();
   public static Integer OpportunityCount = 4;

    @testSetup static void setupInsertData(){
       
       User us = TestDataFactory.createUser(true, '', true);
       System.runAs(us)
       {
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
	        
	        Map<String,Object>  opportunityQuotationMap = new Map<String,Object>();
	        for(Opportunity opp:opportunitys)
	        {
	            opportunityQuotationMap.put('Opportunity__c', opportunitys[0].ID);
	            opportunityQuotationMap.put('TravelStartDate__c',system.today());
	            opportunityQuotationMap.put('TravelEndDate__c',system.today().addDays(500));
	            opportunityQuotationMap.put('Include_Passenger_Insurance_USD__c',true);
	            opportunityQuotationMap.put('Include_Passenger_Insurance_ZAR__c',false);
	            opportunityQuotationMap.put('Include_Photobooks_USD__c',true);
	            opportunityQuotationMap.put('Include_Photobooks_ZAR__c',false);
	            opportunityQuotationMap.put('Quotation_Stage__c','Confirmed');
	            opportunityQuotationMap.put('Primary_by_Consultant__c',false);
	        }
	        
	        for(Integer i = 0 ; i <OpportunityCount; i++)
	        {
	            Quotations.add((Quotations__c) TestDataFactory.operationOnObjectRecord(null, DAL_Quotations.OBJECT_NAME, opportunityQuotationMap));
	        }
	        DAL_BaseObject.InsertDBObjects(Quotations);
	        
	        Map<String,Object>  ExposureROEOpportunityMap = new Map<String,Object>();
	        for(Opportunity opp:opportunitys)
	        {
	            ExposureROEOpportunityMap.put('Quotation__c', Quotations[0].ID);
	        }
	        
	        for(Integer i = 0 ; i <OpportunityCount; i++)
	        {
	            ExposureROEs.add((Exposure_ROE__c) TestDataFactory.operationOnObjectRecord(null, 'Exposure_ROE__c', ExposureROEOpportunityMap));
	        }
	        DAL_BaseObject.InsertDBObjects(ExposureROEs);
      }
    }
   
    static testMethod void getByQuotationIdTest() {
    	
    	Set<Id> quotationIds = new Set<Id>();
    	Test.startTest();
    	for(Opportunity opp:opportunitys)
        {
            quotationIds.add(opp.ID);
        }
    	DAL_ExposureRoe.getByQuotationId(quotationIds);
    	Test.stopTest();
        
    }
}
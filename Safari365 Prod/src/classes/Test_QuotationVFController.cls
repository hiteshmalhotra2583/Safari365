@isTest
private class Test_QuotationVFController {

    static List<Opportunity> opportunitys = new List<Opportunity>();
   	static List<Account> accounts = new List<Account>();
    static Integer recordCount = 1;
    
    static void setupInsertData()
    {
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
        
        for(Integer i = 0 ; i <recordCount; i++)
        {
            opportunitys.add((Opportunity) TestDataFactory.operationOnObjectRecord(null, 'Opportunity', accountOpportunityMap));
        }
        DAL_BaseObject.InsertDBObjects(opportunitys);
    	}
    }
        
    static testMethod void TestCreateNewQuotation() {
      
        Test.startTest();
        setupInsertData();
        
        PageReference pageRef = Page.QuotationsVF;
		Test.setCurrentPage(pageRef);
		pageRef.getParameters().put('retURL', String.valueOf(opportunitys[0].Id));
		ApexPages.StandardController sc = new ApexPages.StandardController(opportunitys[0]);
		QuotationVFController ctrl = new QuotationVFController(sc);
        ctrl.parentID= opportunitys[0].Id;
        ctrl.recId=opportunitys[0].Id;
    	Test.stopTest();
    }
}
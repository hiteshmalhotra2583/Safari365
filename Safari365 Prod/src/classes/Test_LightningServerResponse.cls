@isTest
private class Test_LightningServerResponse {
    public static List<Account> accounts = new List<Account>();
    @testSetup static void setupInsertData()
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
        }
    }
    
    @isTest static void Test_AllMethods(){
        List<Account> accountList = [SELECT Id FROM Account];
        Map<String, Object> objectData = new Map<String, Object>();
        List<APXFieldValidationError> fieldValidationErrors = new  List<APXFieldValidationError>();
        for(Account act:accountList){
            objectData.put(act.Id,act);
        }
        Test.startTest();
        	LightningServerResponse lsr1 = new LightningServerResponse(true,'Success',objectData);
        	LightningServerResponse lsr2 = new LightningServerResponse(true,'Success',objectData,fieldValidationErrors);
        Test.stopTest();
    }
}
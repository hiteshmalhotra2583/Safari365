@isTest
private class Test_CustomLightningActionApxCtrl {
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
            accountRec.Credit_Status__c = 'red';
            accounts.add(accountRec);
            DAL_BaseObject.InsertDBObjects(accounts);
        }
    }
    
    @isTest static void Test_AllMethodsOne(){
        List<Account> accountRecords = [SELECT Id,Credit_Status__c FROM Account];
        Test.startTest();
            CustomLightningActionApxCtrl.creditStatusConfirmConditionalCheck(accountRecords[0].Id);
        	CustomLightningActionApxCtrl.creditStatusRedirectCheck(accountRecords[0].Id);
        	CustomLightningActionApxCtrl.stupidStaticMethod(accountRecords[0].Id);
        	CustomLightningActionApxCtrl.createSalesOrder(accountRecords[0].Id);
        Test.stopTest();
    }
    
    @isTest static void Test_AllMethodsTwo(){
        Test.startTest();
            CustomLightningActionApxCtrl.creditStatusConfirmConditionalCheck('1231312312');
        	CustomLightningActionApxCtrl.creditStatusRedirectCheck('123131231');
        	CustomLightningActionApxCtrl.stupidStaticMethod('123123213123');
        Test.stopTest();
    }
}
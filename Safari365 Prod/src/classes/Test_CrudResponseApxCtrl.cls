@isTest
private class Test_CrudResponseApxCtrl {
    public static List<Account> accounts = new List<Account>();
    @isTest static  void setupInsertData()
    {
        List<SObject> sObjects = new List<SObject>();
        List<Database.SaveResult> saveResults = new List<Database.SaveResult>();
        
        User us = TestDataFactory.createUser(true, '', true);
        System.runAs(us){
            Account accountRec = new Account();
            //accountRec.Name = 'Unit Test Account';
            accountRec.BillingStreet = '123 Unit Test Street';
            accountRec.BillingCity='Dallas';
            accountRec.BillingState = 'TX';
            accountRec.BillingPostalCode = '75006';
            accountRec.BillingCountry='US';
            accountRec.Industry = 'Commerical';
            accountRec.Newsletter__c= true;
            accounts.add(accountRec);
            
            sObjects.add(accountRec);
            saveResults  = Database.insert(accounts, false);
            
            Test.startTest();
            CrudResponseApxCtrl.getCrudResponseFromSaveResults(sObjects,saveResults);
            //CrudResponseApxCtrl.getCrudResponseFromDeleteResults(sObjects,deleteResults);
            Test.stopTest();
            
        }
    }
    
    @isTest static  void Test_getCrudResponseFromDeleteResultsOne()
    {
        List<SObject> sObjects = new List<SObject>();
        List<Database.DeleteResult> deleteResults = new List<Database.DeleteResult>();
        List<Database.DeleteResult> deleteResults2 = new List<Database.DeleteResult>();
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
            
            sObjects.add(accountRec);
            // Query the accounts to delete
            Account[] accts = [SELECT Id from Account];
            // Delete the accounts
            deleteResults = Database.delete(accts, false);
            deleteResults2 = Database.delete(accts, false);
            Test.startTest();
            CrudResponseApxCtrl.getCrudResponseFromDeleteResults(sObjects,deleteResults);
            CrudResponseApxCtrl.getCrudResponseFromDeleteResults(sObjects,deleteResults2);
            Test.stopTest();
        }
    }
    

}
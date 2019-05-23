@isTest
private class Test_GenericDataSaverApxCtrl {
	public static List<Account> accounts = new List<Account>();
    @isTest static  void testMethodOneInsert()
    {
        List<SObject> sObjects = new List<SObject>();
        List<Database.SaveResult> saveResults = new List<Database.SaveResult>();
        
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
            
            sObjects.add(accountRec);
            saveResults  = Database.insert(accounts, false);
            Test.startTest();
            GenericDataSaverApxCtrl.doDML(sObjects,'insert');
            Test.stopTest();
            
        }
    }
    
    @isTest static  void testMethodTwoUpdate()
    {
        List<SObject> sObjects = new List<SObject>();
        List<Database.SaveResult> saveResults = new List<Database.SaveResult>();
        
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
            
            List<Account> accountList = [SELECT Id,BillingCountry FROM Account WHERE Name Like 'Unit Test Account'];
            
            sObjects.add(accountRec);
            saveResults  = Database.update(accountList, false);
            Test.startTest();
            GenericDataSaverApxCtrl.doDML(sObjects,'update');
            Test.stopTest();
            
        }
    }
    
    @isTest static  void testMethodThreeDelete()
    {
        List<SObject> sObjects = new List<SObject>();
        List<Database.DeleteResult> deleteResults = new List<Database.DeleteResult>();
        
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
            
            List<Account> accountList = [SELECT Id,BillingCountry FROM Account WHERE Name Like 'Unit Test Account'];
            
            sObjects.add(accountRec);
            deleteResults  = Database.delete(accountList, false);
            Test.startTest();
            GenericDataSaverApxCtrl.doDML(sObjects,'delete');
            Test.stopTest();
            
        }
    }
    
}
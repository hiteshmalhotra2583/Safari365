@isTest
private class Test_CreatePassengerServiceReqButton {

   static List<Opportunity> opportunitys = new List<Opportunity>();
   static List<Account> accounts = new List<Account>();
   public static Integer count = 1;

    static void setupInsertData(){
       
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
        
        for(Integer i = 0 ; i <count; i++)
        {
            opportunitys.add((Opportunity) TestDataFactory.operationOnObjectRecord(null, 'Opportunity', accountOpportunityMap));
        }
        DAL_BaseObject.InsertDBObjects(opportunitys);
       }
        
    }

    static testMethod void createPassengerAccountTest() {
       setupInsertData();
       Test.startTest();
       CreatePassengerServiceReqButtonHelper.createPassengerAccount(accounts[0].Id,opportunitys[0].Id,'Adult','2');
       
       Test.stopTest(); 
    }
}
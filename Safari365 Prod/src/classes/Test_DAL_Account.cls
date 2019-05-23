@isTest
private class Test_DAL_Account {

   public static List<Account>  accounts = new List<Account>();
   public static List<Opportunity> opportunitys = new List<Opportunity>();
   public static List<ExchangeRates__c> exchangeRates = new List<ExchangeRates__c>();
   static Integer recordCount = 1; 
   public static Integer count =5;
   @testSetup static void setupInsertData(){
           User us = TestDataFactory.createUser(true, '', true);
           System.runAs(us){
           	Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
	        Map <String,Object> MapFieldsAndValueAcc = new Map <String,Object>();
	        MapFieldsAndValueAcc.put('RecordTypeId', devRecordTypeId );
	        MapFieldsAndValueAcc.put('LastName', 'TestL');
	        MapFieldsAndValueAcc.put('PersonEmail', 'abc@gmail.com');
	        for(Integer i = 0 ; i <recordCount; i++){
	            Account AccObj = (Account) TestDataFactory.operationOnObjectRecord(null, 'Account', MapFieldsAndValueAcc);
	            accounts.add(AccObj);
	        }
	        insert accounts; 
               
               	Map<String,Object>  accountOpportunityMap = new Map<String,Object>();
                for(Account acc:accounts)
                {
                    accountOpportunityMap.put('AccountId', acc.ID);
                    accountOpportunityMap.put('StageName', 'Prospect');
                }
               
                Map<String,Object> exchangeRateMap = new Map<String,Object>();
                exchangeRateMap.put('BaseCurrency__c','ZAR');
                for(Integer i = 0 ; i <recordCount; i++)
                {
                    exchangeRates.add((ExchangeRates__c) TestDataFactory.operationOnObjectRecord(null, 'ExchangeRates__c', exchangeRateMap));
                }
                DAL_BaseObject.InsertDBObjects(exchangeRates);
                
                for(Integer i = 0 ; i <recordCount; i++)
                {
                    opportunitys.add((Opportunity) TestDataFactory.operationOnObjectRecord(null, 'Opportunity', accountOpportunityMap));
                }
                DAL_BaseObject.InsertDBObjects(opportunitys);
           }
    }
    
    static testMethod void getByIdTest() 
    {
      List<Account> accountsList = [SELECT Id,PersonEmail FROM Account];
      List<Account> opportunityList = [SELECT Id FROM Account];
      Test.startTest();
          Set<Id> accountIds = new Set<Id>();
          for(Account ac: accountsList)
          {
            accountIds.add(ac.Id);
          }
          DAL_Account.getById(accountIds);
          DAL_Account.getPersonAccountById(accountsList[0].Id);
          DAL_Account.getAccount_DynamiCSOQL(opportunityList[0].Id);
          DAL_Account.getAccountById(accountsList[0].Id);
          DAL_Account.getAccountByEmailId('abc@gmail.com');
          //Map<Id, Account> accountIdMap = DAL_Account.getById(accountIds);
          //system.assert(accountIdMap.size() <> count);
      Test.stopTest();
    }
}
@isTest
private class Test_DAL_BaseObject {

   public static final String EMAIL_SUFFIX = '@mailinator.com';
   
   static List<Account> accounts = new List<Account>();
   static List<Opportunity> opportunitys = new List<Opportunity>();
   static List<ExchangeRates__c> exchangeRates = new List<ExchangeRates__c>();
   public static Integer count = 1;
   
   static testMethod void test_getRecordTypeById()
    {
        Schema.sObjectType accountType = Schema.Account.getSObjectType();
        
        List<RecordType> recordTypes = DAL_BaseObject.getRecordTypes(accountType);      
        
        if (recordTypes.size() > 0)
        {
            RecordType rt = recordTypes.get(0);
        
            // TEST 1
            Id rt_id = rt.Id;
            String expectedName = rt.Name;
            String fetchedName = DAL_BaseObject.getRecordTypeById(rt_id);
            System.assertEquals(expectedName, fetchedName);

            //TEST 2
            String emptyName = DAL_BaseObject.getRecordTypeById(null);
            System.assertEquals(true, String.isEmpty(emptyName));
        }               
    }

    static testMethod void test_getRecordTypesByIds()
    {
        Schema.sObjectType accountType = Schema.Account.getSObjectType();       
        List<RecordType> accountRecordTypes = DAL_BaseObject.getRecordTypes(accountType);

        Set<Id> ids = new Set<Id>();
        for (RecordType rt : accountRecordTypes)
        {
            ids.add(rt.Id);
        }

        List<RecordType> fetchedRecordTypes = DAL_BaseObject.getRecordTypesByIds(ids);
        System.assertEquals(accountRecordTypes.size(), fetchedRecordTypes.size());
    }

    static testMethod void test_getRecordTypeByDeveloperName()
    {
        Schema.sObjectType accountType = Schema.Account.getSObjectType();
        
        List<RecordType> recordTypes = DAL_BaseObject.getRecordTypes(accountType);      
        
        if (recordTypes.size() > 0)
        {
            RecordType rt = recordTypes.get(0);
        
            String developerName = rt.DeveloperName;        

            Id fetchedId = DAL_BaseObject.getRecordTypeByDeveloperName(accountType, developerName);
            System.assertEquals(rt.Id, fetchedId);
        }       
    }

    static testMethod void test_getRecordTypesByDeveloperNames()
    {
        Schema.sObjectType accountType = Schema.Account.getSObjectType();       
        List<RecordType> accountRecordTypes = DAL_BaseObject.getRecordTypes(accountType);

        Set<String> developerNames = new Set<String>();
        Set<Id> expectedIds = new Set<Id>();
        for (RecordType rt : accountRecordTypes)
        {
            developerNames.add(rt.DeveloperName);
            expectedIds.add(rt.Id);
        }

        Set<Id> fetchedIds = DAL_BaseObject.getRecordTypesByDeveloperNames(developerNames);
        System.assertEquals(expectedIds, fetchedIds);
    }
   
   static testMethod void test_UpdateDatabase_Success()
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
        
        Map<String,Object> exchangeRateMap = new Map<String,Object>();
        exchangeRateMap.put('BaseCurrency__c','ZAR');
        for(Integer i = 0 ; i <count; i++)
        {
            exchangeRates.add((ExchangeRates__c) TestDataFactory.operationOnObjectRecord(null, 'ExchangeRates__c', exchangeRateMap));
        }
        DAL_BaseObject.InsertDBObjects(exchangeRates);
        
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
        
        Quotations__c a = (Quotations__c) TestDataFactory.operationOnObjectRecord(null, 'Quotations__c',opportunityQuotationMap);
       
        //TEST 1 - Insert object
        Boolean isInserted = DAL_BaseObject.InsertDBObject(a);
        System.assertEquals(isInserted, true);

        //a.Name = DAL_BaseObject.generateRandomName();
        
        //TEST 2 - Update object
        Boolean isUpdated = DAL_BaseObject.UpdateDBObject(a);
        System.assertEquals(isUpdated, true);

        //TEST 3 - Delete object
        Boolean isDeleted = DAL_BaseObject.DeleteDBObject(a);
        System.assertEquals(isDeleted, true);
       }
    }

    static testMethod void test_UpdateDatabase_Fail()
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
        
         Map<String,Object> exchangeRateMap = new Map<String,Object>();
        exchangeRateMap.put('BaseCurrency__c','ZAR');
        for(Integer i = 0 ; i <count; i++)
        {
            exchangeRates.add((ExchangeRates__c) TestDataFactory.operationOnObjectRecord(null, 'ExchangeRates__c', exchangeRateMap));
        }
        DAL_BaseObject.InsertDBObjects(exchangeRates);
        
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
        
        Quotations__c a = (Quotations__c) TestDataFactory.operationOnObjectRecord(null, 'Quotations__c',opportunityQuotationMap);
        List<Quotations__c> quotations1 = new List<Quotations__c>();
         quotations1.add(a);        
        
        //TEST 1 - Insert object (Causes exception but does not fail because allInsertsMustSucceed=false)
        Boolean isInserted = DAL_BaseObject.InsertDBObjects(quotations1, false);
        System.assertEquals(isInserted, true);
      
        //TEST 2 - Update object (Causes exception but does not fail because allUpdatesMustSucceed=false)
        Boolean isUpdated = DAL_BaseObject.UpdateDBObjects(quotations1, false);
        System.assertEquals(isUpdated, true);

        //TEST 3
        //Preparing test data;
        quotations1 = new List<Quotations__c>();
        Quotations__c a2 = (Quotations__c) TestDataFactory.operationOnObjectRecord(null, 'Quotations__c',opportunityQuotationMap);
        quotations1.add(a2);
        isInserted = DAL_BaseObject.InsertDBObjects(quotations1, true);
         
        //====================================   
        List<Quotations__c> quotations4; 
        quotations4 = new List<Quotations__c>();
        Quotations__c a4 = (Quotations__c) TestDataFactory.operationOnObjectRecord(null, 'Quotations__c',opportunityQuotationMap);
        quotations4.add(a4);   
        DAL_BaseObject.InsertDBObjectsAsync(quotations4);
        DAL_BaseObject.UpdateDBObjectsAsync(quotations4);
        //=====================================   
           

        //Deleting objects
        Boolean isDeleted = DAL_BaseObject.DeleteDBObjects(quotations1, true);

        //Deleting objects second time causes exception but does not fail because allDeletesMustSucceed=false
        isDeleted = DAL_BaseObject.DeleteDBObjects(quotations1, false);
        System.assertEquals(isDeleted, true);
         }
    }
   


    static testMethod void test_newObject()
    {       
        SObject a = DAL_BaseObject.newObject(DAL_Quotations.OBJECT_NAME);
        Schema.sObjectType expected = Quotations__c.SObjectType;
        System.assertEquals(expected, a.getSobjectType());

        //Null object
        SObject empty = DAL_BaseObject.newObject(DAL_BaseObject.generateRandomName());
        System.assertEquals(null, empty);
    }   
    
    static testMethod void test_generateRandomNumber()
    {
        String randomNumber = DAL_BaseObject.generateRandomNumber();
        
        Boolean isNumeric = randomNumber.isNumeric();       
        System.assertEquals(true, isNumeric);

        Integer expectedLength = 15;
        System.assertEquals(expectedLength, randomNumber.length());

    }
    
    static testMethod void test_generateRandomName()
    {
        String randomName = DAL_BaseObject.generateRandomName();
        
        Boolean isAlphabetic = randomName.isAlpha();
        System.assertEquals(true, isAlphabetic);

        Integer expectedLength = 15;
        System.assertEquals(expectedLength, randomName.length());
    }

    static testMethod void test_generateRandomDescription()
    {
        String randomDescription = DAL_BaseObject.generateRandomDescription();

        Boolean isAlphabetic = randomDescription.isAlpha();
        System.assertEquals(true, isAlphabetic);

        Integer expectedLength = 80;
        System.assertEquals(expectedLength, randomDescription.length());
    }

    static testMethod void test_generateRandomEmail()
    {
        String randomEmail = DAL_BaseObject.generateRandomEmail();

        String randomEmailSuffix = randomEmail.substring(15, randomEmail.length());
        System.assertEquals(EMAIL_SUFFIX, randomEmailSuffix);
    }   
    
    //==============================================
    static testMethod void test_getTriggerDBOperation()
    {
       //DAL_BaseObject.getTriggerDBOperation();
       DAL_BaseObject.generateRandomDouble();
       DAL_BaseObject.generateRandomNumber(3);
       DAL_BaseObject.generateRandomPhoneNumber(3);
       DAL_BaseObject.fitToName('134');
    }
    //===============================================
}
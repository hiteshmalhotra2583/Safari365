@isTest
private class Test_EmailUtilService {
	static List<Opportunity> opportunitys = new List<Opportunity>();
    static List<Account> accounts = new List<Account>();
    static List<Passenger__c> passengers = new List<Passenger__c>();
    static List<Quotations__c> Quotations = new List<Quotations__c>();
    static List<ExchangeRates__c> exchangeRates = new List<ExchangeRates__c>();
     static Integer recordCount = 2;
    
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
            
            Map<String,Object>  accountOpportunityMap = new Map<String,Object>();
            for(Account acc:accounts)
            {
                accountOpportunityMap.put('AccountId', acc.ID);
                accountOpportunityMap.put('StageName', 'Prospect');
                accountOpportunityMap.put('Client_Display_Currency__c','USD');
            }
            Map<String,Object>  accountOpportunityMap1 = new Map<String,Object>();
            for(Account acc:accounts)
            {
                accountOpportunityMap1.put('AccountId', acc.ID);
                accountOpportunityMap1.put('StageName', 'Prospect');
                accountOpportunityMap1.put('Client_Display_Currency__c','AUD');
            }
            Map<String,Object>  accountOpportunityMap2 = new Map<String,Object>();
            for(Account acc:accounts)
            {
                accountOpportunityMap2.put('AccountId', acc.ID);
                accountOpportunityMap2.put('StageName', 'Prospect');
                accountOpportunityMap2.put('Client_Display_Currency__c','EUR');
            }
            Map<String,Object>  accountOpportunityMap3 = new Map<String,Object>();
            for(Account acc:accounts)
            {
                accountOpportunityMap3.put('AccountId', acc.ID);
                accountOpportunityMap3.put('StageName', 'Prospect');
                accountOpportunityMap3.put('Client_Display_Currency__c','GBP');
            }
            
            //USD
            Map<String,Object> exchangeRateMap = new Map<String,Object>();
            exchangeRateMap.put('BaseCurrency__c','USD');
            exchangeRateMap.put('USD__c',1.0d);
            //AUD
            Map<String,Object> exchangeRateMap1 = new Map<String,Object>();
            exchangeRateMap1.put('BaseCurrency__c','AUD');
            exchangeRateMap1.put('AUD__c',1.0d);
            //EUR
            Map<String,Object> exchangeRateMap2 = new Map<String,Object>();
            exchangeRateMap2.put('BaseCurrency__c','EUR');
            exchangeRateMap2.put('EUR__c',1.0d);
            //GBP
            Map<String,Object> exchangeRateMap3 = new Map<String,Object>();
            exchangeRateMap3.put('BaseCurrency__c','GBP');
            exchangeRateMap3.put('GBP__c',1.0d);
            
            for(Integer i = 0 ; i <recordCount; i++)
            {
                exchangeRates.add((ExchangeRates__c) TestDataFactory.operationOnObjectRecord(null, 'ExchangeRates__c', exchangeRateMap));
            }
            for(Integer i = 0 ; i <recordCount; i++)
            {
                exchangeRates.add((ExchangeRates__c) TestDataFactory.operationOnObjectRecord(null, 'ExchangeRates__c', exchangeRateMap1));
            }
            for(Integer i = 0 ; i <recordCount; i++)
            {
                exchangeRates.add((ExchangeRates__c) TestDataFactory.operationOnObjectRecord(null, 'ExchangeRates__c', exchangeRateMap2));
            }
            for(Integer i = 0 ; i <recordCount; i++)
            {
                exchangeRates.add((ExchangeRates__c) TestDataFactory.operationOnObjectRecord(null, 'ExchangeRates__c', exchangeRateMap3));
            }
            DAL_BaseObject.InsertDBObjects(exchangeRates);
            
            //New Opportunity One
            for(Integer i = 0 ; i <recordCount; i++)
            {
                opportunitys.add((Opportunity) TestDataFactory.operationOnObjectRecord(null, 'Opportunity', accountOpportunityMap));
            }
            //New Opportunity Two
            for(Integer i = 0 ; i <recordCount; i++)
            {
                opportunitys.add((Opportunity) TestDataFactory.operationOnObjectRecord(null, 'Opportunity', accountOpportunityMap1));
            }
            //New Opportunity Three
            for(Integer i = 0 ; i <recordCount; i++)
            {
                opportunitys.add((Opportunity) TestDataFactory.operationOnObjectRecord(null, 'Opportunity', accountOpportunityMap2));
            }
            //New Opportunity Four
            for(Integer i = 0 ; i <recordCount; i++)
            {
                opportunitys.add((Opportunity) TestDataFactory.operationOnObjectRecord(null, 'Opportunity', accountOpportunityMap3));
            }
            DAL_BaseObject.InsertDBObjects(opportunitys);
            
            //For Quotation One
            Map<String,Object>  opportunityQuotationMap = new Map<String,Object>();
            opportunityQuotationMap.put('Opportunity__c', opportunitys[0].ID);
            opportunityQuotationMap.put('TravelStartDate__c',system.today());
            opportunityQuotationMap.put('TravelEndDate__c',system.today().addDays(3));
            opportunityQuotationMap.put('Itinerary_Summary__c','21123');
            opportunityQuotationMap.put('ROE_ZAR_to_CC__c',2);
            opportunityQuotationMap.put('ROE_USD_to_CC__c',2);
            opportunityQuotationMap.put('ROE_EUR_to_CC__c',2);
            
            //For Quotation Two
            Map<String,Object>  opportunityQuotationMap1 = new Map<String,Object>();
            opportunityQuotationMap1.put('Opportunity__c', opportunitys[1].ID);
            opportunityQuotationMap1.put('TravelStartDate__c',system.today());
            opportunityQuotationMap1.put('TravelEndDate__c',system.today().addDays(3));
            opportunityQuotationMap1.put('Itinerary_Summary__c','21123');
            opportunityQuotationMap1.put('ROE_ZAR_to_CC__c',2);
            opportunityQuotationMap1.put('ROE_USD_to_CC__c',2);
            opportunityQuotationMap1.put('ROE_EUR_to_CC__c',2);
            
            //For Quotation Three
            Map<String,Object>  opportunityQuotationMap2 = new Map<String,Object>();
            opportunityQuotationMap2.put('Opportunity__c', opportunitys[2].ID);
            opportunityQuotationMap2.put('TravelStartDate__c',system.today());
            opportunityQuotationMap2.put('TravelEndDate__c',system.today().addDays(3));
            opportunityQuotationMap2.put('Itinerary_Summary__c','21123');
            opportunityQuotationMap2.put('ROE_ZAR_to_CC__c',2);
            opportunityQuotationMap2.put('ROE_USD_to_CC__c',2);
            opportunityQuotationMap2.put('ROE_EUR_to_CC__c',2);
            
            //For Quotation Four
            Map<String,Object>  opportunityQuotationMap3 = new Map<String,Object>();
            opportunityQuotationMap3.put('Opportunity__c', opportunitys[0].ID);
            opportunityQuotationMap3.put('TravelStartDate__c',system.today());
            opportunityQuotationMap3.put('TravelEndDate__c',system.today().addDays(3));
            opportunityQuotationMap3.put('Itinerary_Summary__c','21123');
            opportunityQuotationMap3.put('ROE_ZAR_to_CC__c',2);
            opportunityQuotationMap3.put('ROE_USD_to_CC__c',2);
            opportunityQuotationMap3.put('ROE_EUR_to_CC__c',2);
            
            Map<String,Object>  accountMap = new Map<String,Object>();
            accountMap.put('Opportunity__c' ,opportunitys[0].id );
            
            for(Integer i = 0 ; i <recordCount; i++)
            {
                passengers.add((Passenger__c) TestDataFactory.operationOnObjectRecord(null, DAL_Passenger.OBJECT_NAME, accountMap));
            }
            DAL_BaseObject.InsertDBObjects(passengers);
            
            //New Quotations One
            for(Integer i = 0 ; i <recordCount; i++)
            {
                Quotations.add((Quotations__c) TestDataFactory.operationOnObjectRecord(null, DAL_Quotations.OBJECT_NAME, opportunityQuotationMap));
            }
            //New Quotations Two
            for(Integer i = 0 ; i <recordCount; i++)
            {
                Quotations.add((Quotations__c) TestDataFactory.operationOnObjectRecord(null, DAL_Quotations.OBJECT_NAME, opportunityQuotationMap1));
            }
            //New Quotations Three
            for(Integer i = 0 ; i <recordCount; i++)
            {
                Quotations.add((Quotations__c) TestDataFactory.operationOnObjectRecord(null, DAL_Quotations.OBJECT_NAME, opportunityQuotationMap2));
            }
            //New Quotations Four
            for(Integer i = 0 ; i <recordCount; i++)
            {
                Quotations.add((Quotations__c) TestDataFactory.operationOnObjectRecord(null, DAL_Quotations.OBJECT_NAME, opportunityQuotationMap3));
            }
           
            BaseTriggerHandler.bypass('OpportunityTriggerHandler');
            DAL_BaseObject.InsertDBObjects(Quotations);
            BaseTriggerHandler.clearBypass('OpportunityTriggerHandler');
        }
    }
    
    @isTest static void sendEmailTest(){
        List<Quotations__c> quotations = [SELECT Id FROM Quotations__c];
        Set<Id> confirmedQuotaionsIds = new Set<Id>();
        Map<Id,String> quotationIdEmailMap = new Map<Id,String>();
        for(Quotations__c quotation:quotations){
            confirmedQuotaionsIds.add(quotation.Id);
            quotationIdEmailMap.put(quotation.Id,quotation.Id);
        }
        Test.startTest();
        EmailUtilService.sendEmail(confirmedQuotaionsIds,quotationIdEmailMap);
        Test.stopTest();
    } 
    
}
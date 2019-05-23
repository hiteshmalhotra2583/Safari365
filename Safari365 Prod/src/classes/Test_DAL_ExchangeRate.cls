@isTest
private class Test_DAL_ExchangeRate {

    static List<ExchangeRates__c> exchangeRates = new List<ExchangeRates__c>();
    
    static Integer recordCount = 1; 
    
    
    @testSetup
    static void setupInsertData()
    {
        User us = TestDataFactory.createUser(true, '', true);
        System.runAs(us){
            
            //USD
            Map<String,Object> exchangeRateMap = new Map<String,Object>();
            exchangeRateMap.put('BaseCurrency__c','USD');
            exchangeRateMap.put('USD__c',1.0d);
            //AUD
            Map<String,Object> exchangeRateMap1 = new Map<String,Object>();
            exchangeRateMap1.put('BaseCurrency__c','ZAR');
            exchangeRateMap1.put('ZAR__c',1.0d);
            //EUR
            Map<String,Object> exchangeRateMap2 = new Map<String,Object>();
            exchangeRateMap2.put('BaseCurrency__c','EUR');
            exchangeRateMap2.put('EUR__c',1.0d);
            //ZAR
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
            DAL_BaseObject.InsertDBObjects(exchangeRates);
            
        }   
        
    }
    
    @isTest static void getCurrencyByBaseCurrencyTest(){
        setupInsertData();
        Test.startTest();
           DAL_ExchangeRate.getCurrencyByBaseCurrency('ZAR');
           DAL_ExchangeRate.getCurrencyAllByBaseCurrency();
           DAL_ExchangeRate.getExchangeRateMapping();
        Test.stopTest();
    }
    
}
@isTest
private class Test_ExchangeRateWebServiceCall {
   
   @testSetup static void insertTestData()
   {
    	List<CurrencyExchangeRate__c> exchangeRates  = new List<CurrencyExchangeRate__c>();
       
    	CurrencyExchangeRate__c exchangeRate = new CurrencyExchangeRate__c();
    	exchangeRate.Name ='CurrUSDAED';
    	exchangeRate.Country__c= 'AED';
    	exchangeRate.BaseCurrency__c = 'USD';
    	exchangeRates.add(exchangeRate);
    	CurrencyExchangeRate__c exchangeRate1 = new CurrencyExchangeRate__c();
    	exchangeRate1.Name ='CurrZARAED';
    	exchangeRate1.Country__c= 'AED';
    	exchangeRate1.BaseCurrency__c = 'AED';
    	exchangeRates.add(exchangeRate1);
        exchangeRate1 = new CurrencyExchangeRate__c();
    	exchangeRate1.Name ='CurrXYZAED';
    	exchangeRate1.Country__c= 'USD';
    	exchangeRate1.BaseCurrency__c = 'USD';
    	exchangeRates.add(exchangeRate1);
    	insert exchangeRates;
   }
   
   
    @isTest static void TestService()
    {
        //insertTestData();
        Test.startTest();
         // Set mock callout class 
         Test.setMock(HttpCalloutMock.class, new Test_MockExchangeRateHttpResponce());
         // Call method to test.
         ExchangeRateWebServiceCall.CallService();
         Test.stopTest();
        
    }
}
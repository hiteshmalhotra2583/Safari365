@isTest
global class Test_MockExchangeRateHttpResponce implements HttpCalloutMock {
    
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
         String baseCurrency='USD';
       String commaSepratedCountryList='';
        
       List<CurrencyExchangeRate__c> countryNames =[SELECT Country__c FROM CurrencyExchangeRate__c WHERE BaseCurrency__c=:baseCurrency];
       
       for(CurrencyExchangeRate__c currencyExchangeRate : countryNames)
       {
            commaSepratedCountryList = commaSepratedCountryList + currencyExchangeRate.Country__c + ',' ;
       }
       
       string url ='https://openexchangerates.org/api/latest.json?app_id='+Label.ExchangeRateApp_id+'&base='+baseCurrency+'&symbols='+commaSepratedCountryList;
        
        System.assertEquals(url, req.getEndpoint());
        System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"disclaimer": "https://openexchangerates.org/terms/","license": "https://openexchangerates.org/license/", "timestamp":1449877801,"base": "USD","rates": { "USD":3.12, "AED":3.672538,"AFN":66.809999}}');
        res.setStatusCode(200);
        return res;
    }
}
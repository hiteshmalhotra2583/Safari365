global class ExchangeRateWebServiceCall implements Schedulable  {
    
    @future(callout=true)
    public static void CallService(){
       String baseCurrency='USD';
       String commaSepratedCountryList='';
        
       List<CurrencyExchangeRate__c> countryNames =[SELECT Country__c FROM CurrencyExchangeRate__c WHERE BaseCurrency__c=:baseCurrency];
       
       for(CurrencyExchangeRate__c currencyExchangeRate : countryNames)
       {
            commaSepratedCountryList = commaSepratedCountryList + currencyExchangeRate.Country__c + ',' ;
       }
       
       string url ='https://openexchangerates.org/api/latest.json?app_id='+Label.ExchangeRateApp_id+'&base='+baseCurrency+'&symbols='+commaSepratedCountryList;

        // Instantiate a new http object
        Http h = new Http();

        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('GET');
        // Send the request, and return a response
        HttpResponse res = h.send(req);        
        
        if(res.getStatus() =='Forbidden')
        {
           return;
        }
        
        List<ExchangeRateColumnMapping__mdt> exchangeRateMappingColumns = [SELECT SourceField__c,TargetField__c FROM ExchangeRateColumnMapping__mdt];
        
        JSON2Apex.CurrencyExchangeRate currencyExchangeRate = new JSON2Apex.CurrencyExchangeRate(System.JSON.createParser(res.getBody()),countryNames);
        
        System.debug('currencyExchangeRate.Rates.FxRates: >>'+currencyExchangeRate.Rates.FxRates);

        //Iterate through the properties of an object instance
        //          String s = JSON.serialize(currencyExchangeRate.Rates);
        // Deserialize it back into a key/value map
        //      Map<String,Object> rate =     (Map<String,Object>) JSON.deserializeUntyped(s);
        
        ExchangeRates__c exchangeRate = new ExchangeRates__c();
        
        for (String key : currencyExchangeRate.Rates.FxRates.keySet()) {
            
            for(ExchangeRateColumnMapping__mdt exchangeRateColumnMapping: exchangeRateMappingColumns)
            {
                if(key ==exchangeRateColumnMapping.SourceField__c){
                    exchangeRate.put(key+'__c',currencyExchangeRate.Rates.FxRates.get(key)) ;     
                }
            }
        }
        
        exchangeRate.ExchangeRateDate__c = date.today();
        exchangeRate.BaseCurrency__c=baseCurrency;
        
        List<ExchangeRates__c> exchangeRates = new List<ExchangeRates__c>();
        exchangeRates.add(exchangeRate);
        
        DAL_BaseObject.InsertDBObjects(exchangeRates) ;
        
        //Calculate currency rates for all Base Currency e.g. ZAR
        AggregateResult[]  allBaseCurrency= [SELECT BaseCurrency__c FROM CurrencyExchangeRate__c WHERE BaseCurrency__c <> 'USD' GROUP BY BaseCurrency__c];
        for(AggregateResult abc:allBaseCurrency)
        {
            
            baseCurrency = String.valueOf(abc.get('BaseCurrency__c'));
            if(exchangeRate.get(baseCurrency +'__c') != null)
            {
           		List<ExchangeRates__c> newExchangeRates = new List<ExchangeRates__c>();
	            Decimal newBaseValue =((Decimal)exchangeRate.get('USD__c') / (Decimal)exchangeRate.get(baseCurrency +'__c'));
	            
	            ExchangeRates__c newExchangeRate = new ExchangeRates__c();
	        
	            for (String key : currencyExchangeRate.Rates.FxRates.keySet()) {
	                
	                for(ExchangeRateColumnMapping__mdt exchangeRateColumnMapping: exchangeRateMappingColumns)
	                {
	                    if(key ==exchangeRateColumnMapping.SourceField__c){
	                        newExchangeRate.put(key+'__c',(newBaseValue * currencyExchangeRate.Rates.FxRates.get(key)).setScale(4)) ;     
	                    }
	                }
	            }
	            
	            newExchangeRate.ExchangeRateDate__c = date.today();
	            newExchangeRate.BaseCurrency__c=baseCurrency;    
	            newExchangeRates.add(newExchangeRate);
	            DAL_BaseObject.InsertDBObjects(newExchangeRates) ;
            }
        }
        
    }
    
 global void execute(SchedulableContext bc){
       ExchangeRateWebServiceCall.CallService();
   }        
        
}
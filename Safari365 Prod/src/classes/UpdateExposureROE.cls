public class UpdateExposureROE {
    
    
    public static void processRecords(Set<Id> quotationIds, Map<Id, String> quotationIdKeyClientCurrencyValue)
    {
        Map<Id, Exposure_ROE__c> quotationIdKeyExposureROEValue = DAL_ExposureRoe.getByQuotationId(quotationIds);
        
        List<ExchangeRates__c> latestExchangesRates = DAL_ExchangeRate.getCurrencyAllByBaseCurrency();
        Map<String , ExchangeRates__c> baseCurrencyKeyExchangeRateValue = new Map<String,ExchangeRates__c >();
        for(ExchangeRates__c exchangeRate :latestExchangesRates )
        {
            baseCurrencyKeyExchangeRateValue.put(exchangeRate.BaseCurrency__c,exchangeRate);
        }   
        
        Map<String, Decimal> baseCurrencyKeyMarkupValue= new Map<String, Decimal>();
        List<ExchangeRateColumnMapping__mdt> exchangeRateColumnMappings = DAL_ExchangeRate.getExchangeRateMapping();   
        for(ExchangeRateColumnMapping__mdt exchangeRateColumnMapping: exchangeRateColumnMappings)
        {
            baseCurrencyKeyMarkupValue.put(exchangeRateColumnMapping.Label,exchangeRateColumnMapping.Markup_Value__c);
        } 
        
        List<Exposure_ROE__c> processRecords = new List<Exposure_ROE__c>();
        for(Id a: quotationIds)
        {
            Exposure_ROE__c exposureRoe = null;
            if(! quotationIdKeyExposureROEValue.isEmpty() && quotationIdKeyExposureROEValue.get(a) != null)
            {
                exposureRoe = quotationIdKeyExposureROEValue.get(a);
            }
            else
            {
                exposureRoe = new Exposure_ROE__c(Quotation__c =a);
            }
            
            Decimal clientExchangeRateUSD;
            Decimal clientExchangeRateAUD;
            Decimal clientExchangeRateGBP;
            Decimal clientExchangeRateEUR;
            for(ExchangeRates__c exchangeRate:latestExchangesRates)
            {
                 if(exchangeRate.BaseCurrency__c =='USD')
                 {
                    for(ExchangeRateColumnMapping__mdt exRatColMap:exchangeRateColumnMappings)
                    {
                      if(exRatColMap.Label=='USD:USD')
                      {
                            clientExchangeRateUSD = exchangeRate.USD__c*((100+exRatColMap.Markup_Value__c)/100);
                      }
                      else if(exRatColMap.Label=='USD:AUD')
                      {
                        clientExchangeRateAUD = exchangeRate.AUD__c*((100+exRatColMap.Markup_Value__c)/100);
                      }
                      else if(exRatColMap.Label=='USD:GBP')
                      {
                        clientExchangeRateGBP = exchangeRate.GBP__c*((100+exRatColMap.Markup_Value__c)/100);
                      }
                      else if(exRatColMap.Label=='USD:EUR')
                      {
                        clientExchangeRateEUR = exchangeRate.EUR__c*((100+exRatColMap.Markup_Value__c)/100);
                      }
                    }
                    
                    exposureRoe.CC_ROE_for_USD_to_USD__c = clientExchangeRateUSD;
                    exposureRoe.CC_ROE_for_USD_in_AUD__c = clientExchangeRateAUD;
                    exposureRoe.CC_ROE_for_USD_in_GPB__c = clientExchangeRateGBP;
                    exposureRoe.CC_ROE_for_USD_in_EUR__c = clientExchangeRateEUR;
                    
                 }
                
                 if(exchangeRate.BaseCurrency__c =='EUR')
                     {
                        for(ExchangeRateColumnMapping__mdt exRatColMap:exchangeRateColumnMappings)
                        {
                          if(exRatColMap.Label=='EUR:USD')
                          {
                                clientExchangeRateUSD = exchangeRate.USD__c*((100+exRatColMap.Markup_Value__c)/100);
                          }
                          else if(exRatColMap.Label=='EUR:AUD')
                          {
                            clientExchangeRateAUD = exchangeRate.AUD__c*((100+exRatColMap.Markup_Value__c)/100);
                          }
                          else if(exRatColMap.Label=='EUR:GBP')
                          {
                            clientExchangeRateGBP = exchangeRate.GBP__c*((100+exRatColMap.Markup_Value__c)/100);
                          }
                          else if(exRatColMap.Label=='EUR:EUR')
                          {
                            clientExchangeRateEUR = exchangeRate.EUR__c*((100+exRatColMap.Markup_Value__c)/100);
                          }
                        }
                        exposureRoe.CC_ROE_for_EUR_in_USD__c = clientExchangeRateUSD;
                        exposureRoe.CC_ROE_for_EUR_in_AUD__c = clientExchangeRateAUD;
                        exposureRoe.CC_ROE_for_EUR_in_GPB__c = clientExchangeRateGBP;
                        exposureRoe.CC_ROE_for_EUR_in_EUR__c = clientExchangeRateEUR;
                        
                     }
                 
                  if(exchangeRate.BaseCurrency__c =='ZAR')
                 {
                     for(ExchangeRateColumnMapping__mdt exRatColMap:exchangeRateColumnMappings)
                    {
                      if(exRatColMap.Label=='ZAR:USD')
                      {
                         clientExchangeRateUSD = exchangeRate.USD__c*((100+exRatColMap.Markup_Value__c)/100);
                      }
                      else if(exRatColMap.Label=='ZAR:AUD')
                      {
                        clientExchangeRateAUD = exchangeRate.AUD__c*((100+exRatColMap.Markup_Value__c)/100);
                      }
                      else if(exRatColMap.Label=='ZAR:GBP')
                      {
                        clientExchangeRateGBP = exchangeRate.GBP__c*((100+exRatColMap.Markup_Value__c)/100);
                      }
                      else if(exRatColMap.Label=='ZAR:EUR')
                      {
                        clientExchangeRateEUR = exchangeRate.EUR__c*((100+exRatColMap.Markup_Value__c)/100);
                      }
                    }

                    exposureRoe.CC_ROE_for_ZAR_to_USD__c = clientExchangeRateUSD;
                    exposureRoe.CC_ROE_for_ZAR_to_AUD__c = clientExchangeRateAUD;
                    exposureRoe.CC_ROE_for_ZAR_to_GPB__c = clientExchangeRateGBP;
                    exposureRoe.CC_ROE_for_ZAR_to_EUR__c = clientExchangeRateEUR;
                    
                 }
	           }  
              processRecords.add(exposureRoe);
        }
        
        if(!processRecords.isEmpty())
		{		
        	BaseTriggerHandler.bypass('TH_Quotations');
        	upsert processRecords;
        	BaseTriggerHandler.clearBypass('TH_Quotations');
		}
              
    }
}
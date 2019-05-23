global with sharing class QuotationCCROEFieldsUpdateController{
    
    webservice static String updateAllCCROIFieldsClassic(String quotationId)
    {
      String response = updateAllCCROIFields(quotationId);
      return response;
    }
    
     @AuraEnabled
    public static String updateManuallyCCROIFields(String quotationId)
    {
        String response='success';
        List<Quotations__c> quotations= DAL_Quotations.getAllQuotationsById(quotationId);
        Quotations__c quotation = quotations[0];
        updateROE(quotation);
        BaseTriggerHandler.bypass('TH_Quotations');
        quotation.Update_CC_ROE_Fields_Date__c = system.today();
        update quotation;
        BaseTriggerHandler.clearBypass('TH_Quotations');
        
        return response;
    }

    @AuraEnabled
    public static String updateAllCCROIFields(String quotationId)
    {
        String response='success';
        List<Quotations__c> quotations= DAL_Quotations.getAllQuotationsById(quotationId);
        
        Quotations__c quotation = quotations[0];
        
        Boolean flag = false;
        if(quotation.Client_Fund_Recieved__c == true 
            || quotation.Valid_Until__c >= system.today())
        {
            flag  = true;
            response ='success';
            return response;
        }
        else if(!flag 
                && quotation.Exchange_Values_Override_By_Finance__c == true)
        {
            flag  = true;
            system.debug('condition3>'+quotation.Exchange_Values_Override_By_Finance__c);
            response ='Itinerary Document not created as FX Rate Refresh has been disabled. If needed, please contact FX manager to create';
            return response;
        }
        else if(!flag
                 && quotation.Quote_Exposure__c > 0
                 && quotation.Valid_Until__c < system.today() 
                 && Integer.valueof(Label.Maximum_Quote_Exposure_Days) > ((system.today()).daysBetween(quotation.LastModifiedDate.date()))
                 )
        {
            flag  = true;
            quotation.Valid_Until__c = system.today().addDays(Integer.valueof(Label.Valid_Until_Days));
            BaseTriggerHandler.bypass('TH_Quotations');
            update quotation;
            BaseTriggerHandler.clearBypass('TH_Quotations');
            response ='success';
            return response;
            
        }
        
        else if(!flag)
        {
            
            try{
                updateROE(quotation);
                BaseTriggerHandler.bypass('TH_Quotations');
                quotation.Valid_Until__c = system.today().addDays(Integer.valueof(Label.Valid_Until_Days));
                update quotation;
                BaseTriggerHandler.clearBypass('TH_Quotations');
                response ='success';
            }catch(Exception e){
                
                response = e.getMessage();
            }
        }
        else
        {
            response ='FailureFXRateLocked';
        }
        return response;
    }
    
    
    private  static void updateROE(Quotations__c quotation)
    {
        List<ExchangeRateColumnMapping__mdt> exchangeRateColumnMapping = DAL_ExchangeRate.getExchangeRateMapping();                                 
        List<ExchangeRates__c> exchangeRates= DAL_ExchangeRate.getCurrencyAllByBaseCurrency();
            
            if(exchangeRateColumnMapping != null
                 && exchangeRates.size()>0)
            {
                Decimal clientExchangeRateUSD;
                Decimal clientExchangeRateAUD;
                Decimal clientExchangeRateGBP;
                Decimal clientExchangeRateEUR;
                 for(ExchangeRates__c exchangeRate:exchangeRates)
                 {
                     if(exchangeRate.BaseCurrency__c =='USD')
                     {
                        for(ExchangeRateColumnMapping__mdt exRatColMap:exchangeRateColumnMapping)
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
                        
                        quotation.CC_ROE_for_USD_in_USD__c = clientExchangeRateUSD;
                        quotation.CC_ROE_for_USD_in_AUD__c = clientExchangeRateAUD;
                        quotation.CC_ROE_for_USD_in_GPB__c = clientExchangeRateGBP;
                        quotation.CC_ROE_for_USD_in_EUR__c = clientExchangeRateEUR;
                        
                     }
                     
                     if(exchangeRate.BaseCurrency__c =='EUR')
                     {
                        for(ExchangeRateColumnMapping__mdt exRatColMap:exchangeRateColumnMapping)
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
                        quotation.CC_ROE_for_EUR_in_USD__c = clientExchangeRateUSD;
                        quotation.CC_ROE_for_EUR_in_AUD__c = clientExchangeRateAUD;
                        quotation.CC_ROE_for_EUR_in_GPB__c = clientExchangeRateGBP;
                        quotation.CC_ROE_for_EUR_in_EUR__c = clientExchangeRateEUR;
                        
                     }
                     
                     if(exchangeRate.BaseCurrency__c =='ZAR')
                     {
                         for(ExchangeRateColumnMapping__mdt exRatColMap:exchangeRateColumnMapping)
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
    
                        quotation.CC_ROE_for_ZAR_in_USD__c = clientExchangeRateUSD;
                        quotation.CC_ROE_for_ZAR_in_AUD__c = clientExchangeRateAUD;
                        quotation.CC_ROE_for_ZAR_in_GPB__c = clientExchangeRateGBP;
                        quotation.CC_ROE_for_ZAR_in_EUR__c = clientExchangeRateEUR;
                     }
                 }  
            }
    }
    
    @AuraEnabled
    public static String createOrNotQuotationItineraryDocOnGDLtng(String quotationId)
    {
        return QuotationItineraryDocOnGD.createOrNotQuotationItineraryDocOnGDLtng(quotationId);
    }
}
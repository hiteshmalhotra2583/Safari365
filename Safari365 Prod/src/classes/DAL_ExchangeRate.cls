public class DAL_ExchangeRate {
   
    public static final String OBJECT_NAME = ExchangeRates__c.SObjectType.getDescribe().getLocalName();
    
    public static List<ExchangeRates__c> getCurrencyByBaseCurrency(String baseCurrency)
    {
      return [SELECT        
                     AED__c,
                     ANG__c,
                     ARS__c,
                     AUD__c,
                     BaseCurrency__c,
                     BRL__c,
                     CAD__c,
                     CHF__c,
                     CLP__c,
                     CNY__c,
                     DKK__c,
                     EUR__c,
                     ExchangeRateDate__c,
                     GBP__c,
                     HKD__c,
                     Id,
                     ILS__c,
                     MYR__c,
                     Name,
                     NZD__c,
                     PEN__c,
                     RUB__c,
                     SEK__c,
                     SGD__c,
                     USD__c,
                     ZAR__c,
                     BRL_Credit_Card_Markup__c
                FROM
                     ExchangeRates__c
                WHERE 
                     BaseCurrency__c =:baseCurrency
             ORDER by CreatedDate DESC limit 1];

    }
    
    public static List<ExchangeRates__c> getCurrencyAllByBaseCurrency()
    {
      return [SELECT        
                     AED__c,
                     ANG__c,
                     ARS__c,
                     AUD__c,
                     BaseCurrency__c,
                     BRL__c,
                     CAD__c,
                     CHF__c,
                     CLP__c,
                     CNY__c,
                     DKK__c,
                     EUR__c,
                     ExchangeRateDate__c,
                     GBP__c,
                     HKD__c,
                     Id,
                     ILS__c,
                     MYR__c,
                     Name,
                     NZD__c,
                     PEN__c,
                     RUB__c,
                     SEK__c,
                     SGD__c,
                     USD__c,
                     ZAR__c 
                FROM
                     ExchangeRates__c
                  WHERE 
                    BaseCurrency__c IN ('USD','EUR','ZAR') 
             ORDER by CreatedDate DESC limit 3];

    }
 
    public static  List<ExchangeRateColumnMapping__mdt> getExchangeRateMapping()
    {
         return [SELECT 
                        Id,
                        Label,
                        Markup_Value__c,
                        Base_Currency__c 
                    FROM
                         ExchangeRateColumnMapping__mdt ];
    }
}
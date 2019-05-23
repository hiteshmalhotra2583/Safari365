@RestResource(urlMapping='/Safari365/MembersClub/GetLatestExchangeRate/*')

global with sharing class WS_GetLatestExchangeRate {
    private static final String SUCCESS = 'Success';
    private static final String ERROR = 'Error';
    private static final String BLANK_STRING = '';
    
    @HttpGet
    global static ResponseWrapper doGet()
    {
        ResponseWrapper returnResponse = new ResponseWrapper();
        List<ExchangeRates__c> exchangeRates = DAL_ExchangeRate.getCurrencyByBaseCurrency('USD');
        if(!exchangeRates.isEmpty()){
            returnResponse.status  = SUCCESS;
            returnResponse.exchangeRates = exchangeRates[0] ;
        }
        else {
            returnResponse.status  = Error;
            returnResponse.errorMessage ='Exchange rate not Found';
        }
     
       return returnResponse;
    }
    
    global class ResponseWrapper
    {
        webservice String status;
        webservice String errorMessage;
        webservice sObject exchangeRates;
    }
            
}
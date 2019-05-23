@RestResource(urlMapping='/Safari365/MembersClub/GetQuotation/*')

global with sharing class WS_GetQuotation {
    private static final String SUCCESS = 'Success';
    private static final String ERROR = 'Error';
    private static final String BLANK_STRING = '';
    
    @Httppost
    global static ResponseWrapper doPost(RequestWrapper requestWrapper)
    {
        ResponseWrapper returnResponse = new ResponseWrapper();
        List<Quotations__c> quotation = DAL_Quotations.getQuotations_DynamiCSOQL(new List<String>{requestWrapper.QuotationId});
        returnResponse.requestWrapper = requestWrapper;
        if(!quotation.isEmpty()){
            returnResponse.status  = SUCCESS;
            returnResponse.quotation = quotation[0] ;
        }
        else {
            returnResponse.status  = Error;
            returnResponse.errorMessage ='Quotation not Found';
        }
     
       return returnResponse;
    }
    
    global class ResponseWrapper
    {
        webservice String status;
        webservice String errorMessage;
        webservice sObject Quotation;
        webservice RequestWrapper requestWrapper;
    }
        
    global class RequestWrapper
    {
        webservice String QuotationId;
        
        public RequestWrapper(String QuotationId) {
            this.QuotationId= QuotationId;
        }
    }   
            
}

/********** Request ************

{
"requestWrapper":{
"QuotationId" : "a0m0E00000171ex"
}
}

*******************************/
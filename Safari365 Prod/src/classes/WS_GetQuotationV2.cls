@RestResource(urlMapping='/Safari365/MembersClub/GetQuotationV2/*')
global with sharing class WS_GetQuotationV2 {
    private static final String SUCCESS = 'Success';
    private static final String ERROR = 'Error';
    private static final String BLANK_STRING = '';
    
    @Httppost
    global static ResponseWrapper doPost(RequestWrapper requestWrapper)
    {
        ResponseWrapper returnResponse = new ResponseWrapper();
        List<Quotations__c> quotation = DAL_Quotations.getQuotations_DynamiCSOQLV2(new List<String>{requestWrapper.OpportunityId});
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
        webservice String OpportunityId;
        
        public RequestWrapper(String OpportunityId) {
            this.OpportunityId= OpportunityId;
        }
    }   
            
}

/********** Request ************

{
"requestWrapper":{
"OpportunityId" : "0060E000008XrVa"
}
}

*******************************/
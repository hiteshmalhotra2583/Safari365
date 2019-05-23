@RestResource(urlMapping='/Safari365/MembersClub/GetQuotations/*')
global with sharing class WS_GetQuotations {
    private static final String SUCCESS = 'Success';
    private static final String ERROR = 'Error';
    private static final String BLANK_STRING = '';
    
    @Httppost
    global static ResponseWrapper doPost(RequestWrapper requestWrapper)
    {
        ResponseWrapper returnResponse = new ResponseWrapper();
        List<Quotations__c> quotation = DAL_Quotations.getQuotationsFromOppId_DynamiCSOQL(requestWrapper.OpportunityIds);
        returnResponse.requestWrapper = requestWrapper;
        if(quotation != null && !quotation.isEmpty()){
            returnResponse.status  = SUCCESS;
            returnResponse.quotation = quotation ;
        }     
        else {
            returnResponse.status  = Error;
            returnResponse.errorMessage ='Quotations not Found';
        }
       return returnResponse;
    }
    
    global class ResponseWrapper
    {
        webservice String status;
        webservice String errorMessage;
        webservice List<sObject> Quotation;
        webservice RequestWrapper requestWrapper;
    }
        
    global class RequestWrapper
    {
        webservice List<String> OpportunityIds;
        
    }   
            
}

/********** Request ************


{
"requestWrapper":{
"OpportunityIds" : ["0060E000007oSVR"]
}
}

*******************************/
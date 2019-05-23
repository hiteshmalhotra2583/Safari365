@RestResource(urlMapping='/Safari365/MembersClub/UpdateQuotation/*')
global with sharing class WS_UpdateQuotation
{
    private static final String SUCCESS = 'Success';
    private static final String ERROR = 'Error';
    private static final String BLANK_STRING = '';
    
    @Httppost
    global static ResponseWrapper doPost(RequestWrapper requestWrapper)
    {
        ResponseWrapper returnResponse = new ResponseWrapper();
        returnResponse.requestWrapper = requestWrapper;
        if(requestWrapper.quotation != null){
            try{
                Quotations__c quoteObj = new Quotations__c(Id=requestWrapper.quotation.QuotationId);
                if(requestWrapper.quotation.Status != null && requestWrapper.quotation.Status != '')
                {
                    quoteObj.Quotation_Stage__c = requestWrapper.quotation.Status;
                }
                if(requestWrapper.quotation.Client_Has_Requested_Confirmation != null)
                {
                    quoteObj.Client_Has_Requested_Confirmation__c = requestWrapper.quotation.Client_Has_Requested_Confirmation;
                    quoteObj.Date_Client_Requested_Confirmation__c = system.today();
                }
                if(requestWrapper.quotation.Client_Has_Requested_Requote != null )
                {
                    quoteObj.Client_Has_Requested_Requote__c = requestWrapper.quotation.Client_Has_Requested_Requote;
                }
                update quoteObj;   
                returnResponse.status  = SUCCESS;         
            }catch(Exception ex){
                System.debug('-----Error--- '+ ex);
                returnResponse.status  = Error;
                returnResponse.errorMessage = ex.getMessage();
            }
        }
        else {
            returnResponse.status  = Error;
            returnResponse.errorMessage ='Quotation not found in request message';
        }
     
       return returnResponse;
    }
    
    global class ResponseWrapper {
    
        webservice String status;
        webservice String errorMessage;
        webservice RequestWrapper requestWrapper;
        
    }
        
    global class RequestWrapper {
        
        webservice Quotation quotation;
        
    }  
    
    global class Quotation {
    
        webservice String QuotationId;
        webservice boolean Client_Has_Requested_Confirmation;
        webservice boolean Client_Has_Requested_Requote;
        webservice String Status;
    
    } 
            
}


/*****************************

{ 
"requestWrapper":{ 
"quotation" : {
"QuotationId":"a0m0E0000015OyO",
"Client_Has_Requested_Confirmation":"true",
"Client_Has_Requested_Requote":"true",
"Status":"Confirmed"
} 
} 
}


******************************/
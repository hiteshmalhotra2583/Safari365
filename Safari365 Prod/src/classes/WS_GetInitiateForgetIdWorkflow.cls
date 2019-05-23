@RestResource(urlMapping='/Safari365/MembersClub/GetInitiateForgetIdWorkflow/*')
global  with sharing class WS_GetInitiateForgetIdWorkflow
{
    private static final String SUCCESS = 'Success';
    private static final String ERROR = 'Error';
    private static final String BLANK_STRING = '';
    
    @Httppost
    global static ResponseWrapper doPost(RequestWrapper requestWrapper)
    {
        ResponseWrapper returnResponse = new ResponseWrapper();
        try{
            returnResponse.requestWrapper = requestWrapper;
            Account account = DAL_Account.getAccountByEmailId(requestWrapper.EmailId);                  
            if(account != null){
                account.Initiate_Forget_Id_Workflow__c = true;          
                returnResponse.status  = SUCCESS;
                update account;
            }
            else {
                returnResponse.status  = Error;
                returnResponse.errorMessage ='Account not found with this EmailId';
            }
        }catch(Exception ex){
            returnResponse.status  = Error;
            returnResponse.errorMessage ='Account not found with this EmailId';
        }
     
       return returnResponse;
    }
    
    global class ResponseWrapper {
        webservice String status;
        webservice String errorMessage;
        webservice RequestWrapper requestWrapper;
    }
        
    global class RequestWrapper {
        webservice String EmailId;
    }   
    
        
}

/******************

{
"requestWrapper":{
"EmailId" : "kj@ghmail.com"
}
}


***************/
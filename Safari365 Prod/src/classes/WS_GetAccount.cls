@RestResource(urlMapping='/Safari365/MembersClub/GetAccount/*')
global with sharing class WS_GetAccount
{
    private static final String SUCCESS = 'Success';
    private static final String ERROR = 'Error';
    private static final String BLANK_STRING = '';
    
    @Httppost
    global static ResponseWrapper doPost(RequestWrapper requestWrapper)
    {
        ResponseWrapper returnResponse = new ResponseWrapper();
        Account account  = DAL_Account.getAccount_DynamiCSOQL(requestWrapper.OpportunityId);
        returnResponse.requestWrapper = requestWrapper;
        if(account != null){
            returnResponse.status  = SUCCESS;
            returnResponse.account = account;
        }
        else {
            returnResponse.status  = Error;
            returnResponse.errorMessage ='Account not Found';
        }
     
       return returnResponse;
    }
    
    global class ResponseWrapper
    {
        webservice String status;
        webservice String errorMessage;
        webservice sObject account;
        webservice String  profileURL;
        webservice String UserProfileIntro;
        webservice RequestWrapper requestWrapper;
    }
        
    global class RequestWrapper
    {
        webservice String OpportunityId;
        
        public RequestWrapper(String OpportunityId) {
            this.OpportunityId = OpportunityId;
        }
    }   
            
}

/* 
/services/apexrest/Safari365/MembersClub/GetAccount/*

Request ---
{
"requestWrapper":{
"OpportunityId" : "00QD000000o5qkkMAA"
}
}

Response--

{
  "status" : "Success",
  "requestWrapper" : {
    "OpportunityId" : "00QD000000o5qkkMAA"
  },
  "errorMessage" : null,
  "account" : {
    "attributes" : {
      "type" : "Account",
      "url" : "/services/data/v42.0/sobjects/Account/001D000001XTyhqIAD"
    },
    "Name" : "MB TEST",
    "Id" : "001D000001XTyhqIAD",
    "Members_Club_ID__c" : "00QD000000o5qkkMAA"
  }
}
*/
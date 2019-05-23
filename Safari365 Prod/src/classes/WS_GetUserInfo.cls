@RestResource(urlMapping='/Safari365/MembersClub/GetUserInfo/*')
global with sharing class WS_GetUserInfo
{
    private static final String SUCCESS = 'Success';
    private static final String ERROR = 'Error';
    private static final String BLANK_STRING = '';
    
    @Httppost
    global static ResponseWrapper doPost(RequestWrapper requestWrapper)
    {
        ResponseWrapper returnResponse = new ResponseWrapper();
        Opportunity opp  = DAL_Opportunity.getOpportunityById(requestWrapper.OpportunityId);
        User user  = DAL_USER.getbyOwnerId(opp.OwnerId);
        returnResponse.requestWrapper = requestWrapper;
        if(user != null){
            returnResponse.status  = SUCCESS;
            returnResponse.profileURL = user.ProfileImageUrl__c;
            returnResponse.userProfileIntro=user.User_Profile_Intro__c;
            returnResponse.ProfileImageUrl=user.ProfileImageUrl__c;
            returnResponse.Name = user.Name;
            returnResponse.Email = user.Email;
            returnResponse.Extension=user.Extension;
            returnResponse.Phone = user.Phone;
            returnResponse.MobilePhone=user.MobilePhone;
            
        }
        else {
            returnResponse.status  = Error;
            returnResponse.errorMessage ='User not Found';
        }
     
       return returnResponse;
    }
    
    global class ResponseWrapper
    {
        webservice String status;
        webservice String errorMessage;
        webservice String  profileURL;
        webservice String userProfileIntro;
        webservice String ProfileImageUrl;
        webservice String Name;
        webservice String Email;
        webservice String Extension;
        webservice String Phone;
        webservice String MobilePhone;
       
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
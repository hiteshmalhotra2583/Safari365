@RestResource(urlMapping='/Safari365/MembersClub/GetUpdateReviewOpportunity/*')
global  with sharing class WS_GetUpdateReviewOpportunity
{
    private static final String SUCCESS = 'Success';
    private static final String ERROR = 'Error';
    private static final String BLANK_STRING = '';
    
    @Httppost
    global static ResponseWrapper doPost(RequestWrapper requestWrapper)
    {
        ResponseWrapper returnResponse = new ResponseWrapper();
        returnResponse.requestWrapper = requestWrapper;
        
        try{
            if(requestWrapper.OpportunityInfo != null
            	 && requestWrapper.OpportunityInfo.OpportunityId != null 
            	 && requestWrapper.OpportunityInfo.OpportunityId != '')
             {
                Opportunity opportunity = new Opportunity(Id = requestWrapper.OpportunityInfo.OpportunityId);
                //opportunity.Star_Rating__c = requestWrapper.OpportunityInfo.StarRating;
                //opportunity.Overall_Impressions__c = requestWrapper.OpportunityInfo.OverallImpressions;
                //opportunity.Improvements__c = requestWrapper.OpportunityInfo.Improvements;
                
                opportunity.Review_Stage__c = requestWrapper.OpportunityInfo.ReviewStage;
				opportunity.Overall_client_safari_experience__c= requestWrapper.OpportunityInfo.Overallclientsafariexperience;
				opportunity.How_can_Safari365_improve__c= requestWrapper.OpportunityInfo.HowcanSafari365improve;
				opportunity.Rating_1__c= requestWrapper.OpportunityInfo.Rating1;
				opportunity.Rating_2__c= requestWrapper.OpportunityInfo.Rating2;
				opportunity.Rating_3__c= requestWrapper.OpportunityInfo.Rating3;
				opportunity.Rating_4__c= requestWrapper.OpportunityInfo.Rating4;
				opportunity.Rating_5__c= requestWrapper.OpportunityInfo.Rating5;

                update opportunity;
                returnResponse.status  = SUCCESS;
            }
            else {
                returnResponse.status  = Error;
                returnResponse.errorMessage ='Opportunity Not found';
            }
        }catch(Exception ex){
            returnResponse.status  = Error;
            returnResponse.errorMessage = ex.getMessage();
        }
     
       return returnResponse;
    }
    
    global class ResponseWrapper {
        webservice String status;
        webservice String errorMessage;        
        webservice RequestWrapper requestWrapper;
    }
        
    global class RequestWrapper {
        
        webservice OpportunityInfoWrapper OpportunityInfo;
        
        public RequestWrapper(OpportunityInfoWrapper oppWrap) {
            this.OpportunityInfo = oppWrap;
        }
    }   
    
    global class OpportunityInfoWrapper
     {
        webservice String OpportunityId;
        webservice String ReviewStage;
        webservice String Overallclientsafariexperience;
        webservice String HowcanSafari365improve;
	    webservice Boolean Rating1;
	    webservice Boolean Rating2;
	    webservice Boolean Rating3;
	    webservice Boolean Rating4;
	    webservice Boolean Rating5;
    }       
        
}
/********************************************************

{
    "requestWrapper": {
        "OpportunityInfo":{
            "OpportunityId":"0060E000007jk8A",
            "StarRating":"4",
            "OverallImpressions":"Test OverallImpressions",
            "Improvements": "Test Improvements"
        }   
    }

}


***********************************************************/
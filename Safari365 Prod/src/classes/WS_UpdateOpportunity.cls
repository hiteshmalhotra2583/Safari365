@RestResource(urlMapping='/Safari365/MembersClub/UpdateClientCurencyOpportunity/*')
global  with sharing class WS_UpdateOpportunity
{
    private static final String SUCCESS = 'Success';
    private static final String ERROR = 'Error';
    private static final String BLANK_STRING = '';
    static final Set<String> validCurrencyType = new Set<String>{'USD','EUR','AUD','GBP'};
    
    @Httppost
    global static ResponseWrapper doPost(RequestWrapper requestWrapper)
    {
        ResponseWrapper returnResponse = new ResponseWrapper();
        returnResponse.requestWrapper = requestWrapper;
        
        try{
            if(requestWrapper.OpportunityInfo != null 
               && requestWrapper.OpportunityInfo.OpportunityId != null
             && requestWrapper.OpportunityInfo.OpportunityId != '' 
             && checkValidCurrType(requestWrapper.OpportunityInfo.CurrencyType)){
                Opportunity opportunity = new Opportunity(Id = requestWrapper.OpportunityInfo.OpportunityId);
                opportunity.Client_Display_Currency__c = requestWrapper.OpportunityInfo.CurrencyType;
               
                BaseTriggerHandler.byPass('OpportunityTriggerHandler');
                	update opportunity;
                BaseTriggerHandler.clearBypass('OpportunityTriggerHandler');
                returnResponse.status  = SUCCESS;
            }
            else {
                returnResponse.status  = Error;
                returnResponse.errorMessage ='Opportunity Not found or Currency Type does not match';
            }
        }catch(Exception ex){
            returnResponse.status  = Error;
            returnResponse.errorMessage = ex.getMessage();
        }
     
       return returnResponse;
    }
    
    private static boolean checkValidCurrType(String currencyType)
    {
    	 boolean flag;
    	 if(validCurrencyType.contains(currencyType))
    	 {
    	 	flag =true;
    	 }
    	 return flag;
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
    
    global class OpportunityInfoWrapper {
        webservice String OpportunityId;
        webservice String CurrencyType;
    }       
        
}
/********************************************************

{
    "requestWrapper": {
        "OpportunityInfo":{
            "OpportunityId":"0060E000007jk8A",
            "CurrencyType":"USD"
        }   
    }

}


***********************************************************/
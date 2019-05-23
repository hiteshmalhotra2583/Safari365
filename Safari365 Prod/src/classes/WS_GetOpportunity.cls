@RestResource(urlMapping='/Safari365/MembersClub/GetOpportunity/*')
global  with sharing class WS_GetOpportunity
{
    private static final String SUCCESS = 'Success';
    private static final String ERROR = 'Error';
    private static final String BLANK_STRING = '';
    
    @Httppost
    global static ResponseWrapper doPost(RequestWrapper requestWrapper)
    {
        ResponseWrapper returnResponse = new ResponseWrapper();
        List<Opportunity> lst_ActiveOpportunity  = DAL_Opportunity.getActiveOpportunity(requestWrapper.OpportunityId);

        returnResponse.requestWrapper = requestWrapper;
        
        if(! lst_ActiveOpportunity.isEmpty()){
            for(Opportunity var: lst_ActiveOpportunity){
                returnResponse.OpportunityInfo = new OpportunityInfoWrapper(var.Name, var.Id, 
                                            var.Owner.Name, var.Owner.Email, var.Owner.Phone,
                                            var.Client_Display_Currency__c, var.Client_Currency_Locked__c);
                break;
            }           
            returnResponse.status  = SUCCESS;
        }
        else {
            returnResponse.status  = Error;
            returnResponse.errorMessage ='No Active Opportunity Related to this Opportunity Id';
        }
     
       return returnResponse;
    }
    
    global class ResponseWrapper
    {
        webservice String status;
        webservice String errorMessage;
        webservice OpportunityInfoWrapper OpportunityInfo;
        webservice RequestWrapper requestWrapper;
    }
        
    global class RequestWrapper {
        webservice String OpportunityId;
        
        public RequestWrapper(String OpportunityId) {
            this.OpportunityId = OpportunityId;
        }
    }   
    
    global class OpportunityInfoWrapper {
        webservice String OpportunityName;
        webservice String OpportunityId;
        webservice String ConsultantName;
        webservice String ConsultantEmail;
        webservice String ConsultantPhoneNumber;
        webservice String ClientCurrency;
        webservice Boolean ClientClientCurrencyLocked;
        
        public OpportunityInfoWrapper(String OppName, String OppId, 
                                      String conName, String conEmail,
                                      String conPhoneNumber, String clientCurrency,
                                      Boolean clientCurrencyLocked)
        {
            this.OpportunityName = OppName;
            this.OpportunityId = OppId;
            this.ConsultantName = conName;
            this.ConsultantEmail = conEmail;
            this.ConsultantPhoneNumber = conPhoneNumber;
            this.ClientCurrency = clientCurrency;
            this.ClientClientCurrencyLocked = clientCurrencyLocked;
            
        }
    }       
        
}

/******************

{
"requestWrapper":{
"AccountId" : "001D0000021eNac"
}
}


***************/
@RestResource(urlMapping='/Safari365/MembersClub/GetPassenger/*')
global  with sharing class WS_GetPassenger
{
   private static final String SUCCESS = 'Success';
  private static final String ERROR = 'Error';
  private static final String BLANK_STRING = '';
  
    @Httppost
    global static ResponseWrapper doPost(RequestWrapper requestWrapper)
    {
        ResponseWrapper returnResponse = new ResponseWrapper();
        Passenger__c passenger  = DAL_Passenger.getPasenger_DynamiCSOQL(requestWrapper.PassengerId);
        if(null !=passenger)
        {
	        passenger.FirstName__c = '';
	        passenger.Last_Name__c='';
        }
        system.debug('passenger:::'+passenger);
        returnResponse.requestWrapper = requestWrapper;
        if(passenger != null){
            returnResponse.status  = SUCCESS;
            returnResponse.Passenger = passenger;
        }
        else {
            returnResponse.status  = Error;
            returnResponse.errorMessage ='Passenger not Found';
        }
     
       return returnResponse;
    }
    
    global class ResponseWrapper
    {
        webservice String status;
        webservice String errorMessage;
        webservice sObject Passenger;
        webservice RequestWrapper requestWrapper;
    }
        
    global class RequestWrapper
    {
        webservice String PassengerId;
        
        public RequestWrapper(String PassengerId) {
            this.PassengerId = PassengerId;
        }
    }   
            
}

/******************

{
"requestWrapper":{
"PassengerId" : ""
}
}


***************/
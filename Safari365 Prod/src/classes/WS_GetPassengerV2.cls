@RestResource(urlMapping='/Safari365/MembersClub/GetPassengerV2/*')
global  with sharing class WS_GetPassengerV2
{
   private static final String SUCCESS = 'Success';
  private static final String ERROR = 'Error';
  private static final String BLANK_STRING = '';
  
    @Httppost
    global static ResponseWrapper doPost(RequestWrapper requestWrapper)
    {
        system.debug('requestWrapper:::'+requestWrapper);
        ResponseWrapper returnResponse = new ResponseWrapper();
        List<Passenger__c> passengers  = DAL_Passenger.getPasengers_DynamiCSOQL(requestWrapper.PassengerIds);
        system.debug('passengers:::'+passengers);
        /*for(Passenger__c p: passengers)
        {
	        p.FirstName__c = '';
	        p.Last_Name__c='';
        }*/
        returnResponse.requestWrapper = requestWrapper;
        if(! passengers.isEmpty()){
            returnResponse.status  = SUCCESS;
            returnResponse.Passengers = passengers;
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
        webservice List<sObject> Passengers;
        webservice RequestWrapper requestWrapper;
    }
        
    global class RequestWrapper
    {
        webservice List<String> PassengerIds;
        
        public RequestWrapper(List<String> PassengerIds) {
            this.PassengerIds = PassengerIds;
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
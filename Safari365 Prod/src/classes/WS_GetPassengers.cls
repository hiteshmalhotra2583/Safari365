@RestResource(urlMapping='/Safari365/MembersClub/GetPassengersFromQuotationId/*')
global  with sharing class WS_GetPassengers
{
    private static final String SUCCESS = 'Success';
	private static final String ERROR = 'Error';
	private static final String BLANK_STRING = '';
	static Set<String> propertyIds = new Set<String>();
	
	@Httppost
	global static ResponseWrapper doPost(RequestWrapper requestWrapper)
	{
		ResponseWrapper returnResponse = new ResponseWrapper();
	    List<PassengerInfoWrapper> passengers  = DAL_Passenger.getPassengersDetailsByQuotationId(getQuoteIds(requestWrapper));
	    if(! passengers.isEmpty())
	    {
	    returnResponse.passengerInfoWrapper = passengers;
	    returnResponse.status  = SUCCESS;
	    
	    }
	    else
	    {
	    	returnResponse.status  = Error;
	    	returnResponse.errorMessage ='No Passenger are linkted to the Quote Id';
	    }
	     returnResponse.requestWrapper=requestWrapper; 
	 
	   return returnResponse;
	}

	public static List<Id> getQuoteIds(RequestWrapper requestWrapper)
	{
		List<Id> quoteIds  = new List<Id>();
		quoteIds.add(requestWrapper.QuotationId);
		
		return quoteIds;
	}
	
	global class ResponseWrapper
	{
		webservice String status;
		webservice String errorMessage;
		webservice List<PassengerInfoWrapper> passengerInfoWrapper;
		webservice RequestWrapper requestWrapper;
	}
		
	global class RequestWrapper
	{
		webservice String QuotationId;
	    
	    public RequestWrapper(String QuotationId) {
		this.QuotationId = QuotationId;
		}
	}	
	
	global class PassengerInfoWrapper
	{
		webservice String passengerType;
		webservice boolean isPrimary;
		webservice String name;
		webservice String status;
		webservice String passengerId;
		webservice boolean WaiverOfLiability;
	    
	    public PassengerInfoWrapper(String passengerType, boolean isPrimary,
	    							String name,String passengerId,String status,
	    							boolean WaiverOfLiability) {
		this.passengerType = passengerType;
		this.isPrimary = isPrimary;
		this.name = name;
		this.status = status;
		this.passengerId=passengerId;
        this.WaiverOfLiability = WaiverOfLiability;
		}
	}	
	
		
}

/******************

{
"requestWrapper":{
"QuotationId" : ""
}
}


***************/
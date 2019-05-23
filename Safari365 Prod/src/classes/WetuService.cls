global  class WetuService {

    static QuotationBuilderDatabaseQueries DbQueries= new QuotationBuilderDatabaseQueries();
    static  UTIL_LogGenerator logger = new UTIL_LogGenerator();
    
    @AuraEnabled
    public static String processRequestLtng(String quotationId){
        List<Id> ids = new List<Id>();
        ids.add(quotationId);
        List<Quotations__c> quotations=DAL_Quotations.getAllQuotations(ids);
        Quotations__c quotationsToProcess = quotations[0];
        String opportunityId=quotationsToProcess.Opportunity__r.Id;
        List<Opportunity> opportunities=DAL_Opportunity.getById(opportunityId);
        Opportunity opportunityToProcess = opportunities[0];
        Boolean errorFlag = false;
        String labelName = '';
        Boolean isTestRunning = false;
        string userId = userInfo.getUserId();
        List<User> users=[SELECT wetu_username__c,wetu_password__c,wetu_user_id__c FROM User WHERE Id=:userId];
        User userToProcess = users[0];
        if(quotationsToProcess.Do_not_include_Photobooks__c == false
        	&& quotationsToProcess.Include_Photobooks_USD__c == false
            && quotationsToProcess.Include_Photobooks_ZAR__c == false)
        {
            labelName = System.Label.Photobooks_not_included_for_wetu;
            errorFlag = true;  
        }
        
        if(quotationsToProcess.Include_Passenger_Insurance_USD__c == false
          && quotationsToProcess.Include_Passenger_Insurance_ZAR__c == false 
          && quotationsToProcess.Do_not_include_insurance__c == false
          && errorFlag== false)
        {
            labelName = System.Label.Passenger_Insurance_not_included_for_wetu; 
            errorFlag = true;  
        }
        
        if(quotationsToProcess.Itinerary_Summary__c != null
           && quotationsToProcess.Itinerary_Summary__c.length() < 150 
           && errorFlag == false)
        {
            labelName = System.Label.WetuQuotation_Intro_Note_to_Customer_Length; 
            errorFlag = true;  
        }
        
        try{
            if(errorFlag == false){
                WetuService.processRequest(quotationsToProcess.Id,userToProcess.Id,opportunityToProcess.Id,isTestRunning);
                labelName = 'successMsg';
                Quotations__c quotation = [SELECT Id,Wetu_Request_Fail__c FROM Quotations__c WHERE Id=:quotationId];
                if(quotation.Wetu_Request_Fail__c == true){
                    quotation.Wetu_Request_Fail__c = false;
                    update quotation;
                }
            }
        }
        catch(Exception e)
        {
            Quotations__c quotation = [SELECT Id,Wetu_Request_Fail__c FROM Quotations__c WHERE Id=:quotationId];
            quotation.Wetu_Request_Fail__c = true;
            update quotation;
        }
        return labelName;
    }
    
    
    webservice static void processRequest(String quotationId,String userId,String opportunityId, boolean isTestRunning)    
    {
        List<Quotations__c> quotations=DAL_Quotations.getQuotationForWetuById(quotationId);
        List<Opportunity> opportunities=DAL_Opportunity.getById(opportunityId);
        List<User> users=[SELECT wetu_username__c,wetu_password__c,wetu_user_id__c FROM User WHERE Id=:userId];
        
        Quotations__c quotationsToProcess = quotations[0];
        Opportunity opportunityToProcess = opportunities[0];
        User userToProcess = users[0];
        
        logger.start(WetuService.class.getName(),'WetuService');
        try
        {
            String request = createRequest(quotationsToProcess,opportunityToProcess,userToProcess);
            logger.log('request',request);
             // Instantiate a new http object
            //String  url = 'https://requestb.in/1mb5que1';
            //String  url ='https://requestb.in/1f1j4ic1';
            String  url ='https://wetu.com/Map/ItineraryServiceV7.asmx';
            Http h = new Http();
            
            // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
            HttpRequest req = new HttpRequest();
            
            req.setHeader('Host', 'wetu.com');
            req.setHeader('Content-Type', 'text/xml; charset=utf-8');
            req.setHeader('Content-Length', 'length');
            req.setHeader('SOAPAction', 'http://wetu.com/Map/ItineraryServiceV7/AuthenticateAndSaveItinerary');
            
            req.setEndpoint(url);
            req.setMethod('POST');
            //req.setBody(request);
            //String request1 = '<?xml version="1.0" encoding="UTF-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"> <soap:Body> <AuthenticateAndSaveItinerary xmlns="http://wetu.com/Map/ItineraryServiceV7"><itinerary><Type>Personal</Type><Days>4</Days><Name>Simple Itinerary</Name><Language>en</Language><Summary>&lt;p>A simple itinerary.&lt;/p></Summary><StartDate>2018-07-17T00:00:00Z</StartDate><Legs><ItineraryLeg xsi:type="ItineraryLegByDay"><ItineraryLegId>1</ItineraryLegId><Sequence>0</Sequence><ContentEntityId>3733</ContentEntityId><Nights>2</Nights><Type>Standard</Type><Days><ItineraryLegDay><Day>0</Day><RoomBasis>BedAndBreakfast</RoomBasis><DrinksBasis>None</DrinksBasis><Activities><ItineraryLegDayActivity><Sequence>1000</Sequence><Name>V&amp;A Waterfront</Name><IsHighlight>false</IsHighlight><Type>Included</Type><PreventVoucher>false</PreventVoucher><ContentEntityId>140</ContentEntityId><TimeSlot>None</TimeSlot></ItineraryLegDayActivity></Activities></ItineraryLegDay><ItineraryLegDay></ItineraryLegDay></Days></ItineraryLeg></Legs></itinerary><username>marcus@safari365.com</username><password>marcus365</password></AuthenticateAndSaveItinerary>  </soap:Body></soap:Envelope>';
            req.setBody(request);
            // Send the request, and return a response
            HttpResponse res = h.send(req);
            String response =  res.getBody();
            logger.log('response',response);
            ProcessResponse(quotationsToProcess, response,request);
            Quotations__c quotation = [SELECT Id,Wetu_Request_Fail__c FROM Quotations__c WHERE Id=:quotationId];
            if(quotation.Wetu_Request_Fail__c == true){
                quotation.Wetu_Request_Fail__c = false;
                update quotation;
            }
        }
        catch(Exception e)
        {
            logger.log('Wetu ProcessRequest',e.getMessage());
            Quotations__c quotation = [SELECT Id,Wetu_Request_Fail__c FROM Quotations__c WHERE Id=:quotationId];
            quotation.Wetu_Request_Fail__c = true;
            update quotation;
        }
        logger.end();
    }
        
    public static  String createRequest(Quotations__c quotationsToProcess,Opportunity opportunityToProcess,User userToProcess)
    {
        return WetuServiceHelper.createWetuXmlString(quotationsToProcess,opportunityToProcess,userToProcess);
    }
    
    public static void ProcessResponse(Quotations__c quotation, String Xmlresponse,String request)
    {
       WetuResponseHandler.ProcessResponse(Xmlresponse,request,quotation);
      
        System.debug('quotation.Wetu_Identifier__c>>'+quotation.Wetu_Identifier__c);
        System.debug('quotation.Wetu_Identifier_Key__c>>'+quotation.Wetu_Identifier_Key__c);
    }
}
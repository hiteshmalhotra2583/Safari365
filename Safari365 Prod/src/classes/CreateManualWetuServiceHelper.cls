public class CreateManualWetuServiceHelper{
static QuotationBuilderDatabaseQueries DbQueries= new QuotationBuilderDatabaseQueries();
    static  UTIL_LogGenerator logger = new UTIL_LogGenerator();
    
    public static String createWetuXmlString(Quotations__c quotationsToProcess,Opportunity opportunityToProcess,User userToProcess)
    {
        String wetuXMl = wetuHeader()+
                         +createOnlyOpeningTag('itinerary')+
                         +createTagWithValue('operator_id',String.valueof(quotationsToProcess.wetu_operator_id__c))+
                         +createTagWithValue('operator_user_id',String.valueof(userToProcess.wetu_user_id__c))+
                         +createTagWithValue('operator_identity_id',String.valueof(quotationsToProcess.operator_identity_id__c))+
                         +createTagWithValue('operator_theme_id',String.valueof(quotationsToProcess.wetu_operator_theme_id__c))+
                         +createTagWithValue('type',quotationsToProcess.wetu_type__c)+
                         +createTagWithValue('Days',String.valueof(quotationsToProcess.Total_Days__c))+
                         +createTagWithValue('Name',opportunityToProcess.Name+'-'+quotationsToProcess.Quotation_Name__c+'-'+quotationsToProcess.Name)+
                         +createTagWithValue('Language','')+
                         +createTagWithValue('reference_number',String.valueof(quotationsToProcess.Name))+
                         +createTagWithValue('Summary',quotationsToProcess.Itinerary_Summary__c)+
                         +createTagWithValue('description',quotationsToProcess.Quotation_Name__c)+
                         +createTagWithValue('client_name',opportunityToProcess.Client_Name__c)+
                         +createTagWithValue('StartDate',String.valueof(quotationsToProcess.TravelStartDate__c)+'T00:00:00Z')+
                         +createlegTag(quotationsToProcess)+
                         +createOnlyClosingTag('itinerary')+
                         +createTagWithValue('username',userToProcess.wetu_username__c)+
                         +createTagWithValue('password',userToProcess.wetu_password__c)+
                         +wetuFooter();
       system.debug('wetu manual service request::::'+wetuXMl);                  
       return  wetuXMl;               
    }
    
    public static String createlegTag(Quotations__c quotationsToProcess)
    {
        String legTag  = createOnlyOpeningTag('Legs')+
                         +createItinerayLegTag(quotationsToProcess)+
                         +createOnlyClosingTag('Legs');
                         
        return legTag;          
    }
    
    public static String createItineraryLegDay()
    {
        String ItineraryLegDay = createOnlyOpeningTag('ItineraryLegDay')+
                                +createOnlyClosingTag('ItineraryLegDay');
        return  ItineraryLegDay;                    
                                
    }
    
    public static String wetuHeader()
    {
        String wetuHeader = '<?xml version="1.0" encoding="UTF-8"?>' +
                            + '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">'+
                            +'<soap:Body>'+
                            +'<AuthenticateAndSaveItinerary xmlns="http://wetu.com/Map/ItineraryServiceV7">';
                          
                         
        return wetuHeader;                 
    }
    
    public static String createTagWithValue(String tagName, String tagValue)
    {
        String tagwithValue = '<'+tagName+'>'+tagValue+'</'+tagName+'>';
        return tagwithValue;
    }
    
    public static String createOnlyOpeningTag(String tagName)
    {
        String tag = '<'+tagName+'>';
        return tag;
    }
    
     public static String createItinerayLegTag(Quotations__c quotationsToProcess)
    {
        String Itinerarytag ='';
        try{
                //ItineraryLegs.add(createItineraryLeg(i,totalNights, quotationsToProcess,currentLeg));
                Itinerarytag = Itinerarytag+
                                 +'<ItineraryLeg xsi:type="ItineraryLegByDay">'+
                                  +createTagWithValue('ItineraryLegId','1')+
                                  +createTagWithValue('Sequence','0')+
                                  +createTagWithValue('ContentEntityId','0')+//Service line CRM > NTS > NTS catorgory = WET ( each service will have a 4 didget number 
                                  +createTagWithValue('Nights',String.valueof(quotationsToProcess.Total_Nights__c))+
                                  +createTagWithValue('Type','OwnArrangement') +
                                  +createDaysTag(quotationsToProcess)+
                                  +createOnlyClosingTag('ItineraryLeg');    
         }
        catch(Exception e)
        {
            System.debug('createItinerayLegTag:>'+e.getMessage());
        }
        return Itinerarytag;
    }
    
    public static string createDaysTag(Quotations__c quotationsToProcess)
    {
    	 String DaysTag  = createOnlyOpeningTag('Days')+
                         +createDayTag(quotationsToProcess)+
                         +createOnlyClosingTag('Days');
                         
        return DaysTag;   
    }
    
    public static string createDayTag(Quotations__c quotationsToProcess)
    {
    	 Integer counter  =0;
    	 String DayTag  ='';
    	 for(counter = 0; counter<quotationsToProcess.Total_Days__c;counter++)
    	 {
    	  DayTag  = DayTag+createOnlyOpeningTag('ItineraryLegDay')+
                         +createTagWithValue('Day',String.valueof(counter))+
                         +createOnlyClosingTag('ItineraryLegDay');
    	 }
                         
        return DayTag;   
    }
    
    public static String createOnlyClosingTag(String tagName)
    {
        String tag = '</'+tagName+'>';
        return tag;
    }
    
    
    public static String createOnlySpecificNullTag(String tagName)
    {
        String tag = '<'+tagName +' xsi:nil="true"/>';
        return tag;
    }
    
    public static String wetuFooter()
    {
        String wetuFooter = '</AuthenticateAndSaveItinerary>'+
                     +'</soap:Body>'+
                     +'</soap:Envelope>';
        return wetuFooter;
    }
}
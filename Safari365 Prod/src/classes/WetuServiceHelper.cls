public class WetuServiceHelper {
    
    static QuotationBuilderDatabaseQueries DbQueries= new QuotationBuilderDatabaseQueries();
    static  UTIL_LogGenerator logger = new UTIL_LogGenerator();
    
    public static List<LegDetail> GetLegDetails(Quotations__c quotation,List<ServiceLineItem__c> allServiceLineItems)
    {
        logger.start(WetuServiceHelper.class.getName(),'GetLegDetails');
        //List<ServiceLineItem__c> allServiceLineItems = DbQueries.GetServiceLineItemForWetu(quotation.Id);
       // List<ServiceLineItem__c> allServiceLineItems = allServiceLineItems;
        system.debug('allServiceLineItems from BB:::::'+allServiceLineItems);
        List<LegDetail> legDetails = new List<LegDetail>();
        try{
            if(allServiceLineItems.size() ==0)
            {
                return legDetails;
            }
            Integer LegSequenceCounter = 0;
            //Map<Integer, LegDetail> mapLegDetails = new Map<Integer, LegDetail>();
            Map<String, LegDetail> supplierNameToLegDetailsMap = new Map<String, LegDetail>();
            Integer supplierCounter = 1;
            for(ServiceLineItem__c sli: allServiceLineItems)
            {
                if(sli.SupplierName__c != null)
                {
                    LegDetail legDetail = null;
                    if(sli.Service_Type__c=='Accommodation' 
                        && supplierNameToLegDetailsMap.get(sli.SupplierName__c) != null
                        && supplierNameToLegDetailsMap.get(sli.SupplierName__c).LegStartLocation == sli.SupplierName__c)
                    {
                        legDetail = supplierNameToLegDetailsMap.get(sli.SupplierName__c);
                        legDetail.LegEndLocation = sli.SupplierName__c;
                        legDetail.LegEndDate = sli.Service_Date__c;
                        continue;
                    }
                    else if(sli.Service_Type__c=='Accommodation' 
                            && supplierNameToLegDetailsMap.get(sli.SupplierName__c) != null
                            && supplierNameToLegDetailsMap.get(sli.SupplierName__c).LegStartLocation != sli.SupplierName__c)
                    {
                        legDetail = new legDetail();
                        legDetail.LegStartLocation =supplierNameToLegDetailsMap.get(sli.SupplierName__c).LegStartLocation;
                        legDetail.LegEndLocation = sli.SupplierName__c;
                        legDetail.LegStartDate = sli.Service_Date__c;
                        legDetail.LegEndDate = sli.Service_Date__c;
                        legDetail.LegSequence = LegSequenceCounter;
                        LegSequenceCounter++;
                        legDetails.add(legDetail);
                        //supplierCounter++;
                        supplierNameToLegDetailsMap.put(sli.SupplierName__c,legDetail);
                        continue;
                    }
                    else if(sli.Service_Type__c=='Accommodation' 
                        && supplierNameToLegDetailsMap.get(sli.SupplierName__c) == null)
                    {
                        legDetail = new legDetail();
                        legDetail.LegStartLocation = sli.SupplierName__c;
                        legDetail.LegEndLocation = sli.SupplierName__c;
                        legDetail.LegStartDate = sli.Service_Date__c;
                        legDetail.LegEndDate = sli.Service_Date__c;
                        legDetail.LegSequence = LegSequenceCounter;
                        LegSequenceCounter++;
                        legDetails.add(legDetail);
                        supplierNameToLegDetailsMap.put(sli.SupplierName__c,legDetail);
                        continue;
                    }
                    
               }
           }
         logger.end();
        }
        catch(Exception e)
        {
            System.debug('GetLegDetails:>'+e.getMessage());
        }  
        return legDetails;
    }
    
    public static List<LegDayDetail> GetLegDayDetails(String quotationId,LegDetail currentLeg,List<ServiceLineItem__c> allServiceLineItems)
    {
        List<ServiceLineItem__c> serviceLineItemsForCurrentLeg = FindServiceItemsForLeg(currentLeg,allServiceLineItems);
        system.debug('serviceLineItemsForCurrentLeg:::::'+serviceLineItemsForCurrentLeg);
        List<LegDayDetail> legDayDetails  = new List<LegDayDetail>();
        try
        {
	        Integer totalDays = currentLeg.LegStartDate.DaysBetween(currentLeg.LegEndDate);
	        Integer dayCounter = 0;
       	    for(Date legDate= currentLeg.LegStartDate ;legDate<=currentLeg.LegEndDate; legDate=legDate.addDays(1))
            {
	            LegDayDetail dayDetail=new LegDayDetail();
	            dayDetail.dayCounter = dayCounter;
	            dayCounter++;
	            dayDetail.LegDate=legDate;
	            dayDetail.LegServiceLineItems = new List<ServiceLineItem__c>();
	            for(ServiceLineItem__c sli:serviceLineItemsForCurrentLeg)
	            {
	                system.debug('sli.Service_Date__c:>'+sli.Service_Date__c);
	                system.debug('legDate:>'+legDate);
	                if(sli.Service_Date__c==legDate)
	                {
	                    if(sli.Service_Type__c=='Accommodation')
	                    {
	                        dayDetail.LegDayServiceLineItem = sli;
	                    }
	                    else
	                    {
	                        dayDetail.LegServiceLineItems.add(sli);
	                    }
	                }
	        }
            legDayDetails.add(dayDetail);
        }
     }
        catch(Exception e)
        {
            System.debug('GetLegDayDetails:>'+e.getMessage());
        }  
        return legDayDetails;
    }
    
    private static List<ServiceLineItem__c> FindServiceItemsForLeg(LegDetail legDetail,List<ServiceLineItem__c> allServiceLineItems)
    {
        List<ServiceLineItem__c> result = new List<ServiceLineItem__c>();
        try{
            for(ServiceLineItem__c sli:allServiceLineItems)
            {
                if(sli.Service_Date__c >= legDetail.LegStartDate
                    && sli.Service_Date__c<= legDetail.LegEndDate)
                {
                    result.add(sli);
                }
                    
            }
        }
        catch(Exception e)
        {
            System.debug('FindServiceItemsForLeg:>'+e.getMessage());
        }    
        return result;
    }
    
    public static List<ServiceLineItem__c> FindServiceItemsForRoute(List<ServiceLineItem__c> allServiceLineItems)
    {
        List<ServiceLineItem__c> result = new List<ServiceLineItem__c>();
        system.debug('FindServiceItemsForRoute::::allServiceLineItems:::'+allServiceLineItems);
        for(ServiceLineItem__c sli:allServiceLineItems)
        {
            if( sli.Service_Type__c == 'Coach Hire'
               || sli.Service_Type__c == 'Cruise'
               || sli.Service_Type__c == 'Flight'
               || sli.Service_Type__c == 'Other Transport'
               || sli.Service_Type__c == 'Transfer'
               || sli.Service_Type__c == 'Rail'
               || sli.Service_Type__c == 'Transport')
            {
                result.add(sli);
            }
                
        }
            
        return result;
    }
    
    private static List<ServiceLineItem__c> FindServiceItemsForCarHire(List<ServiceLineItem__c> allServiceLineItems)
    {
        List<ServiceLineItem__c> result = new List<ServiceLineItem__c>();
        for(ServiceLineItem__c sli:allServiceLineItems)
        {
            if(sli.Service_Type__c == 'Camper Hire' 
               || sli.Service_Type__c == 'Car Rental')
            {
                result.add(sli);
            }
                
        }
            
        return result;
    }
    
    public static List<String> GetRouteType(String tourPlanRouteType) {
        List<String> routTypes=new List<String>();
        List<Wetu_Service_Type__mdt> mappings = [SELECT Field_Set_Name__c 
                                                    FROM 
                                                         Wetu_Service_Type__mdt 
                                                    WHERE
                                                         MasterLabel=:tourPlanRouteType AND Wetu_Type__c='Route'];
        for(Wetu_Service_Type__mdt m:mappings)
        {
            routTypes.add(m.Field_Set_Name__c);
        }
        return routTypes;
    }
    
    public static OPT__c getOPTForItineraryLegDay(ServiceLineItem__c serviceLineItem)
    {
        return DAL_OPT.GetOptIdsForServiceLineItem(serviceLineItem.Service_Type__c,serviceLineItem.ServiceLocation__c,
                                                   serviceLineItem.SupplierName__c,serviceLineItem.Service_Detail__c,
                                                   '');
    }
    
    public static String createWetuXmlString(Quotations__c quotationsToProcess,Opportunity opportunityToProcess,User userToProcess)
    {
       
        List<ServiceLineItem__c> allServiceLineItems = DbQueries.GetServiceLineItemForWetu(quotationsToProcess.Id);
        List<LegDetail> legDetails = GetLegDetails(quotationsToProcess,allServiceLineItems);
        system.debug('@@@@legDetails1111:::'+legDetails.size());	
        system.debug('@@@@@allServiceLineItems:::'+allServiceLineItems);
        //Map<String,OPT__c> allOptsMap = DAL_OPT.GetOptForServiceLineItems(allServiceLineItems);
        Map<String,CRM__c> allCrmsMap = DAL_CRM.getCrmFromServiceLineItems(allServiceLineItems);
        system.debug('allCrmsMap:::'+allCrmsMap);
        system.debug('allCrmsMap.values():::'+allCrmsMap.values());
        Map<String,NTS__c> allNtsMap = DAL_NTS.GetNtsForServiceLineItems(allCrmsMap.values());
        system.debug('allNtsMap:::'+allNtsMap);
        system.debug('allNtsMap:::'+allNtsMap.values());
        
        String wetuXMl = wetuHeader()+
                         +createOnlyOpeningTag('itinerary')+
                         +createTagWithValue('operator_id',String.valueof(quotationsToProcess.wetu_operator_id__c))+
                         +createTagWithValue('operator_user_id',String.valueof(userToProcess.wetu_user_id__c))+
                         +createTagWithValue('operator_identity_id',String.valueof(quotationsToProcess.operator_identity_id__c))+
                         +createTagWithValue('operator_theme_id',String.valueof(quotationsToProcess.wetu_operator_theme_id__c))+
                         +createTagWithValue('type',quotationsToProcess.wetu_type__c)+
                         //+createTagWithValue('type','Standard')+
                         +createTagWithValue('Days',String.valueof(quotationsToProcess.Total_Days__c))+
                         +createTagWithValue('Name',opportunityToProcess.Name+'-'+quotationsToProcess.Quotation_Name__c+'-'+quotationsToProcess.Name)+
                         +createTagWithValue('Language','')+
                         +createTagWithValue('reference_number',String.valueof(quotationsToProcess.Name))+
                         +createTagWithValue('Summary',quotationsToProcess.Itinerary_Summary__c)+
                         +createTagWithValue('description',quotationsToProcess.Quotation_Name__c)+
                         +createTagWithValue('client_name',opportunityToProcess.Client_Name__c)+
                         +createTagWithValue('StartDate',String.valueof(quotationsToProcess.TravelStartDate__c)+'T00:00:00Z')+
                        //+createTagWithValue('StartDate','2018-07-17T00:00:00Z')+
                         +createlegTag(quotationsToProcess,opportunityToProcess,legDetails,allServiceLineItems,allCrmsMap,allNtsMap)+
                         //+createOnlyOpeningTag('TravelArrangements')+
                         +createRouteTag(quotationsToProcess,opportunityToProcess,legDetails,allServiceLineItems,allCrmsMap,allNtsMap)+
                         +createOnlyOpeningTag('CarHire')+
                         +createCarHireTag(quotationsToProcess,legDetails,allServiceLineItems)+
                         +createOnlyClosingTag('CarHire')+
                        // +createOnlyClosingTag('TravelArrangements')+
                         +createTagWithValue('RouteHandlingMode','AutoGenerateRoutesFromTravelArrangements')+
                         //+createTagWithValue('IsDisabled','False')+
                         //+createTagWithValue('TravellersAdult','')+
                         //+createTagWithValue('TravellersChildren','')+
                         //+createTagWithValue('RoomsSingle','')+
                         //+createTagWithValue('RoomsDouble','')+
                         //+createTagWithValue('RoomsTwin','')+
                         //+createTagWithValue('RoomsTriple','')+
                         //+createTagWithValue('StartTravelDays','')+
                         //+createTagWithValue('EndTravelDays','')+
                         //+createTagWithValue('BookingStatus','')+
                         //+createTagWithValue('SourceOperatorId','')+
                         //+createTagWithValue('NotificationFrequency','')+
                         //+createTagWithValue('Published','')+
                         //+createTagWithValue('RouteHandlingMode','')+ 
                         +createOnlyClosingTag('itinerary')+
                         +createTagWithValue('username',userToProcess.wetu_username__c)+
                         +createTagWithValue('password',userToProcess.wetu_password__c)+
                         +wetuFooter();
	                     String replaceString =  wetuXMl.replaceAll('&','&amp;');
                  
       return  replaceString;                
    }
    
    
     public static String createCarHireTag(Quotations__c quotationsToProcess,
                                            List<LegDetail> legDetails,
                                            List<ServiceLineItem__c> allServiceLineItems)
    {
        String carHireTag  = '';
        try{
            Set<String> carHireCheckSet = new Set<String>();
            for(LegDetail legDetail: legDetails)
            {
                List<LegDayDetail> legDayDetails= GetLegDayDetails(quotationsToProcess.Id,legDetail,allServiceLineItems);
               system.debug('legDayDetails:::'+legDayDetails);
                for(LegDayDetail legDayDetail:legDayDetails)
                {
                    system.debug('LegServiceLineItems:::'+legDayDetail.LegServiceLineItems);
                    List<ServiceLineItem__c> carHireServiceLineItems = FindServiceItemsForCarHire(legDayDetail.LegServiceLineItems);
                    for(ServiceLineItem__c sli:carHireServiceLineItems)
                    {
                        
                        String key = sli.SupplierName__c+sli.Wetu_Start_Location_Id__c+sli.Wetu_End_Location_Id__c;
                        if(!carHireCheckSet.contains(key))
                        {
                            carHireTag = carHireTag +createCarHire(sli);
                            carHireCheckSet.add(key);
                        }
                    }
                }
            }
        }
        catch(Exception e)
        {
            System.debug('createCarHireTag:>'+e.getMessage());
        }
                         
        return carHireTag;          
    }
    
    public static String createRouteTag(Quotations__c quotationsToProcess,
                                        Opportunity opportunityToProces,
                                        List<LegDetail> legDetails,
                                        List<ServiceLineItem__c> allServiceLineItems,
                                        Map<String,CRM__c> allOptsMap,
                                        Map<String,NTS__c> allNtsMap)
    {
        String ItineraryRoute  = '';
        //Integer dayCounter = 0;
        Date startDate =quotationsToProcess.TravelStartDate__c;
        try{
            system.debug('@@@@@@@legDetails11111111::::'+legDetails.size());
            for(LegDetail legDetail: legDetails)
            {
                List<LegDayDetail> legDayDetails= GetLegDayDetails(quotationsToProcess.Id,legDetail,allServiceLineItems);
                system.debug('@@@@@@@legDayDetails::::'+legDayDetails);
                for(LegDayDetail legDayDetail:legDayDetails)
                {
                    system.debug('legDayDetail:::::'+legDayDetail);
                    CRM__c crm = allOptsMap.get(legDayDetail.LegDayServiceLineItem.Crm_Code__c);
                    system.debug('crm::::'+crm);
                    NTS__c nts = null;
                    if( null != crm )
                    nts = allNtsMap.get(crm.Id);
                   
                    List<ServiceLineItem__c> routeServiceLineItems = FindServiceItemsForRoute(legDayDetail.LegServiceLineItems);
                    system.debug('legDayDetail.routeServiceLineItems::::'+routeServiceLineItems);
                    for(ServiceLineItem__c sli:routeServiceLineItems)
                    {
                        system.debug('routeServiceLineItems::slir::::'+sli);
                        system.debug('legDetail.LegSequence::::'+legDetail.LegSequence);
                        Integer daydifferenece  = startDate.daysBetween(sli.Service_Date__c);
                        system.debug('differenece:'+daydifferenece);
                        ItineraryRoute = ItineraryRoute 
                             +createItineraryRoute(quotationsToProcess,opportunityToProces,sli,nts,legDetail.LegSequence, daydifferenece);
                    }
                }
                //Day counter increment
                 //dayCounter = dayCounter + 1;
            }
        }
        catch(Exception e)
        {
            System.debug('createRouteTag:>'+e.getMessage());
        }
        logger.log('ItineraryRoute',ItineraryRoute);
        String RouteTag = '';
        if(!String.isBlank(ItineraryRoute))
        {
        RouteTag  = createOnlyOpeningTag('TravelArrangements')+
                        + ItineraryRoute+
                     + createOnlyClosingTag('TravelArrangements');
        }
                         
        return RouteTag;          
    }
    
    
    public static String createCarHire(ServiceLineItem__c sli)
    {
        String collection = '-';
        String dropOff = '-';
        if(null != sli)
        {
            collection = sli.Wetu_Start_Location__c;
            dropOff =  sli.Wetu_End_Location__c;
        }
        
        String collectionDate  = String.valueof(sli.Service_Date__c)+'T00:00:00Z';
        String DropOffDate =String.valueof(sli.Service_Date__c.addDays((Integer)sli.Service_Duration__c))+'T00:00:00Z';
        
        String carHireTag = createOnlyOpeningTag('ItineraryCarHire');
                             if(null != collection)
                             {
                             carHireTag = carHireTag+createTagWithValue('Collection',Collection);
                             }else{
                             carHireTag = carHireTag+createOnlySpecificNullTag('Collection');
                             }
                             if( null != dropOff){
                             carHireTag = carHireTag+createTagWithValue('DropOff', dropOff);
                             }else{
                             carHireTag = carHireTag+createOnlySpecificNullTag('DropOff');
                             } 
                             carHireTag = carHireTag+createOnlySpecificNullTag('CollectionContentEntityId')+
                             +createOnlySpecificNullTag('DropOffContentEntityId')+
                           //  +createTagWithValue('CollectionContentEntityId',StartContentEntityId)+
                             //+createTagWithValue('DropOffContentEntityId', EndContentEntityId)+
                             +createTagWithValue('Agency',sli.SupplierName__c)+
                             +createTagWithValue('Vehicle',sli.Basis__c)+
                             +createTagWithValue('ReferenceCodes',sli.Reservation_Number__c)+
                             +createTagWithValue('Collectiondate',collectionDate)+// Start date of Leg 1
                             +createTagWithValue('CollectionTime',String.valueof(sli.Wetu_Start_time__c))+
                             +createTagWithValue('DropOffDate',DropOffDate)+// End date of the leg 
                             +createTagWithValue('DropOffTime',String.valueof(sli.Wetu_End_Time__c))+
                             +createTagWithValue('VehicleClass',sli.Service_Detail__c)+
                             +createOnlyClosingTag('ItineraryCarHire');
                         
        return carHireTag;          
    }
    
    
    public static String createItineraryRoute(Quotations__c quotationsToProcess,
                                              Opportunity opportunityToProces,
                                              ServiceLineItem__c sli,
                                              NTS__c nts,
                                              Integer legId,
                                              Integer dayCounter)
    {
        List<String> routeTpes = GetRouteType(sli.Service_Type__c);
        system.debug('routeTpes::::'+routeTpes);
        String mode='';
        if(!routeTpes.isEmpty())
        {
            mode = routeTpes[0];
        }
        String StartContentEntityId;
        String EndContentEntityId;
        if(null !=  sli.Wetu_Start_Location_Id__c )
        {
            StartContentEntityId = sli.Wetu_Start_Location_Id__c;
        }
        if(null !=  sli.Wetu_End_Location_Id__c )
        {
            EndContentEntityId =  sli.Wetu_End_Location_Id__c;
        }
        
        String ItineraryRoute  = createOnlyOpeningTag('ItineraryTravelArrangement')+
                                 +createTagWithValue('Mode',mode);
                                 
                                 if(null !=  sli.Wetu_Start_Location_Id__c)
                                 {
                                  ItineraryRoute= ItineraryRoute+createTagWithValue('FirstContentEntityId',StartContentEntityId);
                                 }
                                 else
                                 {
                                    ItineraryRoute=ItineraryRoute+createOnlySpecificNullTag('StartContentEntityId');
                                 }
                                 
                                 if(null !=  sli.Wetu_End_Location_Id__c)
                                 {
                                   ItineraryRoute=ItineraryRoute+createTagWithValue('SecondContentEntityId',EndContentEntityId);
                                 }
                                 else
                                 {
                                    ItineraryRoute=ItineraryRoute+createOnlySpecificNullTag('SecondContentEntityId');
                                 }
                                 
                  ItineraryRoute =
                                 ItineraryRoute+ 
                                 //createTagWithValue('SecondContentEntityId', EndContentEntityId)+
                                 +createTagWithValue('Agency',sli.SupplierName__c)+
                                 +createTagWithValue('Vehicle',sli.Basis__c)+
                                 +createTagWithValue('ReferenceCodes',sli.Reservation_Number__c)+
                                 +createTagWithValue('Notes',sli.ClientNotes__c)+
                                 +createTagWithValue('Day',String.valueof(dayCounter))+
                                 +createTagWithValue('FirstTime',String.valueof(sli.Wetu_Start_time__c))+
                                 +createTagWithValue('SecondTime',String.valueof(sli.Wetu_End_Time__c))+
                                 +createOnlyClosingTag('ItineraryTravelArrangement');
                                 
                                 
                      system.debug('ItineraryRoute::::'+ItineraryRoute);    
        return ItineraryRoute;          
    }
    
    public static String createlegTag(Quotations__c quotationsToProcess,
                                      Opportunity opportunityToProcess,
                                      List<LegDetail> legDetails,
                                      List<ServiceLineItem__c> allServiceLineItems,
                                      Map<String,CRM__c> allOptsMap,
                                      Map<String,NTS__c> allNtsMap)
    {
        
        
        
        String legTag  = createOnlyOpeningTag('Legs')+
                         +createItinerayLegTag(quotationsToProcess,legDetails,allServiceLineItems,allOptsMap,allNtsMap)+
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
    
     public static String createItinerayLegTag(Quotations__c quotationsToProcess,
                                                    List<LegDetail> legDetails,
                                                    List<ServiceLineItem__c> allServiceLineItems,
                                                    Map<String,CRM__c> allCrmMap,
                                                    Map<String,NTS__c> allNtsMap)
    {
        String Itinerarytag ='';
        try{
            system.debug('legDetails::::::'+legDetails.size());
            for(Integer i=0;i<legDetails.size();i++)
            {
                LegDetail currentLeg =legDetails[i];
                system.debug('currentLeg::::::'+currentLeg);
                List<LegDayDetail> legDayDetails= GetLegDayDetails(quotationsToProcess.Id,currentLeg,allServiceLineItems);
                system.debug('legDayDetails:::::'+legDayDetails);
                if(!legDayDetails.isEmpty())
                {
                    Integer totalNights = currentLeg.LegStartDate.daysBetween(currentLeg.LegEndDate)+1;
                    String contentId = '0';
                    if(null !=legDayDetails[0].LegDayServiceLineItem.Crm_Code__c)
                    {
                        system.debug('legDayDetails[0].LegDayServiceLineItem.Crm_Code__c'+legDayDetails[0].LegDayServiceLineItem.Crm_Code__c);
                        Crm__c crm = allCrmMap.get(legDayDetails[0].LegDayServiceLineItem.Crm_Code__c);
                        system.debug('crm'+crm);
                        system.debug('allNtsMap'+allNtsMap);
                        if(null !=crm.Id)
                        {
                            NTS__c nts = allNtsMap.get(crm.Id);
                            if(null != nts)
                            {
                                contentId = nts.MESSAGE_TEXT__c;
                            }
                        }
                    }
                    //ItineraryLegs.add(createItineraryLeg(i,totalNights, quotationsToProcess,currentLeg));
                    Itinerarytag = Itinerarytag+
                                  +'<ItineraryLeg xsi:type="ItineraryLegByDay">'+
                                  +createTagWithValue('ItineraryLegId',String.valueof(i+1))+
                                  +createTagWithValue('Sequence',String.valueof(i))+
                                  +createTagWithValue('ContentEntityId',contentId)+//Service line CRM > NTS > NTS catorgory = WET ( each service will have a 4 didget number 
                                  +createTagWithValue('Nights',String.valueof(totalNights))+
                                  +createTagWithValue('Type','Standard') +
                                  +createOnlyOpeningTag('Days')+
                                  +createItinerayLegDayTag(legDayDetails)+
                                  +createOnlyClosingTag('Days')+
                                  +createOnlyClosingTag('ItineraryLeg');    
                }
            }
            
        }
        catch(Exception e)
        {
            System.debug('createItinerayLegTag:>'+e.getMessage());
        }
        return Itinerarytag;
    }
    
     public static String createItinerayLegDayTag(List<LegDayDetail> legDayDetails)
    {
        
        system.debug('legDayDetails in createItinerayLegDayTag'+legDayDetails);
        String ItineraryLegDay ='';
        Integer dayCounter = 0;
        try{
            for(LegDayDetail legDayDetail: legDayDetails)
            {
                //OPT__c opt = allOptsMap.get(legDayDetail.LegDayServiceLineItem.Selected_OPT_Code__c);
                //NTS__c nts = allNtsMap.get(opt.CRM_Lookup__c);
                
                ItineraryLegDay = ItineraryLegDay+createOnlyOpeningTag('ItineraryLegDay')+
                                   +createTagWithValue('Day',String.valueOf(dayCounter))+
                                   //+createTagWithValue('RoomBasis',opt.Comment__c)+
                                   //+createTagWithValue('DrinksBasis','None')+
                                   +createActivitiesTag(legDayDetail)+
                                   +createOnlyClosingTag('ItineraryLegDay');
                
                dayCounter = dayCounter + 1;
            }
        }
        catch(Exception e)
        {
            System.debug('createItinerayLegDayTag:>'+e.getMessage());
        }
        return ItineraryLegDay;
    }
    
    public static String createActivitiesTag(LegDayDetail legDayDetail)
    {
        
        String ActivitiyLegDay = '';     
        Integer sequenceCounter = 0;
        try
        {
            for(ServiceLineItem__c sli:legDayDetail.LegServiceLineItems)
            {
                ActivitiyLegDay = ActivitiyLegDay + createOnlyOpeningTag('ItineraryLegDayActivity')+
                                +createTagWithValue('Sequence', String.valueOf(sequenceCounter))+ // Is this correct ??
                                +createTagWithValue('Name',sli.SupplierName__c)+ // Is this correct??
                                +createTagWithValue('IsHighlight','false') +     // Is this correct??
                                +createTagWithValue('Type','Included') +         // Is this correct?? 
                                +createTagWithValue('PreventVoucher','false') +  // Is this correct?? 
                                +createTagWithValue('TimeSlot','None')+// We dont have this value as yet
                                +createOnlyClosingTag('ItineraryLegDayActivity');
                
                sequenceCounter = sequenceCounter + 1;
            }
        }
        catch(Exception e)
        {
            System.debug('createActivitiesTag:>'+e.getMessage());
        }
        String Activities ='';
        if(!String.isBlank(ActivitiyLegDay))
        {
        Activities =createOnlyOpeningTag('Activities')
                            +ActivitiyLegDay 
                           +createOnlyClosingTag('Activities');
        }
        return Activities;
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
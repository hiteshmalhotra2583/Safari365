public class ServiceLineItemController {
    
    
    private static final String CLASS_NAME = ServiceLineItemController.class.getName();
    private static final String VALID_CHECK_MESSGAE='';
    static QuotationBuilderDatabaseQueries DbQueries= new QuotationBuilderDatabaseQueries();
    
    @AuraEnabled public static void RemoveServiceLineItems(String serviceLineItemId,String serviceDuration) {
        DbQueries.RemoveServiceLineItems(serviceLineItemId,serviceDuration);
    }
    
    @AuraEnabled public static List<String> loadPassengersForServiceLineItem(String serviceLineItemId) {
        return DbQueries.loadPassengersForServiceLineItem(serviceLineItemId);
    }
    
    @AuraEnabled public static ServiceLineItem__c loadServiceLineItem(String serviceLineItemId) {
        return DbQueries.loadServiceLineItem(serviceLineItemId);
    }
    
    @AuraEnabled public static Date GetQuotationLineItemDate(String quotationLineItemId) {
        
     	List<QuotationLineItem__c> qli= [SELECT Line_Item_Date__c FROM QuotationLineItem__c WHERE Id=:quotationLineItemId];
      	system.debug('qli[0].Line_Item_Date__c::::'+qli[0].Line_Item_Date__c);
      	return qli[0].Line_Item_Date__c;
      
    }   
        
    @AuraEnabled public static List<String> getServiceTypes() {
        return DbQueries.GetServiceTypes();
     }
     
     @AuraEnabled public static List<String> getLocations(String selectedServiceType) {
        return DbQueries.GetLocations(selectedServiceType);
     }
    
    @AuraEnabled public static List<String> getTimeList() {
        List<String> options = new List<String>();
        
        for(Integer hour=0;hour<24;hour++)
        {
            String timeStr ='';
            if(hour <10)
            {
                timeStr ='0'+hour + ':';
            }
            else
            {
                timeStr =hour+':';
            }
            options.add(timeStr+'00');
            options.add(timeStr+'05');
            options.add(timeStr+ 10);
            options.add(timeStr+ 15);
            options.add(timeStr+ 20);
            options.add(timeStr+ 25);
            options.add(timeStr+ 30);
            options.add(timeStr+ 35);
            options.add(timeStr+ 40);
            options.add(timeStr+ 45);
            options.add(timeStr+ 50);
            options.add(timeStr+ 55);
        }
        return options;
    }
      @AuraEnabled public static List<String> getSupplierNames(String selectedLocation,String selectedServiceType,Boolean preferredSupplier) {
      	return DbQueries.GetSupplierNames(selectedLocation,selectedServiceType,preferredSupplier); 
      }

      @AuraEnabled public static List<String> getServiceStatus() {
		 return DbQueries.GetServiceStatus();
      }
	
    @AuraEnabled public static List<String> getPassengerAgeList() {
        return DAL_Passenger.GetPassengerAgeList();
      }
    
    @AuraEnabled public static List<String> savePassengerAge(String passengerAge,String passengerId) {
        List<String> Errors  =new List<String>();
		try
        {
        Passenger__c p = [SELECT Given_Age__c FROM Passenger__c WHERE Id=:passengerId][0];
         p.Given_Age__c = passengerAge;
         upsert p;
        }
       catch(DMLException e)
       {
           Errors.add(e.getMessage());
       }
        return Errors;
      }
    
     @AuraEnabled public static List<String> getServiceDetails(String selectedSupplierName,String selectedServiceType,String selectedLocation) {
        	return DbQueries.GetServiceDetails(selectedSupplierName,selectedServiceType,selectedLocation);
    	}
    
    @AuraEnabled public static List<String> getServiceDetailsWithSupplierId(String selectedSupplierId,String selectedServiceType,String selectedLocation) {
        	return DbQueries.GetServiceDetailsWithSupplierId(selectedSupplierId,selectedServiceType,selectedLocation);
    	}
    
     @AuraEnabled public static List<Passenger__c> GetServiceLineItemPassengers(String serviceLineItemId) {
        	return DbQueries.GetServiceLineItemPassengers(serviceLineItemId);
    	}
    
    @AuraEnabled public static List<ServiceLinePassengerWrapper> GetQuotationPassengers(String quotationId) {
        List<ServiceLinePassengerWrapper> result=new List<ServiceLinePassengerWrapper>();
        
        List<Passenger__c> passengers=DbQueries.GetQuotationPassengers(quotationId);
        for(Passenger__c p:passengers)
        {
            ServiceLinePassengerWrapper w = new ServiceLinePassengerWrapper();
            w.Passenger = p;
            w.IsSelected = false;
            result.add(w);
        }
        	return result;
    	}
    
    @AuraEnabled public static List<String> GetNumberOfDays(String quotationId,String quotationLineItemId) {
        	return DbQueries.GetNumberOfDays(quotationId,quotationLineItemId);
    	}
    
    @AuraEnabled public static List<String> GetNumberOfNights(String quotationId,String quotationLineItemId) {
        	return DbQueries.GetNumberOfNights(quotationId,quotationLineItemId);
    	}
    
    @AuraEnabled public static List<String> GetServiceTypeForSupplier(String supplierId) {
        	return DbQueries.GetServiceTypeForSupplier(supplierId);
    	}
    
    /*@AuraEnabled public static List<String> GetSuppplierNameLookupQuery(String selectedLocation,String selectedServiceType,Boolean preferredSupplier) {
      	return DbQueries.GetSuppplierNameLookupQuery(selectedLocation,selectedServiceType,preferredSupplier); 
      }*/

    @AuraEnabled public static List<String> GetRoomConfiguration(String supplierIdorCode,String mode) {
        return DbQueries.GetRoomConfiguration(supplierIdorCode,mode);
    }
    
    @AuraEnabled public static List<String> GetLocationForSupplier(String supplierIdorCode,String mode) {
        	return DbQueries.GetLocationForSupplier(supplierIdorCode,mode);
    	}
    	
     @AuraEnabled public static Boolean checkGivenPassengerAge(String passengerId) 
     {
        	List<Passenger__c> passengers = DAL_Passenger.getById(passengerId);
        	boolean flag = false;
        	if(passengers != null
        		 && 
                   passengers[0].Given_Age__c != null)
        	{
        				flag = true;
        	}
        	return flag;
     }	
    
    @AuraEnabled
     public static List<String> UpdateServiceLineItem(String serviceLineItemId,String serviceClientNotes,
                                                    String serviceReservationNumber, String serviceSupplierNotes,
                                                    String serviceStatus, String serviceExpiryDate,
                                                    Boolean notOverrideNetCost)
     {
         return DbQueries.UpdateServiceLineItem(serviceLineItemId,serviceClientNotes,
         										 serviceReservationNumber, serviceSupplierNotes,
         										 serviceStatus, serviceExpiryDate,
         										 notOverrideNetCost);
         
     }
     
     @AuraEnabled
     public static List<String> saveServiceLineItem(String serviceLineItemName,String selectedServiceType,
     												String selectedLocation,String selectedSupplierName, 
                                                    String selectedSupplierId, String selectedServiceDetail,
                                                    String quotationLineItemId, String serviceClientNotes, 
                                                    String serviceReservationNumber, String serviceSupplierNotes,
                                                    String serviceSelectServiceStatus, String serviceExpiryDate, 
                                                    Boolean overrideDetails, String[] selectedPassengers,
                                                    String serviceDate, String numberOfDays,String quotationId, 
                                                    String roomConfiguration, String wetuStartLocation,
                                                    String wetuStartLocationId,String wetuEndLocation,
                                                    String wetuEndLocationId, 
                                                    String wetuStartTime,String wetuEndTime,
                                                    String startTerminal, String endTerminal,
                                                    String duration,String checkInTime,
                                                    String ticketClass) {
        
        List<String> ErrorMessageList = new List<String>();
		UTIL_LogGenerator logger = new UTIL_LogGenerator();
        logger.start(CLASS_NAME,'saveServiceLineItem');
        logger.log('serviceDate',serviceDate);
        String errorMessage ='';
        OPT__c  optId = null;
        List<Passenger__c>  allPassengers =  new List<Passenger__c>();
		try
        {
            logger.Log('selectedPassengers',selectedPassengers);
            allPassengers  =DAL_Passenger.getByIds(new List<String>(selectedPassengers));
            logger.Log('allPassengers',allPassengers);
            List<Passenger__c> adultPassengers = new List<Passenger__c>();
            List<Passenger__c> notAdultPassengers = new List<Passenger__c>();
            for(Passenger__c p:allPassengers)
            {
                if('Adult' == p.PassengerType__c)
                {
                    adultPassengers.add(p);
                }
                if('Child' == p.PassengerType__c ||
                   'Infant' == p.PassengerType__c)
                {
                    notAdultPassengers.add(p);
                }
                if(String.isEmpty(p.PassengerType__c))
                {
                    ErrorMessageList.add(system.label.Passenger_Type_Not_Defined+ p.PassengerName__c); 
                    return ErrorMessageList;
                }
                
            }

                String selectedServiceDetailbeforeSplit = null;
                String selectedServiceCommentsAfterSplit= null;
                if(selectedServiceDetail.contains('||'))
                {
                 selectedServiceDetailbeforeSplit  = selectedServiceDetail.substringBefore('||').trim();
                 selectedServiceCommentsAfterSplit = selectedServiceDetail.substringAfter('||').trim();
                }
                else
                {
                	selectedServiceDetailbeforeSplit = selectedServiceDetail;
                }
                
                optId  = DAL_OPT.GetOptIdsForServiceLineItem(selectedServiceType, selectedLocation, 
	        											 selectedSupplierName,selectedServiceDetailbeforeSplit,
	        											 selectedServiceCommentsAfterSplit);
		        
                if(optId== null)
                {
                  errorMessage = system.label.OPT_Not_Available;
                }
                
                if(!overrideDetails)
	            {
	                Logger.log('Info','AllPassengers sorted');
	                //bypass validation if override details is true
			        string hour = '00';
			        string minute = '00';
			        string second = '00';
			         
			         
			        String serviceDate1 = serviceDate.substringBefore('-')+'-'+serviceDate.substringAfterLast('-')+'-'+serviceDate.substringBetween('-','-');
					Date startdate = date.valueOf(serviceDate  + ' ' + hour + ':' + minute + ':' + second);
					Logger.log('Info','validateTheCriteriaToSOD started');
			        if(String.isBlank(errorMessage))
			        {  
	                    if(numberOfDays== null)
	                    {
	                        numberOfDays ='0';
	                    }
				        Set<String> CriteriaToSODerrorMessage = validateTheCriteriaToSOD(startdate, Integer.valueof(numberOfDays) 
				        																,allPassengers, adultPassengers ,
				        																notAdultPassengers,selectedServiceType,
				        																optId,roomConfiguration);
			            Logger.log('Info','validateTheCriteriaToSOD End');
	                    if(CriteriaToSODerrorMessage.size() > 0)
			            {
			                ErrorMessageList.addAll(CriteriaToSODerrorMessage);
			                
			                return ErrorMessageList;
			            }
			        }
			                                                                          
			        Logger.log('Info','validateTheCriteriaToSOD witho Error');   
			        Boolean checkDurationIsValid = DbQueries.validateDurationIsValid(startdate,Integer.valueof(numberOfDays), 
			        																 quotationId,selectedServiceType);
			        																 
			        if(!checkDurationIsValid)
			        {
			        	errorMessage = System.Label.Duration_Check;
			        	ErrorMessageList.add(errorMessage);
			           
			            return ErrorMessageList;
			        }
			        logger.Log('errorMessage',errorMessage);
	        }    
			
			if(String.isBlank(errorMessage))
	        {
                logger.log('Info','Calling Save Method');
	        	Set<String> errorMessages =  DbQueries.saveServiceLineItem(serviceLineItemName, selectedServiceType, 
	        															   selectedLocation, selectedSupplierName, selectedSupplierId,
	                                                                       selectedServiceDetail, quotationLineItemId,
	                                                                       serviceClientNotes,
	                                                                       serviceReservationNumber,serviceSupplierNotes, 
	                                                                       serviceSelectServiceStatus,serviceExpiryDate,
	                                                                       overrideDetails,selectedPassengers,serviceDate,numberOfDays,
	                                            						   quotationId,optId,allPassengers, roomConfiguration,
	                                                                       wetuStartLocation,wetuStartLocationId,
	                                                                       wetuEndLocation,wetuEndLocationId, wetuStartTime,wetuEndTime
                                                                          ,startTerminal,endTerminal, duration, checkInTime, ticketClass);
	            ErrorMessageList.addAll(errorMessages);
	                                                                       
	        }
	       	logger.log('ErrorMessageList',ErrorMessageList);
        }
		catch(Exception e){
			ErrorMessageList.add(e.getMessage());
        }
        return ErrorMessageList;
        
    }
    
    public static Set<String> validateTheCriteriaToSOD(Date startDate, Integer duration ,List<Passenger__c> allPassengers ,		
    					List<Passenger__c> adultPassengers , List<Passenger__c> notadultPassengers, 
                                                       String serviceType, OPT__c  opt, String roomConfiguration)
    {
       Set<String> ErrorMessages = new Set<String>();
       UTIL_LogGenerator logger = new UTIL_LogGenerator();
       logger.start(CLASS_NAME,'validateTheCriteriaToSOD');
       String errorMessage= '';
       try
	   {
	       Set<Id> sodIds = new Set<Id>();
	       SOD__c selectedSOD = null;
	       sodIds.add(opt.SOD_Lookup__c);
	        Logger.log('Info','Checking getSODSPolicyType');
	       List<SOD__c> sodWithPolicyTypes =  DAL_SOD.getSODSPolicyType(sodIds).values();
	       
	       for(SOD__c sod: sodWithPolicyTypes)
	       {
	          Logger.log('Info','Checking checkWeekDayMatch');
	          errorMessage = checkWeekDayMatch(sod , UTIL_Date.giveWeekDayName(startDate));
	          if(!String.isBlank(errorMessage))
	          {
	              	ErrorMessages.add(errorMessage);
	          }
	           Logger.log('Info','Checking validateIncludedDays');
	          errorMessage =  validateIncludedDays(sod,serviceType,startDate,duration); 
	          
	          if(!String.isBlank(errorMessage))
	          {
	              	ErrorMessages.add(errorMessage);
	          }
	          Logger.log('Info','Checking validateInfantsAndChildAgeIncluded');
	          errorMessage = validateInfantsAndChildAgeIncluded(sod,notadultPassengers, allPassengers );
		      if(!String.isBlank(errorMessage))
		      {
		        	ErrorMessages.add(errorMessage);
		      }
	          
	          if(serviceType == 'Accommodation')
	          {
                  Logger.log('Info','Checking validateRoomConfiguration');
	          	errorMessage = validateRoomConfiguration(sod,roomConfiguration);
	           
		          if(!String.isBlank(errorMessage))
		          {
		              	ErrorMessages.add(errorMessage);
		          }
		          Logger.log('Info','Checking validateAdultIncluded');
		          errorMessage = validateAdultIncluded(sod, adultPassengers,roomConfiguration);
		          
		          if(!String.isBlank(errorMessage))
		          {
		              	ErrorMessages.add(errorMessage);
		          }
		          Logger.log('Info','Checking validateTotalPaxIncluded');
		          errorMessage = validateTotalPaxIncluded(sod,allPassengers,roomConfiguration);
		          
		          if(!String.isBlank(errorMessage))
		          {
		              	ErrorMessages.add(errorMessage);
		          } 
	           }
	              
	         
	          if(ErrorMessages.size() ==0)
	          {
	           	selectedSOD = sod;
	           	break;
	          }
	        }
	        
	        logger.log('selectedSOD>>',selectedSOD);
	        logger.end();      
	        }
	        catch(Exception e)
	        {
	            errorMessages.add('validateTheCriteriaToSOD:>>' +e.getMessage());
	        }
        return ErrorMessages;
    }
    
    
    
    public static String checkWeekDayMatch(SOD__c sod , String sericeStartDay )
    {
        String errorMesage = '';
        try
        {
          if((sod.START_MON__c && sericeStartDay=='MON')
            || (sod.START_TUE__c && sericeStartDay=='TUE')
            || (sod.START_WED__c && sericeStartDay== 'WED')
            || (sod.START_THU__c && sericeStartDay=='THU')
            || (sod.START_FRI__c && sericeStartDay=='FRI')
            || (sod.START_SAT__c && sericeStartDay=='SAT')
            || (sod.START_SUN__c && sericeStartDay=='SUN'))
            {
             	return VALID_CHECK_MESSGAE;
            }
            else
            {
          		errorMesage =System.Label.WeekDay_Match; 
          	}
        }
        catch(Exception e)
        {
            errorMesage = 'checkWeekDayMatch:>>' +e.getMessage(); 
        }
       return errorMesage;        
    }
    
    public static String validateIncludedDays(SOD__c sod, String servicetype,Date serviceStartDay , Integer Duration)
    {
        String errorMesage = '';
        try
        {
        	if(Duration > 7 )
             Duration = 7;
        
            Set<String> days  = new Set<String>();
            Set<String> daysToInclude  = new Set<String>();
            if(sod.INCLUDE_MON__c )
       	    {
                daysToInclude.add('Mon');
            }
            if(sod.INCLUDE_TUE__c )
       	    {
                daysToInclude.add('Tue');
            }
            if(sod.INCLUDE_WED__c )
       	    {
                daysToInclude.add('Wed');
            }
            if(sod.INCLUDE_THU__c )
       	    {
                daysToInclude.add('Thu');
            }
            if(sod.INCLUDE_FRI__c )
       	    {
                daysToInclude.add('Fri');
            }
            if(sod.INCLUDE_SAT__c )
       	    {
                daysToInclude.add('Sat');
            }
            if(sod.INCLUDE_SUN__c )
       	    {
                daysToInclude.add('Sun');
            }
            for(Integer i = 0; i< Duration; i++)
            {
          		 days.add(UTIL_Date.giveWeekDayName(serviceStartDay.addDays(i)));
            }
            boolean flag = true; 

            for(String day:daysToInclude)
            {
                if(!days.contains(day))
                {
                    flag=false;
                    break;
                }
            }
            
           if(flag)
           {
             return VALID_CHECK_MESSGAE;
          
           }
           else
           {
	     	 errorMesage = System.Label.Included_Day_Match;
	      	
	       }
        }
        catch(Exception e)
        {
            errorMesage = 'validateIncludedDays:>>' +e.getMessage();
        }
       return errorMesage;              
    }
    
    public static String validateRoomConfiguration(SOD__c sod, String roomConfiguration)
    {
       String errorMessage = '';
        try{
       		  if (roomConfiguration!=null && roomConfiguration.length() > 0 &&
                 (sod.SINGLE_AVAIL__c  && roomConfiguration == 'SINGLE AVAIL' 
	               || sod.TWIN_AVAIL__c && roomConfiguration == 'TWIN AVAIL'
	               || sod.DOUBLE_AVAIL__c && roomConfiguration == 'DOUBLE AVAIL'
	               || sod.TRIPLE_AVAIL__c && roomConfiguration == 'TRIPLE AVAIL'
	               || sod.QUAD_AVAIL__c && roomConfiguration == 'QUAD AVAIL'
	               || sod.OTHER_AVAIL__c && roomConfiguration == 'OTHER AVAIL'
	                ))
                   
     		 {
                return VALID_CHECK_MESSGAE;
             }
            else
            {
               errorMessage =System.Label.Room_Configuration_Match+sod.Id;
            }
        }
        catch(Exception e)
        {
            errorMessage = 'validateRoomConfiguration:>>' + e.getMessage();
        }
       return errorMessage;       
    }
    
    public static String validateAdultIncluded(SOD__c sod , List<Passenger__c> adultPassengers, String roomConfiguration)
    {
        String errorMessage = '';
        try
        {
            System.debug('sod>>'+sod);
           Integer noofAdultPassenger = adultPassengers.size();
           if (noofAdultPassenger >= 1 &&
               (roomConfiguration =='SINGLE AVAIL' && sod.SINGLE_AD_MAX__c  >= noofAdultPassenger )
                   ||(roomConfiguration =='TRIPLE AVAIL' && sod.TRIPLE_AD_MAX__c >= noofAdultPassenger)
                   ||(roomConfiguration =='DOUBLE AVAIL' &&sod.DOUBLE_AD_MAX__c >= noofAdultPassenger)
                   ||(roomConfiguration =='TWIN AVAIL' &&sod.TWIN_AD_MAX__c >= noofAdultPassenger)
                   ||(roomConfiguration =='QUAD AVAIL' &&sod.QUAD_AD_MAX__c >= noofAdultPassenger)
                   ||(roomConfiguration =='OTHER AVAIL' &&sod.OTHER_AD_MAX__c >= noofAdultPassenger)
                    )
                       
	          {
	                 return VALID_CHECK_MESSGAE;
	          }
	         else
	         {
	                  errorMessage = System.Label.Adult_Count+sod.Id;
	         }
        }
        catch(Exception e)
        {
            errorMessage = 'validateAdultIncluded:>>' + e.getMessage();
        }
       return errorMessage;       
    }
    
    
    public static String validateTotalPaxIncluded(SOD__c sod , List<Passenger__c> totalPassengers, String roomConfiguration)
    {
        String errorMessage = '';
        try{
        Integer totalNumberOfPassengers  = totalPassengers.size();
        system.debug('totalNumberOfPassengers'+totalNumberOfPassengers);
        if(  totalNumberOfPassengers >=1 
            &&(
              (roomConfiguration =='SINGLE AVAIL' && sod.SINGLE_MAX__c >= totalNumberOfPassengers)
              ||(roomConfiguration =='DOUBLE AVAIL' && sod.DOUBLE_MAX__c >= totalNumberOfPassengers)
              ||(roomConfiguration =='TWIN AVAIL' && sod.TWIN_MAX__c >= totalNumberOfPassengers)
              ||(roomConfiguration =='TRIPLE AVAIL' && sod.TRIPLE_MAX__c >= totalNumberOfPassengers)
              ||(roomConfiguration =='QUAD AVAIL' && sod.QUAD_MAX__c >= totalNumberOfPassengers)
              ||(roomConfiguration =='OTHER AVAIL' && sod.OTHER_MAX__c >= totalNumberOfPassengers)))
          {    
            errorMessage = VALID_CHECK_MESSGAE;
          }         
          else
          {
          	errorMessage =System.Label.Age_Criteria_Total_Pax+sod.Id;
          } 
        }
        catch(Exception e)        
        {
            errorMessage = 'validateTotalPaxIncluded:>>' + e.getMessage();
        }
       return errorMessage;              
    }
    
    public static String validateInfantsAndChildAgeIncluded(SOD__c sod ,
    														List<Passenger__c> kidsAndAdultPassengers,
    														List<Passenger__c> allPassengers)
    {
        String errorMessage = '';
        try
        {
        if(!kidsAndAdultPassengers.isEmpty())
        for(Passenger__c p: kidsAndAdultPassengers)
        {
          
            if(p.PassengerType__c =='Child'
            	 &&
	            (sod.CHILD_FROM__c <=Integer.valueof(p.Given_Age__c) &&
	            sod.CHILD_TO__c >=Integer.valueof(p.Given_Age__c)))
            {
                errorMessage =  VALID_CHECK_MESSGAE;
            
           }
            else if(sod.INFANT_FROM__c <=Integer.valueof(p.Given_Age__c)
                    && sod.INFANT_TO__c>=Integer.valueof(p.Given_Age__c))
            {
                
                errorMessage =  VALID_CHECK_MESSGAE;
            }
            
            else
            {
	                for(Passenger__c allp: allPassengers)
	                {
	                   if(p.PassengerType__c=='Child')
	                   {
		                    if(sod.CHILD_FROM__c > 1
	                          && Integer.valueOf(p.Given_Age__c) > sod.CHILD_TO__c)
		                    {
			                    if(allp == p)
			                    {
			                        allp.PassengerType__c ='Adult';
			                    }
		                    }
		                    else
		                    {
		                    	 errorMessage = System.Label.Kids_Not_Allowed+sod.Id;
	                        }
	                   } 
	                   
	                   if(p.PassengerType__c=='Infant')
	                   {
	                    if(sod.INFANT_FROM__c > 1
                           && Integer.valueOf(p.Given_Age__c) > sod.INFANT_TO__c)
	                    {
	                    	if(allp == p)
		                    {
		                        allp.PassengerType__c ='Adult';
		                    }
	                    }
	                    else
	                    {
	                    	 errorMessage = System.Label.Kids_Not_Allowed+sod.Id;
	                    }
	                   }
	                }
            } 
         }         
        }
        catch(Exception e)
        {
            errorMessage = System.Label.Kids_Not_Allowed+ e.getMessage();
        }
       return errorMessage;              
    }
}
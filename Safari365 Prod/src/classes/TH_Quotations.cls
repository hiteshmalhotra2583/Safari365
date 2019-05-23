public class TH_Quotations extends BaseTriggerHandler{

    private static final String CLASS_NAME = TH_Quotations.class.getName();
    private List<Quotations__c> newQuotationsList;
    private List<Quotations__c> oldQuotationsList;
    private Map<ID, Quotations__c > newQuotationsMap;
    private Map<ID, Quotations__c > oldQuotationsMap;
    private static final String DAY='Day';
    private static final String QUOTATION_LINE='Quotation Line';
   

    public TH_Quotations() 
    {
        oldQuotationsList = (List<Quotations__c>)Trigger.old;
        newQuotationsList = (List<Quotations__c>)Trigger.new;
        newQuotationsMap =  (Map<ID, Quotations__c>)Trigger.newMap;
        oldQuotationsMap = (Map<ID, Quotations__c>)Trigger.oldMap;
    }
    
    protected override void beforeInsert()
    {
        if(Trigger_PAD.canRun('TH_Quotations'))
        {
            updateROEValues(); 
        }       
    }
    
    protected override void beforeupdate()
    {
        if(Trigger_PAD.canRun('TH_Quotations'))
        {
            updateROEValues();
            updateConfirmedStatus(); 
        }       
    }
    
   protected override void afterInsert()
   {
       if(Trigger_PAD.canRun('TH_Quotations'))
       { 
            List<Id> ids = new List<Id>();
            for(Quotations__c q:newQuotationsList)
            {
                ids.add(q.Id);
            }
            List<Quotations__c> allQuotations= DAL_Quotations.getAllQuotations(ids);
            List< QuotationLineItem__c > quotationsItemsToCreate= new List< QuotationLineItem__c >();
            for(Quotations__c quo : allQuotations)
            {
              Integer numberOfDays = quo.TravelStartDate__c.daysBetween(quo.TravelEndDate__c) + 1;  
              quotationsItemsToCreate = createQuotationLineItem(quo.Id,numberOfDays, quo.TravelStartDate__c);
            }
       
            if (!quotationsItemsToCreate.isEmpty()) 
            {
              DAL_BaseObject.InsertDBObjects(quotationsItemsToCreate);
            }
            
             changeOLdQuotationValues(); 
             upsertQuotationHistory(true); 
       }
  }
  
  
   protected override void afterUpdate()
   {
    if(Trigger_PAD.canRun('TH_Quotations') )
    {
         isQuotationConfirmedEarlier();
         updateOpportunityWithValues();
         updateQuotationLineItemIncaseOfUpdate();
         processChargeTypeForPhotoBookAndInsurance();
         upsertQuotationHistory(false);
         upadteChargeTypeOverrideNetCostFlag();
       }
   }
   
   public void upsertQuotationHistory(Boolean afterInsertFlag)
   {
       List<Quotation_History__c> quotationHistorys = new List<Quotation_History__c>();
       for(Quotations__c newQuotation : newQuotationsList)
       {
           
           if(afterInsertFlag
                 && newQuotation.Quotation_Stage__c =='Raised Invoice')
           {
               quotationHistorys.add(createQuotationHistoryRecord(newQuotation));
           }
           
           else if(newQuotation.Quotation_Stage__c =='Raised Invoice' 
               && oldQuotationsMap.get(newQuotation.Id).Quotation_Stage__c != 'Raised Invoice' )
           {
              quotationHistorys.add(createQuotationHistoryRecord(newQuotation));
           }
       }
       
      if(!quotationHistorys.isEmpty())
      {
          upsert quotationHistorys;
      }
   }
   
    private Quotation_History__c createQuotationHistoryRecord(Quotations__c newQuotation)
    {
        Quotation_History__c qH = new Quotation_History__c();
        qH.Date_Confirmed__c = system.today();
        qH.Internal_EUR_Exchange__c = newQuotation.ROE_EUR_to_ZAR__c;
        qH.Internal_Reporting_Cost_Total__c = newQuotation.Total_Cos_in_ZAR__c;
        qH.Internal_Quotation_Sale_Total__c = newQuotation.Total_Sale_In_Zar__c;
        qH.Internal_USD_Exchange__c = newQuotation.ROE_USD_to_ZAR__c;
        qH.Internal_ZAR_Exchange__c = newQuotation.ROE_ZAR_to_ZAR__c;
        qH.Sale_Total_in_Selected_CC__c =newQuotation.Quotation_Sale_Total_in_Selected_CC__c;
        qH.Internal_USD_Quotation_Cost_Total__c = newQuotation.Total_Cos_in_USD__c;
        qH.Internal_EUR_Quotation_Cost_Total__c = newQuotation.COS_in_EUR__c; 
        qH.Internal_USD_Quotation_Cost_Total__c = newQuotation.Total_Sale_In_USD__c;
        qH.Internal_EUR_Quotation_Sale_Total__c = newQuotation.Sale_in_EUR__c; 
        qH.Quotation__c =newQuotation.Id;
        
        return qH;
    }
 
   
    public void updateConfirmedStatus()
    {
        for(Quotations__c q : newQuotationsList)
        {
            if(q.Quotation_Stage__c =='Confirmed')
             {
                q.Primary_by_Consultant__c = true;
                q.Confirmed__c = true;
             }
        }
    }
   
   public static void updateRelatedOpportunityDates(Quotations__c quatation,
                                                     Opportunity opp , boolean confirmed){
      
      UTIL_LogGenerator logger = new UTIL_LogGenerator();
      logger.start(CLASS_NAME,'updateRelatedOpportunityDates' );
      //Opportunity opp = new Opportunity(Id=quatation.Opportunity__c);
      Date QuatationstartDate = quatation.TravelStartDate__c;
      Date QuotationEndDate = quatation.TravelEndDate__c;
      Date existingOpportunityStartDate = opp.Arrival_Date__c;
      Date existingOpportunityEndDate = opp.TravelEndDate__c;
      
      if( null == existingOpportunityStartDate
             || QuatationstartDate < existingOpportunityStartDate) 
      {
        opp.Arrival_Date__c = QuatationstartDate;
        
      }
      else if(confirmed == true){
      	  opp.Arrival_Date__c =quatation.TravelStartDate__c;
      }
      
      if(null ==existingOpportunityEndDate 
            || QuotationEndDate > existingOpportunityEndDate)
      {
        opp.TravelEndDate__c = QuotationEndDate;
      }
      else if(confirmed == true)
      {
      	opp.TravelEndDate__c = quatation.TravelEndDate__c;
      }
       
       if(confirmed == false)
       {
         opp.closeDate=system.today().addDays(Integer.valueof(system.Label.Opportunity_Close_Day));
       }
       
       if(confirmed == true)
       {
         opp.Has_Confirmed_Quotation__c = true;
       }
         
      if(quatation.Client_Fund_Recieved__c ==true)
         opp.Client_Currency_Locked__c =true;
     
       logger.end();
      //return opp; 
     }
   
   
   public void changeOLdQuotationValues()
   {
        Set<Id> OppSet = new Set<Id>();
        List<Id> quotationIds = new List<Id>();
        for (Quotations__c tlq : newQuotationsList)
        {  
            if (tlq.Primary_by_Consultant__c == false)
            {
                OppSet.add(tlq.Opportunity__c);
            }
            quotationIds.add(tlq.Id);
             
        }
       
        // query for the tlqs in the context to update
        List<Quotations__c> oldQuotationList = DAL_Quotations.getOldQuotationForSameOpportunituy(OppSet,quotationIds);
        for (Quotations__c tl : oldQuotationList)
        {
            tl.Primary_Quotation__c = false;
        }
        
        // commit the records 
        if(!oldQuotationList.isEmpty())
        {
        BaseTriggerHandler.bypass('TH_Quotations');
        update oldQuotationList; 
        BaseTriggerHandler.clearBypass('TH_Quotations');
        }
   }
   
   
   public void createChargeTypeForPhotoBookAndInsurance()
   {
         Set<Id> quatationIdsToProcessInsuranceForUSD = new Set<Id>();
         Set<Id> quatationIdsToProcessInsuranceForZAR = new Set<Id>();
         Set<Id> quatationIdsToPhotoBookProcessForZAR = new Set<Id>();
         Set<Id> quatationIdsToPhotoBookProcessForUSD = new Set<Id>();
         
         for(Id qid: newQuotationsMap.keySet())
         {
            if( newQuotationsMap.get(qid).Include_Passenger_Insurance_USD__c == true
               && oldQuotationsMap.get(qid).Include_Passenger_Insurance_USD__c == false)
            {
                quatationIdsToProcessInsuranceForUSD.add(qid);
                continue;
            }
            if( newQuotationsMap.get(qid).Include_Passenger_Insurance_ZAR__c == true
               && oldQuotationsMap.get(qid).Include_Passenger_Insurance_ZAR__c == false)
            {
                quatationIdsToProcessInsuranceForZAR.add(qid);
                continue;
            }
            if( newQuotationsMap.get(qid).Include_Photobooks_USD__c == true
                   && oldQuotationsMap.get(qid).Include_Photobooks_USD__c == false
                   && newQuotationsMap.get(qid).No_of_PhotoBook__c > 0)
            {
                quatationIdsToPhotoBookProcessForUSD.add(qid);
                continue;
                
            }
                
            if( newQuotationsMap.get(qid).Include_Photobooks_ZAR__c == true
               && oldQuotationsMap.get(qid).Include_Photobooks_ZAR__c == false 
               && newQuotationsMap.get(qid).No_of_PhotoBook__c > 0)
            {
                quatationIdsToPhotoBookProcessForZAR.add(qid);
                continue;
            }
        }
        
         Set<Id> allQuotationIds = new Set<Id>();
         allQuotationIds.addAll(quatationIdsToProcessInsuranceForUSD);
         allQuotationIds.addAll(quatationIdsToProcessInsuranceForZAR);
         allQuotationIds.addAll(quatationIdsToPhotoBookProcessForUSD);
         allQuotationIds.addAll(quatationIdsToPhotoBookProcessForZAR);
         Map<Id,ServiceLineItem__c> serviceLineItemExtraCosts =null;
         Map<Id,List<Passenger__c>> passengerToBeSaved = null;
         Passenger__c primaryPassenger = null;
         if(!allQuotationIds.isEmpty())
         {
              Map<Id,Id> quotationLineItemsMap = DAL_Quotations.getAllQuotationsLineItemsMaxEndDates(allQuotationIds);
              
              serviceLineItemExtraCosts = DAL_Quotations.getQuotationExtraCostingServiceLineItem(new List<Id>(allQuotationIds));
              passengerToBeSaved = getPassengerForQuotation(new List<Id>(allQuotationIds));
             
             
             List<ServiceLineItemWrapper> sliWrappers = createServiceLineItemForAll(allQuotationIds,quotationLineItemsMap,serviceLineItemExtraCosts,passengerToBeSaved);
             List<ServiceLineItem__c> ServiceLineItemsToBeSaved = new List<ServiceLineItem__c>();
             List<ServiceLineItemPassengersMapping__c> ServiceLineItemPassengersMappingToBeSaved = new List<ServiceLineItemPassengersMapping__c>();
             
             for(ServiceLineItemWrapper wrapper:sliWrappers)
             {
               ServiceLineItemsToBeSaved.add(wrapper.ServiceLineItem);
               ServiceLineItemPassengersMappingToBeSaved.addAll(wrapper.ServiceLineItemPassengersMappings);
             }
          
             DAL_BaseObject.InsertDBObjects(ServiceLineItemsToBeSaved);
             DAL_BaseObject.InsertDBObjects(ServiceLineItemPassengersMappingToBeSaved);
            
             serviceLineItemExtraCosts = DAL_Quotations.getQuotationExtraCostingServiceLineItem(new List<Id>(allQuotationIds)); 
             List<Service_Line_Item_ChargeType__c> chargeTypes = new List<Service_Line_Item_ChargeType__c>();
             
             Additional_Cost__c photoBookCost = Additional_Cost__c.getValues('Photobook Additional Cost In');
             Additional_Cost__c travelInsuranceCost = Additional_Cost__c.getValues('Travel Insurance');
             
             Decimal photoBookCostUSD = photoBookCost.Value_In_USD__c;
             Decimal photoBookCostZAR = photoBookCost.Value_In_ZAR__c;
            
             Decimal travelInsuranceCostUSD =  travelInsuranceCost.Value_In_USD__c;
             Decimal travelInsuranceCostZAR =  travelInsuranceCost.Value_In_ZAR__c;
             
            for(Id qid: newQuotationsMap.keySet())
            {
                ServiceLineItem__c serviceLineItem = serviceLineItemExtraCosts.get(qid);
                List<Passenger__c> passeners = passengerToBeSaved.get(qid);
                Decimal perPassengerphotoBookCostUSD  = ((photoBookCostUSD * newQuotationsMap.get(qid).No_of_PhotoBook__c) /passeners.size()).setscale(2);
                Decimal perPassengerphotoBookCostZAR = ((photoBookCostZAR * newQuotationsMap.get(qid).No_of_PhotoBook__c) /passeners.size()).setscale(2);
                if( newQuotationsMap.get(qid).Include_Passenger_Insurance_USD__c == true
                   && oldQuotationsMap.get(qid).Include_Passenger_Insurance_USD__c == false)
                {
                    //Create insurance charge type for USD
                    for(Passenger__c p:passeners)
                    {
                        chargeTypes.add(createServiceLineItemChargeTypeForInsurance(p, serviceLineItem,'USD',
                                       'Include Passenger Insurance USD',travelInsuranceCostUSD,false,true));
                    }
                }
                if( newQuotationsMap.get(qid).Include_Passenger_Insurance_ZAR__c == true
                   && oldQuotationsMap.get(qid).Include_Passenger_Insurance_ZAR__c == false)
                {
                    for(Passenger__c p:passeners)
                    {
                        chargeTypes.add(createServiceLineItemChargeTypeForInsurance(p, serviceLineItem,'ZAR',
                                       'Include Passenger Insurance ZAR',travelInsuranceCostZAR,false,true));
                    }
                }
                if( newQuotationsMap.get(qid).Include_Photobooks_USD__c == true
                   && oldQuotationsMap.get(qid).Include_Photobooks_USD__c == false
                   && newQuotationsMap.get(qid).No_of_PhotoBook__c > 0)
                {
                    //Create photobook charge type for USD
                    for(Passenger__c p:passeners)
                    {
                       chargeTypes.add(createServiceLineItemChargeTypeForInsurance(p, serviceLineItem,'USD',
                                       'Include Photobooks USD',perPassengerphotoBookCostUSD,true,false));
                    } 
                }
                        
                if( newQuotationsMap.get(qid).Include_Photobooks_ZAR__c == true
                   && oldQuotationsMap.get(qid).Include_Photobooks_ZAR__c == false
                   && newQuotationsMap.get(qid).No_of_PhotoBook__c > 0)
                {
                   //Create photobook charge type for ZAR
                   for(Passenger__c p:passeners)
                   {
                       chargeTypes.add(createServiceLineItemChargeTypeForInsurance(p, serviceLineItem,'ZAR',
                                       'Include Photobooks ZAR',perPassengerphotoBookCostZAR,true,false));
                   } 
                }
            }
             if(!chargeTypes.isEmpty())
             {
                DAL_BaseObject.InsertDBObjects(chargeTypes);
             }
        }
   }
  
   public void deleteChargeTypeForPhotoBookAndInsurance()
   {
       Set<Id> quatationIdsToProcessInsuranceForUSD = new Set<Id>();
       Set<Id> quatationIdsToProcessInsuranceForZAR = new Set<Id>();
       Set<Id> quatationIdsToPhotoBookProcessForZAR = new Set<Id>();
       Set<Id> quatationIdsToPhotoBookProcessForUSD = new Set<Id>();
       
       for(Id qid: newQuotationsMap.keySet())
       {
           if( newQuotationsMap.get(qid).Include_Passenger_Insurance_USD__c == false
              &&oldQuotationsMap.get(qid).Include_Passenger_Insurance_USD__c == true)
           {
               quatationIdsToProcessInsuranceForUSD.add(qid);
               continue;
           }
           if( newQuotationsMap.get(qid).Include_Passenger_Insurance_ZAR__c == false
              &&oldQuotationsMap.get(qid).Include_Passenger_Insurance_ZAR__c == true)
           {
               quatationIdsToProcessInsuranceForZAR.add(qid);
               continue;
           }
           if( newQuotationsMap.get(qid).Include_Photobooks_USD__c == false
              && oldQuotationsMap.get(qid).Include_Photobooks_USD__c == true
              && newQuotationsMap.get(qid).No_of_PhotoBook__c > 0)
           {
               quatationIdsToPhotoBookProcessForUSD.add(qid);
               continue;
               
           }
           
           if( newQuotationsMap.get(qid).Include_Photobooks_ZAR__c == false
              && oldQuotationsMap.get(qid).Include_Photobooks_ZAR__c == true 
              && newQuotationsMap.get(qid).No_of_PhotoBook__c > 0)
           {
               quatationIdsToPhotoBookProcessForZAR.add(qid);
               continue;
           }
       }
       
       List<Id> allQuotationIds = new List<Id>();
       allQuotationIds.addAll(quatationIdsToProcessInsuranceForUSD);
       allQuotationIds.addAll(quatationIdsToProcessInsuranceForZAR);
       allQuotationIds.addAll(quatationIdsToPhotoBookProcessForUSD);
       allQuotationIds.addAll(quatationIdsToPhotoBookProcessForZAR);
       
       Map<Id,ServiceLineItem__c> serviceLineItemsToDelete =
       DAL_Quotations.getQuotationExtraCostingServiceLineItem(allQuotationIds);
       
       Set<Id> allServiceLineItemIds = new Set<Id>();
       Set<String> chargeTypes = new Set<String>();
       
       for(Id qid:allQuotationIds)
       {
           ServiceLineItem__c sli = serviceLineItemsToDelete.get(qid);
           if(null !=sli )
           allServiceLineItemIds.add(sli.Id);
       }
       
       chargeTypes.add('Include Passenger Insurance USD');
       chargeTypes.add('Include Passenger Insurance ZAR');
       chargeTypes.add('Include Photobooks USD');
       chargeTypes.add('Include Photobooks ZAR');
       Map<Id,List<ServiceLineItemPassengersMapping__c>> servicePssengersToDelete =
       DAL_Quotations.getPassengerForServiceLineItems(allServiceLineItemIds);
       
       Map<Id,List<Service_Line_Item_ChargeType__c>> serviceChargeTypes =
       DAL_Quotations.getServiceChargeTypeForPassengerInsurance(allServiceLineItemIds,chargeTypes);
       
       List<ServiceLineItemWrapper> itemsToDelete = new List<ServiceLineItemWrapper>();
       for(Id qid: newQuotationsMap.keySet())
       {
           if( newQuotationsMap.get(qid).Include_Passenger_Insurance_USD__c == false
              &&oldQuotationsMap.get(qid).Include_Passenger_Insurance_USD__c == true)
           {
               //Delete insurance charge type for USD
               ServiceLineItemWrapper sliWrapper = DeleteServiceLineItems(serviceLineItemsToDelete,
                                                                          serviceChargeTypes,
                                                                          servicePssengersToDelete,
                                                                          newQuotationsMap.get(qid),
                                                                          'Include Passenger Insurance USD');
               if(sliWrapper != null)
               {
                   itemsToDelete.add(sliWrapper);
               }
           }
           if( newQuotationsMap.get(qid).Include_Passenger_Insurance_ZAR__c == false
              && oldQuotationsMap.get(qid).Include_Passenger_Insurance_ZAR__c == true)
           {
               //Delete insurance charge type for ZAR
               ServiceLineItemWrapper sliWrapper = DeleteServiceLineItems(serviceLineItemsToDelete,
                                                                          serviceChargeTypes,
                                                                          servicePssengersToDelete,
                                                                          newQuotationsMap.get(qid),
                                                                          'Include Passenger Insurance ZAR');
               if(sliWrapper!= null)
               {
                   itemsToDelete.add(sliWrapper);
               }
           }
           if( newQuotationsMap.get(qid).Include_Photobooks_USD__c == false
              && oldQuotationsMap.get(qid).Include_Photobooks_USD__c == true )
           {
               //Delete photobook charge type for USD
               ServiceLineItemWrapper sliWrapper = DeleteServiceLineItems(serviceLineItemsToDelete,
                                                                          serviceChargeTypes,
                                                                          servicePssengersToDelete,
                                                                          newQuotationsMap.get(qid),
                                                                          'Include Photobooks USD');
               if(sliWrapper!= null)
               {
                   itemsToDelete.add(sliWrapper);
               }
           }
           
           if( newQuotationsMap.get(qid).Include_Photobooks_ZAR__c == false
              && oldQuotationsMap.get(qid).Include_Photobooks_ZAR__c == true)
           {
               //Delete photobook charge type for ZAR
               ServiceLineItemWrapper sliWrapper = DeleteServiceLineItems(serviceLineItemsToDelete,
                                                                          serviceChargeTypes,
                                                                          servicePssengersToDelete,
                                                                          newQuotationsMap.get(qid),
                                                                          'Include Photobooks ZAR');
               if(sliWrapper!= null)
               {
                   itemsToDelete.add(sliWrapper);
               }
           }
       }
         
       if(!itemsToDelete.isEmpty())
       {
           List<ServiceLineItem__c> sliToDelete = new List<ServiceLineItem__c>();
           List<Service_Line_Item_ChargeType__c> chargeTypesToDelete = new List<Service_Line_Item_ChargeType__c>();
           List<ServiceLineItemPassengersMapping__c> passengerMappingToDelete = new List<ServiceLineItemPassengersMapping__c>();
           
           for(ServiceLineItemWrapper item:itemsToDelete)
           {
               chargeTypesToDelete.addAll(item.ChargeTypes);
               if(item.ProcessChilds)
               {
                   sliToDelete.add(item.ServiceLineItem);
                   passengerMappingToDelete.addAll(item.ServiceLineItemPassengersMappings);
               }
           }
           if(!chargeTypesToDelete.isEmpty())
           {
               DAL_BaseObject.DeleteDBObjects(chargeTypesToDelete);
           }
           if(!passengerMappingToDelete.isEmpty())
           {
               DAL_BaseObject.DeleteDBObjects(passengerMappingToDelete);
           }
           if(!sliToDelete.isEmpty())
           {
               DAL_BaseObject.DeleteDBObjects(sliToDelete);
           }
       }  
   }
   
   public void processChargeTypeForPhotoBookAndInsurance()
   {
        Boolean canCreateChargeTypeForPhotoBookAndInsurance = false;
        Boolean canDeleteChargeTypeForPhotoBookAndInsurance = false;
        
        for(Id qid: newQuotationsMap.keySet())
         {
            if( newQuotationsMap.get(qid).Include_Passenger_Insurance_USD__c == true
               && oldQuotationsMap.get(qid).Include_Passenger_Insurance_USD__c == false)
            {
                canCreateChargeTypeForPhotoBookAndInsurance=true;
                break;
            }
            if( newQuotationsMap.get(qid).Include_Passenger_Insurance_ZAR__c == true
               && oldQuotationsMap.get(qid).Include_Passenger_Insurance_ZAR__c == false)
            {
                canCreateChargeTypeForPhotoBookAndInsurance=true;
                break;
            }
            
            if( newQuotationsMap.get(qid).Include_Passenger_Insurance_USD__c == true
               && oldQuotationsMap.get(qid).Include_Passenger_Insurance_USD__c == true)
            {
                canCreateChargeTypeForPhotoBookAndInsurance=true;
                break;
            }
            if( newQuotationsMap.get(qid).Include_Passenger_Insurance_ZAR__c == true
               && oldQuotationsMap.get(qid).Include_Passenger_Insurance_ZAR__c == true)
            {
                canCreateChargeTypeForPhotoBookAndInsurance=true;
                break;
            }
            
            
            if( newQuotationsMap.get(qid).Include_Photobooks_USD__c == true
                   && oldQuotationsMap.get(qid).Include_Photobooks_USD__c == false
                   && newQuotationsMap.get(qid).No_of_PhotoBook__c > 0)
            {
                canCreateChargeTypeForPhotoBookAndInsurance=true;
                break;
                
            }
                
            if( newQuotationsMap.get(qid).Include_Photobooks_ZAR__c == true
               && oldQuotationsMap.get(qid).Include_Photobooks_ZAR__c == false 
               && newQuotationsMap.get(qid).No_of_PhotoBook__c > 0)
            {
                canCreateChargeTypeForPhotoBookAndInsurance=true;
                break;
            }
         }
         for(Id qid: newQuotationsMap.keySet())
         {
            if( newQuotationsMap.get(qid).Include_Passenger_Insurance_USD__c == false
               && oldQuotationsMap.get(qid).Include_Passenger_Insurance_USD__c == true)
            {
                canDeleteChargeTypeForPhotoBookAndInsurance = true;
                break;
            }
            if( newQuotationsMap.get(qid).Include_Passenger_Insurance_ZAR__c == false
               && oldQuotationsMap.get(qid).Include_Passenger_Insurance_ZAR__c == true)
            {
                canDeleteChargeTypeForPhotoBookAndInsurance = true;
                break;
            }
            if( newQuotationsMap.get(qid).Include_Photobooks_USD__c == false
               && oldQuotationsMap.get(qid).Include_Photobooks_USD__c == true )
            {
               canDeleteChargeTypeForPhotoBookAndInsurance = true;
                break;
            }
            
            if( newQuotationsMap.get(qid).Include_Photobooks_ZAR__c == false
               && oldQuotationsMap.get(qid).Include_Photobooks_ZAR__c == true)
            {
                canDeleteChargeTypeForPhotoBookAndInsurance = true;
                break;
            }
         }
         
         if(canCreateChargeTypeForPhotoBookAndInsurance)
         {
            createChargeTypeForPhotoBookAndInsurance();
         }
         
         if(canDeleteChargeTypeForPhotoBookAndInsurance)
         {
            deleteChargeTypeForPhotoBookAndInsurance();
         } 
   
   }   
   
   public List<ServiceLineItemWrapper> createServiceLineItemForAll(Set<Id> allQuotationIds,
                                                                Map<Id,Id> quotationLineItemsMap,
                                                                Map<Id,ServiceLineItem__c> serviceLineItemExtraCosts,
                                                                Map<Id,List<Passenger__c>> passengerToBeSaved )
   {
        List<ServiceLineItemWrapper> ServiceLineItemWrappers = new List<ServiceLineItemWrapper>();
        for(Id qid:allQuotationIds )
        {
           if(serviceLineItemExtraCosts == null 
                || serviceLineItemExtraCosts.get(qid) == null
                || serviceLineItemExtraCosts.isEmpty())
           {
               ServiceLineItemWrappers.add(createServiceLineItem(passengerToBeSaved.get(qid),quotationLineItemsMap.get(qid)));
           }
        }
        return ServiceLineItemWrappers;
   }
   
   
    public ServiceLineItemWrapper createServiceLineItem(List<Passenger__c> passengerToBeSaved,
                                                         Id quotationLineItemId)
     {
        ServiceLineItemWrapper wrapper = new ServiceLineItemWrapper();
         
        ServiceLineItem__c ServiceLineItem = new ServiceLineItem__c();
        ServiceLineItem.Name='Quotation Extra Costing';
        ServiceLineItem.QuotationLine__c = quotationLineItemId;
        ServiceLineItem.Is_Quotation_Extra_Costing_Item__c = true;
        ServiceLineItem.Reservation_Number__c='Dummy Reservation';
        ServiceLineItem.Service_Status__c='Confirmed';
        wrapper.ServiceLineItem = ServiceLineItem;
        List<ServiceLineItemPassengersMapping__c> ServiceLineItemPassengersMappings = new List<ServiceLineItemPassengersMapping__c>();
        for(Passenger__c p:passengerToBeSaved)
        {
             ServiceLineItemPassengersMapping__c ServiceLineItemPassengersMapping = new ServiceLineItemPassengersMapping__c();
             ServiceLineItemPassengersMapping.Passenger__c = p.Id;
             ServiceLineItemPassengersMapping.Service_Line_Item__c = ServiceLineItem.Id;
             ServiceLineItemPassengersMappings.add(ServiceLineItemPassengersMapping);
         }
             
         wrapper.ServiceLineItemPassengersMappings = ServiceLineItemPassengersMappings;
         return wrapper;
         
     }
   
   
  
  public void updateQuotationLineItemIncaseOfUpdate()
  {
     Set<Id> quotationds = new Set<Id>(); 
     
     for(Quotations__c quo : newQuotationsList)
     {
         quotationds.add(quo.Id);
     }
     
     List<QuotationLineItem__c> existingQuotationLineItems = 
     DAL_Quotations.getAllQuotationsLineItems(new List<Id>(quotationds));
     
      List<QuotationLineItem__c> itemsToDelete = new List<QuotationLineItem__c>();
      List<QuotationLineItem__c> itemsToAdd = new List<QuotationLineItem__c>();
      
      for(Quotations__c quo : newQuotationsList)
      {
          Integer quotationItemcounter= 0;
          for(QuotationLineItem__c qli:existingQuotationLineItems)
          {
              if(qli.Quotation__c==quo.Id)
              {
                      quotationItemcounter = quotationItemcounter+1;
              }
          }
          
          Integer quotationTotalDays = quo.TravelStartDate__c.daysBetween(quo.TravelEndDate__c);
          if(quotationTotalDays > quotationItemcounter)
          {
              //add quotation Line Items
              for(Integer a = quotationItemcounter; a <= quotationTotalDays ; a++)
              {
                QuotationLineItem__c ql = new QuotationLineItem__c();
                ql.Day__c = (DAY+ (a+1));
                ql.Name = QUOTATION_LINE + (a+1);
                ql.Quotation__c = quo.Id; 
                ql.Line_Item_Date__c = quo.TravelStartDate__c.AddDays(a);
                ql.Format_Date__c = UTIL_Date.formatGivenDate(quo.TravelStartDate__c.AddDays(a));
                ql.Display_Count__c=a;
                itemsToAdd.add(ql);
              }
          }
          if(quotationTotalDays < quotationItemcounter)
          {
              //delete quotation Line Items
              for(QuotationLineItem__c qli:existingQuotationLineItems)
              {
                  if(qli.Quotation__c==quo.Id)
                  {
                      if(quo.TravelEndDate__c < qli.Line_Item_Date__c)
                      {
                          itemsToDelete.add(qli);
                      }
                  }
              }
          }
     }
     
     if (!itemsToAdd.isEmpty()) 
     {
         DAL_BaseObject.InsertDBObjects(itemsToAdd);
     }
     
     if (!itemsToDelete.isEmpty()) 
     {
         DAL_BaseObject.DeleteDBObjects(itemsToDelete);
     }
      
  }
  
  public List<QuotationLineItem__c> createQuotationLineItem(Id QuotationId,Integer count, Date travelStartDate)
  {
        List<QuotationLineItem__c> lineItems = new List<QuotationLineItem__c>();
        Date startDate  = travelStartDate;
        for(Integer a = 0; a <= count ; a++)
        {
            QuotationLineItem__c ql = new QuotationLineItem__c();
            ql.Day__c = (DAY+ (a+1));
            ql.Name = QUOTATION_LINE + (a+1);
            ql.Quotation__c = QuotationId; 
            ql.Line_Item_Date__c = startDate.addDays(a);
            Datetime dt = datetime.newInstance( ql.Line_Item_Date__c.year(),ql.Line_Item_Date__c.month(),ql.Line_Item_Date__c.day());
            ql.Format_Date__c = UTIL_Date.formatGivenDate(dt);
            ql.Display_Count__c = a;
            lineItems.add(ql);
        }
       
       return lineItems;
    }
  
  
 public void updateOpportunityWithValues()
  {
    List<Id> processQuotationIds = new List<Id>();
    Set<Id> opportunityIdSet = new Set<Id>();
    for(Quotations__c q:newQuotationsList)
    {
       opportunityIdSet.add(q.Opportunity__c);
       processQuotationIds.add(q.Id);
    }
    
    Map<Id,Opportunity> allOpportunity = DAL_Opportunity.getAllOpportunity(opportunityIdSet);
    List<Quotations__c> AllConfirmedQuotations = DAL_Quotations.getOldConfirmedQuotationForSameOpportunity(opportunityIdSet, processQuotationIds);
   
    Map<Id, List<Quotations__c>> oppIdKeyConfirmedQuotationsValues = new Map<Id, List<Quotations__c>>();
    for(Quotations__c confirmedQuotation : AllConfirmedQuotations )
    {
        List<Quotations__c> confirmedQuotations = null;
        if(oppIdKeyConfirmedQuotationsValues.get(confirmedQuotation.Opportunity__c) != null)
        {
            confirmedQuotations = oppIdKeyConfirmedQuotationsValues.get(confirmedQuotation.Opportunity__c) ;
        }
        else
        {
            confirmedQuotations  = new List<Quotations__c>();
        }
        confirmedQuotations.add(confirmedQuotation);
        
        oppIdKeyConfirmedQuotationsValues.put(confirmedQuotation.Opportunity__c,confirmedQuotations);
    }
    
    List<Opportunity> opportunityToUpdate = new List<Opportunity>();
    for(Quotations__c q:newQuotationsList)
    {
        if(null != allOpportunity.get(q.Opportunity__c))
        {
            Opportunity resetOpp = resetTheOpportunityCurrentValue(allOpportunity.get(q.Opportunity__c));
            boolean flag  = false;
            if(oppIdKeyConfirmedQuotationsValues.get(q.Opportunity__c) != null)
            {
                updateRelatedOpportunityDates(q,resetOpp, true);
                opportunityToUpdate.add(updateValue(resetOpp,oppIdKeyConfirmedQuotationsValues,q));
                flag =true;
            }
            
            if(q.Confirmed__c == true)
            {
               addQuotationValuesToOpp(q,resetOpp);
            }
            else if(! flag)
            {
                updateRelatedOpportunityDates(q,resetOpp, false);
                opportunityToUpdate.add(addQuotationValuesToOpp(q,resetOpp));
            }
        }
    }
    
    if(!opportunityToUpdate.isEmpty())
    {
       BaseTriggerHandler.bypass('OpportunityTriggerHandler');
       update opportunityToUpdate;
       BaseTriggerHandler.clearBypass('OpportunityTriggerHandler');
    }
  }
  
  public Opportunity resetTheOpportunityCurrentValue(Opportunity opportunity)
  {
         opportunity.Amount = null ;
         opportunity.CoS__c = null ;
         opportunity.Gross_Profit__c = null;
     
    return opportunity;
  }
  
  public Opportunity  updateValue(Opportunity opportunity , Map<Id, List<Quotations__c>> oppIdKeyConfirmedQuotationsValues, Quotations__c q)
  {
    for(Quotations__c q1: oppIdKeyConfirmedQuotationsValues.get(q.Opportunity__c))
    {
        addQuotationValuesToOpp(q1, opportunity);
    }
    
    return opportunity;
  }
   
   public static Opportunity addQuotationValuesToOpp(Quotations__c q, Opportunity opportunity)
   {
     Decimal cos = 0;
     Decimal grossProfit = 0;
     Decimal amount = 0;
     if(q.Quotation_Sale__c == NULL)
     {
        amount=0;
     }
     else
     {
        amount=q.Quotation_Sale__c;
     }
     if(q.Quotation_Cos__c == NULL)
     {
        cos=0;
     }
     else
     {
        cos=q.Quotation_Cos__c;
     }
    
     if(q.Quotation_Profit__c  == NULL)
     {
        grossProfit=0;
     }
     else
     {
        grossProfit=q.Quotation_Profit__c;
     }
      
     if( null !=  opportunity.Amount)
     {
         opportunity.Amount = opportunity.Amount + amount ;
     }
     else
     {
         opportunity.Amount = amount ;
     }
    
     if( null !=  opportunity.CoS__c)
     {
        opportunity.CoS__c = opportunity.CoS__c + cos ;
     }
     else
     {
         opportunity.CoS__c = cos ;
     }
     
     if( null !=  opportunity.Gross_Profit__c)
     {
        opportunity.Gross_Profit__c = opportunity.Gross_Profit__c + grossProfit;
     }
     else
     {
        opportunity.Gross_Profit__c = grossProfit;
     }
     system.debug('inside the addQuotationValuesToOpp block opportunity::'+opportunity);
     return opportunity;
   }
   
   public void isQuotationConfirmedEarlier()
   {
         Set<Id> opportunityIds = new Set<Id>();
         Map<Id,Quotations__c> opportunityIdQuotationMap  = new Map<Id,Quotations__c>();
         for(Quotations__c q : newQuotationsList)
         {
            if(newQuotationsMap.get(q.Id).Confirmed__c == false
                  &&oldQuotationsMap.get(q.Id).Confirmed__c == true)
            {
                opportunityIds.add(q.Opportunity__c);
                opportunityIdQuotationMap.put(q.Opportunity__c,q);
            }
         }
         
         if(!opportunityIds.isEmpty())
         {
              Map<Id,Opportunity> relatedOpportunity = DAL_Opportunity.getAllOpportunity(opportunityIds);
              List<Opportunity> oppToUpdate = new List<Opportunity>();
              Integer opportunitySize = relatedOpportunity.values().size();
              boolean flagHasConfirmed = false;
              if(opportunitySize ==1 )
              flagHasConfirmed = true;
              for(Opportunity opp: relatedOpportunity.values())
              {
                opp.Amount = opp.Amount - opportunityIdQuotationMap.get(opp.Id).Quotation_Sale__c;
                opp.CoS__c = opp.CoS__c-opportunityIdQuotationMap.get(opp.Id).Quotation_Cos__c;
                opp.Gross_Profit__c = opp.Gross_Profit__c-opportunityIdQuotationMap.get(opp.Id).Quotation_Profit__c;
                if(flagHasConfirmed)
                opp.Has_Confirmed_Quotation__c = false;
                
                oppToUpdate.add(opp);
              }
              
              if(!oppToUpdate.isEmpty())
              {
               
               BaseTriggerHandler.bypass('OpportunityTriggerHandler');
               update oppToUpdate;
               BaseTriggerHandler.clearBypass('OpportunityTriggerHandler');
          }
         }
   }
   
   public void updateROEValues()
   {
     List<ExchangeRates__c> exchangeRates = DAL_ExchangeRate.getCurrencyByBaseCurrency('ZAR');
     if(!exchangeRates.isEmpty())
     {
      
     for(Quotations__c quo : newQuotationsList)
     {
       if(quo.Quotation_Stage__c == 'Quoting')
      {
            quo.ROE_EUR_to_ZAR__c =(Decimal)exchangeRates[0].get('EUR__c');
            quo.ROE_USD_to_ZAR__c= (Decimal)exchangeRates[0].get('USD__c');
            quo.ROE_ZAR_to_ZAR__c= (Decimal)exchangeRates[0].get('ZAR__c');
            
            if(null != quo.Currency__c)
            {
                String baseCurrency = quo.Currency__c;
                Decimal newBaseValue = null;
                newBaseValue =((Decimal)exchangeRates[0].get('ZAR__c') / (Decimal)exchangeRates[0].get(baseCurrency +'__c'));
                quo.ROE_EUR_to_CC__c =(newBaseValue * (Decimal)exchangeRates[0].get('EUR__c'));
                quo.ROE_USD_to_CC__c= (newBaseValue * (Decimal)exchangeRates[0].get('USD__c'));
                quo.ROE_ZAR_to_CC__c= (newBaseValue * (Decimal)exchangeRates[0].get('ZAR__c'));
           }
       }   
      }
     }     
   } 
   
    public Map<Id,List<Passenger__c>> getPassengerForQuotation(List<Id> quotationIds)
    {
        List<PassengerQuotationMapping__c> PassengerQuotationMappings = [SELECT 
                                                                                Quotation__c,
                                                                                Passenger__c
                                                                           FROM 
                                                                                PassengerQuotationMapping__c 
                                                                          WHERE 
                                                                                Quotation__c IN:quotationIds] ;
        
        List<String> PassengerIds = new List<String>();
        Map<Id,Set<Id>> quotationPassengermapping = new Map<Id,Set<Id>>();
        Map<Id,List<Passenger__c>> result = new Map<Id,List<Passenger__c>>();
        
        for(Id qid:quotationIds)
        { 
            Set<Id> pIds = new Set<Id>();
            for(PassengerQuotationMapping__c pqm:PassengerQuotationMappings)
            {
                PassengerIds.add(pqm.Passenger__c);
                pIds.add(pqm.Passenger__c);
            }
            quotationPassengermapping.put(qid,pIds);
        }
        
        List<Passenger__c>  Passengers = DAL_Passenger.getByIds(PassengerIds);
        for(Id qid:quotationPassengermapping.keySet())
        {
            Set<Id> pIds = quotationPassengermapping.get(qid);
            List<Passenger__c>  PassengerForQuotation = new List<Passenger__c>();
            for(Passenger__c p :Passengers)
            {
                if(pIds.Contains(p.Id))
                {
                    PassengerForQuotation.add(p);
                }
            }
            result.put(qid,PassengerForQuotation);
        }
        return result;
    }
    
    public  Passenger__c  getPrimaryPassengerForQuotation(List<id> quotationIds)
    {
        List<PassengerQuotationMapping__c> PassengerQuotationMappings = [SELECT
                                                                                 Passenger__c 
                                                                            FROM 
                                                                                 PassengerQuotationMapping__c 
                                                                           WHERE 
                                                                                Quotation__c IN:quotationIds] ;
        
        List<String> PassengerIds = new List<String>();
        for(PassengerQuotationMapping__c pqm:PassengerQuotationMappings)
        {
            PassengerIds.add(pqm.Passenger__c);
        }
        
        List<Passenger__c>  Passengers = DAL_Passenger.getPrimaryByIds(PassengerIds);
        if(!Passengers.isEmpty())
        {
            return Passengers[0];    
        }
        else
        {
            return null;
        }
        
    }
    
     public ServiceLineItemWrapper createServiceLineItem(String quotationId,List<Passenger__c> passengerToBeSaved)
     {
        ServiceLineItemWrapper wrapper = new ServiceLineItemWrapper();
        AggregateResult[] quotationLineItem = DAL_Quotations.getAllQuotationsLineItemsMaxEndDate(quotationId);
        Date  maxDate = null;
        for(AggregateResult ar:quotationLineItem)
        {
            maxDate = (Date)ar.get('expr0');
        }
        
         List<QuotationLineItem__c>  quotationLineItems = DAL_Quotations.getQuotationLineItemByMaxEndDate(quotationId,maxDate);
         
         if(!quotationLineItems.isEmpty())
         {
            ServiceLineItem__c ServiceLineItem = new ServiceLineItem__c();
            ServiceLineItem.QuotationLine__c = quotationLineItems[0].Id;
            ServiceLineItem.Is_Quotation_Extra_Costing_Item__c = true;
            wrapper.ServiceLineItem = ServiceLineItem;
            List<ServiceLineItemPassengersMapping__c> ServiceLineItemPassengersMappings = new List<ServiceLineItemPassengersMapping__c>();
             for(Passenger__c p:passengerToBeSaved)
             {
                 ServiceLineItemPassengersMapping__c ServiceLineItemPassengersMapping = new ServiceLineItemPassengersMapping__c();
                 ServiceLineItemPassengersMapping.Passenger__c = p.Id;
                 ServiceLineItemPassengersMapping.Service_Line_Item__c = ServiceLineItem.Id;
                 ServiceLineItemPassengersMappings.add(ServiceLineItemPassengersMapping);
             }
             
             wrapper.ServiceLineItemPassengersMappings = ServiceLineItemPassengersMappings;
             return wrapper;
         }
         else
         {
             return null;
         }
     }
    
    private ServiceLineItemWrapper DeleteServiceLineItems(Map<Id,ServiceLineItem__c> serviceLineItemsToDelete,
                                                          Map<Id,List<Service_Line_Item_ChargeType__c>> serviceChargeTypes,
                                                          Map<Id,List<ServiceLineItemPassengersMapping__c>> passengersToDelete,
                                                          Quotations__c quotation,String chargeType)
    {
        
        ServiceLineItem__c  serviceLineItemToDelete = serviceLineItemsToDelete.get(quotation.Id);
        if(serviceLineItemToDelete== null)
        {
            return null;
        }
        
        List<Service_Line_Item_ChargeType__c> chargeTypeItems = serviceChargeTypes.get(serviceLineItemToDelete.Id);
        List<ServiceLineItemPassengersMapping__c> servicePssengersToDelete = passengersToDelete.get(serviceLineItemToDelete.Id);
        List<Service_Line_Item_ChargeType__c> chargeTypeItemToDelete = new List<Service_Line_Item_ChargeType__c>();
        
        for(Service_Line_Item_ChargeType__c cti:chargeTypeItems)
        {
            if(cti.Charge_Type__c == chargeType)
            {
                chargeTypeItemToDelete.add(cti);
            }
        }
        
        ServiceLineItemWrapper wrapper = new ServiceLineItemWrapper();
        
        wrapper.ChargeTypes = new List<Service_Line_Item_ChargeType__c>();
        wrapper.ServiceLineItemPassengersMappings = new List<ServiceLineItemPassengersMapping__c>();
        
        wrapper.ServiceLineItem = serviceLineItemToDelete;
        wrapper.ChargeTypes.addAll(chargeTypeItemToDelete);
        wrapper.ServiceLineItemPassengersMappings.addAll(servicePssengersToDelete);
        
        if(quotation.Include_Photobooks_USD__c==false 
           && quotation.Include_Photobooks_ZAR__c == false
          && quotation.Include_Passenger_Insurance_ZAR__c == false
          && quotation.Include_Passenger_Insurance_USD__c == false)
        {
            wrapper.ProcessChilds = true;
        }
        else
        {
            wrapper.ProcessChilds = false;
        }
        return wrapper;
    }
        
    
    
    public Service_Line_Item_ChargeType__c createServiceLineItemChargeTypeForInsurance(Passenger__c passenger, 
                                                                                       ServiceLineItem__c serviceLineItem, 
                                                                                       String insuranceCurrency,
                                                                                       String chargeType,
                                                                                       Decimal saleValue,
                                                                                       Boolean photoBook,
                                                                                       Boolean insurance)
    {
       Service_Line_Item_ChargeType__c serviceLineChargeType = new Service_Line_Item_ChargeType__c();
       try
       {
           serviceLineChargeType.Service_Line_Item__c = serviceLineItem.Id;
           serviceLineChargeType.Selected_Passenger__c = passenger.Id;
           serviceLineChargeType.Currency__c  = insuranceCurrency;
           serviceLineChargeType.Markup__c = 0;
           serviceLineChargeType.Nett_Cost__c =  0;
           serviceLineChargeType.Total__c = saleValue;
           serviceLineChargeType.Charge_Type__c = chargeType;
           serviceLineChargeType.Extra__c = chargeType;
           serviceLineChargeType.Category__c = 'Other Charge';
           serviceLineChargeType.Is_Additional_Cost__c= true;
           serviceLineChargeType.Additional_Cost_PhotoBook__c = photoBook;
           serviceLineChargeType.Additional_Cost_Insurance__c = insurance;
       }
       catch(Exception e)
       {
           throw new CustomException('createServiceLineItemChargeTypeForInsurance:>>' + e.getMessage());
       }
        
        return serviceLineChargeType;
    }
    
     public void upadteChargeTypeOverrideNetCostFlag()
    {
        List<Id> ids = new List<Id>();
        List<Id>  quatationsWithStageQuotingIds = new List<Id>();
        for(Quotations__c q:newQuotationsList)
        {
            if( q.Quotation_Stage__c !='Quoting' && 
                oldQuotationsMap.get(q.Id).Quotation_Stage__c != q.Quotation_Stage__c)
	        {
	            ids.add(q.Id);
	        }
	        
	        if( q.Quotation_Stage__c == 'Quoting' && 
                oldQuotationsMap.get(q.Id).Quotation_Stage__c != q.Quotation_Stage__c)
            {
                quatationsWithStageQuotingIds.add(q.Id);
            }
        }
        
        if(!ids.isEmpty())
        {
	        List<Service_Line_Item_ChargeType__c> existingChargetTypes = DAL_Quotations.getAllExistingChargeType(ids);
	        List<Service_Line_Item_ChargeType__c>  updateChargetTypes = new  List<Service_Line_Item_ChargeType__c>();
	        for(Service_Line_Item_ChargeType__c clt: existingChargetTypes)
	        {
	            clt.Override_Nett_Cost__c = true;
	            updateChargetTypes.add(clt);
	        }
	       
	        BaseTriggerHandler.bypass('TH_ServiceLineItemChargeType');
            update updateChargetTypes;
            BaseTriggerHandler.clearBypass('TH_ServiceLineItemChargeType');
        }
        
        if(!quatationsWithStageQuotingIds.isEmpty())
        {
            List<Service_Line_Item_ChargeType__c> existingChargetTypes = DAL_Quotations.getAllExistingChargeType(quatationsWithStageQuotingIds);
            List<Service_Line_Item_ChargeType__c>  updateChargetTypes = new  List<Service_Line_Item_ChargeType__c>();
            for(Service_Line_Item_ChargeType__c clt: existingChargetTypes)
            {
                clt.Override_Nett_Cost__c = false;
                updateChargetTypes.add(clt);
            }
           
            BaseTriggerHandler.bypass('TH_ServiceLineItemChargeType');
            update updateChargetTypes;
            BaseTriggerHandler.clearBypass('TH_ServiceLineItemChargeType');
        }
        
    }
    
}
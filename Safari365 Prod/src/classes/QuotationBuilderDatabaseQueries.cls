public class QuotationBuilderDatabaseQueries {
    
    private static final String CLASS_NAME = QuotationBuilderDatabaseQueries.class.getName();
    public static final String SERVICELINEITEM_OBJECT_NAME = ServiceLineItem__c.SObjectType.getDescribe().getLocalName();
    public static final String SERVICELINEITEMPASSENGER_OBJECT_NAME = ServiceLineItemPassengersMapping__c.SObjectType.getDescribe().getLocalName();
    private static final UTIL_LogGenerator logger = new UTIL_LogGenerator();
    
    public string getQuotationStageByLineItemId(String quotationLineId)
    {
        String stage ='';
        List<QuotationLineItem__c> quotationLines= [SELECT 
                                                           Id,
                                                           Quotation__r.Quotation_Stage__c
                                                      FROM 
                                                            QuotationLineItem__c
                                                      WHERE
                                                            Id=:quotationLineId];
        if(!quotationLines.isEmpty())
        {
            stage = quotationLines[0].Quotation__r.Quotation_Stage__c;
        }
        return stage;    
    }
    
    public string getQuotationStage(String quotationId)
    {
        String stage ='';
        List<Quotations__c > quotations= [SELECT
                                                 Id,
                                                 Quotation_Stage__c
                                            FROM 
                                                 Quotations__c
                                           WHERE
                                                 Id=:quotationId
                                            AND 
                                                 Client_Fund_Recieved__c =:true
                                            AND 
                                                 Confirmed__c =: true];
        if(!quotations.isEmpty())
        {
            stage = quotations[0].Quotation_Stage__c;
        }
        return stage;    
    }
    
    public boolean getPageDefaultOpenSetting() {
        return Quotation_Page_Default_Open__c.getInstance().Expand__c;
    }
    
    public List<String> UpdateServiceLineItem(String serviceLineItemId,
                                              String serviceClientNotes,
                                              String serviceReservationNumber,
                                              String serviceSupplierNotes,
                                              String serviceStatus, 
                                              String serviceExpiryDate,
                                              Boolean notOverrideNetCost)
    {
        
        List<String> ErrorMessageList = new List<String>();
        try
        {
            Set<String> quotationLineItemIds = new Set<String>();
            List<ServiceLineItem__c> serviceLineItemsToUpdate = new List<ServiceLineItem__c>();
            //Fetch All serviceLineItem
            List<ServiceLineItem__c> sliIds =[SELECT 
                                                       Id, 
                                                       QuotationLine__r.Quotation__c,
                                                       QuotationLine__r.Quotation__r.Quotation_Stage__c,
                                                       SupplierName__c,
                                                       Service_Duration__c
                                                  FROM 
                                                       ServiceLineItem__c 
                                                  WHERE
                                                       Id=:serviceLineItemId];
            
            String quotationId = sliIds[0].QuotationLine__r.Quotation__c;
            String quotationStage = sliIds[0].QuotationLine__r.Quotation__r.Quotation_Stage__c;
            if(quotationStage =='Confirmed' || quotationStage=='Raised Invoice')
            {
                ErrorMessageList.add('Quotation Stage is in Confirmed or Raised Invoice.This Quotation is not editable');
                return ErrorMessageList;
            }
            
            String supplierName = sliIds[0].SupplierName__c;
            List<QuotationLineItem__c> allQuotationLineItems = [SELECT
                                                                         Id
                                                                FROM 
                                                                        QuotationLineItem__c
                                                                WHERE 
                                                                       Quotation__c=:quotationId];
            
            for(QuotationLineItem__c qli:allQuotationLineItems)
            {
                quotationLineItemIds.add(qli.Id);
            }
            
            List<ServiceLineItem__c> allServiceLineItems = [SELECT 
                                                                    Id,
                                                                    Do_Not_Override_NetCost__c,
                                                                    Reservation_Number__c,
                                                                    ClientNotes__c,
                                                                    Supplier_Notes__c,
                                                                    Service_Status__c,
                                                                    Provisional_Booking_Expiry_Date__c,
                                                                    Service_Duration__c
                                                               FROM 
                                                                    ServiceLineItem__c
                                                              WHERE 
                                                                    QuotationLine__c IN:quotationLineItemIds
                                                               AND  
                                                                     SupplierName__c =:supplierName];             
            
            Integer currentServiceDuration = Integer.valueOf(sliIds[0].Service_Duration__c);
            string expiryDate = serviceExpiryDate + ' 00:00:00';                                                                          
            for(ServiceLineItem__c sli:allServiceLineItems)
            {
                if(Integer.valueOf(sli.Service_Duration__c) <= currentServiceDuration)
                {
                    sli.Do_Not_Override_NetCost__c = notOverrideNetCost;
                    sli.Reservation_Number__c = serviceReservationNumber;
                    sli.ClientNotes__c = serviceClientNotes;
                    sli.Supplier_Notes__c = serviceSupplierNotes;
                    sli.Service_Status__c = serviceStatus;
                    sli.Provisional_Booking_Expiry_Date__c =  date.valueOf(expiryDate);
                    
                    serviceLineItemsToUpdate.add(sli);
                }
            }
            
            if(!serviceLineItemsToUpdate.isEmpty())
            {
                DAL_BaseObject.UpdateDBObjects(serviceLineItemsToUpdate);
            }
        }
        catch(Exception e)
        {
            ErrorMessageList.add(e.getMessage());
        }   
        return ErrorMessageList;
    }
    
    
    public List<String> updateChargeTypes(Set<ChargeTypeUpdate> chargeTypesToUpdate)
    {
        List<String> ErrorMessageList = new List<String>();
        Set<String> chargeTypeIdsToUpdate = new Set<String>();
        Set<String> seviceLineIdsToUpdate = new Set<String>();
        Set<String> seviceLineIdsForWhichAllChargeTypeToUpdate = new Set<String>();
        Set<String> allQuotationLineItemsIdToUpdateStatus = new Set<String>();
        Set<String> allQuotationLineItemsIdForPax = new Set<String>();
        Set<String> allServiceLineItemsIdForPax = new Set<String>();
        Set<String> chargeTypeIdsForPax = new Set<String>() ;  
        
        try
        {
            List<Service_Line_Item_ChargeType__c> itemsToUpdate = new List<Service_Line_Item_ChargeType__c>();
            List<Service_Line_Item_ChargeType__c> itemsToUpdateForPax = new List<Service_Line_Item_ChargeType__c>();
            List<ServiceLineItem__c> serviceLineItemsToUpdate = new List<ServiceLineItem__c>();
            List<ServiceLineItem__c> serviceLineItemsToUpdateStatus = new List<ServiceLineItem__c>();
            List<ServiceLineItem__c> serviceLineItemsForOverrideNetCost = new List<ServiceLineItem__c>();
            
            // Collect all the chargeTypeId && ServiceLineItemIds
            for(ChargeTypeUpdate item:chargeTypesToUpdate)
            {
                if((item.ChargeTypeId != null)
                   && (!chargeTypeIdsToUpdate.contains(item.ChargeTypeId)))
                {
                    chargeTypeIdsToUpdate.add(item.ChargeTypeId);
                }
                if((item.ServiceLineItemId != null) 
                   && (!chargeTypeIdsToUpdate.contains(item.ServiceLineItemId)))
                {
                    seviceLineIdsToUpdate.add(item.ServiceLineItemId);
                }
            } 
            
            if(chargeTypeIdsToUpdate.size() > 0)
            {
                // Query the existing records
                List<Service_Line_Item_ChargeType__c> oldChargeTypes = getAllChargeTypeById(chargeTypeIdsToUpdate);
                
                for(ChargeTypeUpdate newItem:chargeTypesToUpdate)
                {
                    if(newItem.ChargeTypeId != null)
                    {
                        List<Service_Line_Item_ChargeType__c> oldItem = SystemUtil.findWhere(oldChargeTypes,'Id', newItem.ChargeTypeId);
                        
                        if((oldItem[0].Nett_Cost__c != Decimal.valueOf(newItem.NettCost))
                           || (oldItem[0].Markup__c != Decimal.valueOf(newItem.Markup)))
                        {
                            oldItem[0].Markup__c = Decimal.valueOf(newItem.Markup);
                            oldItem[0].Nett_Cost__c = Decimal.valueOf(newItem.NettCost);
                            oldItem[0].Overide_Markup__c = true;
                           
                            itemsToUpdate.add(oldItem[0]);
                            
                            if((oldItem[0].Category__c == 'Service Charge')
                               && (oldItem[0].Markup__c != Decimal.valueOf(newItem.Markup)))
                            {
                                seviceLineIdsForWhichAllChargeTypeToUpdate.add(oldItem[0].Service_Line_Item__c);
                            }
                            chargeTypeIdsForPax.add(oldItem[0].Id);
                        }
                    }
                }    
            }
            
            
            if(!seviceLineIdsForWhichAllChargeTypeToUpdate.isEmpty())
            {
                // Query the existing records
                List<Service_Line_Item_ChargeType__c> oldChargeTypesDueToServiceCategory = getAllChargeTypeByServiceLineId(seviceLineIdsForWhichAllChargeTypeToUpdate);
                for(ChargeTypeUpdate newItem:chargeTypesToUpdate)
                {
                    if(newItem.ChargeTypeId != null)
                    {
                        List<Service_Line_Item_ChargeType__c> oldItem = SystemUtil.findWhere(oldChargeTypesDueToServiceCategory,'Id', newItem.ChargeTypeId);
                        oldItem[0].Markup__c = Decimal.valueOf(newItem.Markup);
                        oldItem[0].Overide_Markup__c = true;
                        itemsToUpdate.add(oldItem[0]);
                    }
                }
            }
            
            
            if(!chargeTypeIdsForPax.isEmpty())
            {
               // Query the existing records
                List<Service_Line_Item_ChargeType__c> chargeTypeItemsForPax  = getAllChargeTypeByIdForPax(chargeTypeIdsForPax);
                Set<String> sliIdsForPax  = new Set<String>();
                    
                for(Service_Line_Item_ChargeType__c slict:chargeTypeItemsForPax)
                {
                    sliIdsForPax.add(slict.Service_Line_Item__c);
                }
                
                // Query the existing records
                List<ServiceLineItem__c> oldServiceLineItemsForPax =  getServiceLineItemById(sliIdsForPax);
                
                String quotationId = oldServiceLineItemsForPax[0].QuotationLine__r.Quotation__c;
                // Query the existing records
                List<QuotationLineItem__c> allQuotationLineItemsForPax = DAL_Quotations.getQuotationLineItemByQuotationId(quotationId);
                for(QuotationLineItem__c qli: allQuotationLineItemsForPax)
                {
                    allQuotationLineItemsIdForPax.add(qli.Id);
                }
                
                 // Query the existing records
                List<ServiceLineItem__c> allOldServiceLineItemsForPax = getServiceLineItemByQuotationLineId(allQuotationLineItemsIdForPax);
                
                for(Service_Line_Item_ChargeType__c oldSli:chargeTypeItemsForPax)
                {
                    //for(Integer i=0; i< Integer.valueOf(oldSli.Service_Line_Item__r.Service_Duration__c); i++)
                    //{
                        //Date serviceDate =   oldSli.Service_Line_Item__r.Service_Date__c.addDays(i);
                        //Date serviceDate =   oldSli.Service_Line_Item__r.Service_Date__c;
                        Id serviceLineId  = oldSli.Service_Line_Item__c;
                        //List<ServiceLineItem__c> serviceItems = SystemUtil.findWhere(allOldServiceLineItemsForPax,'Service_Date__c', serviceDate);
                        List<ServiceLineItem__c> serviceItems = SystemUtil.findWhere(allOldServiceLineItemsForPax,'Id', serviceLineId);
                        for(ServiceLineItem__c sl:serviceItems)
                        {
                            allServiceLineItemsIdForPax.add(sl.Id);    
                        }
                    //}
                }
                
                 // Query the existing records
                List<Service_Line_Item_ChargeType__c> allOldChargeTypesForPax = getAllChargeTypeByServiceLineId(allServiceLineItemsIdForPax);
               
                List<ChargeTypeUpdate> newValues = new List<ChargeTypeUpdate>();
                newValues.addAll(chargeTypesToUpdate);
                
                for(Service_Line_Item_ChargeType__c oldSli:chargeTypeItemsForPax)
                {
                    //for(Integer i=0; i< Integer.valueOf(oldSli.Service_Line_Item__r.Service_Duration__c); i++)
                    //{
                       // Date serviceDate =   oldSli.Service_Line_Item__r.Service_Date__c.addDays(i);
                        Date serviceDate =   oldSli.Service_Line_Item__r.Service_Date__c;
                        for(Service_Line_Item_ChargeType__c sl: allOldChargeTypesForPax)
                        {
                            if((sl.Selected_Passenger__c == oldSli.Selected_Passenger__c) 
                               && (sl.Extra__c == oldSli.Extra__c) 
                               && (sl.Category__c == oldSli.Category__c) 
                               && (sl.Service_Line_Item__r.SupplierName__c == oldSli.Service_Line_Item__r.SupplierName__c)
                               && (sl.Service_Line_Item__r.Service_Date__c == serviceDate) )
                            {
                                for(ChargeTypeUpdate ctu:newValues)
                                {
                                    if(ctu.ChargeTypeId == oldSli.Id)    
                                    {
                                        sl.Markup__c = Decimal.valueOf(ctu.Markup);
                                        sl.Nett_Cost__c = Decimal.valueOf(ctu.NettCost).setScale(2,RoundingMode.HALF_UP);
                                        sl.Overide_Markup__c = true;
                                        itemsToUpdateForPax.add(sl);
                                    }
                                }
                            } 
                        }
                    //}
                }
             }
        
            Set<String> chargeTypeIdsForOverrideNetCost = new Set<String>();
            Set<String> serviceLineItemIdsForOverrideNetCost = new Set<String>();
            for(Service_Line_Item_ChargeType__c ct:itemsToUpdate)   
            {
                chargeTypeIdsForOverrideNetCost.add(ct.Id);
            }
            for(Service_Line_Item_ChargeType__c ct:itemsToUpdateForPax)   
            {
                chargeTypeIdsForOverrideNetCost.add(ct.Id);
            }
            
            if(!chargeTypeIdsForOverrideNetCost.isEmpty())
            {
                
                 // Query the existing records
                List<Service_Line_Item_ChargeType__c> chargeTypeItemsForOverrideNetCost = getAllChargeTypeById(chargeTypeIdsForOverrideNetCost); 
                
                for(Service_Line_Item_ChargeType__c ct:chargeTypeItemsForOverrideNetCost)
                {
                    serviceLineItemIdsForOverrideNetCost.add(ct.Service_Line_Item__r.Id);
                }
                
                if(!serviceLineItemIdsForOverrideNetCost.isEmpty())
                {
                    serviceLineItemsForOverrideNetCost = getServiceLineItemById(serviceLineItemIdsForOverrideNetCost);
                    
                    for(ServiceLineItem__c sli:serviceLineItemsForOverrideNetCost)
                    {
                        sli.Do_Not_Override_NetCost__c = true;
                    }
                }
            }
                
            if(seviceLineIdsToUpdate.size()> 0)
            {
                 // Query the existing records
                List<ServiceLineItem__c> oldServiceLineItems = getServiceLineItemById(seviceLineIdsToUpdate);
                
                String quotationId = oldServiceLineItems[0].QuotationLine__r.Quotation__c;
                
                 // Query the existing records
                List<QuotationLineItem__c> allQuotationLineItems = DAL_Quotations.getQuotationLineItemByQuotationId(quotationId);
              
                for(QuotationLineItem__c qli: allQuotationLineItems)
                {
                    allQuotationLineItemsIdToUpdateStatus.add(qli.Id);
                }
                
                 // Query the existing records
                List<ServiceLineItem__c> allOldServiceLineItems = getServiceLineItemByQuotationLineId(allQuotationLineItemsIdToUpdateStatus);
                
                for(ChargeTypeUpdate newItem:chargeTypesToUpdate)
                {
                    if(newItem.ServiceLineItemId != null)
                    {
                        List<ServiceLineItem__c> oldServiceItem = SystemUtil.findWhere(oldServiceLineItems,'Id', newItem.ServiceLineItemId);
                        
                        if(oldServiceItem[0].Service_Status__c != newItem.Status
                           ||(oldServiceItem[0].ClientNotes__c != newItem.ClientNotes))
                        {
                           // for(Integer i=0; i< Integer.valueOf(oldServiceItem[0].Service_Duration__c); i++)
                            //{
                                //Date serviceDate =   oldServiceItem[0].Service_Date__c.addDays(i);
                                Date serviceDate =   oldServiceItem[0].Service_Date__c;
                                List<ServiceLineItem__c> serviceItems = SystemUtil.findWhere(allOldServiceLineItems,'Service_Date__c', serviceDate);
                                List<ServiceLineItem__c> serviceItemsWithSameSupplierName = SystemUtil.findWhere(serviceItems,'SupplierName__c', oldServiceItem[0].SupplierName__c);
                                if(!serviceItemsWithSameSupplierName.isEmpty())
                                {
                                    for(ServiceLineItem__c sli:serviceItemsWithSameSupplierName)
                                    {
                                        sli.Service_Status__c = newItem.Status;
                                        sli.ClientNotes__c  = newItem.ClientNotes;
                                    }
                                    
                                    serviceLineItemsToUpdateStatus.addAll(serviceItemsWithSameSupplierName);    
                                }
                            //}
                        }
                    }
                }
                
                for(ChargeTypeUpdate newItem:chargeTypesToUpdate)
                {
                    if(newItem.ServiceLineItemId != null)
                    {
                        List<ServiceLineItem__c> oldServiceItem = SystemUtil.findWhere(oldServiceLineItems,'Id', newItem.ServiceLineItemId);
                        
                        if((oldServiceItem[0].Service_Status__c != newItem.Status)
                           ||(oldServiceItem[0].ClientNotes__c != newItem.ClientNotes))
                        {
                            oldServiceItem[0].Service_Status__c = newItem.Status;
                            oldServiceItem[0].ClientNotes__c  = newItem.ClientNotes;
                            serviceLineItemsToUpdate.add(oldServiceItem[0]);
                        }    
                        
                    }
                }
            }
            
            if(!itemsToUpdate.isEmpty())
            {
                DAL_BaseObject.UpdateDBObjects(itemsToUpdate);    
            }
            if(!serviceLineItemsToUpdate.isEmpty())
            {
                DAL_BaseObject.UpdateDBObjects(serviceLineItemsToUpdate);
            }
            if(!serviceLineItemsToUpdateStatus.isEmpty())
            {
                DAL_BaseObject.UpdateDBObjects(serviceLineItemsToUpdateStatus);
            }
            if(!itemsToUpdateForPax.isEmpty())
            {
                DAL_BaseObject.UpdateDBObjects(itemsToUpdateForPax);
            }
            if(!serviceLineItemsForOverrideNetCost.isEmpty())
            {
                DAL_BaseObject.UpdateDBObjects(serviceLineItemsForOverrideNetCost);
            }
        }
        catch(Exception e)
        {
            ErrorMessageList.add(e.getMessage());
        } 
        return ErrorMessageList;
    }
    
    

    public List<ServiceLineItem__c> getServiceLineItemById(Set<String> seviceLineIdsToUpdate)
    {
        return  [SELECT 
                        Id,
                        ClientNotes__c,
                        Service_Status__c,
                        Service_Duration__c,
                        QuotationLine__r.Quotation__c,
                        Service_Date__c,
                        SupplierName__c,
                        Do_Not_Override_NetCost__c
                   FROM 
                        ServiceLineItem__c 
                   WHERE 
                        Id IN:seviceLineIdsToUpdate];
    }
    
    
    public List<ServiceLineItem__c> getServiceLineItemByQuotationLineId(Set<String> allQuotationLineItemsIdToUpdateStatus)
    {
        return  [SELECT 
                       Id,
                       ClientNotes__c,
                       Service_Status__c,
                       Service_Duration__c,
                       QuotationLine__r.Quotation__c,
                       Service_Date__c,
                       SupplierName__c
                FROM 
                       ServiceLineItem__c 
                WHERE 
                       QuotationLine__c IN:allQuotationLineItemsIdToUpdateStatus];
    }
    
    
    
    public List<Service_Line_Item_ChargeType__c> getAllChargeTypeByIdForPax( Set<String> chargeTypeIdsForPax)
    {
        return  [SELECT 
                        Id,
                        Category__c,
                        Extra__c,
                        Service_Line_Item__c,
                        Service_Line_Item__r.SupplierName__c,
                        Service_Line_Item__r.Service_Date__c,
                        Service_Line_Item__r.Service_Duration__c,
                        Selected_Passenger__r.Id,
                        Service_Line_Item__r.Id 
                  FROM 
                        Service_Line_Item_ChargeType__c
                 WHERE 
                        Id IN:chargeTypeIdsForPax
                ORDER BY 
                        Service_Line_Item__r.Service_Date__c ASC];
    }
    
    
    
    public List<Service_Line_Item_ChargeType__c> getAllChargeTypeByServiceLineId( Set<String> seviceLineIdsForWhichAllChargeTypeToUpdate)
    {
        return  [SELECT 
                        Id,
                        Markup__c,
                        Overide_Markup__c,
                        Nett_Cost__c,
                        Extra__c,
                        Category__c,
                        Selected_Passenger__c,
                        Service_Line_Item__c,
                        Service_Line_Item__r.SupplierName__c,
                        Service_Line_Item__r.Service_Date__c
                   FROM 
                        Service_Line_Item_ChargeType__c 
                    WHERE
                        Service_Line_Item__c IN:seviceLineIdsForWhichAllChargeTypeToUpdate];
    }
    
    
    public List<Service_Line_Item_ChargeType__c> getAllChargeTypeById( Set<String> chargeTypeIdsToUpdate)
    {
        return  [SELECT      
                        Id,
                        Total__c,
                        Nett_Cost__c,
                        Markup__c,
                        Overide_Markup__c,
                        Category__c,
                        Service_Line_Item__c,
                        Service_Line_Item__r.QuotationLine__c,
                        Service_Line_Item__r.Id 
                  FROM 
                        Service_Line_Item_ChargeType__c 
                  WHERE 
                        Id IN:chargeTypeIdsToUpdate];
    }
    
    
    /*public List<String> updateChargeTypes(Set<ChargeTypeUpdate> chargeTypesToUpdate) 
    {
        List<String> ErrorMessageList = new List<String>();
        Set<String> chargeTypeIdsToUpdate = new Set<String>();
        Set<String> seviceLineIdsToUpdate = new Set<String>();
        Set<String> seviceLineIdsForWhichAllChargeTypeToUpdate = new Set<String>();
        Set<String> allQuotationLineItemsIdToUpdateStatus = new Set<String>();
        Set<String> allQuotationLineItemsIdForPax = new Set<String>();
        Set<String> allServiceLineItemsIdForPax = new Set<String>();
        Set<String> chargeTypeIdsForPax = new Set<String>() ;
        
        try
        {
            List<Service_Line_Item_ChargeType__c> itemsToUpdate = new List<Service_Line_Item_ChargeType__c>();
            List<Service_Line_Item_ChargeType__c> itemsToUpdateForPax = new List<Service_Line_Item_ChargeType__c>();
            List<ServiceLineItem__c> serviceLineItemsToUpdate = new List<ServiceLineItem__c>();
            List<ServiceLineItem__c> serviceLineItemsToUpdateStatus = new List<ServiceLineItem__c>();
            List<ServiceLineItem__c> serviceLineItemsForOverrideNetCost = new List<ServiceLineItem__c>();
            
            for(ChargeTypeUpdate item:chargeTypesToUpdate)
            {
                if((item.ChargeTypeId !=null)
                   && (!chargeTypeIdsToUpdate.contains(item.ChargeTypeId)))
                {
                    chargeTypeIdsToUpdate.add(item.ChargeTypeId);
                }
                if((item.ServiceLineItemId !=null) 
                   && (!chargeTypeIdsToUpdate.contains(item.ServiceLineItemId)))
                {
                    seviceLineIdsToUpdate.add(item.ServiceLineItemId);
                }
            }
            
            if(chargeTypeIdsToUpdate.size() > 0)
            {
                List<Service_Line_Item_ChargeType__c> oldChargeTypes = [SELECT      
                                                                                Id,
                                                                                Total__c,
                                                                                Nett_Cost__c,
                                                                                Markup__c,
                                                                                Overide_Markup__c,
                                                                                Category__c,
                                                                                Service_Line_Item__c,
                                                                                Service_Line_Item__r.QuotationLine__c
                                                                          FROM 
                                                                                Service_Line_Item_ChargeType__c 
                                                                          WHERE 
                                                                                Id IN:chargeTypeIdsToUpdate];
                
                for(ChargeTypeUpdate newItem:chargeTypesToUpdate)
                {
                    if(newItem.ChargeTypeId != null)
                    {
                        List<Service_Line_Item_ChargeType__c> oldItem = SystemUtil.findWhere(oldChargeTypes,'Id', newItem.ChargeTypeId);
                        
                        if((oldItem[0].Nett_Cost__c != Decimal.valueOf(newItem.NettCost))
                           || (oldItem[0].Markup__c != Decimal.valueOf(newItem.Markup)))
                        {
                            oldItem[0].Markup__c = Decimal.valueOf(newItem.Markup);
                            oldItem[0].Nett_Cost__c = Decimal.valueOf(newItem.NettCost);
                            oldItem[0].Overide_Markup__c = true;
                           
                            itemsToUpdate.add(oldItem[0]);
                            
                            if((oldItem[0].Category__c == 'Service Charge')
                               && (oldItem[0].Markup__c != Decimal.valueOf(newItem.Markup)))
                            {
                                seviceLineIdsForWhichAllChargeTypeToUpdate.add(oldItem[0].Service_Line_Item__c);
                            }
                            chargeTypeIdsForPax.add(oldItem[0].Id);
                        }
                    }
                }
                
                if(!seviceLineIdsForWhichAllChargeTypeToUpdate.isEmpty())
                {
                    List<Service_Line_Item_ChargeType__c> oldChargeTypesDueToServiceCategory = [SELECT 
                                                                                                        Id,
                                                                                                        Markup__c,
                                                                                                        Overide_Markup__c
                                                                                                   FROM 
                                                                                                        Service_Line_Item_ChargeType__c 
                                                                                                    WHERE
                                                                                                        Service_Line_Item__c IN:seviceLineIdsForWhichAllChargeTypeToUpdate];
                    for(ChargeTypeUpdate newItem:chargeTypesToUpdate)
                    {
                        if(newItem.ChargeTypeId != null)
                        {
                            List<Service_Line_Item_ChargeType__c> oldItem = SystemUtil.findWhere(oldChargeTypesDueToServiceCategory,'Id', newItem.ChargeTypeId);
                            oldItem[0].Markup__c = Decimal.valueOf(newItem.Markup);
                            oldItem[0].Overide_Markup__c = true;
                            itemsToUpdate.add(oldItem[0]);
                        }
                    }
                }
                
                if(!chargeTypeIdsForPax.isEmpty())
                {
                    List<Service_Line_Item_ChargeType__c> chargeTypeItemsForPax  = [SELECT 
                                                                                            Id,
                                                                                            Category__c,
                                                                                            Extra__c,
                                                                                            Service_Line_Item__c,
                                                                                            Service_Line_Item__r.SupplierName__c,
                                                                                            Service_Line_Item__r.Service_Date__c,
                                                                                            Service_Line_Item__r.Service_Duration__c,
                                                                                            Selected_Passenger__r.Id
                                                                                      FROM 
                                                                                            Service_Line_Item_ChargeType__c
                                                                                     WHERE 
                                                                                            Id IN:chargeTypeIdsForPax
                                                                                    ORDER BY 
                                                                                            Service_Line_Item__r.Service_Date__c ASC];
                    
                    Set<String> sliIdsForPax  = new Set<String>();
                    
                    for(Service_Line_Item_ChargeType__c slict:chargeTypeItemsForPax)
                    {
                        sliIdsForPax.add(slict.Service_Line_Item__c);
                    }
                    
                    List<ServiceLineItem__c> oldServiceLineItemsForPax = [SELECT 
                                                                                  Id,
                                                                                  Service_Duration__c,
                                                                                  QuotationLine__r.Quotation__c,
                                                                                  Service_Date__c
                                                                            FROM 
                                                                                  ServiceLineItem__c 
                                                                            WHERE 
                                                                                  Id IN:sliIdsForPax];
                    
                    String quotationId = oldServiceLineItemsForPax[0].QuotationLine__r.Quotation__c;
                    
                    List<QuotationLineItem__c> allQuotationLineItemsForPax = [SELECT 
                                                                                    Id
                                                                                FROM 
                                                                                    QuotationLineItem__c 
                                                                              WHERE Quotation__c =: quotationId];
                    for(QuotationLineItem__c qli: allQuotationLineItemsForPax)
                    {
                        allQuotationLineItemsIdForPax.add(qli.Id);
                    }
                    
                    List<ServiceLineItem__c> allOldServiceLineItemsForPax = [SELECT  
                                                                                     Id,
                                                                                     ClientNotes__c,
                                                                                     Service_Status__c,
                                                                                     Service_Duration__c,
                                                                                     QuotationLine__r.Quotation__c,
                                                                                     Service_Date__c
                                                                                FROM 
                                                                                     ServiceLineItem__c 
                                                                               WHERE 
                                                                                     QuotationLine__c IN:allQuotationLineItemsIdForPax];
                    
                    for(Service_Line_Item_ChargeType__c oldSli:chargeTypeItemsForPax)
                    {
                        for(Integer i=0; i< Integer.valueOf(oldSli.Service_Line_Item__r.Service_Duration__c); i++)
                        {
                            Date serviceDate =   oldSli.Service_Line_Item__r.Service_Date__c.addDays(i);
                            
                            List<ServiceLineItem__c> serviceItems = SystemUtil.findWhere(allOldServiceLineItemsForPax,'Service_Date__c', serviceDate);
                            for(ServiceLineItem__c sl:serviceItems)
                            {
                                allServiceLineItemsIdForPax.add(sl.Id);    
                            }
                        }
                    }
                    
                    List<Service_Line_Item_ChargeType__c> allOldChargeTypesForPax = [SELECT     
                                                                                             Id,
                                                                                             Nett_Cost__c,
                                                                                             Markup__c,
                                                                                             Extra__c,
                                                                                             Category__c,
                                                                                             Overide_Markup__c,
                                                                                             //Do_Not_Override_NetCost__c,
                                                                                             Selected_Passenger__c,
                                                                                             Service_Line_Item__c,
                                                                                             Service_Line_Item__r.SupplierName__c,
                                                                                             Service_Line_Item__r.Service_Date__c
                                                                                        FROM 
                                                                                             Service_Line_Item_ChargeType__c 
                                                                                       WHERE 
                                                                                             Service_Line_Item__c IN:allServiceLineItemsIdForPax];
                    List<ChargeTypeUpdate> newValues = new List<ChargeTypeUpdate>();
                    newValues.addAll(chargeTypesToUpdate);
                    
                    for(Service_Line_Item_ChargeType__c oldSli:chargeTypeItemsForPax)
                    {
                        for(Integer i=0; i< Integer.valueOf(oldSli.Service_Line_Item__r.Service_Duration__c); i++)
                        {
                            Date serviceDate =   oldSli.Service_Line_Item__r.Service_Date__c.addDays(i);
                            for(Service_Line_Item_ChargeType__c sl: allOldChargeTypesForPax)
                            {
                                if((sl.Selected_Passenger__c == oldSli.Selected_Passenger__c) 
                                   && (sl.Extra__c == oldSli.Extra__c) 
                                   && (sl.Category__c == oldSli.Category__c) 
                                   && (sl.Service_Line_Item__r.SupplierName__c == oldSli.Service_Line_Item__r.SupplierName__c)
                                   && (sl.Service_Line_Item__r.Service_Date__c == serviceDate) )
                                {
                                    for(ChargeTypeUpdate ctu:newValues)
                                    {
                                        if(ctu.ChargeTypeId == oldSli.Id)    
                                        {
                                            sl.Markup__c = Decimal.valueOf(ctu.Markup);
                                            sl.Nett_Cost__c = Decimal.valueOf(ctu.NettCost).setScale(2,RoundingMode.HALF_UP);
                                            sl.Overide_Markup__c = true;
                                            itemsToUpdateForPax.add(sl);
                                        }
                                    }
                                } 
                            }
                        }
                    }
                }
                
                Set<String> chargeTypeIdsForOverrideNetCost = new Set<String>();
                Set<String> serviceLineItemIdsForOverrideNetCost = new Set<String>();
                for(Service_Line_Item_ChargeType__c ct:itemsToUpdate)   
                {
                    chargeTypeIdsForOverrideNetCost.add(ct.Id);
                }
                for(Service_Line_Item_ChargeType__c ct:itemsToUpdateForPax)   
                {
                    chargeTypeIdsForOverrideNetCost.add(ct.Id);
                }
                
                if(!chargeTypeIdsForOverrideNetCost.isEmpty())
                {
                    
                    List<Service_Line_Item_ChargeType__c> chargeTypeItemsForOverrideNetCost = [SELECT 
                                                                                                       Id, 
                                                                                                       Service_Line_Item__r.Id 
                                                                                                  FROM  
                                                                                                       Service_Line_Item_ChargeType__c 
                                                                                                  WHERE 
                                                                                                       Id IN:chargeTypeIdsForOverrideNetCost];
                    
                    for(Service_Line_Item_ChargeType__c ct:chargeTypeItemsForOverrideNetCost)
                    {
                        serviceLineItemIdsForOverrideNetCost.add(ct.Service_Line_Item__r.Id);
                    }
                    
                    if(!serviceLineItemIdsForOverrideNetCost.isEmpty())
                    {
                        serviceLineItemsForOverrideNetCost = [SELECT
                                                                     Id,
                                                                     Do_Not_Override_NetCost__c
                                                               FROM  
                                                                     ServiceLineItem__c
                                                               WHERE Id IN:serviceLineItemIdsForOverrideNetCost];
                        
                        for(ServiceLineItem__c sli:serviceLineItemsForOverrideNetCost)
                        {
                            sli.Do_Not_Override_NetCost__c = true;
                        }
                    }
                }
            }
            if(seviceLineIdsToUpdate.size()> 0)
            {
                List<ServiceLineItem__c> oldServiceLineItems = [SELECT 
                                                                        Id,
                                                                        ClientNotes__c,
                                                                        Service_Status__c,
                                                                        Service_Duration__c,
                                                                        QuotationLine__r.Quotation__c,
                                                                        Service_Date__c,
                                                                        SupplierName__c
                                                                   FROM 
                                                                        ServiceLineItem__c 
                                                                   WHERE 
                                                                        Id IN:seviceLineIdsToUpdate];
                
                String quotationId = oldServiceLineItems[0].QuotationLine__r.Quotation__c;
                
                List<QuotationLineItem__c> allQuotationLineItems = [SELECT Id FROM QuotationLineItem__c WHERE Quotation__c =: quotationId];
                for(QuotationLineItem__c qli: allQuotationLineItems)
                {
                    allQuotationLineItemsIdToUpdateStatus.add(qli.Id);
                }
                
                List<ServiceLineItem__c> allOldServiceLineItems = [SELECT 
                                                                           Id,
                                                                           ClientNotes__c,
                                                                           Service_Status__c,
                                                                           Service_Duration__c,
                                                                           QuotationLine__r.Quotation__c,
                                                                           Service_Date__c,
                                                                           SupplierName__c
                                                                    FROM 
                                                                           ServiceLineItem__c 
                                                                    WHERE 
                                                                           QuotationLine__c IN:allQuotationLineItemsIdToUpdateStatus];
                
                
                for(ChargeTypeUpdate newItem:chargeTypesToUpdate)
                {
                    if(newItem.ServiceLineItemId != null)
                    {
                        List<ServiceLineItem__c> oldServiceItem = SystemUtil.findWhere(oldServiceLineItems,'Id', newItem.ServiceLineItemId);
                        
                        if(oldServiceItem[0].Service_Status__c != newItem.Status
                           ||(oldServiceItem[0].ClientNotes__c != newItem.ClientNotes))
                        {
                            for(Integer i=0; i< Integer.valueOf(oldServiceItem[0].Service_Duration__c); i++)
                            {
                                Date serviceDate =   oldServiceItem[0].Service_Date__c.addDays(i);
                                List<ServiceLineItem__c> serviceItems = SystemUtil.findWhere(allOldServiceLineItems,'Service_Date__c', serviceDate);
                                List<ServiceLineItem__c> serviceItemsWithSameSupplierName = SystemUtil.findWhere(serviceItems,'SupplierName__c', oldServiceItem[0].SupplierName__c);
                                if(!serviceItemsWithSameSupplierName.isEmpty())
                                {
                                    for(ServiceLineItem__c sli:serviceItemsWithSameSupplierName)
                                    {
                                        sli.Service_Status__c = newItem.Status;
                                        sli.ClientNotes__c  = newItem.ClientNotes;
                                    }
                                    
                                    serviceLineItemsToUpdateStatus.addAll(serviceItemsWithSameSupplierName);    
                                }
                            }
                        }
                    }
                }
                
                for(ChargeTypeUpdate newItem:chargeTypesToUpdate)
                {
                    if(newItem.ServiceLineItemId != null)
                    {
                        List<ServiceLineItem__c> oldServiceItem = SystemUtil.findWhere(oldServiceLineItems,'Id', newItem.ServiceLineItemId);
                        
                        if((oldServiceItem[0].Service_Status__c != newItem.Status)
                           ||(oldServiceItem[0].ClientNotes__c != newItem.ClientNotes))
                        {
                            oldServiceItem[0].Service_Status__c = newItem.Status;
                            oldServiceItem[0].ClientNotes__c  = newItem.ClientNotes;
                            serviceLineItemsToUpdate.add(oldServiceItem[0]);
                        }    
                        
                    }
                }
            }
            
            if(!itemsToUpdate.isEmpty())
            {
                DAL_BaseObject.UpdateDBObjects(itemsToUpdate);    
            }
            if(!serviceLineItemsToUpdate.isEmpty())
            {
                DAL_BaseObject.UpdateDBObjects(serviceLineItemsToUpdate);
            }
            if(!serviceLineItemsToUpdateStatus.isEmpty())
            {
                DAL_BaseObject.UpdateDBObjects(serviceLineItemsToUpdateStatus);
            }
            if(!itemsToUpdateForPax.isEmpty())
            {
                DAL_BaseObject.UpdateDBObjects(itemsToUpdateForPax);
            }
            if(!serviceLineItemsForOverrideNetCost.isEmpty())
            {
                DAL_BaseObject.UpdateDBObjects(serviceLineItemsForOverrideNetCost);
            }
        }
        catch(Exception e)
        {
            ErrorMessageList.add(e.getMessage());
        } 
        return ErrorMessageList;
    }*/
    
    public List<String> deleteSelectedItems(String[] itemsToDelete)
    {
        List<String> ErrorMessageList = new List<String>();
        List<String> quotationLineItemIds = new List<String>();
        Set<String> serviceLineItemIds = new Set<String>();
        Set<String> chargeItemIds = new Set<String>();
        try
        {
            for(String sId:itemsToDelete)
            {
                String sobjectType = Id.valueOf(sId).getSObjectType().getDescribe().getName();
                
                If('QuotationLineItem__c' == sobjectType)
                {
                    quotationLineItemIds.add(sId);
                }
                If('ServiceLineItem__c' == sobjectType)
                {
                    serviceLineItemIds.add(sId);
                }
                If('Service_Line_Item_ChargeType__c' == sobjectType)
                {
                    chargeItemIds.add(sId);
                }
            }
            if(!chargeItemIds.isEmpty())
            {
                List<Service_Line_Item_ChargeType__c> chargeTypeToDelete  = [SELECT 
                                                                             Id
                                                                             FROM 
                                                                             Service_Line_Item_ChargeType__c 
                                                                             WHERE 
                                                                             Id IN:chargeItemIds];
                
                DAL_BaseObject.DeleteDBObjects(chargeTypeToDelete);
            }
            
            if(!serviceLineItemIds.isEmpty())
            {
                DeleteServiceLineItems(serviceLineItemIds);
            }
            
            if(!quotationLineItemIds.isEmpty())
            {
                List<ServiceLineItem__c> relatedServiceLineItemsToDelete = getRelatedQuotationServiceLineItems(quotationLineItemIds);
                Set<String> relatedServiceLineItemIds = new Set<String>();
                for(ServiceLineItem__c sli:relatedServiceLineItemsToDelete)
                {
                    relatedServiceLineItemIds.add(sli.Id);
                }
                if(!relatedServiceLineItemIds.isEmpty())
                {
                    DeleteServiceLineItems(relatedServiceLineItemIds);
                }
            }
        }
        catch(Exception e)
        {
            ErrorMessageList.add(e.getMessage());
        }   
        return ErrorMessageList;
    }
    
    public String getCrmIdByCode(String crmCode)
    {
        String crmId ='';
        List<CRM__c> crms= [SELECT Id FROM CRM__c WHERE Code__c=:crmCode];
        if(!crms.isEmpty())
        {
            crmId = crms[0].Id;
        }
        return crmId;     
    }
    
    public List<String> DeleteServiceLineChargeType(String chargeType)
    {
        List<String> ErrorMessageList = new List<String>();
        try
        {
            List<Service_Line_Item_ChargeType__c> chargeTypeToDelete  = [SELECT 
                                                                         Id 
                                                                         FROM 
                                                                         Service_Line_Item_ChargeType__c 
                                                                         WHERE 
                                                                         Id=:chargeType];
            
            DAL_BaseObject.DeleteDBObjects(chargeTypeToDelete);
        }
        catch(Exception e)
        {
            ErrorMessageList.add(e.getMessage());
        }                                                                          
        return ErrorMessageList;
    }
    
    public List<String> DeleteServiceLineItems(Set<String> serviceLineItemIds)
    {
        List<String> ErrorMessageList = new List<String>();
        try
        {
            List<Service_Line_Item_ChargeType__c> chargeTypeToDelete  = [SELECT
                                                                         Id
                                                                         FROM 
                                                                         Service_Line_Item_ChargeType__c 
                                                                         WHERE 
                                                                         Service_Line_Item__c IN:serviceLineItemIds];
            
            List<ServiceLineItemPassengersMapping__c> servicePassengersToDelete = [SELECT
                                                                                   Id 
                                                                                   FROM  
                                                                                   ServiceLineItemPassengersMapping__c
                                                                                   WHERE 
                                                                                   Service_Line_Item__c IN:serviceLineItemIds];  
            
            List<ServiceLineItem__c> serviceLineItemToDelete = [SELECT 
                                                                Id 
                                                                FROM 
                                                                ServiceLineItem__c
                                                                WHERE 
                                                                Id IN:serviceLineItemIds];
            DAL_BaseObject.DeleteDBObjects(servicePassengersToDelete);
            
            DAL_BaseObject.DeleteDBObjects(chargeTypeToDelete);
            
            DAL_BaseObject.DeleteDBObjects(serviceLineItemToDelete);
        }
        catch(Exception e)
        {
            ErrorMessageList.add(e.getMessage());
        }                                                                          
        return ErrorMessageList;
    }
    
    public List<String> DeleteServiceLineItem(String serviceLineItemId)
    {
        List<String> ErrorMessageList = new List<String>();
        try
        {
            List<Service_Line_Item_ChargeType__c> chargeTypeToDelete  = [SELECT
                                                                                 Id
                                                                            FROM 
                                                                                 Service_Line_Item_ChargeType__c 
                                                                           WHERE 
                                                                                 Service_Line_Item__c=:serviceLineItemId];
            
            List<ServiceLineItemPassengersMapping__c> servicePssengersToDelete = [SELECT 
                                                                                          Id 
                                                                                     FROM
                                                                                          ServiceLineItemPassengersMapping__c
                                                                                     WHERE 
                                                                                          Service_Line_Item__c =: serviceLineItemId];  
            
            List<ServiceLineItem__c> serviceLineItemToDelete = [SELECT
                                                                        Id 
                                                                  FROM 
                                                                        ServiceLineItem__c
                                                                  WHERE 
                                                                        Id =: serviceLineItemId];
            DAL_BaseObject.DeleteDBObjects(servicePssengersToDelete);
            
            DAL_BaseObject.DeleteDBObjects(chargeTypeToDelete);
            
            DAL_BaseObject.DeleteDBObjects(serviceLineItemToDelete);
        }
        catch(Exception e)
        {
            ErrorMessageList.add(e.getMessage());
        }                                                                          
        return ErrorMessageList;
    }
    
    public void RemoveServiceLineItems(String serviceLineItemId, String serviceDuration)
    {
        List<ServiceLineItem__c> sliToDelete  = new List<ServiceLineItem__c>();
        Set<Decimal> serviceDurations=new Set<Decimal>();
        ServiceLineItem__c currentSli=[SELECT Service_Duration__c FROM ServiceLineItem__c WHERE Id=:serviceLineItemId][0];
        Decimal serviceDurationToDelete = currentSli.Service_Duration__c - Decimal.valueOf(serviceDuration);
        if(serviceDurationToDelete > 0)
        {
            for(Decimal i= 1; i <= serviceDurationToDelete;i++)
            {
                serviceDurations.add(i);
            }
            sliToDelete.addAll([SELECT
                                        Id
                                   FROM 
                                        ServiceLineItem__c
                                   WHERE
                                        Parent_Reference__c=:serviceLineItemId
                                   AND 
                                        Service_Duration__c IN: serviceDurations]);
        }
        else
        {
            sliToDelete.addAll([SELECT
                                        Id 
                                   FROM 
                                        ServiceLineItem__c
                                  WHERE 
                                        Parent_Reference__c =: serviceLineItemId]);
        }
        
        DAL_BaseObject.DeleteDBObjects(sliToDelete);
    }
    
    public List<String> loadPassengersForServiceLineItem(String serviceLineItemId)
    {
        List<String> passengerIds=new List<String>();
        List<ServiceLineItemPassengersMapping__c> mappings = [SELECT
                                                                      Passenger__c 
                                                                 FROM 
                                                                      ServiceLineItemPassengersMapping__c 
                                                                WHERE 
                                                                      Service_Line_Item__c =: serviceLineItemId];
        for(ServiceLineItemPassengersMapping__c m:mappings)
        {
            passengerIds.add(m.Passenger__c);
        }
        return passengerIds;
    }
    
    public ServiceLineItem__c loadServiceLineItem(String serviceLineItemId)
    {
        List<ServiceLineItem__c> sli=[SELECT 
                                              Id,
                                              Name,
                                              Service_Type__c,
                                              ServiceLocation__c,
                                              SupplierName__c,
                                              Service_Detail__c,
                                              Service_Date__c,
                                              Service_Duration__c,
                                              Room_Configuration__c,
                                              Override_details__c,
                                              Service_Status__c,
                                              Reservation_Number__c,
                                              Provisional_Booking_Expiry_Date__c,
                                              ClientNotes__c,
                                              Supplier_Notes__c,
                                              Parent_Reference__c,
                                              Selected_Supplier_Id__c,
                                              Wetu_Start_Location__c,
                                              Wetu_Start_Location_Id__c,
                                              Wetu_End_Location_Id__c,
                                              Wetu_End_Location__c,
                                              Wetu_Start_time__c,
                                              Wetu_End_time__c,
                                              Crm_Code__c,
                                              Start_Terminal__c,
                                              End_Terminal__c,
                                              Duration__c,
                                              Checkin_Time__c,
                                              Ticket_Class__c,
                                              Do_Not_Override_NetCost__c
                                         FROM 
                                              ServiceLineItem__c
                                         WHERE
                                              Id=:serviceLineItemId];
        
        return sli[0];
    }
    
    public  String GetResidenceCountryFromQuotationId(String quotationId) {
        String countryOfResidance;
        List<Quotations__c> items= [SELECT
                                            Opportunity__r.Country_of_Residence__c
                                      FROM
                                            Quotations__c 
                                      WHERE 
                                           Id =:quotationId];
        for(Quotations__c item:items)
        {
            countryOfResidance = item.Opportunity__r.Country_of_Residence__c;
        }
        return countryOfResidance;
    }
    
    public String GetCountryMarkup(String country)
    {
        String countryMarkup;
        List<CountryOriginMarkup__mdt> countryMarkups = [SELECT 
                                                                 Value__c
                                                            FROM
                                                                 CountryOriginMarkup__mdt
                                                            WHERE 
                                                                 MasterLabel=:country];
        for(CountryOriginMarkup__mdt cm:countryMarkups)
        {
            countryMarkup = cm.Value__c;
        }
        return countryMarkup;
    }
    
    public Decimal GetServiceTypeMarkup(String serviceType)
    {
        Decimal serviceTypeMarkup;
        List<ServiceTypeMarkup__mdt> serviceTypeMarkups = [SELECT 
                                                                   Value__c
                                                             FROM
                                                                   ServiceTypeMarkup__mdt
                                                             WHERE
                                                                   MasterLabel=:serviceType];
        for(ServiceTypeMarkup__mdt st:serviceTypeMarkups)
        {
            serviceTypeMarkup = st.Value__c;
        }
        return serviceTypeMarkup;
    }
    
    public Decimal GetSupplierMarkup(String code)
    {
        Decimal supplierMarkup;
        List<SupplierMarkup__mdt> supplierMarkups = [select 
                                                             Value__c
                                                        FROM
                                                             SupplierMarkup__mdt
                                                       WHERE 
                                                             Code__c=:code];
        for(SupplierMarkup__mdt sm:supplierMarkups)
        {
            supplierMarkup = sm.Value__c;
        }
        return supplierMarkup;
    }
    
    public Map<String,Decimal> getPaymentDiscountsForQuotation()
    {
        Decimal discountPercentage;
        List<PaymentDiscountsForQuotation__mdt> discounts = [SELECT 
                                                                    Discount_Percentage__c,
                                                                    Payment_Currency__c
                                                             FROM 
                                                                    PaymentDiscountsForQuotation__mdt];
        
        Map<String,Decimal> mapCurrencyToDiscountValue = new Map<String,Decimal>();
        for(PaymentDiscountsForQuotation__mdt st:discounts)
        {
            discountPercentage = st.Discount_Percentage__c;
            mapCurrencyToDiscountValue.put(st.Payment_Currency__c,discountPercentage);
        }
        return mapCurrencyToDiscountValue;
    }
    
    public Map<String,Decimal> getDueDateDifferenceForQuotation()
    {
        Decimal dayDifference;
        List<PaymentDiscountsForQuotation__mdt> discounts = [SELECT
                                                                     Day_Difference__c,
                                                                     Payment_Currency__c
                                                               FROM
                                                                     PaymentDiscountsForQuotation__mdt];
        
        Map<String,Decimal> mapCurrencyToDayDifference = new Map<String,Decimal>();
        for(PaymentDiscountsForQuotation__mdt st:discounts)
        {
            dayDifference = st.Day_Difference__c;
            mapCurrencyToDayDifference.put(st.Payment_Currency__c,dayDifference);
        }
        return mapCurrencyToDayDifference;
    }
    
    public  List<QuotationLineItem__c> GetQuotationLineItems(String quotationId) {
        List<QuotationLineItem__c> quotationLineItems = new List<QuotationLineItem__c>();
        
        List<QuotationLineItem__c> items= [SELECT
                                                   Name,
                                                   Day__c,
                                                   Quotation__c,
                                                   Line_Item_Date__c,
                                                   Format_Date__c
                                              FROM
                                                   QuotationLineItem__c
                                              WHERE 
                                                   Quotation__r.Id =:quotationId
                                           ORDER BY
                                                   Display_Count__c DESC];
        for(QuotationLineItem__c item:items)
        {
            quotationLineItems.add(item);
        }
        return quotationLineItems;
    }
    
    public List<QuotationLineItem__c> GetQuotationLineItemList(String quotationId) {
        return  [Select 
                         Id,
                         Day__c,
                         Name,
                         Line_Item_Date__c,
                         Format_Date__c,
                         Display_Count__c,
                         Net_Cost__c,
                         Markup_in_Zar__c,
                         Sale__c
                     FROM 
                         QuotationLineItem__c
                    WHERE 
                         Quotation__r.Id = :quotationId 
                 ORDER BY
                         Display_Count__c DESC];
    }
    
    public Map<Id,Id> GetCrmCodeToServiceLineItemMapping(String quotationLineItemId) 
    {
        Map<Id,Id> result = new  Map<Id,Id>();
        List<ServiceLineItem__c> slis=  [SELECT  
                                         Id,
                                         Crm_Code__c
                                         FROM  
                                         ServiceLineItem__c  
                                         WHERE 
                                         QuotationLine__c=:quotationLineItemId];
        
        Set<String> crmCodes = new Set<String>();
        for(ServiceLineItem__c sli:slis)
        {
            
            if(!crmCodes.Contains(sli.Crm_Code__c))
            {
                crmCodes.add(sli.Crm_Code__c);
            }
        }
        List<CRM__c> crms=[SELECT
                           Id,CODE__c
                           FROM 
                           CRM__c 
                           WHERE
                           CODE__c IN:crmCodes];
        for(ServiceLineItem__c sli:slis)
        {
            for(CRM__c crm:crms)
            {
                if(sli.Crm_Code__c == crm.Code__c)
                {
                    result.put(sli.Id, crm.Id);
                }
            }
        }
        return result;
    }
    
    public List<ServiceLineItem__c> GetServiceLineItemRelatedToQuotations(String quotationLineItemId) {
        return  [SELECT  
                 Name, 
                 Id,
                 ClientNotes__c,
                 Service_Date__c,
                 Service_Status__c,
                 Basis__c,
                 Service_Detail__c,
                 SupplierName__c,
                 Markup__c,
                 Nett_Cost__c,
                 MarkUp_Zar__c,
                 Markup_Eur__c,
                 MarkupUSD__c,
                 Nett_Cost_in_EUR__c,
                 Nett_Cost_in_USD__c,
                 Sale_in_Eur__c,
                 Sale_in_USD__c,
                 Total__c,
                 Crm_Code__c,
                 Day_Order__c,
                 QuotationLine__c,
                 QuotationLine__r.Day__c,
                 QuotationLine__r.Name  ,
                 QuotationLine__r.Line_Item_Date__c,
                 QuotationLine__r.Format_Date__c,
                 QuotationLine__r.Markup_in_Zar__c
                 FROM  
                 ServiceLineItem__c  
                 WHERE 
                 QuotationLine__c=:quotationLineItemId
                 ORDER BY Day_Order__c,ServiceLineItem__c.CreatedDate ASC, ServiceLineItem__c.Name ASC];
    }
    
    public List<ServiceLineItem__c> getRelatedQuotationServiceLineItems(List<Id> quotationLineItemIds) {
        return  [SELECT  
                 Name, 
                 Id,
                 QuotationLine__c
                 FROM  
                 ServiceLineItem__c  
                 WHERE 
                 QuotationLine__c IN:quotationLineItemIds];
    }
    
    public List<Service_Line_Item_ChargeType__c> GetChargeTypeRelatedToServiceLineItem(String serviceLineItemId) {
        return[SELECT
               Name,
               Total__c,
               Extra__c,
               Category__c,
               Charge_Type__c,
               Currency__c,
               Nett_Cost__c,
               Markup__c,
               Service_Line_Item__c,
               Service_Line_Item__r.Name,
               Service_Line_Item__r.Basis__c,
               Service_Line_Item__r.MarkupUSD__c,
               Service_Line_Item__r.Markup_Eur__c,
               Service_Line_Item__r.MarkUp_Zar__c,
               Service_Line_Item__r.Nett_Cost_in_EUR__c,
               Service_Line_Item__r.Nett_Cost_in_USD__c,
               Service_Line_Item__r.Sale_in_Eur__c,
               Service_Line_Item__r.Sale_in_USD__c,
               Service_Line_Item__r.Service_Detail__c,
               Service_Line_Item__r.Service_Status__c,
               Service_Line_Item__r.ClientNotes__c,
               Selected_Passenger__r.PassengerName__c,
               Service_Line_Item__r.Crm_Code__c
               FROM  
               Service_Line_Item_ChargeType__c 
               WHERE 
               Service_Line_Item__c=:serviceLineItemId  
               ORDER BY Selected_Passenger__r.Is_Primary__c DESC];
    }
    
    public List<Service_Line_Item_ChargeType__c> GetChargeTypeRelatedToServiceLineItems(Set<String> serviceLineItemIds) {
        return   [select
                          Name,
                          Total__c,
                          Extra__c,
                          Category__c,
                          Charge_Type__c,
                          Currency__c,
                          Nett_Cost__c,
                          Markup__c,
                          Service_Line_Item__c,
                          Service_Line_Item__r.Service_Status__c,
                          Selected_Passenger__r.PassengerName__c
                     FROM  
                          Service_Line_Item_ChargeType__c 
                     WHERE 
                          Service_Line_Item__c IN :serviceLineItemIds  
                          ORDER BY Selected_Passenger__r.PassengerName__c ASC];
    }
    
    public List<String> GetServiceTypes()
    {
        List<String> options = new List<String>();
        Set<Id> srvIds = new Set<Id>();
        options.add('--Select Service Types--');
        
        AggregateResult[]  srvLIds= [SELECT 
                                             SRV_Lookup__c
                                        FROM
                                             OPT__c  
                                     GROUP BY SRV_Lookup__c];
        for(AggregateResult ar:srvLIds)
        {
            srvIds.add(String.valueOf(ar.get('SRV_Lookup__c')));
        }
        
        List<SRV__c>  srvs= [SELECT
                                     NAME__c 
                                FROM 
                                     SRV__c  
                                WHERE 
                                     Id IN: srvIds 
                              ORDER BY NAME__c];
        for(SRV__c ar:srvs)
        {
            options.add(ar.NAME__c);
        }
        return options;
    }
    
    public List<String> GetServiceTypeForSupplier(string supplierId){
        Set<String> options = new Set<String>();
        options.add('--Select ServiceType--');
        List<OPT__c> SrvName = [SELECT
                                        SRV_Name__c
                                   FROM
                                        OPT__c
                                  WHERE 
                                        CRM_Lookup__c=:supplierId ];
        
        for(OPT__c opt:SrvName)
        {
            if(!options.contains(opt.SRV_Name__c))
            {
                options.add(opt.SRV_Name__c);
            }
        }
        return new List<String>(options);
    }
    
    public List<String> GetLocationForSupplier(string supplierIdorCode,String mode){
        Set<String> options = new Set<String>();
        options.add('--Select Location--');
        List<OPT__c> SrvName =null;
        if(mode=='Edit')
        {
            SrvName = [SELECT 
                               LOC_Name__c
                          FROM
                               OPT__c 
                          WHERE 
                               CRM_Lookup__r.CODE__c =: supplierIdorCode ];
        }
        else
        {
            SrvName = [SELECT 
                               LOC_Name__c 
                         FROM
                               OPT__c
                          WHERE
                               CRM_Lookup__c =: supplierIdorCode ];
        }
        
        for(OPT__c opt:SrvName)
        {
            if(!options.contains(opt.LOC_Name__c))
            {
                options.add(opt.LOC_Name__c);
            }
        }
        return new List<String>(options);
    }
    
    public List<String> GetLocations(String selectedServiceType) {
        List<String> options = new List<String>();
        Set<Id> locIds = new Set<Id>();
        options.add('--Select Location--');
        
        AggregateResult[]  locLIds= [SELECT 
                                             LCL_Lookup__c
                                      FROM 
                                             OPT__c
                                       WHERE 
                                             SRV_Name__c =: selectedServiceType 
                                   GROUP BY LCL_Lookup__c];
        for(AggregateResult ar:locLIds)
        {
            locIds.add(String.valueOf(ar.get('LCL_Lookup__c')));
        }
        
        List<LCL__c> locations= [SELECT 
                                         DESCR__c
                                   FROM 
                                         LCL__c 
                                   WHERE 
                                         Id IN: locIds 
                                  ORDER BY DESCR__c];
        for(LCL__c ar:locations)
        {
            options.add(ar.DESCR__c);
        }
        return options;
    }
    
    public List<String> GetSupplierNames(String selectedLocation,String selectedServiceType,Boolean preferredSupplier) {
        List<String> options = new List<String>();
        Set<Id> crmIds = new Set<Id>();
        options.add('--Select Supplier Name--');
        AggregateResult[]  crmLIds;
        if(preferredSupplier)
        {    
            crmLIds= [SELECT CRM_Lookup__c FROM OPT__c WHERE ANALYSIS1__c='PF' AND LOC_Name__c=:selectedLocation AND SRV_Name__c=:selectedServiceType GROUP BY CRM_Lookup__c];
        }
        else
        {
            crmLIds= [SELECT CRM_Lookup__c from OPT__c WHERE LOC_Name__c=:selectedLocation  AND SRV_Name__c=:selectedServiceType  GROUP BY CRM_Lookup__c];
        }
        for(AggregateResult ar:crmLIds)
        {
            crmIds.add(String.valueOf(ar.get('CRM_Lookup__c')));
        }
        List<CRM__c> supplierNames= [SELECT NAME__c FROM CRM__c WHERE Id IN:crmIds];
        
        for(CRM__c ar:supplierNames)
        {
            options.add(ar.NAME__c);
        }
        return options;
    }
    
    public List<String> GetRoomConfiguration(String supplierIdOrCode,String mode) {
        
        Set<String> options = new Set<String>();
        options.add('--Select Room Configuration--');
        List<SOD__c> sods = null;
        if(mode == 'Edit')
        {
            sods = [SELECT 
                    SINGLE_AVAIL__c,DOUBLE_AVAIL__c,TWIN_AVAIL__c,TRIPLE_AVAIL__c,QUAD_AVAIL__c,OTHER_AVAIL__c
                    FROM SOD__c 
                    WHERE CRM_Lookup__r.CODE__c=:supplierIdOrCode ];
        }
        else
        {
            sods = [SELECT  SINGLE_AVAIL__c,
                    DOUBLE_AVAIL__c,
                    TWIN_AVAIL__c,
                    TRIPLE_AVAIL__c,
                    QUAD_AVAIL__c,
                    OTHER_AVAIL__c
                    FROM 
                    SOD__c 
                    WHERE 
                    CRM_Lookup__c=:supplierIdOrCode ];
        }
        
        for(SOD__c ar:sods)
        {
            if(ar.SINGLE_AVAIL__c== true)
            {
                if(!options.contains('SINGLE AVAIL'))
                    options.add('SINGLE AVAIL');
            }
            if(ar.DOUBLE_AVAIL__c== true)
            {
                if(!options.contains('DOUBLE AVAIL'))
                    options.add('DOUBLE AVAIL');
            }
            if(ar.TWIN_AVAIL__c== true)
            {
                if(!options.contains('TWIN AVAIL'))
                    options.add('TWIN AVAIL');
            }
            if(ar.TRIPLE_AVAIL__c== true)
            {
                if(!options.contains('TRIPLE AVAIL'))
                    options.add('TRIPLE AVAIL');
            }
            if(ar.QUAD_AVAIL__c== true)
            {
                if(!options.contains('QUAD AVAIL'))
                    options.add('QUAD AVAIL');
            }
            if(ar.OTHER_AVAIL__c== true)
            {
                if(!options.contains('OTHER AVAIL'))
                    options.add('OTHER AVAIL');
            }
        }
        
        return new List<String>(options);
    }
    
    public  List<String>  GetSuppplierNameLookupQuery(String selectedLocation,String selectedServiceType,Boolean preferredSupplier) {
        
        List<String> dbQuery = new List<String>();
        String crmIds='';
        
        AggregateResult[]  crmLIds;
        if(preferredSupplier)
        {    
            crmLIds= [SELECT CRM_Lookup__c FROM OPT__c WHERE ANALYSIS1__c='PF' AND LOC_Name__c=:selectedLocation  AND SRV_Name__c=:selectedServiceType GROUP BY CRM_Lookup__c];
        }
        else
        {
            crmLIds= [SELECT CRM_Lookup__c FROM OPT__c WHERE LOC_Name__c=:selectedLocation  AND SRV_Name__c=:selectedServiceType  GROUP BY CRM_Lookup__c];
        }
        for(AggregateResult ar:crmLIds)
        {
            
            crmIds += (crmIds==''?'':',') + '\''+ String.valueOf(ar.get('CRM_Lookup__c')) + '\'';
            
        }
        
        String query  = 'SELECT NAME__c FROM CRM__c WHERE Id IN( '+crmIds+')';
        
        dbQuery.add(query);
        
        return dbQuery;
    }
    
    public List<String> GetServiceDetails(String selectedSupplierName,String selectedServiceType,String selectedLocation) {
        List<String> options = new List<String>();
        options.add('--Select Service Details--');
        List<OPT__c> supplierNames= [SELECT 
                                     Comment__c,
                                     Description__c
                                     FROM 
                                     OPT__c
                                     WHERE LOC_Name__c=:selectedLocation
                                     AND SRV_Name__c=:selectedServiceType 
                                     AND CRM_Name__c=:selectedSupplierName];
        
        for(OPT__c ar:supplierNames)
        {
            options.add(String.valueOf(ar.Description__c)+' || '+String.valueOf(ar.Comment__c));
        }
        
        //System.debug('GetServiceDetails>>'+options);
        return options;
    }
    
    public List<String> GetServiceDetailsWithSupplierId(String selectedSupplierId,String selectedServiceType,String selectedLocation) {
        List<String> options = new List<String>();
        options.add('--Select Service Details--');
        List<OPT__c> supplierNames= [SELECT 
                                     Comment__c,
                                     Description__c
                                     FROM 
                                     OPT__c
                                     WHERE LOC_Name__c=:selectedLocation
                                     AND SRV_Name__c=:selectedServiceType 
                                     AND CRM_Lookup__c=:selectedSupplierId];
        
        for(OPT__c ar:supplierNames)
        {
            options.add(String.valueOf(ar.Description__c)+' || '+String.valueOf(ar.Comment__c));
        }
        return options;
    }
    
    public List<String> GetServiceStatus() {
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = ServiceLineItem__c.Service_Status__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for (Schema.PicklistEntry f: ple) {
            options.add(f.getLabel());
        }       
        return options;
    }
    
    public List<String> GetNumberOfDays(String quotationId,String quotationLineItemId) {
        
        List<String> options = new List<String>();
        List<Quotations__c> quotations= [SELECT  Total_Days__c from Quotations__c where  Id =:quotationId];
        List<QuotationLineItem__c> QuotationLineItems= [SELECT  Display_Count__c from QuotationLineItem__c where  Id =:quotationLineItemId];
        Decimal TotalDays =  quotations[0].Total_Days__c - QuotationLineItems[0].Display_Count__c;
        
        for (Integer i=1;i<= TotalDays;i++) {
            options.add(String.valueOf(i));
        }       
        
        Logger.log('GetNumberOfDays',options);
        return options;
    }
    
    public List<String> GetNumberOfNights(String quotationId,String quotationLineItemId)
    {
        
        List<String> options = new List<String>();
        List<Quotations__c> quotations= [SELECT  Total_Nights__c from Quotations__c where  Id =:quotationId];
        List<QuotationLineItem__c> QuotationLineItems= [SELECT  Display_Count__c from QuotationLineItem__c where  Id =:quotationLineItemId];
        Decimal TotalNights =  quotations[0].Total_Nights__c - QuotationLineItems[0].Display_Count__c;
        
        for (Integer i=1;i<=TotalNights;i++) {
            options.add(String.valueOf(i));
        }   
        Logger.log('GetNumberOfNights',options);
        return options;
    }
    
    public List<String> GetCurrencyCodes()
    {
        List<String> options = new List<String>();
        options.add('--SELECT Currency--');
        AggregateResult[] currencyCodes= [SELECT Description__c from DB4__c where Id  IN (SELECT DB4_Lookup__c FROM OPT__c ) GROUP BY Description__c];
        for(AggregateResult ar:currencyCodes)
        {
            options.add(String.valueOf(ar.get('Description__c')));
        }
        
        return options;
    }
    
    public List<String> GetChargeTypes() {
        List<String> options = new List<String>();
        options.add('--SELECT Charge Types--');
        AggregateResult[] chargeTypes= [SELECT FCU__c from OPT__c GROUP BY FCU__c];
        for(AggregateResult ar:chargeTypes)
        {
            options.add(String.valueOf(ar.get('FCU__c')));
        }
        
        return options;
    }
    
    public List<Passenger__c> GetQuotationPassengers(String quotationId) {
        List<PassengerQuotationMapping__c> PassengerQuotationMappings = [SELECT Passenger__c FROM PassengerQuotationMapping__c WHERE Quotation__c=:quotationId] ;
        
        List<String> PassengerIds = new List<String>();
        
        for(PassengerQuotationMapping__c pqm:PassengerQuotationMappings)
        {
            PassengerIds.add(pqm.Passenger__c);
        }
        
        List<Passenger__c>  Passengers = DAL_Passenger.getByIds(PassengerIds);
        
        return Passengers;
    }
    
    public List<Passenger__c> GetServiceLineItemPassengers(String serviceLineItemId) {
        List<ServiceLineItemPassengersMapping__c> ServiceLineItemPassengersMappings = [SELECT Passenger__c FROM ServiceLineItemPassengersMapping__c WHERE Service_Line_Item__c=:serviceLineItemId] ;
        List<String> PassengerIds = new List<String>();
        
        for(ServiceLineItemPassengersMapping__c pqm:ServiceLineItemPassengersMappings)
        {
            PassengerIds.add(pqm.Passenger__c);
        }
        
        List<Passenger__c>  Passengers = [SELECT Id,PassengerName__c FROM Passenger__c WHERE Id IN:PassengerIds];
        
        return Passengers;
    }
    
    public  Set<String> saveServiceLineItem(String serviceLineItemName,String selectedServiceType,String selectedLocation,
                                            String selectedSupplierName, String selectedSupplierId,
                                            String selectedServiceDetail,String quotationLineItemId,
                                            String serviceClientNotes,
                                            String serviceReservationNumber, String serviceSupplierNotes, 
                                            String serviceSelectServiceStatus, String serviceExpiryDate,
                                            Boolean overrideDetails,String[] passengerToBeSaved,String serviceDate,String numberOfDays,
                                            String quotationId,OPT__c opt,List<Passenger__c>  allPassengers, String roomConfiguration,
                                            String wetuStartLocation,String wetuStartLocationId,String wetuEndLocation,String wetuEndLocationId,
                                            String wetuStartTime,String wetuEndTime, String startTerminal,
                                            String endTerminal,String duration,String checkInTime,String ticketClass)
   {
    Set<String> ErrorMessageList = new Set<String>();
    try
    {                                                                      
        UTIL_LogGenerator logger = new UTIL_LogGenerator();
        logger.start(CLASS_NAME,'QuotationBuilderDatabaseQueries>SaveServiceLineItem');
        List<String> quotationIds= new List<String>();
        quotationIds.add(quotationId);                                         
        List<QuotationLineItem__c> items=DAL_Quotations.getAllQuotationsLineItems(quotationIds); 
        
        List<ServiceLineItem__c> ServiceLineItemsToBeSaved = new List<ServiceLineItem__c>();
        Map<ID,DateTime> LineItemDates = new Map<ID,DateTime>();
        Map<ID,String> LineIteOwnerEmailMap = new Map<ID,String>();                                                                    
        for(QuotationLineItem__c qli:items)
        {
            LineItemDates.put(qli.Id, qli.Line_Item_Date__c);
            LineIteOwnerEmailMap.put(qli.Id,qli.Quotation__r.Opportunity__r.Owner.Email);
        }
        logger.log('LineItemDates',LineItemDates);
        if(numberOfDays == null && overrideDetails)
        {
            numberOfDays = '1';
        }
        Integer numberOfDay = Integer.valueOf(numberOfDays);
        Integer ServiceDuration = Integer.valueOf(numberOfDays);
        string hour = '00';
        string minute = '00';
        string second = '00';
        logger.log('serviceDate',serviceDate);
        String serviceDate1 = serviceDate.substringBefore('-')+'-'+serviceDate.substringAfterLast('-')+'-'+serviceDate.substringBetween('-','-');
        Date sDate = date.valueOf(serviceDate  + ' ' + hour + ':' + minute + ':' + second);
        Date LineItemDate = sDate;                                                                  
        String qliId;
        
        Decimal ServiceTypeMarkup =0;
        Decimal CountryMarkup =0;
        Decimal SupplierMarkup = 0;
        //if(!overrideDetails)
        //{
        Decimal stm = GetServiceTypeMarkup(selectedServiceType);
        if(stm != null)
        {
            ServiceTypeMarkup =stm;
        }
        
        Decimal sm = GetSupplierMarkup(opt.CRM_Code__c);
        if(sm != null)
        {
            SupplierMarkup =sm;
        }
        
        String cm = GetResidenceCountryFromQuotationId(quotationId);
        String cor = GetCountryMarkup(cm);
        if(!String.isEmpty(cor))                                                                            
        {
            CountryMarkup = Decimal.valueOf(cor);
        }
        //}
        
        for(Integer i=0;i<numberOfDay;i++)
        {
            for(ID  Iid:LineItemDates.keySet())
            {
                if(LineItemDates.get(Iid) == LineItemDate)
                {
                    qliId = Iid;
                    logger.log('qliId',qliId);
                }
            }
            
            Integer lastCount = DAL_Quotations.getExistingServiceLineItemCount(LineItemDate,qliId);
            if(lastCount==NULL)
            {
                lastCount =0;
            }
            ServiceLineItem__c ServiceLineItem = new ServiceLineItem__c();
            
            ServiceLineItem.Service_Date__c = LineItemDate;
            LineItemDate  =LineItemDate.addDays(1);
            
            if(serviceLineItemName == null || serviceLineItemName.length()==0)
            {
               // ServiceLineItem.Name = selectedSupplierName + ' '+selectedServiceType;
               ServiceLineItem.Name = selectedSupplierName;
            }
            else
            {
                ServiceLineItem.Name = serviceLineItemName;    
            }
            
            ServiceLineItem.Service_Type__c = selectedServiceType;
            ServiceLineItem.ServiceLocation__c = selectedLocation;
            ServiceLineItem.SupplierName__c = selectedSupplierName;
            ServiceLineItem.Service_Detail__c = selectedServiceDetail;
            
            if(opt !=null)
            {
                ServiceLineItem.Basis__c = opt.Comment__c;
                ServiceLineItem.Crm_Code__c = opt.CRM_Code__c;
                ServiceLineItem.Selected_OPT_Code__c = opt.Code__c;
            }
            
            ServiceLineItem.ClientNotes__c = serviceClientNotes;
            ServiceLineItem.QuotationLine__c = qliId;    
            ServiceLineItem.Reservation_Number__c = serviceReservationNumber;    
            ServiceLineItem.Supplier_Notes__c = serviceSupplierNotes;    
            ServiceLineItem.Service_Status__c = serviceSelectServiceStatus;    
            ServiceLineItem.Override_details__c = overrideDetails;
            ServiceLineItem.Service_Duration__c = ServiceDuration; 
            ServiceLineItem.Room_Configuration__c = roomConfiguration;
            ServiceLineItem.Selected_Supplier_Id__c = selectedSupplierId;
            ServiceLineItem.Opportunity_Owner_Email__c  =LineIteOwnerEmailMap.get(qliId);
            
            // Populate this value with the selected supplied code ServiceLineItem.Supplier_Code__c  = 
            ServiceLineItem.Sequence__c =lastCount+1;
            
            ServiceLineItem.Wetu_Start_Location__c = wetuStartLocation;
            ServiceLineItem.Wetu_End_Location__c = wetuEndLocation;
            ServiceLineItem.Wetu_Start_Location_Id__c = wetuStartLocationId;
            ServiceLineItem.Wetu_End_Location_Id__c = wetuEndLocationId;
            ServiceLineItem.Checkin_Time__c = checkInTime;
            ServiceLineItem.End_Terminal__c  = endTerminal;
            ServiceLineItem.Start_Terminal__c  = startTerminal;
            ServiceLineItem.Ticket_Class__c  = ticketClass;
            ServiceLineItem.Duration__c  = duration;
            ServiceLineItem.TotalServiceDuration__c  = Integer.valueOf(numberOfDays);
           
            string stringDate = serviceExpiryDate + ' ' + hour + ':' + minute + ':' + second;                                                                          
            ServiceLineItem.Provisional_Booking_Expiry_Date__c =  date.valueOf(stringDate);

            ServiceLineItem.Wetu_Start_time__c = wetuStartTime;
            ServiceLineItem.Wetu_End_Time__c = wetuEndTime;
            
            ServiceLineItemsToBeSaved.add(ServiceLineItem);
            ServiceDuration  = ServiceDuration -1;
        }
        
        DAL_BaseObject.InsertDBObjects(ServiceLineItemsToBeSaved); 
        
        for(ServiceLineItem__c sli:ServiceLineItemsToBeSaved)
        {
            sli.Parent_Reference__c =ServiceLineItemsToBeSaved[0].Id;
        }
        BaseTriggerHandler.bypass('TH_ServiceLineItems');
        upsert ServiceLineItemsToBeSaved;
        BaseTriggerHandler.clearBypass('TH_ServiceLineItems');
        
        
        List<ServiceLineItemPassengersMapping__c> ServiceLineItemPassengersMappings = null;
        if(!passengerToBeSaved.isEmpty())
        {
            ServiceLineItemPassengersMappings = new List<ServiceLineItemPassengersMapping__c>();
            for(ServiceLineItem__c sli:ServiceLineItemsToBeSaved)
            {
                for(String pId:passengerToBeSaved)
                {
                    ServiceLineItemPassengersMapping__c ServiceLineItemPassengersMapping = new ServiceLineItemPassengersMapping__c();
                    ServiceLineItemPassengersMapping.Passenger__c = pId;
                    ServiceLineItemPassengersMapping.Service_Line_Item__c = sli.Id;
                    ServiceLineItemPassengersMappings.add(ServiceLineItemPassengersMapping);
                }
            }
            logger.log('ServiceLineItemPassengersMappings>>',ServiceLineItemPassengersMappings);
            
            DAL_BaseObject.InsertDBObjects(ServiceLineItemPassengersMappings); 
        }
        
        Set<String> errors = PopulateServiceChargeTypeInserviceLineItems(ServiceLineItemsToBeSaved,
                                                                        allPassengers,
                                                                        ServiceLineItemPassengersMappings,
                                                                        opt,
                                                                        CountryMarkup,
                                                                        ServiceTypeMarkup,
                                                                        overrideDetails,
                                                                        SupplierMarkup,
                                                                        selectedSupplierId);             
        
        System.debug('errors>>'+errors);
        if(errors.size() > 0)
        {
            ErrorMessageList.addAll(errors);
            delete ServiceLineItemsToBeSaved;
        }
    }
    catch(Exception e)
    {
        ErrorMessageList.add(e.getMessage());
    }                                                                          
    return ErrorMessageList;
  }
    
    
    public Set<String> PopulateServiceChargeTypeInserviceLineItems(List<ServiceLineItem__c> ServiceLineItems,
                                                                   List<Passenger__c>  allPassengers,
                                                                   List<ServiceLineItemPassengersMapping__c> ServiceLineItemPassengersMapping,
                                                                   OPT__c opt,
                                                                   Decimal CountryMarkup,
                                                                   Decimal ServiceTypeMarkup,
                                                                   Boolean overrideDetails,
                                                                   Decimal SupplierMarkup,
                                                                   String selectedSupplierId)
    {
                                                                       
       Set<String> ErrorMessageList = new Set<String>();
       try
       {
           System.debug('Entry PopulateServiceChargeTypeInserviceLineItems');
           Set<Service_Line_Item_ChargeType__c> serviceLineItemChargeTypes = new Set<Service_Line_Item_ChargeType__c>();
           
           RateCalculation_Helper rateCalculator = null;
           if(opt != null)
           {
               rateCalculator =new RateCalculation_Helper(opt);
           }
           System.debug('after creating rate calculater helper instance PopulateServiceChargeTypeInserviceLineItems');
           Boolean isFirstServiceLineItem = true;
           Boolean IsDiscountAvailable = false;
           Decimal discount = 0;
           
           for(ServiceLineItem__c serviceLineItem:ServiceLineItems)
           {
               System.debug('serviceLineItem  PopulateServiceChargeTypeInserviceLineItems>>'+serviceLineItem);
               if(serviceLineItem.Override_details__c)
               {
                   List<Crm__c> selectedCrm  = DAL_CRM.getById(selectedSupplierId);
                   for(Passenger__c p:allPassengers)
                   {
                       Service_Line_Item_ChargeType__c ServiceLineItemChargeType = CreateServiceLineItemChargeType(serviceLineItem,//serviceLineItem
                                                                                                                   p,//passenger
                                                                                                                   selectedCrm[0].DEFAULT_CURRENCY__c,//sellCurrency
                                                                                                                   0,//Total
                                                                                                                   CountryMarkup,//CountryMarkup
                                                                                                                   ServiceTypeMarkup,//ServiceTypeMarkup
                                                                                                                   opt,//opt
                                                                                                                   null,//selectedOPD
                                                                                                                   IsDiscountAvailable,//IsDiscountAvailable
                                                                                                                   0,//discount
                                                                                                                   SupplierMarkup);//SupplierMarkup
                       
                       if(!serviceLineItemChargeTypes.contains(ServiceLineItemChargeType))
                           serviceLineItemChargeTypes.add(ServiceLineItemChargeType);    
                   }
               }
               else
               {
                   FetchCalculatedValues calculatedValues =   rateCalculator.CalculateServiceChargeType(serviceLineItem,allPassengers,opt);
                   ErrorMessageList.AddAll(calculatedValues.ErrorMessages);
                   if(!ErrorMessageList.isEmpty())
                   {
                       return ErrorMessageList;
                   }
                   ChargeTypeExtraRate ChargeTypeExtraRatesForAdult = calculatedValues.ChargeTypeExtraRatesForAdult ;
                   ChargeTypeExtraRate ChargeTypeExtraRatesForChild = calculatedValues.ChargeTypeExtraRatesForChild ;
                   ChargeTypeExtraRate ChargeTypeExtraRatesForInfant = calculatedValues.ChargeTypeExtraRatesForInfant;
                   
                   
                   if(isFirstServiceLineItem == true)
                   {
                       logger.log('First serviceLineItem Duration>>',serviceLineItem.Service_Duration__c);
                       if(calculatedValues.IsDiscountAvailable)
                       {
                           IsDiscountAvailable  = true;
                           discount = calculatedValues.Discount;
                       }
                       isFirstServiceLineItem = false;
                   }
                   
                   for(Passenger__c p :allPassengers)
                   {
                       OPD__c selectedOpd = null;
                       Decimal Total;
                       if(p.PassengerType__c=='Adult')
                       {
                           //Total = calculatedValues.TotalAdultRate;
                           if(calculatedValues.PerAdultRate == null)
                           {
                               Total = 0;
                           }
                           else
                           {
                               Total = calculatedValues.PerAdultRate;
                           }
                           
                           selectedOpd = calculatedValues.SelectedOPDForAdult;
                       }
                       if(p.PassengerType__c=='Child')
                       {
                           //Total = calculatedValues.TotalChildRate;
                           
                           if(calculatedValues.PerChildRate == null)
                           {
                               Total = 0;
                           }
                           else
                           {
                               Total = calculatedValues.PerChildRate;
                           }
                           selectedOpd = calculatedValues.SelectedOPDForChild;
                       }
                       if(p.PassengerType__c=='Infant')
                       {
                           //Total = calculatedValues.TotalInfantRate;
                           if(calculatedValues.PerInfantRate == null)
                           {
                               Total = 0;
                           }
                           else
                           {
                               Total = calculatedValues.PerInfantRate;
                           }
                           selectedOpd = calculatedValues.SelectedOPDForInfant;
                       }
                       
                       Service_Line_Item_ChargeType__c ServiceLineItemChargeType = CreateServiceLineItemChargeType(serviceLineItem,
                                                                                                                   p,
                                                                                                                   calculatedValues.SelectedOSR.SELL_CURRENCY__c,
                                                                                                                   Total,CountryMarkup,
                                                                                                                   ServiceTypeMarkup,
                                                                                                                   opt,
                                                                                                                   selectedOpd,
                                                                                                                   IsDiscountAvailable,
                                                                                                                   discount,SupplierMarkup);
                       
                       if(!serviceLineItemChargeTypes.contains(ServiceLineItemChargeType))
                           serviceLineItemChargeTypes.add(ServiceLineItemChargeType);    
                       
                       for(String key:ChargeTypeExtraRatesForAdult.ChgExs.keySet())
                       {
                           String ex = ChargeTypeExtraRatesForAdult.ChgExs.get(key);
                           if(ex=='P' || ex=='S' || ex=='1')
                           {
                               //Create charge for each passenger per service line item
                               //Create an Extra Charge Per Day Per Person
                               List<Service_Line_Item_ChargeType__c> extraChargeTypes= CreateExtraChargePerDayPerPerson(
															                                   ServiceLineItems, //ServiceLineItems
															                                   allPassengers,//allPassengers
															                                   key,//chgExValue
															                                   ChargeTypeExtraRatesForAdult,//ChargeTypeExtraRate
															                                   calculatedValues.SelectedOSR.Sell_Currency__c,//sellCurrency
															                                   (Decimal)ChargeTypeExtraRatesForAdult.OPD.Get(key),
															                                   //calculatedValues.PerAdultRate,//chargeRate
															                                   opt,//opt
															                                   CountryMarkup,//CountryMarkup
															                                   ServiceTypeMarkup,
															                                   SupplierMarkup);//ServiceTypeMarkup
                               serviceLineItemChargeTypes.addAll(extraChargeTypes);
                           }
                           if(ex=='G' || ex=='3' || ex=='R')
                           {
                               //Create an Extra Charge Per Day per service line item
                               List<Service_Line_Item_ChargeType__c> extraChargeTypes= CreateExtraChargePerDayPerServiceLineItem(serviceLineItem,
                                                                                                                                 allPassengers,
                                                                                                                                 key,
                                                                                                                                 ChargeTypeExtraRatesForAdult,
                                                                                                                                 calculatedValues.SelectedOSR.Sell_Currency__c,
                                                                                                                                 (Decimal)ChargeTypeExtraRatesForAdult.OPD.Get(key),
                                                                                                                                 //calculatedValues.PerAdultRate,
                                                                                                                                 opt,
                                                                                                                                 CountryMarkup,
                                                                                                                                 ServiceTypeMarkup,
                                                                                                                                 IsDiscountAvailable,
                                                                                                                                 discount,
                                                                                                                                 SupplierMarkup);
                               serviceLineItemChargeTypes.addAll(extraChargeTypes);
                           }
                           if(ex=='2' )
                           {
                               //Create an Extra Charge only on the first line item created NOTE: Devide the charge value by the number of passengers
                               List<Service_Line_Item_ChargeType__c> extraChargeTypes= CreateExtraChargePnlyOnFirstServiceLineItem(ServiceLineItems,
                                                                                                                                   allPassengers,
                                                                                                                                   key,
                                                                                                                                   ChargeTypeExtraRatesForAdult,
                                                                                                                                   calculatedValues.SelectedOSR.Sell_Currency__c,
                                                                                                                                   (Decimal)ChargeTypeExtraRatesForAdult.OPD.Get(key),
                                                                                                                                   //calculatedValues.PerAdultRate,
                                                                                                                                   opt,
                                                                                                                                   CountryMarkup,
                                                                                                                                   ServiceTypeMarkup,
                                                                                                                                   IsDiscountAvailable,
                                                                                                                                   discount,
                                                                                                                                   SupplierMarkup);
                               serviceLineItemChargeTypes.addAll(extraChargeTypes);
                           }
                           if(ex=='0')
                           {
                               //Create an Extra Charge per person only on the first line item
                               List<Service_Line_Item_ChargeType__c> extraChargeTypes= CreateExtraChargePnlyOnFirstServiceLineItem(ServiceLineItems,
                                                                                                                                   allPassengers,
                                                                                                                                   key,
                                                                                                                                   ChargeTypeExtraRatesForAdult,
                                                                                                                                   calculatedValues.SelectedOSR.Sell_Currency__c,
                                                                                                                                   (Decimal)ChargeTypeExtraRatesForAdult.OPD.Get(key),
                                                                                                                                   //calculatedValues.PerAdultRate,
                                                                                                                                   opt,
                                                                                                                                   CountryMarkup,
                                                                                                                                   ServiceTypeMarkup,
                                                                                                                                   IsDiscountAvailable,
                                                                                                                                   discount,
                                                                                                                                   SupplierMarkup);
                               serviceLineItemChargeTypes.addAll(extraChargeTypes);
                           }
                       }
                   }
               }
               
               
           }   
           DAL_BaseObject.InsertDBObjects(new List<Service_Line_Item_ChargeType__c>(serviceLineItemChargeTypes));
       }
       catch(Exception e)
       {
           ErrorMessageList.add(e.getMessage());
       }
       return ErrorMessageList;
  }
    
    public List<Service_Line_Item_ChargeType__c> CreateExtraChargePerDayPerPerson(List<ServiceLineItem__c> ServiceLineItems,
                                                                                  List<Passenger__c>  allPassengers,
                                                                                  String chgExValue,
                                                                                  ChargeTypeExtraRate chargeTypeExtraRate,
                                                                                  String sellCurrency, 
                                                                                  Decimal chargeRate,
                                                                                  OPT__c opt,
                                                                                  Decimal CountryMarkup,
                                                                                  Decimal ServiceTypeMarkup,
                                                                                  Decimal SupplierMarkup)
  {
      List<Service_Line_Item_ChargeType__c> chargeTypeItems =  new List<Service_Line_Item_ChargeType__c>();
      try{
          for(ServiceLineItem__c serviceLineItem:ServiceLineItems){
              for(Passenger__c p:allPassengers)
              {
                  Service_Line_Item_ChargeType__c chargeTypeItem = new Service_Line_Item_ChargeType__c();
                  chargeTypeItem.Service_Line_Item__c = serviceLineItem.Id;
                  chargeTypeItem.Category__c = 'Other Charge';
                  chargeTypeItem.Currency__c = sellCurrency;
                  chargeTypeItem.Extra__c = chargeTypeExtraRate.ExtraRateDescription.get(chgExValue);
                  chargeTypeItem.Nett_Cost__c = chargeRate.setScale(2, RoundingMode.HALF_UP); 
                  chargeTypeItem.Markup__c =  ((CountryMarkup/100) +(ServiceTypemarkup/100) + (SupplierMarkup/100))*100;
                  chargeTypeItem.Total__c = Math.round(chargeTypeItem.Nett_Cost__c *(1 + (CountryMarkup/100) +(ServiceTypemarkup/100) + (SupplierMarkup/100)));    
                  chargeTypeItem.Charge_Type__c = opt.FCU__c;
                  chargeTypeItem.Selected_Passenger__c = p.Id;
                  chargeTypeItem.Selected_OPD__c = chargeTypeExtraRate.OPD.Id;
                  chargeTypeItem.Selected_OPT__c=opt.Id;
                  chargeTypeItems.add(chargeTypeItem);
              }
          }
      }
      catch(Exception e)
      {
          throw new CustomException('CreateExtraChargePerDayPerPerson:>>' + e.getMessage() );
      }
    return chargeTypeItems;
 }
    
    public List<Service_Line_Item_ChargeType__c> CreateExtraChargePerDayPerServiceLineItem(ServiceLineItem__c serviceLineItem,
                                                                                           List<Passenger__c>  allPassengers,
                                                                                           String chgExValue,
                                                                                           ChargeTypeExtraRate chargeTypeExtraRate,
                                                                                           String sellCurrency, Decimal chargeRate,
                                                                                           OPT__c opt,Decimal CountryMarkup,
                                                                                           Decimal ServiceTypeMarkup,
                                                                                           Boolean IsDiscountAvailable,
                                                                                           Decimal discount,
                                                                                           Decimal SupplierMarkup)
    {
        List<Service_Line_Item_ChargeType__c> chargeTypeItems =  new List<Service_Line_Item_ChargeType__c>();
        try{
            Decimal rate = chargeRate/allPassengers.size();
            
            for(Passenger__c p:allPassengers)
            {
                Service_Line_Item_ChargeType__c chargeTypeItem = new Service_Line_Item_ChargeType__c();
                chargeTypeItem.Service_Line_Item__c = serviceLineItem.Id;
                chargeTypeItem.Category__c = 'Other Charge';
                if(sellCurrency == 'NAD')
                sellCurrency ='ZAR';
                chargeTypeItem.Currency__c = sellCurrency;
                
                if(serviceLineItem.Override_details__c)
                {
                    //chargeTypeItem.Markup__c = 0;
                    chargeTypeItem.Markup__c =  ((CountryMarkup/100) +(ServiceTypemarkup/100) + (SupplierMarkup/100))*100;
                    chargeTypeItem.Nett_Cost__c =  0;
                    chargeTypeItem.Total__c = 0;
                    chargeTypeItem.Is_Discounted__c = true;
                }
                else
                {
                    chargeTypeItem.Nett_Cost__c = rate.setScale(2, RoundingMode.HALF_UP); 
                    chargeTypeItem.Markup__c =  ((CountryMarkup/100) +(ServiceTypemarkup/100) + (SupplierMarkup/100))*100;
                    chargeTypeItem.Total__c = Math.round(chargeTypeItem.Nett_Cost__c *(1 + (CountryMarkup/100) +(ServiceTypemarkup/100) + (SupplierMarkup/100)));
                }
                chargeTypeItem.Extra__c = chargeTypeExtraRate.ExtraRateDescription.get(chgExValue);
                chargeTypeItem.Charge_Type__c = opt.FCU__c;
                chargeTypeItem.Selected_Passenger__c = p.Id;
                chargeTypeItem.Selected_OPD__c = chargeTypeExtraRate.OPD.Id;
                chargeTypeItem.Selected_OPT__c=opt.Id;
                chargeTypeItems.add(chargeTypeItem);
            }
        }
        catch(Exception e)
        {
            throw new CustomException('CreateExtraChargePerDayPerServiceLineItem:>>' + e.getMessage() );
        }
        return chargeTypeItems;
    }
    
    public List<Service_Line_Item_ChargeType__c> CreateExtraChargePnlyOnFirstServiceLineItem(
        List<ServiceLineItem__c> ServiceLineItems,
        List<Passenger__c>  allPassengers,
        String chgExValue,
        ChargeTypeExtraRate chargeTypeExtraRate,
        String sellCurrency,
        Decimal chargeRate,
        OPT__c opt,
        Decimal CountryMarkup,
        Decimal ServiceTypeMarkup,
        Boolean IsDiscountAvailable,
        Decimal discount,
        Decimal SupplierMarkup)
    {
        List<Service_Line_Item_ChargeType__c> chargeTypeItems =  new List<Service_Line_Item_ChargeType__c>();
        try{
            ServiceLineItem__c firstServiceLineItem = null; 
            
            for(ServiceLineItem__c serviceLineItem:ServiceLineItems)
            {
                if(firstServiceLineItem == null)
                {
                    firstServiceLineItem = serviceLineItem;
                }
                if(firstServiceLineItem.Service_Duration__c < serviceLineItem.Service_Duration__c)
                {
                    firstServiceLineItem =serviceLineItem;
                }
            }
            
            Decimal rate = chargeRate/allPassengers.size();
            for(Passenger__c p:allPassengers)
            {
                Service_Line_Item_ChargeType__c chargeTypeItem = new Service_Line_Item_ChargeType__c();
                chargeTypeItem.Category__c = 'Other Charge';
                chargeTypeItem.Service_Line_Item__c = firstServiceLineItem.Id;
                if(sellCurrency == 'NAD')
                sellCurrency ='ZAR';
                chargeTypeItem.Currency__c = sellCurrency;
                chargeTypeItem.Extra__c = chargeTypeExtraRate.ExtraRateDescription.get(chgExValue);
                chargeTypeItem.Nett_Cost__c = rate.setScale(2, RoundingMode.HALF_UP); 
                chargeTypeItem.Markup__c =  ((CountryMarkup/100) +(ServiceTypemarkup/100) + (SupplierMarkup/100)) *100;
                chargeTypeItem.Total__c = Math.round(chargeTypeItem.Nett_Cost__c *(1 + (CountryMarkup/100) +(ServiceTypemarkup/100) + (SupplierMarkup/100)));    
                chargeTypeItem.Charge_Type__c = opt.FCU__c;
                chargeTypeItem.Selected_Passenger__c = p.Id;
                chargeTypeItem.Selected_OPD__c= chargeTypeExtraRate.OPD.Id;
                chargeTypeItem.Selected_OPT__c=opt.Id;
                chargeTypeItems.add(chargeTypeItem);
            }
        }
        catch(Exception e)
        {
            throw new CustomException('CreateExtraChargePnlyOnFirstServiceLineItem:>>' + e.getMessage() );
        }
        return chargeTypeItems;
    }
    
    public boolean validateDurationIsValid(Date startdate, Integer duration, String quotationId, String serviceType)
    {
        Boolean checkFlag = false;
        try
        {
            Date endDate = null;
            
            List<AggregateResult> qli=DAL_Quotations.getAllQuotationsLineItemsMaxEndDate(quotationId);
            // sum the amounts
            Date  maxDate = null;
            
            for(AggregateResult q : qli )
            {
                maxDate = (Date)q.get('expr0');
                system.debug('maxDate:::'+maxDate);
                system.debug('startdate:::'+startdate);
                if(maxDate == startdate && duration == 1)
                {
                    checkFlag = true;
                    break;
                }
                else
                {
                    endDate = startdate.addDays(duration-1);
                    if(endDate <= maxDate)
                    {
                        checkFlag = true;
                        break;
                    }
                }
            }
        }
        catch(Exception e)
        {
            throw new CustomException('validateDurationIsValid:>>' + e.getMessage() );
        }
        return checkFlag;
    }
    
    public Service_Line_Item_ChargeType__c CreateServiceLineItemChargeType(ServiceLineItem__c serviceLineItem, 
                                                                           Passenger__c passenger,
                                                                           String sellCurrency,
                                                                           Decimal Total,
                                                                           Decimal CountryMarkup,
                                                                           Decimal ServiceTypeMarkup,
                                                                           OPT__c opt,
                                                                           OPD__c selectedOPD,
                                                                           Boolean IsDiscountAvailable,
                                                                           Decimal discount,
                                                                           Decimal SupplierMarkup)
    {
       system.debug('CountryMarkup:::'+CountryMarkup);
       system.debug('ServiceTypeMarkup:::'+ServiceTypeMarkup);
        Service_Line_Item_ChargeType__c serviceLineChargeType = new Service_Line_Item_ChargeType__c();
        try
        {
            serviceLineChargeType.Service_Line_Item__c = serviceLineItem.Id;
            serviceLineChargeType.Selected_Passenger__c = passenger.Id;
            if(sellCurrency == 'NAD')
            sellCurrency ='ZAR';
            serviceLineChargeType.Currency__c  = sellCurrency;
            if((IsDiscountAvailable && serviceLineItem.Service_Duration__c < = discount) 
               || (serviceLineItem.Override_details__c == true))
            {
               // serviceLineChargeType.Markup__c = 0;
                serviceLineChargeType.Markup__c =  ((CountryMarkup/100) + (ServiceTypemarkup/100) + (SupplierMarkup/100))*100;
                serviceLineChargeType.Nett_Cost__c =  0;
                serviceLineChargeType.Total__c = 0;
                if(IsDiscountAvailable)
                    serviceLineChargeType.Is_Discounted__c = true;
            }
            else
            {
                serviceLineChargeType.Markup__c =  ((CountryMarkup/100) + (ServiceTypemarkup/100) + (SupplierMarkup/100))*100;
                serviceLineChargeType.Nett_Cost__c =  Total.setScale(2, RoundingMode.HALF_UP);
                serviceLineChargeType.Total__c = Math.round(serviceLineChargeType.Nett_Cost__c *(1 + (CountryMarkup/100) + (ServiceTypemarkup/100) + (SupplierMarkup/100)));   
            }
            if(selectedOPD != null)
            {
                serviceLineChargeType.Selected_OPD__c = selectedOPD.Id;
            }
            if(opt != null)
            {
                serviceLineChargeType.Selected_OPT__c= opt.Id;
            }
            
        }
        catch(Exception e)
        {
            throw new CustomException('CreateServiceLineItemChargeType:>>' + e.getMessage());
        }
        return serviceLineChargeType;
    }
    
    
    public List<ServiceLineItem__c> GetServiceLineItemForWetu(String quotationId) 
    {
        List<QuotationLineItem__c> quotationLineItems=[SELECT 
                                                              Id
                                                           FROM
                                                                QuotationLineItem__c 
                                                           WHERE
                                                                Quotation__r.Id = :quotationId
                                                           ORDER BY Line_Item_Date__c ASC];
        system.debug('quotationLineItems:::'+quotationLineItems.size());
        Set<Id> quotationLineItemIds = new Set<Id>();
        for(QuotationLineItem__c qli:quotationLineItems)
        {
            quotationLineItemIds.add(qli.Id);
        }
        
        return  [SELECT  
                         Name, 
                         Id,
                         Service_Date__c,
                         Service_Status__c,
                         Service_Detail__c,
                         SupplierName__c,
                         Nett_Cost__c,
                         Crm_Code__c,
                         Markup__c,
                         Total__c,
                         QuotationLine__c,
                         Service_Type__c,
                         ServiceLocation__c,
                         ClientNotes__c,
                         Service_Duration__c,
                         Selected_OPT_Code__c,
                         Start_Terminal__c,
                         End_Terminal__c,
                         Ticket_Class__c,
                         TotalServiceDuration__c,
                         Checkin_Time__c,
                         Duration__c,
                         Wetu_Start_Location__c,
                         Wetu_End_Location__c,
                         Wetu_End_Location_Id__c,
                         Wetu_Start_Location_Id__c,
                         Wetu_Start_time__c,
                         Wetu_End_Time__c,
                         Day_Order__c,
                         Reservation_Number__c,
                         Basis__c,
                         Sequence__c
                 FROM  
                        ServiceLineItem__c  
                 WHERE 
                        QuotationLine__c IN:quotationLineItemIds
                 ORDER BY 
                        ServiceLineItem__c.Service_Date__c ASC];    
        
    }
    
    public List<ServiceLineItem__c> GetServiceLineItemForWetuLegDetail(String quotationId,LegDetail currentLeg)
    {
        List<QuotationLineItem__c> quotationLineItems=[SELECT
                                                            Id 
                                                       FROM 
                                                            QuotationLineItem__c 
                                                       WHERE
                                                            Quotation__r.Id = :quotationId
                                                       ORDER BY
                                                            Line_Item_Date__c ASC];
        
        List<ServiceLineItem__c> serviceLineItems = new List<ServiceLineItem__c>();
        Set<Id> quotationLineItemIds = new Set<Id>();
        
        for(QuotationLineItem__c qli:quotationLineItems)
        {
            quotationLineItemIds.add(qli.Id);
        }
        
        List<ServiceLineItem__c> sli=[SELECT  
                                              Name, 
                                              Id,
                                              Service_Date__c,
                                              Service_Status__c,
                                              Service_Detail__c,
                                              SupplierName__c,
                                              Nett_Cost__c,
                                              Markup__c,
                                              Total__c,
                                              QuotationLine__c,
                                              Service_Type__c,
                                              ClientNotes__c,
                                              Selected_OPT_Code__c,
                                              Wetu_Start_time__c,
                                              Wetu_End_Time__c,
                                              Start_Terminal__c,
                                              End_Terminal__c,
                                              Ticket_Class__c,
                                              Checkin_Time__c,
                                              Duration__c,
                                              Sequence__c
                                         FROM  
                                              ServiceLineItem__c  
                                         WHERE 
                                              QuotationLine__c IN:quotationLineItemIds
                                          AND 
                                              Service_Date__c >= :currentLeg.LegStartDate 
                                          AND 
                                              Service_Date__c<= :currentLeg.LegEndDate 
                                              ORDER BY ServiceLineItem__c.Service_Date__c ASC];    
        
        serviceLineItems.addAll(sli);
        return serviceLineItems;
    }
    
    public List<ServiceLineItem__c> GetServiceLineItemForWetuCarHire(String quotationId) {
        
        List<QuotationLineItem__c> quotationLineItems=[SELECT 
                                                               Id
                                                         FROM
                                                               QuotationLineItem__c
                                                         WHERE 
                                                               Quotation__r.Id = :quotationId
                                                        ORDER BY Line_Item_Date__c ASC];
        List<ServiceLineItem__c> serviceLineItems = new List<ServiceLineItem__c>();
        Set<Id> quotationLineItemIds = new Set<Id>();
        for(QuotationLineItem__c qli:quotationLineItems)
        {
            quotationLineItemIds.add(qli.Id);
        }  
        List<ServiceLineItem__c> sli = [SELECT  
                                                Name, 
                                                Id,
                                                Service_Date__c,
                                                Service_Status__c,
                                                Service_Detail__c,
                                                SupplierName__c,
                                                Nett_Cost__c,
                                                Markup__c,
                                                Total__c,
                                                QuotationLine__c,
                                                Selected_OPT_Code__c,
                                                Wetu_Start_time__c,
                                                Wetu_End_Time__c,
                                                Start_Terminal__c,
                                                End_Terminal__c,
                                                Ticket_Class__c,
                                                Checkin_Time__c,
                                                Duration__c
                                          FROM  
                                                ServiceLineItem__c  
                                         WHERE 
                                                QuotationLine__c IN:quotationLineItemIds
                                           AND  
                                                ServiceLineItem__c.Service_Type__c='Car Hire'
                                                ORDER BY ServiceLineItem__c.Service_Date__c ASC];    
        
        serviceLineItems.addAll(sli);
        
        return serviceLineItems;
    }
    
    public AggregateResult[] getTotalPricePerPassengers(Set<String> serviceLineItemsId,
                                                        Set<String> selectedPassengers,String currencyName)
    {
        return [SELECT
                        Selected_Passenger__c, SUM(Total__c) total
                   FROM
                        Service_Line_Item_ChargeType__c 
                  WHERE 
                        Service_Line_Item__c IN:serviceLineItemsId
                   AND   
                        Selected_Passenger__c IN:selectedPassengers
                   AND
                        Currency__c =:currencyName
                 GROUP BY Selected_Passenger__c];
        
    }
    
    public Quotations__c getQuotationForPricingSummary(String quotationId)
    {
        return [SELECT  
                        Id,
                        Sale_in_Zar__c,
                        COS_in_ZAR__c,
                        Profit_IN_ZAR__c,
                        Quotation_Gross_Profit_ZAR__c,
                        Sale_in_USD__c,
                        COS_in_USD__c,
                        Profit_USD__c,
                        Quotation_Gross_Profit_USD__c,
                        Sale_in_EUR__c,
                        COS_in_EUR__c,
                        Profit_EUR__c,
                        Quotation_Gross_Profit_EUR__c,
                        Opportunity__c,
                        Opportunity__r.CloseDate,
                        Opportunity__r.Arrival_Date__c,
                        Quotation_Sale_Total_in_CC__c,
                        Currency__c,
                        Total_Sale_In_Zar__c,
                        Total_Cos_in_ZAR__c,
                        Total_Sale_In_USD__c,
                        Total_Cos_in_USD__c,
                        Quotation_Sale_Total_in_CC_AUD__c,
                        Quotation_Sale_Total_in_CC_EUR__c,
                        Quotation_Sale_Total_in_CC_GBP__c,
                        Quotation_Sale_Total_in_CC_USD__c,
                        Deposite_Due_Amount_USD__c,
                        Deposite_Due_Amount_ZAR__c,
                        Deposite_Due_Amount_EUR__c,
                        Quotation_Sales__c,
                        Deposit_Due_Date__c,
                        Deposit_Due_Amount__c,
                        Balance_Due_Date__c,
                        Balance_Due_Amount__c,
                        CC_ROE_for_EUR_in_AUD__c,
                        CC_ROE_for_EUR_in_EUR__c,
                        CC_ROE_for_EUR_in_GPB__c,
                        CC_ROE_for_EUR_in_USD__c,
                        CC_ROE_for_USD_in_AUD__c,
                        CC_ROE_for_USD_in_EUR__c,
                        CC_ROE_for_USD_in_GPB__c,
                        CC_ROE_for_USD_in_USD__c,
                        CC_ROE_for_ZAR_in_AUD__c,
                        CC_ROE_for_ZAR_in_EUR__c,
                        CC_ROE_for_ZAR_in_GPB__c,
                        CC_ROE_for_ZAR_in_USD__c,
                        Deposit_Value_Override_By_Consultant__c,
                        Client_Fund_Recieved__c
                 FROM 
                        Quotations__c
                WHERE 
                       Id=:quotationId][0];
        
    }
    
    public List<Passenger__c> GetServiceLineItemsPassengers(Set<String> serviceLineItemIds)
    {
        AggregateResult[] ServiceLineItemPassengersMappings = [SELECT
                                                                     Passenger__c
                                                                 FROM 
                                                                      ServiceLineItemPassengersMapping__c 
                                                                WHERE
                                                                       Service_Line_Item__c IN :serviceLineItemIds
                                                              GROUP BY 
                                                                      Passenger__c] ;
        List<String> PassengerIds = new List<String>();
        
        for(AggregateResult ar:ServiceLineItemPassengersMappings)
        {
            PassengerIds.add(String.valueOf(ar.get('Passenger__c')));
        }
        
        
        List<Passenger__c>  Passengers = [SELECT
                                                 Id,
                                                 PassengerName__c
                                            FROM
                                                 Passenger__c 
                                           WHERE
                                                 Id IN:PassengerIds];
        
        return Passengers;
    }
    
    public static List<ServiceLineItem__c> allServiceLineItemRelatedToOpportunityIds(Set<String> opportunityIds)
    {
        return [SELECT 
                        Id,
                        Opportunity_Owner_Email__c,
                        OpportunityId__c
                    FROM
                        ServiceLineItem__c  
                   WHERE 
                        OpportunityId__c IN:opportunityIds];
        
    }
    
    
    public static Map<String,ServiceLineItem__c> allServiceLineItemRelatedToOpportunity(Set<String> opportunityIds)
    {
        List<ServiceLineItem__c> slis =[SELECT
                                                Id,
                                                Opportunity_Owner_Email__c,
                                                OpportunityId__c
                                           FROM
                                                ServiceLineItem__c  
                                           WHERE 
                                                OpportunityId__c IN:opportunityIds];
        
        Map<String,ServiceLineItem__c> serviceLineMap  = new Map<String,ServiceLineItem__c>();
        for(ServiceLineItem__c sli:slis)
        {
            serviceLineMap.put(sli.OpportunityId__c,sli);
        }
        
        return  serviceLineMap;   
    }
}
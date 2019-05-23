public class DAL_Quotations{

 public static final String OBJECT_NAME = Quotations__c.SObjectType.getDescribe().getLocalName();
  
  private static final String BLANKVALUE='';
  public static List<Quotations__c> getAllQuotations(List<Id> ids)
  {
    return [SELECT
                  Id,
                  Opportunity__c,
                  TravelStartDate__c,
                  TravelEndDate__c,
                  Opportunity__r.Arrival_Date__c,
                  Opportunity__r.TravelEndDate__c,
                  Opportunity__r.CoS__c,
                  Opportunity__r.Gross_Profit__c,
                  Opportunity__r.Phone__c,
                  Confirmed__c,
                  Client_Fund_Recieved__c,
                  wetu_operator_id__c,
                  Opportunity__r.Name,
                  Opportunity__r.Account.Name,
                  Opportunity__r.Owner.Name,
                  Opportunity__r.Owner.Phone,
                  Opportunity__r.Owner.Email,
                  WETU_Link__c,
                  Iternary_Language__c,
                  Total_Sale_In_Zar__c,
                  Total_Sale_In_USD__c,
                  No_of_PhotoBook__c,
                  Include_insurance_for_passengers__c,
                  Currency__c,
                  Quotation_Sale_Total_in_CC__c,
                  Valid_Until__c,
                  Name,
                  Client_Has_Requested_Requote__c,
                  Client_Has_Requested_Confirmation__c,
                  operator_identity_id__c,
                  wetu_operator_theme_id__c,
                  wetu_type__c,
                  Wetu_Identifier__c,
                  Total_Days__c,
                  Quotation_Name__c,
                  Quotation_Stage__c,
                  price_includes__c,
                  price_excludes__c,
                  wetu_is_disabled__c,
                  Total_Adult_Passengers__c,
                  Total_Child_and_Infant_Travellers__c,
                  Itinerary_Summary__c,
                  Opportunity__r.Email__c,
                  Include_Photobooks_USD__c,
                  Include_Photobooks_ZAR__c,
                  Quotation_Cos__c,
                  Quotation_Profit__c,
                  Quotation_Sale__c,
                  LastModifiedDate,
                  Do_not_include_Photobooks__c,
                  Include_Passenger_Insurance_USD__c,
                  Include_Passenger_Insurance_ZAR__c,
                  Do_not_include_insurance__c,
                  Quotation_Sale_Total_in_CC_USD__c,
                  Quotation_Sale_Total_in_CC_EUR__c,
                  Quotation_Sale_Total_in_CC_GBP__c,
                  Quotation_Sale_Total_in_CC_AUD__c,
                  Exchange_Values_Override_By_Finance__c,
                  Update_CC_ROE_Fields__c,
                  Update_CC_ROE_Fields_Date__c,
                  Quote_Exposure__c,
                  Sales_Values_Verified_By_Consultant__c,
                  Deposite_Due_Amount_USD__c,
                  Deposite_Due_Amount_ZAR__c,
                  Deposite_Due_Amount_EUR__c,
                  Deposit_Due_Amount__c,
                  Balance_Due_Amount__c,
                  Deposit_Due_Date__c,
                  Balance_Due_Date__c
             FROM 
                  Quotations__c
            WHERE 
                Id IN :ids];
  }
  
  public static List<Quotations__c> getAllQuotationsById(String strId)
  {
    List<Id> ids  = new List<Id>();
    ids.add(Id.valueof(strId));
    return getAllQuotations(ids);
  }
 
  public static List<Quotations__c> getQuotationForWetuById(String strId)
  {
     return [SELECT
                  Id,
                  Opportunity__c,
                  TravelStartDate__c,
                  TravelEndDate__c,
                  Opportunity__r.Arrival_Date__c,
                  Opportunity__r.TravelEndDate__c,
                  Confirmed__c,
                  wetu_operator_id__c,
                  Name,
                  operator_identity_id__c,
                  wetu_operator_theme_id__c,
                  wetu_type__c,
                  Total_Days__c,
                  Quotation_Name__c,
                  Quotation_Stage__c,
                  price_includes__c,
                  price_excludes__c,
                  wetu_is_disabled__c,
                  Total_Adult_Passengers__c,
                  Total_Child_and_Infant_Travellers__c,
                  Itinerary_Summary__c,
                  Sale_in_ZAR__c,
                  Sale_in_USD__c,
                  Sale_in_EUR__c,
                  Wetu_Identifier__c,
                  Wetu_Identifier_Key__c,
                  Total_Nights__c
             FROM 
                  Quotations__c
            WHERE 
                Id =:strId];
  }
    
  public static List<QuotationLineItem__c> getAllQuotationsLineItems(List<String> quotationIds)
  {
    return [SELECT
                  ID,
                  Line_Item_Date__c,
                  Quotation__c,
                  Quotation__r.Opportunity__r.Country_of_Residence__c,
                  Quotation__r.Opportunity__r.Owner.Email
             FROM 
                  QuotationLineItem__c
            WHERE 
                Quotation__c IN :quotationIds
         ORDER BY Line_Item_Date__c];
  }
  
  public static List<QuotationLineItem__c> getAllQuotationsLineItems(Set<Id> quotationIds)
  {
    return [SELECT
                  ID,
                  Line_Item_Date__c,
                  Quotation__c,
                  Confirmed_Status__c,
                  Related_Services_Count__c,
                  Confirmed_serviceLineItems__c,
                  RaisedInvoice_ServiceLineItems_c__c
             FROM 
                  QuotationLineItem__c
            WHERE 
                Quotation__c IN :quotationIds];
  }
  
  public static Map<Date, QuotationLineItem__c> getAllQuotationsLineItemsByDate(Set<Date> quotationDates, Set<Id> quotationIds)
  {
    List<QuotationLineItem__c> allExiistingQuotation = [SELECT
                                                              ID,
                                                              Line_Item_Date__c,
                                                              Quotation__c
                                                         FROM 
                                                              QuotationLineItem__c
                                                        WHERE 
                                                                Line_Item_Date__c IN :quotationDates
                                                            AND
                                                                 Quotation__c IN: quotationIds ];
     
     Map<Date, QuotationLineItem__c> dateQuotationLineItemMap=new Map<Date, QuotationLineItem__c>();           
     for(QuotationLineItem__c qli: allExiistingQuotation)  
     {
        dateQuotationLineItemMap.put(qli.Line_Item_Date__c, qli);
     }
     
     return   dateQuotationLineItemMap;       
  }
    
    
    public static List<Quotations__c> getAllbyOpportunityIds(Set<Id> opportunityIds)
    {
        return [
                SELECT 
                        Id,
                        Confirmed__c,
                        Quotation_Stage__c,
                        Quotation_CoS__c,
                        Quotation_Profit__c,
                        Opportunity__c,
                        Quotation_Sale__c 
               FROM 
                      Quotations__c
             WHERE  
                    Opportunity__c IN :opportunityIds];
    }
    
    
  public static List<ServiceLineItem__c> getAllServiceLineItems(List<Id> quotationLineItemids)
  {
    return [SELECT
                  ID
             FROM 
                  ServiceLineItem__c
            WHERE 
                QuotationLine__c IN :quotationLineItemids];
  } 
    
  public static List<ServiceLineItem__c> getAllServiceLineItemsForPassengerInsurance(List<Id> quotationLineItemids)
  {
    return [SELECT
                  ID
             FROM 
                  ServiceLineItem__c
            WHERE 
                QuotationLine__c IN :quotationLineItemids];
  }
    
  
 public static Integer getExistingServiceLineItemCount(Date LineItemDate , Id quotationLineId)
 {
   
   Integer count  =[SELECT count()
                         FROM
                                ServiceLineItem__c 
                        WHERE 
                                Service_Date__c =: LineItemDate
                          AND 
                                QuotationLine__c=:quotationLineId ];
   return count;
 }
  
  public static AggregateResult[] getAllQuotationsLineItemsMaxEndDate(String quotationId)
  {
    return [SELECT
                  Quotation__c,
                  Max(Line_Item_Date__c)
             FROM 
                  QuotationLineItem__c
            WHERE 
                Quotation__c =:quotationId
             group by Quotation__c];
  }
  
     public static Map<Id,QuotationLineItem__c> getQuotationLineItemByMaxEndDates(Set<Id> allQuotationIds, Set<Date> maxDates)
     {
        return new Map<Id,QuotationLineItem__c>([SELECT 
                                                            Id
                                                     FROM 
                                                            QuotationLineItem__c
                                                     WHERE  
                                                            Quotation__c IN:allQuotationIds
                                                      AND   
                                                            Line_Item_Date__c IN:maxDates]);
     }
    
      public static Map<Id,Id> getAllQuotationsLineItemsMaxEndDates(Set<Id> allQuotationIds)
      {
           List<QuotationLineItem__c> quotationLineItems =  [SELECT
                                                                   Id,
                                                                   Line_Item_Date__c,
                                                                   Quotation__c
                                                               FROM 
                                                                   QuotationLineItem__c
                                                              WHERE 
                                                                   Quotation__c IN:allQuotationIds
                                                                  ORDER BY Line_Item_Date__c desc limit 1];
          
          Map<Id,Id> result = new  Map<Id,Id>();
          for(QuotationLineItem__c qli:quotationLineItems)
          {
              result.put(qli.Quotation__c, qli.Id);
          }
          return result;
      }
  
     public static List<QuotationLineItem__c> getQuotationLineItemByMaxEndDate(String quotationId, Date maxDate)
     {
        return [SELECT 
                       Id 
                 FROM 
                       QuotationLineItem__c
                WHERE 
                      Quotation__c =:quotationId 
                  AND 
                      Line_Item_Date__c=:maxDate];
     }
    
    public static List<QuotationLineItem__c> getQuotationLineItemByQuotationId(String quotationId)
     {
        return [SELECT 
                       Id 
                 FROM 
                       QuotationLineItem__c
                WHERE 
                      Quotation__c =:quotationId];
     }
  
  public static List<ServiceLineItem__c> getAllServiceLineItemsByIds(List<Id> serviceLineItemIds)
  {
    return [SELECT 
                    Id,
                    Service_Type__c,
                    Service_Status__c,
                    ClientNotes__c,
                    Reservation_Number__c,
                    Service_Detail__c,
                    SupplierName__c,
                    Supplier_Notes__c,
                    QuotationLine__c,
                    QuotationLine__r.Quotation__c
              FROM 
                    ServiceLineItem__c
              WHERE 
                    Id IN:serviceLineItemIds];
  } 
  
    public static Map<Id,List<Service_Line_Item_ChargeType__c>> getServiceChargeTypeForPassengerInsurance(Set<id> serviceLineItemIds,Set<String> chargeTypes)
    {
        List<Service_Line_Item_ChargeType__c> serviceChargeTypes =  [SELECT 
                                                                            Id,
                                                                            Service_Line_Item__c ,
                                                                            Charge_Type__c
                                                                        FROM  
                                                                             Service_Line_Item_ChargeType__c 
                                                                        WHERE 
                                                                            Charge_Type__c IN:chargeTypes
                                                                        AND
                                                                            Service_Line_Item__c IN :serviceLineItemIds];
    
        Map<Id,List<Service_Line_Item_ChargeType__c>> result = new Map<Id,List<Service_Line_Item_ChargeType__c>>();
        for(Id sid:serviceLineItemIds)
        {
            List<Service_Line_Item_ChargeType__c> sctToAdd = new List<Service_Line_Item_ChargeType__c>();
            for(Service_Line_Item_ChargeType__c sct:serviceChargeTypes)
            {
                if(sct.Service_Line_Item__c == sid)   
                {
                    sctToAdd.add(sct);
                }
            }
            
            result.put(sid,  sctToAdd);
        }
        
        return result;
    }
    
    
    public static Map<Id,ServiceLineItem__c> getQuotationExtraCostingServiceLineItem(List<id> quotaionIds)
    {
        Map<Id,ServiceLineItem__c> result = new Map<Id,ServiceLineItem__c>();
         List<ServiceLineItem__c> items= [SELECT
                                                 Id,
                                                 QuotationLine__r.Quotation__c
                                            FROM  
                                                ServiceLineItem__c
                                                
                                            WHERE 
                                                Is_Quotation_Extra_Costing_Item__c=:true
                                            AND
                                                QuotationLine__r.Quotation__c IN :quotaionIds];
       for(ServiceLineItem__c sli:items)
        {
            result.put(sli.QuotationLine__r.Quotation__c, sli);
        }
         return result;
    }
    
    public static Map<Id,List<ServiceLineItemPassengersMapping__c>> getPassengerForServiceLineItems(Set<Id> serviceLineItemIds)
    {
        List<ServiceLineItemPassengersMapping__c> passengersMapping=  [SELECT 
                                                                             Service_Line_Item__c,
                                                                             Id 
                                                                         FROM 
                                                                             ServiceLineItemPassengersMapping__c
                                                                        WHERE 
                                                                             Service_Line_Item__c IN:serviceLineItemIds]; 
        Map<Id,List<ServiceLineItemPassengersMapping__c>> result = new Map<Id,List<ServiceLineItemPassengersMapping__c>>();
        for(Id sid:serviceLineItemIds)
        {
            List<ServiceLineItemPassengersMapping__c> passengerMappingToAdd = new List<ServiceLineItemPassengersMapping__c>();
            for(ServiceLineItemPassengersMapping__c pm:passengersMapping)
            {
                if(pm.Service_Line_Item__c == sid)
                {
                    passengerMappingToAdd.add(pm);
                }
            }
            
            result.put(sid, passengerMappingToAdd);
        }
        return result;
    }
    
    
    public static List<Quotations__c> getOldQuotationForSameOpportunituy(Set<Id> OppSet, List<Id> newQuotationsIds)
    {
     return [SELECT
                     Id, 
                     Primary_by_Consultant__c,
                     Opportunity__c
           FROM 
                Quotations__c
          WHERE 
                Id NOT IN :newQuotationsIds
           AND
                 Opportunity__c IN :OppSet];    
    
    }
    
    public static List<Quotations__c> getOldConfirmedQuotationForSameOpportunity(Set<Id> OppSet, List<Id> newQuotationsIds)
    {
     return [SELECT
                     Id, 
                     Primary_by_Consultant__c,
                     Opportunity__c,
                     Quotation_Sale__c,
                     Quotation_CoS__c,
                     Quotation_Profit__c
           FROM 
                Quotations__c
          WHERE 
                Id NOT IN :newQuotationsIds
           AND
                 Opportunity__c IN :OppSet
            AND 
                 Primary_by_Consultant__c =true
           AND  
               Confirmed__c = true];    
    
    }
    
    public static List<Quotations__c> getQuotationsFromOppId_DynamiCSOQL(List<String> OpportunityIds) {
        try
        {
            String query = 'SELECT ';
            for(Schema.FieldSetMember f : SObjectType.Quotations__c.FieldSets.WS_GetQuotations.getFields()) {
                query += f.getFieldPath() + ',';
            }
            query = query.substring(0, query.length()-1);
            query += ' FROM Quotations__c WHERE Valid_Until__c != null AND Opportunity__c IN (';
            for(String str  : OpportunityIds){
                query += '\'' + str + '\',';    
            }
            query = query.substring(0, query.length()-1) + ')';
            return Database.query(query);
        }
        catch(Exception e){
            return null;
        }
        
    }
    
    
     public static List<Quotations__c> getQuotations_DynamiCSOQL(List<String> OpportunityIds) {
        try
        {
            String query = 'SELECT ';
            for(Schema.FieldSetMember f : SObjectType.Quotations__c.FieldSets.WS_GetQuotations.getFields()) {
                query += f.getFieldPath() + ',';
            }
            query = query.substring(0, query.length()-1);
            query += ' FROM Quotations__c WHERE Valid_Until__c != null AND Id IN (';
            for(String str  : OpportunityIds){
                query += '\'' + str + '\',';    
            }
            query = query.substring(0, query.length()-1) + ')';
            return Database.query(query);
        }
        catch(Exception e){
            return null;
        }
        
    }
    
     public static List<Quotations__c> getQuotations_DynamiCSOQLV2(List<String> opportunityIds) {
        try
        {
            String query = 'SELECT ';
            for(Schema.FieldSetMember f : SObjectType.Quotations__c.FieldSets.WS_GetQuotations.getFields()) {
                query += f.getFieldPath() + ',';
            }
            query = query.substring(0, query.length()-1);
            query += ' FROM Quotations__c WHERE Valid_Until__c != null AND Primary_Quotation__c = true AND Opportunity__c IN (';
            for(String str  : opportunityIds){
                query += '\'' + str + '\',';    
            }
            query = query.substring(0, query.length()-1) + ')';
            return Database.query(query);
        }
        catch(Exception e){
            return null;
        }
        
    }
    
     public static List<Quotations__c> getQuotationbyQuotationStage(String quotationStage) {
        return [SELECT 
                       Id,
                       isBookingConfStatusOverdue__c,
                       Raised_Booking_Confirmation_Date__c,
                       Date_Client_Requested_Confirmation__c
                 FROM  
                      Quotations__c
                WHERE
                      Quotation_Stage__c =: quotationStage
                 AND 
                     isBookingConfStatusOverdue__c =: false];
    }
    
    public static List<Quotations__c> getQuotationbyClienRquestedConf(String quotationStage)
    {
     return [SELECT 
                       Id,
                       isClientRequestedConfStatusOverdue__c,
                       Date_Client_Requested_Confirmation__c
                 FROM  
                      Quotations__c
                WHERE
                      Quotation_Stage__c =: quotationStage
                 AND 
                     Client_Has_Requested_Confirmation__c =: true
                 AND 
                     isClientRequestedConfStatusOverdue__c =:false];
    }
    
   public static List<Service_Line_Item_ChargeType__c> getAllExistingChargeType(List<Id> quotationId)
   {
    
      List<QuotationLineItem__c> QuotionLines = [SELECT ID FROM QuotationLineItem__c WHERE Quotation__c IN: quotationId];
      List<Id> quotationLineItemsIds = new List<Id>();
      for(QuotationLineItem__c qlI: QuotionLines)
      {
          quotationLineItemsIds.add(qlI.Id);
      }
      
       List<Service_Line_Item_ChargeType__c> chargeTypes = [SELECT 
                       Id,
                       Override_Nett_Cost__c
                 FROM  
                      Service_Line_Item_ChargeType__c
                WHERE
                      Service_Line_Item__c IN (SELECT ID FROM ServiceLineItem__c WHERE QuotationLine__c IN:
                      quotationLineItemsIds)];
                      
            return  chargeTypes;    
    }
}
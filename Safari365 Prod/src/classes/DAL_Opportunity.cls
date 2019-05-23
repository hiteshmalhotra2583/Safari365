public class DAL_Opportunity {
  
  public static final String OBJECT_NAME = Opportunity.SObjectType.getDescribe().getLocalName();
  
  public static Map<Id,Opportunity> getAllOpportunity(Set<Id> ids)
  {
    return new Map<Id,Opportunity>([SELECT
                  Id,
                  Name,
                  Arrival_Date__c,
                  TravelEndDate__c,
                  CloseDate,
                  CoS__c,
                  Gross_Profit__c,
                  StageName,
                  Amount,
                  Owner.Email,
                  Do_Not_Send_Phptpbook_Offer__c,
                  International_Flight_Arrival_Details__c,
                  International_Flight_Departure_Details__c,
                  Has_Confirmed_Quotation__c
             FROM 
                  Opportunity
            WHERE 
                  Id IN :ids
                  //AND 
                  //CloseDate >=:system.today()
                  ]);
  }
  
 public static List<Opportunity> getByIds(Set<Id> ids)
  {
    return [SELECT
                  Id,
                  Name,
                  AccountId,
                  Arrival_Date__c,
                  CloseDate,
                  CoS__c,
                  Gross_Profit__c,
                  Amount,
                  Email__c,
                  Client_Name__c,
                  Do_Not_Send_Phptpbook_Offer__c,
                  International_Flight_Arrival_Details__c,
                  International_Flight_Departure_Details__c,
                  Client_Display_Currency__c 
             FROM 
                  Opportunity
            WHERE 
                Id IN :ids];
  }
  
  public static Map<Id,Opportunity> getConfirmedOpportunity(Set<Id> ids)
  {
    return new Map<Id,Opportunity>([SELECT
                  Id,
                  Name,
                  Has_Confirmed_Quotation__c,
                  CoS__c,
                  Gross_Profit__c,
                  Amount,
                  Arrival_Date__c,
                  TravelEndDate__c
             FROM 
                  Opportunity
            WHERE 
                 Id IN :ids
             AND 
                Has_Confirmed_Quotation__c = true]);
  }
  
  public static List<Opportunity> getActiveOpportunity(Id OpportunityId)
  {
    return [SELECT
                  Id,
                  Name,
                  Owner.Name,
                  Owner.Phone,
                  Owner.Email,
                  Client_Display_Currency__c,
                  Client_Currency_Locked__c
             FROM 
                  Opportunity
            WHERE 
                Id =: OpportunityId 
            AND 
                StageName != 'Closed Lost'
            ORDER BY
                CreatedDate DESC];
  }
    
  public static List<Opportunity> getById(String opportunityId)
  {
    Set<Id> ids  = new Set<Id>();
    ids.add(Id.valueof(opportunityId));
    return getByIds(ids);
  }
  
  public static Opportunity getOpportunityById(String oppId)
    {
      return [SELECT 
                     Id,
                    Name,
                    GoogleOppFolderId__c,
                    OwnerId,
                    AccountId
             FROM 
                  Opportunity
            WHERE 
                Id = :oppId];
    }
}
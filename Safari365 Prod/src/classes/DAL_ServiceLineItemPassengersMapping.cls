public class DAL_ServiceLineItemPassengersMapping{

  public static integer getAdultPassengerCountBySerLineItemId(String serviceLineItemId){
     return [
             SELECT 
                     count() 
             FROM 
                 ServiceLineItemPassengersMapping__c 
             WHERE 
                 Service_Line_Item__c=:serviceLineItemId 
             AND  
                 ServiceLineItemPassengersMapping__c.Passenger__r.PassengerType__c='Adult'
       ];
  }
  
  public static integer getChildPassengerCountBySerLineItemId(String serviceLineItemId){
     return [
             SELECT 
                     count() 
             FROM 
                 ServiceLineItemPassengersMapping__c 
             WHERE 
                 Service_Line_Item__c =:serviceLineItemId 
             AND  
                 ServiceLineItemPassengersMapping__c.Passenger__r.PassengerType__c='Child'
       ];
  }
  
  public static integer getInfantPassengerCountBySerLineItemId(String serviceLineItemId){
     return [
             SELECT 
                     count() 
             FROM 
                 ServiceLineItemPassengersMapping__c 
             WHERE 
                 Service_Line_Item__c =:serviceLineItemId 
             AND  
                 ServiceLineItemPassengersMapping__c.Passenger__r.PassengerType__c='Infant'
       ];
  }
  
  public static List<ServiceLineItemPassengersMapping__c> getPassengerCountBySerLineItemId(Set<Id> serviceLineItemIds){
     return [
             SELECT 
                     Service_Line_Item__c,
                     Passenger__r.PassengerType__c
             FROM 
                 ServiceLineItemPassengersMapping__c 
             WHERE 
                 Service_Line_Item__c=:serviceLineItemIds];
  }

}
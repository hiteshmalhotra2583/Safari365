public class DAL_ServiceLineItemChargeType{

  public static List<Service_Line_Item_ChargeType__c> getServiceLineItemChargeTypeById(String serviceLineItemId)
  {
     return [SELECT
                  Id,
                  Name,
                  Markup__c,
                  Additional_Cost_Insurance__c,
                  Additional_Cost_PhotoBook__c,
                  Category__c,
                  Charge_Type__c,
                  Currency__c,
                  Do_Not_Include_Extra_Charge__c,
                  Extra__c,
                  Is_Additional_Cost__c,
                  Is_Discounted__c,
                  Nett_Cost__c,
                  Overide_Markup__c,
                  Passenger_Name__c,
                  Total__c,
                  Selected_OPD__c,
                  Selected_OPT__c,
                  Selected_Passenger__c,
                  Service_Line_Item__c
             FROM 
                 Service_Line_Item_ChargeType__c
             WHERE
                 Service_Line_Item__c = :serviceLineItemId 
             AND
                 Category__c != 'Service Charge'
       ];
  }
}
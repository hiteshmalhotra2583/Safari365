public class ServiceLineItemWrapper {
    public Boolean ProcessChilds{get;set;}
    public ServiceLineItem__c ServiceLineItem {get;set;}
    public List<Service_Line_Item_ChargeType__c> ChargeTypes{get;set;}
    public List<ServiceLineItemPassengersMapping__c> ServiceLineItemPassengersMappings{get;set;}
}
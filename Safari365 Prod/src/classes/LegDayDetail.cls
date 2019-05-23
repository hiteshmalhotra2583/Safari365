public class LegDayDetail
{
    public Date LegDate {get;set;}
    public ServiceLineItem__c LegDayServiceLineItem {get;set;}
    public Integer dayCounter {get;set;}
    public List<ServiceLineItem__c> LegServiceLineItems {get;set;}
}
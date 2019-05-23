public class FetchCalculatedValues
{
    public FetchCalculatedValues()
    {
        ErrorMessages = new Set<String>();
    }
    public OPD__c SelectedOPDForAdult{get;set;}
    public OPD__c SelectedOPDForChild{get;set;}
    public OPD__c SelectedOPDForInfant{get;set;}
    public OSR__c SelectedOSR{get;set;}
    
    public Decimal TotalAdultRate{get;set;}
    public Decimal TotalChildRate{get;set;}
    public Decimal TotalInfantRate{get;set;}
    public Decimal PerAdultRate{get;set;}
    public Decimal PerChildRate{get;set;}
    public Decimal PerInfantRate{get;set;}
    public Decimal Discount {get;set;}
    public Boolean IsDiscountAvailable{get;set;}
    public String TargetObjectName {get;set;}
    public Set<String> ErrorMessages{get;set;}
    public ChargeTypeExtraRate ChargeTypeExtraRatesForAdult{get;set;}
    public ChargeTypeExtraRate ChargeTypeExtraRatesForChild{get;set;}
    public ChargeTypeExtraRate ChargeTypeExtraRatesForInfant{get;set;}
}
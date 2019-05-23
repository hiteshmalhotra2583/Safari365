public class QuotationPricingSummaryWrapper 
{
    @AuraEnabled public ProfileAnalysisWrapper ProfileAnalysisZAR {get;set;}
    @AuraEnabled public ProfileAnalysisWrapper ProfileAnalysisUSD {get;set;}
    @AuraEnabled public ProfileAnalysisWrapper ProfileAnalysisEUR {get;set;}
    @AuraEnabled public ProfileAnalysisWrapper ProfileAnalysisClientCurrency {get;set;}
    @AuraEnabled public PaymentSummaryWrapper PaymentSummaryZAR{get;set;}
    @AuraEnabled public PaymentSummaryWrapper PaymentSummaryUSD{get;set;}
    @AuraEnabled public PaymentSummaryWrapper PaymentSummaryEUR{get;set;}
    @AuraEnabled public PaymentSummaryWrapper PaymentSummaryClientCurrency{get;set;}
    @AuraEnabled public List<PricePerPersonSummaryWrapper> PricePerPersonSummaryZAR {get;set;}
    @AuraEnabled public List<PricePerPersonSummaryWrapper> PricePerPersonSummaryUSD {get;set;}
    @AuraEnabled public List<PricePerPersonSummaryWrapper> PricePerPersonSummaryEUR {get;set;}
    @AuraEnabled public List<PricePerPersonSummaryWrapper> PricePerPersonSummaryClientCurrency {get;set;}
    @AuraEnabled public List<TotalPricePerPersonSummaryWrapper> TotalPricePerPersonSummaryClientCurrency {get;set;}
    @AuraEnabled public ProfileAnalysisWrapper PaymentClientCurrency{get;set;}
    @AuraEnabled public String  ClientSelectedCurrency{get;set;}
    @AuraEnabled public String ClientFundRecieved{get;set;}
}
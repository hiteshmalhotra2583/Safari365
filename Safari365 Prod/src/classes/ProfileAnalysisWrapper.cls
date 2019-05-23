public class ProfileAnalysisWrapper
{
    @AuraEnabled public string QuotationSale{get;set;}
    @AuraEnabled public string QuotationCost{get;set;}
    @AuraEnabled public string QuotationProfit{get;set;}
    @AuraEnabled public string QuotationGross{get;set;}
    @AuraEnabled public string GrandTotal{get;set;}
   
    //====================
    @AuraEnabled public string QuotationSales{get;set;}
    @AuraEnabled public string DepositDueDate{get;set;}
    @AuraEnabled public string DepositDueAmount{get;set;}
    @AuraEnabled public string BalanceDueDate{get;set;}
    @AuraEnabled public string BalanceDueAmount{get;set;}
    //====================
}
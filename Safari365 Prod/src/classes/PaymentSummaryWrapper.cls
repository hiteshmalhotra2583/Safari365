public class PaymentSummaryWrapper {
    @AuraEnabled public string DepositeDueAmount{get;set;}
    @AuraEnabled public string DepositeDueDate{get;set;}
    @AuraEnabled public string BalanceDueAmount{get;set;}
    @AuraEnabled public string BalanceDueDate{get;set;}
     @AuraEnabled public string clientCurrency{get;set;}
}
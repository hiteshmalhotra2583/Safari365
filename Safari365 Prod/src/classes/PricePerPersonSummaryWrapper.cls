public class PricePerPersonSummaryWrapper {
    @AuraEnabled public string PassengerId{get;set;}
    @AuraEnabled public string PassengerName{get;set;}
    @AuraEnabled public string Amount{get;set;}
    @AuraEnabled public string AmountINUSD{get;set;}
    @AuraEnabled public string AmountINEUR{get;set;}
    @AuraEnabled public string AmountINAUD{get;set;}
    @AuraEnabled public string AmountInGBP{get;set;}
}
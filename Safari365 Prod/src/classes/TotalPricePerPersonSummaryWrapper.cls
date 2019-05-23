public class TotalPricePerPersonSummaryWrapper {
	
	@AuraEnabled public string PassengerId{get;set;}
    @AuraEnabled public string PassengerName{get;set;}
    @AuraEnabled public string TotalAmountINUSD{get;set;}
    @AuraEnabled public string TotalAmountINEUR{get;set;}
    @AuraEnabled public string TotalAmountINAUD{get;set;}
    @AuraEnabled public string TotalAmountInGBP{get;set;}
    
}
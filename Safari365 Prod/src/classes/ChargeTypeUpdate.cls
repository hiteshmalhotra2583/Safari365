public class ChargeTypeUpdate {
    @AuraEnabled public String ChargeTypeId {get;set;}
    @AuraEnabled public String ServiceLineItemId {get;set;}
    @AuraEnabled public String Markup{get;set;}
    @AuraEnabled public String NettCost {get;set;}
    @AuraEnabled public String ClientNotes {get;set;}
    @AuraEnabled public String Status {get;set;}
}
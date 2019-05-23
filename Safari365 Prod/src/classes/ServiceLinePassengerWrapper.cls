public class ServiceLinePassengerWrapper {
		@AuraEnabled public Passenger__c Passenger{get;set;}
		@AuraEnabled public boolean IsSelected{get;set;}
}
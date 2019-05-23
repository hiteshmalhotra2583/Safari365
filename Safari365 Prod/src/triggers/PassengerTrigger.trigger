trigger PassengerTrigger on Passenger__c (after update) {
    
    new TH_Passenger().run(); 
}
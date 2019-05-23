trigger NTSTrigger on NTS__c (before insert, before update) {
    
    NTSTriggerHandler handler = new NTSTriggerHandler();
    handler.run();
    
}
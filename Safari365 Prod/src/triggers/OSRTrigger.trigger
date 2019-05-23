trigger OSRTrigger on OSR__c  (before insert , before update) {
    
    OSRTriggerHandler handler = new OSRTriggerHandler();
    handler.run();
}
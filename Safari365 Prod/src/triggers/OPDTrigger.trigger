trigger OPDTrigger on OPD__c(before insert) {
    OPDTriggerHandler handler = new OPDTriggerHandler();
    handler.run();

}
trigger OPTTrigger on Opt__c (before insert , before update) {

    OPTTriggerHandler handler=new OPTTriggerHandler ();
    handler.run();
}
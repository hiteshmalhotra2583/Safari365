trigger SODTrigger on SOD__c (before insert, before update) {
    SODTriggerHandler handler=new SODTriggerHandler ();
    handler.run();
}
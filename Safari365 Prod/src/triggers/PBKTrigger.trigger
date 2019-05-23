trigger PBKTrigger on PBK__c (before insert, before update) {
	
	PBKTriggerHandler handler=new PBKTriggerHandler ();
    handler.run();
    
}
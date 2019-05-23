trigger AccountTrigger on Account (before insert, before update ,after update) {
   
       AccountTriggerHandler handler=new AccountTriggerHandler ();
    handler.run();
   
   /*if(trigger.isBefore &&  Trigger.isInsert){
        for(Account a : trigger.new){
		      if(a.Newsletter__c){
		         a.PersonHasOptedOutOfEmail= false;    
		      }else{
		        a.PersonHasOptedOutOfEmail= true;    
		      }
         }
    }
    
    if(Trigger.isBefore && Trigger.isUpdate){
        	Map<Id, Account> oldAccountMap=Trigger.oldMap;
           	Map<Id, Account> newAccountMap=Trigger.newMap;
            for(Account l : Trigger.new){
        	if(oldAccountMap.get(l.Id).PersonHasOptedOutOfEmail != newAccountMap.get(l.Id).PersonHasOptedOutOfEmail ){
        	   if(newAccountMap.get(l.Id).PersonHasOptedOutOfEmail){
        	    l.Newsletter__c= false;
        	   }else{
        	   l.Newsletter__c= true;
        	   }
        	}
        	 if((oldAccountMap.get(l.Id).Newsletter__c != newAccountMap.get(l.Id).Newsletter__c )){
		      	 if(newAccountMap.get(l.Id).Newsletter__c){
		            l.PersonHasOptedOutOfEmail= false;    
		         }else {
		          l.PersonHasOptedOutOfEmail= true;
		         }
            } 
         }
       }
  
  
  if(Trigger.isAfter && Trigger.isUpdate){
  	AccountTriggerManager.changeOpportunityEmail(Trigger.old, Trigger.new);
  	AccountTriggerManager.createSubOpportunity( Trigger.new);
  }*/
}
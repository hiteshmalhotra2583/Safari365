trigger lead_insert_update on Lead (before insert, before update, after insert , after update) {
    if(Trigger.isBefore){
        LeadNurturingHandler.validateAndLinkLead(Trigger.new,Trigger.newMap);
        UpdateOwnerImageId.updateImageId(Trigger.New);    
        
    }
       /*if(Trigger.isBefore && Trigger.isInsert){
       	 system.debug('Inside the  insert trigger');
          for(Lead l : trigger.new){
           if(l.Newsletter__c ){
      	  system.debug('Newsletter value is'+l.Newsletter__c);
            l.HasOptedOutOfEmail= false;    
            }else {
            l.HasOptedOutOfEmail= true;   
           } 
          }
        }*/   
        if(Trigger.isBefore && Trigger.isUpdate){
        system.debug('Inside the update trigger');
        	Map<Id, Lead> oldLeadMap=Trigger.oldMap;
           	Map<Id, Lead> newLeadMap=Trigger.newMap;
            for(Lead l : Trigger.new){
        	if(oldLeadMap.get(l.Id).HasOptedOutOfEmail != newLeadMap.get(l.Id).HasOptedOutOfEmail ){
        	   if(newLeadMap.get(l.Id).HasOptedOutOfEmail){
        	    l.Newsletter__c= false;
        	   }else{
        	   l.Newsletter__c= true;
        	   }
        	}
        	 if((oldLeadMap.get(l.Id).Newsletter__c != newLeadMap.get(l.Id).Newsletter__c )){
		      	 if(newLeadMap.get(l.Id).Newsletter__c){
		            l.HasOptedOutOfEmail= false;    
		         }else {
		          l.HasOptedOutOfEmail= true;
		         }
            } 
         }
       }
    if(Trigger.isUpdate && Trigger.isBefore){
    for(Lead l : trigger.new){
        if(l.ConvertedAccountId != null){
            l.Activate_Workflow__c = true;
        }
      }
    }
    
}
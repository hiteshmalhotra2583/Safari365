trigger ServiceLineItemTrigger on ServiceLineItem__c  (after insert, after update) {   
   new TH_ServiceLineItems().run(); 
  }
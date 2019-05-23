trigger QuotationTrigger on Quotations__c  (before insert, before update, after insert, after update) {   
    
   new TH_Quotations().run(); 
}
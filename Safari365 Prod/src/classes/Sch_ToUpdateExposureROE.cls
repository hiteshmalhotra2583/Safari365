global class Sch_ToUpdateExposureROE implements Database.Batchable<SObject>,Schedulable{
    

   global Database.QueryLocator start(Database.BatchableContext BC){

        Set<String> quotationStages = new Set<String>();
        quotationStages.add('Quoting');
        quotationStages.add('Raised Invoice');
        
        return Database.getQueryLocator([SELECT Id,Currency__c,Quotation_Stage__c FROM Quotations__c WHERE Quotation_Stage__c IN:quotationStages]);
    
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope){
    	
    	Set<Id> quotationIds = new Set<Id>();
        Map<Id, String> quotationIdKeyClientCurrencyValue  = new  Map<Id, String>();
        for(Quotations__c var: (List<Quotations__c>)scope)
        {
        	system.debug('var::'+var.Quotation_Stage__c);
        	quotationIds.add(var.Id);
        	quotationIdKeyClientCurrencyValue.put(var.Id,var.Currency__c);
        }
        UpdateExposureROE.processRecords(quotationIds, quotationIdKeyClientCurrencyValue);               
    }

    global void finish(Database.BatchableContext BC){
       
    }
    
    global void execute(SchedulableContext sc)
    {
        Sch_ToUpdateExposureROE updateExposureROE= new Sch_ToUpdateExposureROE();
        database.executebatch(updateExposureROE, 1);
    }
}
global class BATCH_CalculateTotalLeadTarget implements Database.Batchable<sObject>,Schedulable{
    
    
    global Database.QueryLocator start(Database.BatchableContext BC){        
        return Database.getQueryLocator([ 
                                            SELECT 
                                            Id,
                                            Consultant_Leads_Target__c,
                                            Consultant_Target_Lead_Achieved__c,
                                            Consultant_Role__c,
                                            Consultant__c,
                                            Month__c,
                                            Year__c
                                       FROM 
                                            Consultant_Target_Lead_Monthly__c]);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope){
        UpdateYearlyLeadTargetService.updateYearlyTarget((List<Consultant_Target_Lead_Monthly__c>)scope);               
    }

    global void finish(Database.BatchableContext BC){
       
    }
    
    global void execute(SchedulableContext sc)
    {
        BATCH_CalculateTotalLeadTarget calTarget = new BATCH_CalculateTotalLeadTarget();
        database.executebatch(calTarget, 100 );
    }
    
}
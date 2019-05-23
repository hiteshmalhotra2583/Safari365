global class Batch_LeadNurtureNewsLetter implements Database.Batchable<sObject>,Schedulable{
    
    global Database.QueryLocator start(Database.BatchableContext BC){

        String queryStr =  'Select Id, Email__c, Last_Name__c, First_Name__c, NewsLetterSent__c, Next_NewsLetter_Date__c,';
        String TodayDate = String.valueOf(System.Today());
        String condition = 'WHERE Newsletter__c=true AND Converted_to_Lead__c=false AND Email__c!=null AND (Next_NewsLetter_Date__c=null OR Next_NewsLetter_Date__c='+TodayDate+') AND(';
        List<LeadNurtureMapping__c> leadNurture = LeadNurtureMapping__c.getall().values();

        for(LeadNurtureMapping__c var : leadNurture){
            queryStr = queryStr + var.Name +', ';
            condition = condition + var.name + '=true OR ';
        }
        queryStr = queryStr.substring(0, queryStr.length()-2) + ' FROM Lead_Nurture__c ';
        condition = condition.substring(0, condition.length()-3) + ')';
        queryStr = queryStr +condition;
        System.debug('---- '+ queryStr );
        if(test.isrunningtest()){
            queryStr = queryStr + ' limit 20';
        }
        return Database.getQueryLocator(queryStr);
    
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope){
        LeadNurtureNewsLetter.sendNewsLetter((List<Lead_Nurture__c>)scope);               
    }

    global void finish(Database.BatchableContext BC){
       
    }
    
    global void execute(SchedulableContext sc)
    {
        Batch_LeadNurtureNewsLetter NewsLetter= new Batch_LeadNurtureNewsLetter();
        database.executebatch(NewsLetter, 20);
    }
    
}
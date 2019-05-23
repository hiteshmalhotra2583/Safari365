trigger LeadNurture_Insert_Update on Lead_Nurture__c (before insert,before update) {

    LeadNurturingHandler.validateLeadNurturing(Trigger.new,Trigger.newMap);
}
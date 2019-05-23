trigger Contact_before_insert_update on Contact (before insert,before update) {
    
    
    LeadNurturingHandler.validateAndLinkContact(Trigger.new);
    
}
public class LeadNurturingHandler{



    public static void validateAndLinkLead(List<Lead> listNewLeads,Map<Id,Lead> mapNewLeads){
        
        
        Map<String,Lead_Nurture__c> mapEmailToLeadNurture = new Map<string,Lead_Nurture__c>();
        Set<String> setLeadEmail = new Set<string>();
        
        for(Lead currLead:listNewLeads){
            setLeadEmail.add(currLead.email);
        }
        
        
        List<Lead_Nurture__c> listLeadNurtures = [select id,email__c from Lead_Nurture__c where email__c IN: setLeadEmail];
        for(Lead_Nurture__c leadNurtureRec : listLeadNurtures ){
            mapEmailToLeadNurture.put(leadNurtureRec.email__c,leadNurtureRec);
        }
        
        for(Lead newlead : listNewLeads){
            Lead_Nurture__c leadNurtureRec = mapEmailToLeadNurture.get(newlead.Email);
            
            if(leadNurtureRec != null){              
                              
               newlead.Lead_Nurture__c = leadNurtureRec.Id;    
               
              
            }
            
          
        }
        
        
    }
    
    public static void validateAndLinkContact(List<Contact> listNewContacts){
    
        Map<String,Contact> mapEmailToContact = new Map<string,Contact>();
        Map<String,Lead_Nurture__c> mapEmailToLeadNurture = new Map<string,Lead_Nurture__c>();
        Set<String> setContactEmail = new Set<string>();
        List<Contact> listUpdateContacts = new List<Contact>();
        for(Contact currContact:listNewContacts){
            setContactEmail .add(currContact.email);
        }
        
        List<Contact> listContacts = [select id,email,Lead_Nurture__c from Contact where email IN: setContactEmail];
        for(Contact contactRec : listContacts ){
            mapEmailToContact.put(contactRec.email,contactRec);
        }
        List<Lead_Nurture__c> listLeadNurtures = [select id,email__c from Lead_Nurture__c where email__c IN: setContactEmail];
        for(Lead_Nurture__c leadNurtureRec : listLeadNurtures ){
            mapEmailToLeadNurture.put(leadNurtureRec.email__c,leadNurtureRec);
        }
        
        for(Contact currContact :listNewContacts){
            Lead_Nurture__c leadNurtureRec = mapEmailToLeadNurture.get(currContact.email);
            Contact contactRec = mapEmailToContact.get(currContact.Email);
            if(leadNurtureRec != null && contactRec != null){
               currContact.Lead_Nurture__c = leadNurtureRec.Id; 
               //listUpdateContacts.add(contactRec);
            }
            
           
        }
    
    }
    public static void validateLeadNurturing(List<Lead_Nurture__c> listNewLeadNurtures,Map<Id,Lead_Nurture__c> mapNewLeadNurture){
        
        Set<String> setLeadNurtureEmail = new Set<String>();
        Map<String,Lead_Nurture__c> mapLeadNurture = new Map<String,Lead_Nurture__c>();
        for(Lead_Nurture__c leadNurtureRec : listNewLeadNurtures){
            setLeadNurtureEmail.add(leadNurtureRec.Email__c);
            
        }
        
        Map<String,Lead> mapStringToLead = new Map<String,Lead>();
        Map<String,Contact> mapStringToContact = new Map<String,Contact>();
        
        List<Lead> listLeads = [select id,email 
                                        from Lead 
                                        where email IN: setLeadNurtureEmail];
                                        
        List<Contact> listContacts = [select id,email 
                                            from Contact 
                                            where email IN: setLeadNurtureEmail];
        
        
        List<Lead_Nurture__c> listExistingLeadNurture;
        if(mapNewLeadNurture != null){
            listExistingLeadNurture = [select id,email__c 
                                            from Lead_Nurture__c 
                                            where email__c IN:setLeadNurtureEmail  
                                            AND Id NOT IN:mapNewLeadNurture.keyset()];
        }else{
            listExistingLeadNurture = [select id,email__c 
                                            from Lead_Nurture__c 
                                            where email__c IN:setLeadNurtureEmail];
        }
        
        for(Lead_Nurture__c leadNurtureRec : listExistingLeadNurture){
            mapLeadNurture.put(leadNurtureRec.Email__c,leadNurtureRec);
            
        }
        
        for(Lead leadRec : listLeads){
           mapStringToLead .put(leadRec.email,leadRec); 
        }
        
        for(Contact contactRec: listContacts){
            mapStringToContact.put(contactRec.email,contactRec);
        }
        //List<Lead_Nurture__c> listUpdateLeadNurture = new List<Lead_Nurture__c>();
        for(Lead_Nurture__c leadNurtureRec:listNewLeadNurtures){
           Lead leadSelectRec = mapStringToLead.get(leadNurtureRec.email__c);
           Contact contactSelectRec = mapStringToContact.get(leadNurtureRec.email__c);
           if((leadSelectRec  != null)){
               leadNurtureRec.Lead__c = leadSelectRec.id;
           }
           
           if(contactSelectRec != null){
                leadNurtureRec.contact__c  = contactSelectRec.id;
           }
           
           Lead_Nurture__c existingLNRec  = mapLeadNurture.get(leadNurtureRec.email__c);
           if(existingLNRec != null){
                leadNurtureRec.Lead_Nurture__c = existingLNRec.Id;
           }
           
        }
        
    
    }

}
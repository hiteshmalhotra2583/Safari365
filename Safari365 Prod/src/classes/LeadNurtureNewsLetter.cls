public class LeadNurtureNewsLetter{

    public static void sendNewsLetter(List<Lead_Nurture__c> lst_Lead_Nurture){
        List<LeadNurtureMapping__c> lst_leadNurtureMapping = LeadNurtureMapping__c.getall().values();
        Map<String, String> map_TemplteName = new Map<String, String>();
        for(LeadNurtureMapping__c var : lst_leadNurtureMapping){
            if(var.Template_Label_Name__c != null && var.Template_Label_Name__c.trim().length()>0){
                map_TemplteName.put(var.Name, var.Template_Label_Name__c);
            }
        }
        List<EmailTemplate> lst_NurtureTemplates = [Select Id, Name 
                                                        FROM EmailTemplate 
                                                        WHERE Name IN : map_TemplteName.values()]; 
        Map<String, EmailTemplate> Map_TempName2Template = new Map<String, EmailTemplate>();
        for(EmailTemplate var : lst_NurtureTemplates){
            Map_TempName2Template.put(var.Name, var);
        }  
        Contact contact = new Contact(FirstName='Safari', LastName='365', Email='noreply@safari365.com');
        insert contact;
        List<Messaging.SingleEmailMessage> lst_mails = new List<Messaging.SingleEmailMessage>();
        List<Task> lst_Task = new List<Task>();
        for(Lead_Nurture__c var : lst_Lead_Nurture){  
            String TemplateName = getTemplateName(var, map_TemplteName);
            if(TemplateName != null){    
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();                
                email.setWhatId(var.Id);            
                email.setTargetObjectId(contact.Id);
                if(Map_TempName2Template.containskey(TemplateName)){
                    email.setTemplateId(Map_TempName2Template.get(TemplateName).Id);
                }
                email.setSenderDisplayName('Safari365.com');
                List<String> toAddresses = new List<String>();
                toAddresses.add(var.Email__c); 
                email.setToAddresses(toAddresses);       
                if(Map_TempName2Template.containsKey(TemplateName)){         
                    lst_mails.add(email);
                    lst_Task.add(new task(WhatId = var.Id, Type='Other', Subject = 'Email Notification - '+TemplateName, Status = 'Completed', OwnerId=UserInfo.getUserId(), Description= String.valueOf(email), ActivityDate= System.Today()));  
                }
            }    
        }
        if(!Test.isRunningTest())
        Messaging.sendEmail(lst_mails); 
        if(!lst_Task.isEmpty()){
            insert lst_Task;
        }
        delete contact;
        update lst_Lead_Nurture;
    }    

    private static String  getTemplateName(Lead_Nurture__c LeadNurture, Map<String, String> Map_leadNurtureMapping){

        if(LeadNurture.Wildlife_and_safari_experiences__c && Map_leadNurtureMapping.containsKey('Wildlife_and_safari_experiences__c') && (LeadNurture.NewsLetterSent__c==null || !LeadNurture.NewsLetterSent__c.contains('Wildlife_and_safari_experiences__c'))){
            LeadNurture.Next_NewsLetter_Date__c = System.Today() + Integer.valueOf(System.Label.NextNewsLetterDay);
            if(LeadNurture.NewsLetterSent__c == null){
                LeadNurture.NewsLetterSent__c = 'Wildlife_and_safari_experiences__c';
            }else{
                LeadNurture.NewsLetterSent__c = LeadNurture.NewsLetterSent__c + ', Wildlife_and_safari_experiences__c';
            }
            return Map_leadNurtureMapping.get('Wildlife_and_safari_experiences__c');
        }
        else if(LeadNurture.Honeymoons_and_romance__c && Map_leadNurtureMapping.containsKey('Honeymoons_and_romance__c') && (LeadNurture.NewsLetterSent__c==null || !LeadNurture.NewsLetterSent__c.contains('Honeymoons_and_romance__c'))){
            LeadNurture.Next_NewsLetter_Date__c = System.Today() + Integer.valueOf(System.Label.NextNewsLetterDay);
            if(LeadNurture.NewsLetterSent__c == null){
                LeadNurture.NewsLetterSent__c = 'Honeymoons_and_romance__c';
            }else{
                LeadNurture.NewsLetterSent__c = LeadNurture.NewsLetterSent__c + ', Honeymoons_and_romance__c';
            }
            return Map_leadNurtureMapping.get('Honeymoons_and_romance__c');
        }
        else if(LeadNurture.Family_safaris__c && Map_leadNurtureMapping.containsKey('Family_safaris__c') && (LeadNurture.NewsLetterSent__c==null || !LeadNurture.NewsLetterSent__c.contains('Family_safaris__c'))){
            LeadNurture.Next_NewsLetter_Date__c = System.Today() + Integer.valueOf(System.Label.NextNewsLetterDay);
            if(LeadNurture.NewsLetterSent__c == null){
                LeadNurture.NewsLetterSent__c = 'Family_safaris__c';
            }else{
                LeadNurture.NewsLetterSent__c = LeadNurture.NewsLetterSent__c + ', Family_safaris__c';
            }
            return Map_leadNurtureMapping.get('Family_safaris__c');
        }
        else if(LeadNurture.Active_and_outdoor_adventure__c && Map_leadNurtureMapping.containsKey('Active_and_outdoor_adventure__c') && (LeadNurture.NewsLetterSent__c==null || !LeadNurture.NewsLetterSent__c.contains('Active_and_outdoor_adventure__c'))){
            LeadNurture.Next_NewsLetter_Date__c = System.Today() + Integer.valueOf(System.Label.NextNewsLetterDay);
            if(LeadNurture.NewsLetterSent__c == null){
                LeadNurture.NewsLetterSent__c = 'Active_and_outdoor_adventure__c';
            }else{
                LeadNurture.NewsLetterSent__c = LeadNurture.NewsLetterSent__c + ', Active_and_outdoor_adventure__c';
            }
            return Map_leadNurtureMapping.get('Active_and_outdoor_adventure__c');
        }
        else if(LeadNurture.Food_and_Wine__c && Map_leadNurtureMapping.containsKey('Food_and_Wine__c') && (LeadNurture.NewsLetterSent__c==null || !LeadNurture.NewsLetterSent__c.contains('Food_and_Wine__c'))){
            LeadNurture.Next_NewsLetter_Date__c = System.Today() + Integer.valueOf(System.Label.NextNewsLetterDay);
            if(LeadNurture.NewsLetterSent__c == null){
                LeadNurture.NewsLetterSent__c = 'Food_and_Wine__c';
            }else{
                LeadNurture.NewsLetterSent__c = LeadNurture.NewsLetterSent__c + ', Food_and_Wine__c';
            }
            return Map_leadNurtureMapping.get('Food_and_Wine__c');
        }
        else if(LeadNurture.Walking_safaris__c && Map_leadNurtureMapping.containsKey('Walking_safaris__c') && (LeadNurture.NewsLetterSent__c==null || !LeadNurture.NewsLetterSent__c.contains('Walking_safaris__c'))){
            LeadNurture.Next_NewsLetter_Date__c = System.Today() + Integer.valueOf(System.Label.NextNewsLetterDay);
            if(LeadNurture.NewsLetterSent__c == null){
                LeadNurture.NewsLetterSent__c = 'Walking_safaris__c';
            }else{
                LeadNurture.NewsLetterSent__c = LeadNurture.NewsLetterSent__c + ', Walking_safaris__c';
            }
            return Map_leadNurtureMapping.get('Walking_safaris__c') ;
        }
        else if(LeadNurture.Beach_relaxation__c && Map_leadNurtureMapping.containsKey('Beach_relaxation__c') && (LeadNurture.NewsLetterSent__c==null || !LeadNurture.NewsLetterSent__c.contains('Beach_relaxation__c'))){
            LeadNurture.Next_NewsLetter_Date__c = System.Today() + Integer.valueOf(System.Label.NextNewsLetterDay);
            if(LeadNurture.NewsLetterSent__c == null){
                LeadNurture.NewsLetterSent__c = 'Beach_relaxation__c';
            }else{
                LeadNurture.NewsLetterSent__c = LeadNurture.NewsLetterSent__c + ', Beach_relaxation__c';
            }
            return Map_leadNurtureMapping.get('Beach_relaxation__c');
        }    
        else if(LeadNurture.History_and_culture__c && Map_leadNurtureMapping.containsKey('History_and_culture__c') && (LeadNurture.NewsLetterSent__c==null || !LeadNurture.NewsLetterSent__c.contains('History_and_culture__c'))){
            LeadNurture.Next_NewsLetter_Date__c = System.Today() + Integer.valueOf(System.Label.NextNewsLetterDay);
            if(LeadNurture.NewsLetterSent__c == null){
                LeadNurture.NewsLetterSent__c = 'History_and_culture__c';
            }else{
                LeadNurture.NewsLetterSent__c = LeadNurture.NewsLetterSent__c + ', History_and_culture__c';
            }
            return Map_leadNurtureMapping.get('History_and_culture__c');
        }
        else if(LeadNurture.South_Africa__c && Map_leadNurtureMapping.containsKey('South_Africa__c') && (LeadNurture.NewsLetterSent__c==null || !LeadNurture.NewsLetterSent__c.contains('South_Africa__c'))){
            LeadNurture.Next_NewsLetter_Date__c = System.Today() + Integer.valueOf(System.Label.NextNewsLetterDay);
            if(LeadNurture.NewsLetterSent__c == null){
                LeadNurture.NewsLetterSent__c = 'South_Africa__c';
            }else{
                LeadNurture.NewsLetterSent__c = LeadNurture.NewsLetterSent__c + ', South_Africa__c';
            }
            return Map_leadNurtureMapping.get('South_Africa__c');
        }
        else if(LeadNurture.Botswana__c && Map_leadNurtureMapping.containsKey('Botswana__c') && (LeadNurture.NewsLetterSent__c==null || !LeadNurture.NewsLetterSent__c.contains('Botswana__c'))){
            LeadNurture.Next_NewsLetter_Date__c = System.Today() + Integer.valueOf(System.Label.NextNewsLetterDay);
            if(LeadNurture.NewsLetterSent__c == null){
                LeadNurture.NewsLetterSent__c = 'Botswana__c';
            }else{
                LeadNurture.NewsLetterSent__c = LeadNurture.NewsLetterSent__c + ', Botswana__c';
            }
            return Map_leadNurtureMapping.get('Botswana__c');
        }
        else if(LeadNurture.Tanzania__c && Map_leadNurtureMapping.containsKey('Tanzania__c') && (LeadNurture.NewsLetterSent__c==null || !LeadNurture.NewsLetterSent__c.contains('Tanzania__c'))){
            LeadNurture.Next_NewsLetter_Date__c = System.Today() + Integer.valueOf(System.Label.NextNewsLetterDay);
            if(LeadNurture.NewsLetterSent__c == null){
                LeadNurture.NewsLetterSent__c = 'Tanzania__c';
            }else{
                LeadNurture.NewsLetterSent__c = LeadNurture.NewsLetterSent__c + ', Tanzania__c';
            }
            return Map_leadNurtureMapping.get('Tanzania__c');
        }
        else if(LeadNurture.Namibia__c && Map_leadNurtureMapping.containsKey('Namibia__c') && (LeadNurture.NewsLetterSent__c==null || !LeadNurture.NewsLetterSent__c.contains('Namibia__c'))){
            LeadNurture.Next_NewsLetter_Date__c = System.Today() + Integer.valueOf(System.Label.NextNewsLetterDay);
            if(LeadNurture.NewsLetterSent__c == null){
                LeadNurture.NewsLetterSent__c = 'Namibia__c';
            }else{
                LeadNurture.NewsLetterSent__c = LeadNurture.NewsLetterSent__c + ', Namibia__c';
            }
            return Map_leadNurtureMapping.get('Namibia__c');
        }
        else if(LeadNurture.Kenya__c && Map_leadNurtureMapping.containsKey('Kenya__c') && (LeadNurture.NewsLetterSent__c==null || !LeadNurture.NewsLetterSent__c.contains('Kenya__c'))){
            LeadNurture.Next_NewsLetter_Date__c = System.Today() + Integer.valueOf(System.Label.NextNewsLetterDay);
            if(LeadNurture.NewsLetterSent__c == null){
                LeadNurture.NewsLetterSent__c = 'Kenya__c';
            }else{
                LeadNurture.NewsLetterSent__c = LeadNurture.NewsLetterSent__c + ', Kenya__c';
            }
            return Map_leadNurtureMapping.get('Kenya__c');
        }
        else if(LeadNurture.Zambia__c && Map_leadNurtureMapping.containsKey('Zambia__c') && (LeadNurture.NewsLetterSent__c==null || !LeadNurture.NewsLetterSent__c.contains('Zambia__c'))){
            LeadNurture.Next_NewsLetter_Date__c = System.Today() + Integer.valueOf(System.Label.NextNewsLetterDay);
            if(LeadNurture.NewsLetterSent__c == null){
                LeadNurture.NewsLetterSent__c = 'Zambia__c';
            }else{
                LeadNurture.NewsLetterSent__c = LeadNurture.NewsLetterSent__c + ', Zambia__c';
            }
            return Map_leadNurtureMapping.get('Zambia__c');
        }
        else if(LeadNurture.Mozambique__c && Map_leadNurtureMapping.containsKey('Mozambique__c') && (LeadNurture.NewsLetterSent__c==null || !LeadNurture.NewsLetterSent__c.contains('Mozambique__c'))){
            LeadNurture.Next_NewsLetter_Date__c = System.Today() + Integer.valueOf(System.Label.NextNewsLetterDay);
            if(LeadNurture.NewsLetterSent__c == null){
                LeadNurture.NewsLetterSent__c = 'Mozambique__c';
            }else{
                LeadNurture.NewsLetterSent__c = LeadNurture.NewsLetterSent__c + ', Mozambique__c';
            }
            return Map_leadNurtureMapping.get('Mozambique__c');
        }
        else if(LeadNurture.Uganda__c && Map_leadNurtureMapping.containsKey('Uganda__c') && (LeadNurture.NewsLetterSent__c==null || !LeadNurture.NewsLetterSent__c.contains('Uganda__c'))){
            LeadNurture.Next_NewsLetter_Date__c = System.Today() + Integer.valueOf(System.Label.NextNewsLetterDay);
            if(LeadNurture.NewsLetterSent__c == null){
                LeadNurture.NewsLetterSent__c = 'Uganda__c';
            }else{
                LeadNurture.NewsLetterSent__c = LeadNurture.NewsLetterSent__c + ', Uganda__c';
            }
            return Map_leadNurtureMapping.get('Uganda__c');
        }
        else if(LeadNurture.Rwanda__c && Map_leadNurtureMapping.containsKey('Rwanda__c') && (LeadNurture.NewsLetterSent__c==null || !LeadNurture.NewsLetterSent__c.contains('Rwanda__c'))){
            LeadNurture.Next_NewsLetter_Date__c = System.Today() + Integer.valueOf(System.Label.NextNewsLetterDay);
            if(LeadNurture.NewsLetterSent__c == null){
                LeadNurture.NewsLetterSent__c = 'Rwanda__c';
            }else{
                LeadNurture.NewsLetterSent__c = LeadNurture.NewsLetterSent__c + ', Rwanda__c';
            }
            return Map_leadNurtureMapping.get('Rwanda__c');
        }
        else if(LeadNurture.Victoria_Falls__c && Map_leadNurtureMapping.containsKey('Victoria_Falls__c') && (LeadNurture.NewsLetterSent__c==null || !LeadNurture.NewsLetterSent__c.contains('Victoria_Falls__c'))){
            LeadNurture.Next_NewsLetter_Date__c = System.Today() + Integer.valueOf(System.Label.NextNewsLetterDay);
            if(LeadNurture.NewsLetterSent__c == null){
                LeadNurture.NewsLetterSent__c = 'Victoria_Falls__c';
            }else{
                LeadNurture.NewsLetterSent__c = LeadNurture.NewsLetterSent__c + ', Victoria_Falls__c';
            }
            return Map_leadNurtureMapping.get('Victoria_Falls__c');
        }
        else if(LeadNurture.Zanzibar_and_Pemba__c && Map_leadNurtureMapping.containsKey('Zanzibar_and_Pemba__c') && (LeadNurture.NewsLetterSent__c==null || !LeadNurture.NewsLetterSent__c.contains('Zanzibar_and_Pemba__c'))){
            LeadNurture.Next_NewsLetter_Date__c = System.Today() + Integer.valueOf(System.Label.NextNewsLetterDay);
            if(LeadNurture.NewsLetterSent__c == null){
                LeadNurture.NewsLetterSent__c = 'Zanzibar_and_Pemba__c';
            }else{
                LeadNurture.NewsLetterSent__c = LeadNurture.NewsLetterSent__c + ', Zanzibar_and_Pemba__c';
            }
            return Map_leadNurtureMapping.get('Zanzibar_and_Pemba__c');
        }

        return null;
    } 

}
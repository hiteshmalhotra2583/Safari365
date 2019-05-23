public class ServiceLineItem_EmailService {
    
    private static final String CLASS_NAME = ServiceLineItem_EmailService.class.getName();
    public static final String REQUEST_PROVISIONAL_BOOKING='Request Provisional Booking';
    public static final String REQUEST_CONFIRMATION='Request Confirmation';
    public static final String REQUEST_CANCELLATION='Request Cancellation';
     
    public List<EmailTemplateMapping__mdt> loadCustomMetadata()
    {
        return [ 
                Select Id,
                        Send_Email__c,
                        Status_Name__c,
                        Template_Name__c    
                FROM
                        EmailTemplateMapping__mdt];
    }
     
     
     public void sendEmailToService(List<ServiceLineItem__c> serviceLineItems)
     {
        List<Id> requestConfirmationIds = new List<Id>();
        List<Id> requestCancellationIds = new List<Id>();
        List<Id> requestProvisionalBookingIds = new List<Id>();
        List<EmailTemplateMapping__mdt> emailNotificationMDT = this.loadCustomMetadata();
        if(Test.isRunningTest()) {
            emailNotificationMDT = this.loadCustomMetadata();//new List<EmailTemplateMapping__mdt>();
            
        } 
        Map<String, Boolean> StatusFlagMap  = new Map<String, Boolean>();
        Map<String, String> StatusTemplateNameMap  = new Map<String, String>();
        for(EmailTemplateMapping__mdt emailTemplateMapp:emailNotificationMDT)
        {
            StatusFlagMap.put(emailTemplateMapp.Status_Name__c,emailTemplateMapp.Send_Email__c);
            StatusTemplateNameMap.put(emailTemplateMapp.Status_Name__c,emailTemplateMapp.Template_Name__c);
        } 
         
        for(ServiceLineItem__c sli: serviceLineItems)
        {
            if(sli.Service_Status__c==REQUEST_PROVISIONAL_BOOKING)
            {
                requestProvisionalBookingIds.add(sli.Id);
            }
            if(sli.Service_Status__c==REQUEST_CONFIRMATION)
            {
                requestConfirmationIds.add(sli.Id);
            }
            if(sli.Service_Status__c==REQUEST_CANCELLATION)
            {
                requestCancellationIds.add(sli.Id);
            }
        }
         if(!requestProvisionalBookingIds.isEmpty() && StatusFlagMap.get(REQUEST_PROVISIONAL_BOOKING))
         {
             SendEmail(requestProvisionalBookingIds,StatusTemplateNameMap.get(REQUEST_PROVISIONAL_BOOKING));
         }
         if(!requestConfirmationIds.isEmpty() && StatusFlagMap.get(REQUEST_CONFIRMATION))
         {
             SendEmail(requestConfirmationIds,StatusTemplateNameMap.get(REQUEST_CONFIRMATION));
         }
         if(!requestCancellationIds.isEmpty() && StatusFlagMap.get(REQUEST_CANCELLATION))
         {
             SendEmail(requestCancellationIds,StatusTemplateNameMap.get(REQUEST_CANCELLATION));
         }
  }
    
    public void SendEmail(List<Id> serviceLineItemIds, String template)
    {
       
        Id templateId;
      try
        {
          templateId = [select id from EmailTemplate where Name = :template].id;
        } 
       
        catch (QueryException e) 
        {
            throw e;
        }
    
        List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
        
        List<ServiceLineItem__c> serviceLineItemWithValues =DAL_Quotations.getAllServiceLineItemsByIds(serviceLineItemIds);
        System.debug('@@serviceLineItemWithValues'+serviceLineItemWithValues);
        Set<String> serviceTypes = new Set<String>();
        for(ServiceLineItem__c sli:serviceLineItemWithValues)
        {
            if(!serviceTypes.contains(sli.Service_Type__c))
            {
                serviceTypes.add(sli.Service_Type__c);
            }
        }
        List<OPT__c> emailAddresses = [SELECT Id,SRV_Name__c FROM OPT__c WHERE SRV_Name__c IN:serviceTypes ];
        
        Contact c = new Contact(LastName='fakecontact',email='hiteshmalhotra2583@gmail.com');
        insert c;
        for (ServiceLineItem__c sli: serviceLineItemWithValues) 
        {
            String[] emailToSend = new  String[]{};
            emailToSend.add('hiteshmalhotra2583@gmail.com') ;  
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setTemplateId(templateId);
            message.setTargetObjectId(c.Id);
           // message.setWhatId(sli.QuotationLine__r.Quotation__c);
            message.setSaveAsActivity(true);
            
           //Fake Email to be used in a the rollback 
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
            mail.setWhatId(sli.QuotationLine__r.Quotation__c);
            //mail.setTargetObjectId(wo.ContactId);
            mail.setTargetObjectId(c.Id);
            mail.setBccSender(false); 
            mail.setUseSignature(false); 
            mail.setSaveAsActivity(false); 
            mail.setTemplateId(templateId);
            mail.setToAddresses(new list<String>{'example@test.com'});
            Savepoint sp = Database.setSavepoint();
            try{
                if(! Test.isRunningTest()) {
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                }
            }catch(Exception e){
                throw e;
            }
            Database.rollback(sp);
            message.setHTMLBody(mail.htmlBody);
            for(OPT__c opt:emailAddresses)
            {
                //if(!emailToSend.contains(opt.PBK_Email__c))
                //{
                    //emailToSend.add(opt.PBK_Email__c);
                //}
                
            }
            message.setToAddresses(emailToSend);
            messages.add(message);
        }
        
        if(! Test.isRunningTest()) {
        Messaging.sendEmail(messages);
        }
        delete c;
  }
}
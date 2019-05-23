public class EmailUtilService {

    /*public void sendEmailToServiceContactType(List<Quotations__c> quotaions)
	{
	  List<Id> confirmedQuotaionsIds = new List<Id>();
	  for(Quotations__c quotaion: quotaions)
	  {
	    if(quotaion.Confirmed__c)
	    {
	    	confirmedQuotaionsIds.add(quotaion.Id);
	    }
	  }
        SendEmail(confirmedQuotaionsIds);
	   
       /* //Fetch Confirmed all QuotationLineItems
	   List<QuotationLineItem__c> quotationLineItemsIds = DAL_Quotations.getAllQuotationsLineItems(confirmedQuotaionsIds);
	   
	   //Fetch Confirmed all serrviceLineItems
	   List<ServiceLineItem__c> allServiceLineItem = DAL_Quotations.getAllServiceLineItems(new List<Id>(
	   												SystemUtil.extractListIds(quotationLineItemsIds)));
	}*/
    
    public static void sendEmail(Set<Id> confirmedQuotaionsIds, Map<Id,String> quotationIdEmailMap)
    {
        final String template = 'EmailForPessangerDetails';
        Id templateId;

    	try
        {
        	templateId = [select id from EmailTemplate where Name = :template].id;
      	} 
        catch (QueryException e) 
        {
            System.debug('Email Template was not found for Passenger Details Email');
      	}
		
        List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
        //for (Quotations__c q: [select Id,Confirmed__c,Opportunity__c  from Quotations__c where Id IN:confirmedQuotaionsIds]) 
        for (Id i: confirmedQuotaionsIds) 
        {
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setTemplateId(templateId);
            message.setTargetObjectId(i);
            //message.setWhatId(q.Confirmed__c);
            message.setToAddresses(new String[] {quotationIdEmailMap.get(i)});
      		messages.add(message);
        }
        
        if(!Test.isRunningTest())
		Messaging.sendEmail(messages);
	}
}
public class TH_ServiceLineItems extends BaseTriggerHandler{
    
    private static final String CLASS_NAME = TH_ServiceLineItems.class.getName();
    private List< ServiceLineItem__c > newServiceLineItemsList;
    private List< ServiceLineItem__c > oldServiceLineItemsList;
    private Map<ID, ServiceLineItem__c > newServiceLineItemsMap;
    private Map<ID, ServiceLineItem__c > oldServiceLineItemsMap;
    
    public TH_ServiceLineItems() {
        oldServiceLineItemsList = (List<ServiceLineItem__c>)Trigger.old;
        newServiceLineItemsList = (List<ServiceLineItem__c>)Trigger.new;
        newServiceLineItemsMap =  (Map<ID, ServiceLineItem__c>)Trigger.newMap;
        oldServiceLineItemsMap = (Map<ID, ServiceLineItem__c>)Trigger.oldMap;
    }
	
    protected override void afterUpdate()
    {
    	if(Trigger_PAD.canRun('TH_ServiceLineItems'))
        {
            processRecords();     
        }
   }
   protected override void afterInsert()
   {
       if(Trigger_PAD.canRun('TH_ServiceLineItems'))
        {
            processRecords();  
        }
   }
   
   
   private void processRecords()
   {
   	  Set<Id> allQuotationLineIds = new Set<Id>();
      for(ServiceLineItem__c sli: newServiceLineItemsList)
      {
	        allQuotationLineIds.add(sli.QuotationLine__c);
      }
        List<QuotationLineItem__c> allQuotationLines= DAL_Quotations.getAllQuotationsLineItems(allQuotationLineIds);
        updateRelatedQuotationLineItems(allQuotationLines);
            
        ServiceLineItem_EmailService emailService = new ServiceLineItem_EmailService();
        emailService.sendEmailToService(newServiceLineItemsList); 
   }
   
   
   private void updateRelatedQuotationLineItems(List<QuotationLineItem__c> allQuotationLines)
   {
   	 for(QuotationLineItem__c qli:allQuotationLines)
     {
        if(qli.Related_Services_Count__c  == qli.Confirmed_serviceLineItems__c)
        {
            qli.Confirmed_Status__c='Confirmed';
        }
        if(qli.Related_Services_Count__c  == qli.RaisedInvoice_ServiceLineItems_c__c)
        {
            qli.Raised_Invoice_Status__c='Confirmed';
        }
    }

        DAL_BaseObject.UpdateDBObjects(allQuotationLines);
   }
   
   
   
}
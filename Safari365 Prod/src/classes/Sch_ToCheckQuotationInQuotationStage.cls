global class Sch_ToCheckQuotationInQuotationStage  implements Schedulable{
	
    private static final String CLASS_NAME = Sch_ToCheckQuotationInQuotationStage.class.getName();
    
	public static  void checkRecords(){
        
        UTIL_LogGenerator logger = new UTIL_LogGenerator();
        logger.start(CLASS_NAME,'Sch_ToCheckQuotationInQuotationStage' );
       
       List<Quotations__c>  quotaionsToProcessed = DAL_Quotations.getQuotationbyClienRquestedConf('Quoting');
       List<Quotations__c> quotationToSendEmail =  new List<Quotations__c>();
       for(Quotations__c q: quotaionsToProcessed)
       {
       	  if(null != q.Date_Client_Requested_Confirmation__c)
       	  {
	       	  if(Integer.valueof(system.today().daysBetween(q.Date_Client_Requested_Confirmation__c)) 
	       	  		> Integer.valueof(Label.Raised_Client_Confirmation_Tolearance))
	       	  {
	       	  	q.isClientRequestedConfStatusOverdue__c = true;
	       	  	quotationToSendEmail.add(q);
	       	  }
       	  }
       }
       
      if(! quotationToSendEmail.isEmpty())
      {
	       BaseTriggerHandler.bypass('TH_Quotations');
	       update quotationToSendEmail;
	       BaseTriggerHandler.clearBypass('TH_Quotations');
      }
        logger.end();
	}
	
	global void execute(SchedulableContext bc){
       Sch_ToCheckQuotationInQuotationStage.checkRecords();
   }
}
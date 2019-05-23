global class SchedulerToCheckBookingConfirmation implements Schedulable{
	
	private static final String CLASS_NAME = SchedulerToCheckBookingConfirmation.class.getName();
    
	public static  void checkRecords(){
        
        UTIL_LogGenerator logger = new UTIL_LogGenerator();
        logger.start(CLASS_NAME,'SchedulerToCheckBookingConfirmation' );
       
       
       List<Quotations__c>  quotaionsToProcessed = DAL_Quotations.getQuotationbyQuotationStage('Raised Invoice');
       List<Quotations__c> quotationToSendEmail =  new List<Quotations__c>();
       for(Quotations__c q: quotaionsToProcessed)
       {
       	  if(null != q.Raised_Booking_Confirmation_Date__c)
       	  {
	       	  if(Integer.valueof(system.today().daysBetween(q.Raised_Booking_Confirmation_Date__c)) 
	       	  		> Integer.valueof(Label.Raised_Booking_Confirmation_Tolearance))
	       	  {
	       	  	system.debug(Integer.valueof(system.today().daysBetween(q.Raised_Booking_Confirmation_Date__c)));
	       	  	q.isBookingConfStatusOverdue__c = true;
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
       SchedulerToCheckBookingConfirmation.checkRecords();
   }
}
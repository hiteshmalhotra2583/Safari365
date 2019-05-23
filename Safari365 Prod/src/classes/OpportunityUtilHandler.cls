global class OpportunityUtilHandler implements Schedulable{
	
static Datetime stDate = DateTime.newInstance(2008,1,1);
//static Datetime endDate = DateTime.newInstance(2013,2,28);
static Datetime endDate = System.now();
	// This test runs a scheduled job at midnight Sept. 3rd. 2022

   public static String CRON_EXP = '0 0 0 3 9 ? 2022';
   
 global void execute(SchedulableContext ctx) {
	
List<Opportunity> updateOppList= new List<Opportunity>();
List<Opportunity> oppList=[Select Id, Name, CreatedDate, WorkflowRun__c ,WorkflowRun2__c,WorkflowRun3__c,WorkflowRun4__c,Arrival_Date__c
							FROM
								 Opportunity o
							 WHERE (o.CreatedDate > :stDate AND o.CreatedDate <: endDate ) AND (o.StageName='Money in the Bank' OR o.StageName='Closed Won Deal')];

 	date currentDate=   date.today();
   for(Opportunity opp :oppList )
   {
 	if(null!=opp.Arrival_Date__c)
 	{
		integer numberDaysDue = currentDate.daysBetween(opp.Arrival_Date__c);
        if(numberDaysDue<=-361 && !opp.WorkflowRun__c )
        {
         opp.WorkflowRun__c=true;
         updateOppList.add(opp);
         continue;
        }
 		else if(numberDaysDue==-360 && !opp.WorkflowRun__c)
 		{
		  opp.WorkflowRun__c=true;
		  updateOppList.add(opp);
		  continue;
	    }  
 		else if(numberDaysDue==30 && !opp.WorkflowRun2__c)
 		{
		  opp.WorkflowRun2__c=true;
		  updateOppList.add(opp);
		  continue;
       }    
       else if(numberDaysDue==5 && !opp.WorkflowRun3__c)
       {
	  	opp.WorkflowRun3__c=true;
	  	updateOppList.add(opp);
	  	continue;
       }
      else if(numberDaysDue==-14 && !opp.WorkflowRun4__c)
      {
		  opp.WorkflowRun4__c=true;
		  updateOppList.add(opp);
		  continue;
      } 
     }
   }
  
   if(!Test.isRunningTest())
   upsert updateOppList;
}

}
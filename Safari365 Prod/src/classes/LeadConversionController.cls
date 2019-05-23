public class LeadConversionController {
	@auraenabled
    public static String leadConversion(String leadId){
        List<Lead> leads = [Select Id, Cancel_Workflow__c, LastName from Lead Where Id=:leadId];
        if(!leads.isEmpty()){        
            leads[0].Cancel_Workflow__c = true;
        }
        return null;
    }
}
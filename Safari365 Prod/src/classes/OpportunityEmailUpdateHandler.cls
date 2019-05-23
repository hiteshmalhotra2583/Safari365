public class OpportunityEmailUpdateHandler {
	
	
	 public static void updateEmailFromAccount(List<Opportunity> listOpps)
	 {
         
         Set<Id>  accountIDSet= new Set<Id>();
         for(Opportunity OppRec : listOpps)
          {
            accountIDSet.add(OppRec.AccountId);
          }
          
          Map<Id,Account> accountMap = new Map<ID, Account>([Select Id,
         															PersonEmail 
         													    FROM 
         													    	 Account
         													   WHERE Id IN:accountIDSet]);
          for(Opportunity OppRecs : listOpps)
           {
	            Account acc = accountMap.get(OppRecs.AccountId);
	            if(null!=acc && null!=acc.PersonEmail)
	            {
	             	OppRecs.Email__c=acc.PersonEmail;
	            }
           }    
	 }
}
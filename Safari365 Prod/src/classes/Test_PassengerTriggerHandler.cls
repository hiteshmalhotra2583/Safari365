@isTest
private class Test_PassengerTriggerHandler {

   static List<Account> accounts = new List<Account>();
   static List<Passenger__c> passengers = new List<Passenger__c>();
   static List<Opportunity> opportunitys = new List<Opportunity>();
   public static Integer count = 1;

    static void setupInsertData(){
       
       User us = TestDataFactory.createUser(true, '', true);
       System.runAs(us){
       Account accountRec = new Account();
       accountRec.Name = 'Unit Test Account';
       accountRec.BillingStreet = '123 Unit Test Street';
       accountRec.BillingCity='Dallas';
       accountRec.BillingState = 'TX';
       accountRec.BillingPostalCode = '75006';
       accountRec.BillingCountry='US';
       accountRec.Industry = 'Commerical';
       accountRec.Newsletter__c= true;
       accounts.add(accountRec);
       
       DAL_BaseObject.InsertDBObjects(accounts);
       Map<String,Object>  accountMap = new Map<String,Object>();
       Map<String,Object>  accountOpportunityMap = new Map<String,Object>();
       Date arrivaleDate = Date.newInstance(2008,1,1);
       Date closeDate = Date.newInstance(2008,1,1); 
        for(Account acc:accounts)
        {
            accountMap.put('Account__c', acc.ID);
            accountOpportunityMap.put('AccountId', acc.ID);
            accountOpportunityMap.put('StageName','Money in the Bank');
            accountOpportunityMap.put('CloseDate',closeDate);
            accountOpportunityMap.put('Arrival_Date__c',arrivaleDate);
        }
        
       for(Integer i = 0 ; i <count; i++)
        {
            opportunitys.add((Opportunity) TestDataFactory.operationOnObjectRecord(null, DAL_Opportunity.OBJECT_NAME, accountOpportunityMap));
        }
    
      insert opportunitys;
      
      for(Opportunity opp:opportunitys)
      {
      	accountMap.put('Opportunity__c' ,opp.id );
      }
      
       for(Integer i = 0 ; i <count; i++)
        {
            passengers.add((Passenger__c) TestDataFactory.operationOnObjectRecord(null, DAL_Passenger.OBJECT_NAME, accountMap));
        }
       }
       DAL_BaseObject.InsertDBObjects(passengers);
       
    }
    
    static testMethod void beforeUpdateTest()
     {
        
	    setupInsertData();
	    Test.startTest();
	    List<Passenger__c> toUpdatePassengers = new List<Passenger__c>();
	    for(Passenger__c pass: passengers)
	    {
	    	pass.Confirmed__c = true;
	    	pass.Create_Sub_Opportunity__c = true;
	    	toUpdatePassengers.add(pass);
	    }
	    
	    update toUpdatePassengers;
	    Test.stopTest();
    }
}
@isTest
private class Test_CreatePassengerController {
  
   static List<Opportunity> opportunitys = new List<Opportunity>();
   static List<Account> accounts = new List<Account>();
   static List<Passenger__c> passengers = new List<Passenger__c>();
   public static Integer OpportunityCount = 1;
   
    static void setupInsertData()
    {
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
        
        Map<String,Object>  accountOpportunityMap = new Map<String,Object>();
        for(Account acc:accounts)
        {
            accountOpportunityMap.put('AccountId', acc.ID);
            accountOpportunityMap.put('StageName', 'Prospect');
            accountOpportunityMap.put('TravelEndDate__c', System.today().addDays(1));
            accountOpportunityMap.put('Arrival_Date__c', System.today());
        }
        
        for(Integer i = 0 ; i < OpportunityCount; i++)
        {
            opportunitys.add((Opportunity) TestDataFactory.operationOnObjectRecord(null, 'Opportunity', accountOpportunityMap));
        }
        DAL_BaseObject.InsertDBObjects(opportunitys);
        
       }   
    }
    
    static testMethod void createPassengerVFTest() {
    	
    	Test.startTest();
    	setupInsertData();
    	Passenger__c p = new Passenger__c();
    	
    	Test.setCurrentPageReference(new PageReference('CreatePassenger_VF.myPage'));
    	System.currentPageReference().getParameters().put('retURL/', opportunitys[0].id);
    	ApexPages.StandardController sc = new ApexPages.StandardController(p);
    	CreatePassengerController createPassCTRL = new CreatePassengerController(sc);
    	
        
        
        //CreatePassengerController createPassCTRL = new CreatePassengerController();
        createPassCTRL.SelectedPassengerType='Adult';
        createPassCTRL.SelectedPassengerNumber ='2';
        createPassCTRL.getPassengerTypes();
        createPassCTRL.getPassengerNumbers();
        createPassCTRL.Save();
        createPassCTRL.Cancel();
        createPassCTRL.closePopup();
        createPassCTRL.showPopup();
        Test.stopTest();
        
        
    }
}
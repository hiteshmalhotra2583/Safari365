@isTest
private class OpportunityEmailUpdateHandler_Test {

     static Account accountObj;
     static Date arrivaleDate = Date.newInstance(2008,1,1);
     static Date closeDate = Date.newInstance(2008,1,1); 
     
     static void setupData(){
        Recordtype rt = [ select id from recordtype where name='person Account'];
        accountObj = new Account(recordtypeid=rt.id, 
        						FirstName='testFirst', lastName='test Last', 
        						Phone='4343343434', PersonEmail='tes1t@fakememail.com',
        						Salutation='Mr.');
        insert accountObj;
    } 
    
    public testmethod static void testUpdateEmailFromAccount(){
        setupData();
        Test.startTest();
        Opportunity opp  = new Opportunity();
	       opp.Name = 'testScheduledApexFromTest';
	       opp.StageName='Money in the Bank';
	       opp.CloseDate=closeDate;
	       opp.Arrival_Date__c=arrivaleDate;
	       opp.WorkflowRun__c=false;
	       opp.PhotoBook_Tracking_Number__c='1111';
	       opp.AccountId= accountObj.Id;
	       insert opp;
        Test.stopTest();
    }
    
}
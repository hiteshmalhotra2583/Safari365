@isTest
private class OpportunityUtilHandler_Test {

  static Date arrivaleDate = Date.newInstance(2008,1,1);
  static Date closeDate = Date.newInstance(2008,1,1); 
  static List<Account> accounts = new List<Account>();
 
   static testmethod void test() {
  
    User us = TestDataFactory.createUser(true, '', true);
       System.runAs(us)
       {
       
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
    
       Opportunity opp  = new Opportunity();
       opp.Name = 'testScheduledApexFromTest';
       opp.StageName='Money in the Bank';
       opp.CloseDate=closeDate;
       opp.Arrival_Date__c=arrivaleDate;
       opp.WorkflowRun__c=false;
       opp.PhotoBook_Tracking_Number__c='1111';
       opp.AccountId= accounts[0].Id;
      BaseTriggerHandler.bypass('OpportunityTriggerHandler');
      insert opp;
     

   // Schedule the test job
     Test.startTest();
      String jobId = System.schedule('testBasicScheduledApex',
      OpportunityUtilHandler.CRON_EXP, 
         new OpportunityUtilHandler());
   // Get the information from the CronTrigger API object

      CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
         NextFireTime
         FROM CronTrigger WHERE id = :jobId];

   // Verify the expressions are the same
      System.assertEquals(OpportunityUtilHandler.CRON_EXP, 
         ct.CronExpression);

   // Verify the job has not run
      System.assertEquals(0, ct.TimesTriggered);

   // Verify the next time the job will run
      System.assertEquals('2022-09-03 00:00:00', 
         String.valueOf(ct.NextFireTime));
      System.assertNotEquals('testScheduledApexFromTestMethodUpdated',
         [SELECT id, name FROM Opportunity WHERE id = :opp.id].name);
   BaseTriggerHandler.clearBypass('OpportunityTriggerHandler');
   Test.stopTest();

       }

   }
}
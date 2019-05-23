@isTest
private class Test_OpportunityTriggerHandler {

    static List<Account> testAccountsList;
    static List<Opportunity> testOpportunityRec;
    public static List<Consultant_Target_Monthly__c>  consultantTargetMonthlys = new List<Consultant_Target_Monthly__c>();
    static Integer recordCount = 1;
    public static void setupTestData(){
       
       User us = TestDataFactory.createUser(true, '', true);
       System.runAs(us){
       testAccountsList = new List<Account>();
       testOpportunityRec = new List<Opportunity>();
       
       Account accountRec = new Account();
       accountRec.Name = 'Unit Test Account';
       accountRec.BillingStreet = '123 Unit Test Street';
       accountRec.BillingCity='Dallas';
       accountRec.BillingState = 'TX';
       accountRec.BillingPostalCode = '75006';
       accountRec.BillingCountry='US';
       accountRec.Industry = 'Commerical';
       accountRec.Newsletter__c= true;
       testAccountsList.add(accountRec);
       
       insert testAccountsList;
       
       Opportunity opptyRec = new Opportunity();
       opptyRec.AccountId = testAccountsList[0].Id;
       opptyRec.Name = 'Unit Test Opportuntiy';
       opptyRec.CloseDate = System.Today();
       opptyRec.StageName = 'Prospect';
       opptyRec.ownerId = us.Id;
       testOpportunityRec.add(opptyRec);
       
       insert testOpportunityRec;
       
	    Map<String,Object> consultantTargetMonthlyMap = new Map<String,Object>();
	    consultantTargetMonthlyMap.put('Month__c',String.valueof(system.today().month()));
	    consultantTargetMonthlyMap.put('Year__c',String.valueof(system.today().year()));
	    consultantTargetMonthlyMap.put('Consultant__c',us.id);
	    consultantTargetMonthlyMap.put('Override__c',true);
	    consultantTargetMonthlyMap.put('Gross_Profit_Target__c',1000);
	    consultantTargetMonthlyMap.put('Consultant_Gross_Profit_Target__c',10);
	    for(Integer i = 0 ; i <recordCount; i++)
	    {
	        consultantTargetMonthlys.add((Consultant_Target_Monthly__c) TestDataFactory.operationOnObjectRecord(null, 'Consultant_Target_Monthly__c', consultantTargetMonthlyMap));
	    }
	    DAL_BaseObject.InsertDBObjects(consultantTargetMonthlys);
            
       }
    }
    
    public static testmethod void updateOpportunity(){
        
         User us = TestDataFactory.createUser(true, '', true);
       System.runAs(us){
        setupTestData();
        Test.startTest();
        
        testOpportunityRec[0].Number_of_Adults__c = 25;
        testOpportunityRec[0].Number_of_Children__c = 20;
       
        testOpportunityRec[0].Ages_of_Children__c = '12';
        testOpportunityRec[0].stagename= 'Money in the Bank';
        testOpportunityRec[0].Arrival_Date__c=System.Today();
        
       Opportunity opptyRec = new Opportunity();
       opptyRec.AccountId = testAccountsList[0].Id;
       opptyRec.Name = 'Unit Test Opportuntiy2';
       opptyRec.CloseDate = System.Today();
       opptyRec.StageName = 'Prospect';
       testOpportunityRec.add(opptyRec);
       
        upsert testOpportunityRec;
        Test.stopTest();
       }
    }
    
    
     public static testmethod void updateOpportunity2(){
        
        User us = TestDataFactory.createUser(true, '', true);
        System.runAs(us){
	        setupTestData();
	        Test.startTest();
	        
	        testOpportunityRec[0].Number_of_Adults__c = 25;
	        testOpportunityRec[0].Number_of_Children__c = 20;
	        testOpportunityRec[0].Ages_of_Children__c = '12';
	        testOpportunityRec[0].stagename= 'Closed Won Deal';
	        testOpportunityRec[0].Arrival_Date__c=System.Today();
	        testOpportunityRec[0].Amount=100;
	        testOpportunityRec[0].Gross_Profit__c=80;
	       
	        update testOpportunityRec;
	        Test.stopTest();
        }
    }
    
    public static testmethod void deleteOpportunity2(){
        
        User us = TestDataFactory.createUser(true, '', true);
        System.runAs(us){
            setupTestData();
            Test.startTest();
            
            testOpportunityRec[0].Number_of_Adults__c = 25;
            testOpportunityRec[0].Number_of_Children__c = 20;
            testOpportunityRec[0].Ages_of_Children__c = '12';
            testOpportunityRec[0].stagename= 'Closed Won Deal';
            testOpportunityRec[0].Arrival_Date__c=System.Today();
            testOpportunityRec[0].Amount=100;
            testOpportunityRec[0].Gross_Profit__c=80;
            update testOpportunityRec;
            delete testOpportunityRec;
            Test.stopTest();
        }
    }
}
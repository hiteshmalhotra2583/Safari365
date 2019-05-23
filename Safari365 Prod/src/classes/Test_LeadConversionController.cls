@isTest
private class Test_LeadConversionController {
    public static List<Lead> leadList = new List<Lead>();
    @testSetup static void setupInsertData()
    {
        User us = TestDataFactory.createUser(true, '', true);
        System.runAs(us){
            Lead testLeadRec = new Lead();
            testLeadRec.Email = 'test@gmail.com';
            testLeadRec.LastName = 'lead test';
            testLeadRec.Company = 'company1';
            leadList.add(testLeadRec);
            DAL_BaseObject.InsertDBObjects(leadList);
        }
    }
    @isTest static void Test_leadConversion(){
        List<Lead> leads = [Select Id, Cancel_Workflow__c, LastName from Lead];
        Test.startTest();
        LeadConversionController.leadConversion(leads[0].Id);
        Test.stopTest();
    }
    
}
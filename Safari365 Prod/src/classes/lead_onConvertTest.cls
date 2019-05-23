@isTest
private class lead_onConvertTest
{
    public static List<Lead> testLeads = new List<Lead>();
    @testSetup static void setupInsertData()
    {
        User us = TestDataFactory.createUser(true, '', true);
        System.runAs(us){
            // Create the Lead object
            Lead testLead = new Lead(
                FirstName='Demo First',
                LastName = 'Demo Last UnitTest',
                Email = 'Test@test.com',
                New_Country_of_residence__c = 'South Africa',
                HasOptedOutOfEmail= true,
                Basket_Information__c='Hi this is just for testing purpose',
                Website_origin__c='Web: safari365.com',
                Status='Qualified'   
            );
            testLeads.add(testLead);
            insert testLeads;
        }
        
    }
    @isTest static void mLeadConvert()
    {
        User us = TestDataFactory.createUser(true, '', true);
        System.runAs(us)
        {
	        Lead testLead = [SELECT Id,Status FROM Lead limit 1];
	        Test.startTest();
	        System.debug('Created and inserted lead');
	        Database.LeadConvert lc = new database.LeadConvert();
	        lc.setLeadId(testLead.Id);
	        
	        //LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
	        //lc.setConvertedStatus(convertStatus.MasterLabel);
	        lc.setConvertedStatus(testLead.Status);
	        Database.LeadConvertResult lcr = Database.convertLead(lc);
	        
	        // Make sure conversion was successful
	        System.assert(lcr.isSuccess());
	        Test.stopTest();
        }
    }
}
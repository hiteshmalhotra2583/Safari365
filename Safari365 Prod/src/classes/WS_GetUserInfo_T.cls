@isTest
private class WS_GetUserInfo_T {

    static User adminUser;
    static List<Opportunity>  Opportunities;
   
    @testSetup
   static void setupInsertData()
   {
         adminUser = TestDataFactory.createUser(true,'OpportunityTriggerHandler',true);
         system.runas(adminUser)
        {
	        List<Account>  accounts = new List<Account>();
	        Opportunities = new List<Opportunity>();
	        Integer count =1;
	        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
	        Map <String,Object> MapFieldsAndValueAcc = new Map <String,Object>();
	        MapFieldsAndValueAcc.put('RecordTypeId', devRecordTypeId );
	        MapFieldsAndValueAcc.put('LastName', 'TestL');
	        for(Integer i = 0 ; i <count; i++){
	            Account AccObj = (Account) TestDataFactory.operationOnObjectRecord(null, 'Account', MapFieldsAndValueAcc);
	            accounts.add(AccObj);
	        }
	        insert accounts; 
	        Map <String,Object> MapFieldsAndValue = new Map <String,Object>();
	        MapFieldsAndValue.put('AccountId', accounts[0].Id);
	        MapFieldsAndValue.put('StageName', 'TL Quotation');
	        MapFieldsAndValue.put('TravelEndDate__c', System.Today()+4);
	        Opportunities.add((Opportunity) TestDataFactory.operationOnObjectRecord(null, 'Opportunity', MapFieldsAndValue));
	        insert Opportunities;
         }
    }
    
    static testMethod void getUserInfoWSTest_Postive() {
       
       Test.startTest();
       Opportunity oppObj = [ Select Id from Opportunity];
       WS_GetUserInfo.RequestWrapper request  = new WS_GetUserInfo.RequestWrapper(oppObj.Id);      
       WS_GetUserInfo.ResponseWrapper  response = WS_GetUserInfo.doPost(request);
       System.AssertEquals(response.status, 'Success');
       Test.stopTest();
        
    }
    
    
}
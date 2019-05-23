@isTest
private class WS_GetOpportunity_T {
   
   @testSetup
   static void setupInsertData(){
   
        List<Account>  accounts = new List<Account>();
        List<Opportunity>  Opportunities = new List<Opportunity>();
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

    static testMethod void opportunitytWSTest_Negative() {
       
       Test.startTest();
       Account AccObj = [ Select Id, Members_Club_ID__c from Account];
       WS_GetOpportunity.RequestWrapper request  = new WS_GetOpportunity.RequestWrapper(AccObj.Id);      
       WS_GetOpportunity.ResponseWrapper  response = WS_GetOpportunity.doPost(request);
       System.AssertEquals(response.status, 'Error');
       Test.stopTest();
        
    }
    static testMethod void opportunityWSTest_Positive() {
       
       Test.startTest();
       Opportunity OppObj = [ Select Id from Opportunity];
       WS_GetOpportunity.RequestWrapper request  = new WS_GetOpportunity.RequestWrapper(OppObj.Id);
       WS_GetOpportunity.ResponseWrapper  response = WS_GetOpportunity.doPost(request);
       System.AssertEquals(response.status, 'Success');
       Test.stopTest();
        
    }
}
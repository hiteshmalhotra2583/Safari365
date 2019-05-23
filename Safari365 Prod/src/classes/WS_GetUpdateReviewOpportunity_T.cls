@isTest
private class WS_GetUpdateReviewOpportunity_T {
   
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

    static testMethod void quotationsWSTest_Negative() {
       
       Test.startTest();
       Account AccObj = [ Select Id, Members_Club_ID__c from Account];
       WS_GetUpdateReviewOpportunity.OpportunityInfoWrapper OppRecord  = new WS_GetUpdateReviewOpportunity.OpportunityInfoWrapper ();
       OppRecord.Overallclientsafariexperience = 'Testing';
       OppRecord.HowcanSafari365improve = 'Testing';
       OppRecord.Rating1 = true;
       OppRecord.Rating2 = true;
       OppRecord.Rating3 = true;
       OppRecord.Rating4 = false;
       OppRecord.Rating5 = false;
       WS_GetUpdateReviewOpportunity.RequestWrapper request  = new WS_GetUpdateReviewOpportunity.RequestWrapper(OppRecord);
       WS_GetUpdateReviewOpportunity.ResponseWrapper  response = WS_GetUpdateReviewOpportunity.doPost(request);
       System.AssertEquals(response.status, 'Error');
       Test.stopTest();
        
    }
    
    static testMethod void quotationsWSBlankTest_Negative() {
       
       Test.startTest();
       WS_GetUpdateReviewOpportunity.RequestWrapper request  = new WS_GetUpdateReviewOpportunity.RequestWrapper(null);
       WS_GetUpdateReviewOpportunity.ResponseWrapper  response = WS_GetUpdateReviewOpportunity.doPost(request);
       system.AssertEquals(response.status, 'Error');
       Test.stopTest();
        
    }
    
    static testMethod void QuotationsWSTest_Positive() {
       
       Test.startTest();
       
       WS_GetUpdateReviewOpportunity.OpportunityInfoWrapper OppRecord  = new WS_GetUpdateReviewOpportunity.OpportunityInfoWrapper ();
       OppRecord.OpportunityId = [ Select Id from Opportunity ].Id;
       OppRecord.Overallclientsafariexperience = 'Testing';
       OppRecord.HowcanSafari365improve = 'Testing';
       OppRecord.Rating1 = true;
       OppRecord.Rating2 = true;
       OppRecord.Rating3 = true;
       OppRecord.Rating4 = false;
       OppRecord.Rating5 = false;
       WS_GetUpdateReviewOpportunity.RequestWrapper request  = new WS_GetUpdateReviewOpportunity.RequestWrapper(OppRecord);
       WS_GetUpdateReviewOpportunity.ResponseWrapper  response = WS_GetUpdateReviewOpportunity.doPost(request);
       system.AssertEquals(response.status, 'Success');
       Test.stopTest();
        
    }
}
@isTest
private class WS_GetPassenger_T {
   
   @testSetup
   static void setupInsertData(){
   
        List<Account>  accounts = new List<Account>();
        List<Opportunity>  Opportunities = new List<Opportunity>();
        List<Passenger__c> passengers = new List<Passenger__c>();
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
        
        Map <String,Object> MapFieldsAndValuePassenger = new Map <String,Object>();
        MapFieldsAndValuePassenger.put('Account__c', accounts[0].Id);
        MapFieldsAndValuePassenger.put('Opportunity__c', Opportunities[0].Id);
        passengers.add((Passenger__c) TestDataFactory.operationOnObjectRecord(null, 'Passenger__c', MapFieldsAndValuePassenger));
        insert passengers;
        
    }

    static testMethod void passengerWSTest_Negative() {
       
       Test.startTest();
       Account AccObj = [ Select Id, Members_Club_ID__c from Account];
       WS_GetPassenger.RequestWrapper request  = new WS_GetPassenger.RequestWrapper(AccObj.Id);      
       WS_GetPassenger.ResponseWrapper  response = WS_GetPassenger.doPost(request);
       System.AssertEquals(response.status, 'Error');
       Test.stopTest();
        
    }
    static testMethod void opportunityWSTest_Positive() {
       
       Test.startTest();
       Passenger__c PassengerObj = [ Select Id from Passenger__c limit 1];
       WS_GetPassenger.RequestWrapper request  = new WS_GetPassenger.RequestWrapper(PassengerObj.Id);
       WS_GetPassenger.ResponseWrapper  response = WS_GetPassenger.doPost(request);
       System.AssertEquals(response.status, 'Success');
       Test.stopTest();
        
    }
}
@isTest
private class WS_GetQuotation_T {
   
   static List<Opportunity>  Opportunities = new List<Opportunity>();
   @testSetup
   static void setupInsertData(){
        
        User us = TestDataFactory.createUser(true, '', true);
        System.runAs(us){
	        List<Account>  accounts = new List<Account>();
	       // List<Opportunity>  Opportunities = new List<Opportunity>();
	        List<Passenger__c> passengers = new List<Passenger__c>();
	        List<Quotations__c> quotations = new List<Quotations__c>();
	        List<PassengerQuotationMapping__c> PQMapping = new List<PassengerQuotationMapping__c>();
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
	        MapFieldsAndValue.put('Arrival_Date__c', System.Today());
	        MapFieldsAndValue.put('TravelEndDate__c', System.Today()+4);
	        Opportunities.add((Opportunity) TestDataFactory.operationOnObjectRecord(null, 'Opportunity', MapFieldsAndValue));
	        insert Opportunities;
	        
	        Map <String,Object> MapFieldsAndValuePassenger = new Map <String,Object>();
	        MapFieldsAndValuePassenger.put('Account__c', accounts[0].Id);
	        MapFieldsAndValuePassenger.put('Opportunity__c', Opportunities[0].Id);
	        passengers.add((Passenger__c) TestDataFactory.operationOnObjectRecord(null, 'Passenger__c', MapFieldsAndValuePassenger));
	        insert passengers;
	        
	        Map <String,Object> MapFieldsAndValuequotations = new Map <String,Object>();
	        //MapFieldsAndValuequotations.put('TravelEndDate__c', System.today()+30);
	        MapFieldsAndValuequotations.put('Opportunity__c', Opportunities[0].Id);
	        MapFieldsAndValuequotations.put('Quotation_Stage__c', 'Quoting');
	        MapFieldsAndValuequotations.put('Primary_Quotation__c', true);
	        MapFieldsAndValuequotations.put('Quotation_Stage__c', 'Quoting');
	        quotations.add((Quotations__c) TestDataFactory.operationOnObjectRecord(null, 'Quotations__c', MapFieldsAndValuequotations));
	        insert quotations;
	        
	        Map <String,Object> MapFieldsAndValuePQMap = new Map <String,Object>();
	        MapFieldsAndValuePQMap.put('Passenger__c', passengers[0].Id);
	        MapFieldsAndValuePQMap.put('Quotation__c', quotations[0].Id);
	        PQMapping.add((PassengerQuotationMapping__c) TestDataFactory.operationOnObjectRecord(null, 'PassengerQuotationMapping__c', MapFieldsAndValuePQMap));
	        insert PQMapping;
        }
    }

    static testMethod void passengerWSTest_Negative() {
       
       Test.startTest();
       Account AccObj = [ Select Id, Members_Club_ID__c from Account];
       WS_GetQuotation.RequestWrapper request  = new WS_GetQuotation.RequestWrapper(AccObj.Id);      
       WS_GetQuotation.ResponseWrapper  response = WS_GetQuotation.doPost(request);
       System.AssertEquals(response.status, 'Error');
       Test.stopTest();
        
    }
    static testMethod void opportunityWSTest_Positive() {
       
       Test.startTest();
       Quotations__c QuoteObj = [ Select Id from Quotations__c ];
       WS_GetQuotation.RequestWrapper request  = new WS_GetQuotation.RequestWrapper(QuoteObj.Id);
       WS_GetQuotation.ResponseWrapper  response = WS_GetQuotation.doPost(request);
       System.AssertEquals(response.status, 'Success');
       Test.stopTest();
        
    }
    
    static testMethod void passengerWSTest_Negative2() {
       
       Test.startTest();
       Account AccObj = [ Select Id, Members_Club_ID__c from Account];
       WS_GetQuotationV2.RequestWrapper request  = new WS_GetQuotationV2.RequestWrapper(AccObj.Id);      
       WS_GetQuotationV2.ResponseWrapper  response = WS_GetQuotationV2.doPost(request);
       System.AssertEquals(response.status, 'Error');
       Test.stopTest();
        
    }
    
    static testMethod void opportunityWSTest_Positive2() {
       
       Test.startTest();
       Opportunity QuoteObj = [ Select Id from Opportunity ];
       WS_GetQuotationV2.RequestWrapper request  = new WS_GetQuotationV2.RequestWrapper(QuoteObj.Id);
       WS_GetQuotationV2.ResponseWrapper  response = WS_GetQuotationV2.doPost(request);
       System.AssertEquals(response.status, 'Success');
       Test.stopTest();
        
    }
}
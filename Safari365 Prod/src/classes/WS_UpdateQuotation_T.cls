@isTest
private class WS_UpdateQuotation_T {
   
   @testSetup
   static void setupInsertData(){
   
        List<Account>  accounts = new List<Account>();
        List<Opportunity>  Opportunities = new List<Opportunity>();
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
        MapFieldsAndValue.put('TravelEndDate__c', System.Today()+4);
        Opportunities.add((Opportunity) TestDataFactory.operationOnObjectRecord(null, 'Opportunity', MapFieldsAndValue));
        insert Opportunities;
        
        Map <String,Object> MapFieldsAndValuePassenger = new Map <String,Object>();
        MapFieldsAndValuePassenger.put('Account__c', accounts[0].Id);
        MapFieldsAndValuePassenger.put('Opportunity__c', Opportunities[0].Id);
        passengers.add((Passenger__c) TestDataFactory.operationOnObjectRecord(null, 'Passenger__c', MapFieldsAndValuePassenger));
        insert passengers;
        
        Map <String,Object> MapFieldsAndValuequotations = new Map <String,Object>();
        MapFieldsAndValuequotations.put('TravelEndDate__c', System.today()+30);
        MapFieldsAndValuequotations.put('Opportunity__c', Opportunities[0].Id);
        MapFieldsAndValuequotations.put('Quotation_Stage__c', 'Quoting');
        quotations.add((Quotations__c) TestDataFactory.operationOnObjectRecord(null, 'Quotations__c', MapFieldsAndValuequotations));
        insert quotations;
        
        Map <String,Object> MapFieldsAndValuePQMap = new Map <String,Object>();
        MapFieldsAndValuePQMap.put('Passenger__c', passengers[0].Id);
        MapFieldsAndValuePQMap.put('Quotation__c', quotations[0].Id);
        PQMapping.add((PassengerQuotationMapping__c) TestDataFactory.operationOnObjectRecord(null, 'PassengerQuotationMapping__c', MapFieldsAndValuePQMap));
        insert PQMapping;
        
    }

    static testMethod void quotationsWSTest_Negative() {
       
       Test.startTest();
       Account AccObj = [ Select Id, Members_Club_ID__c from Account];
       WS_UpdateQuotation.RequestWrapper request  = new WS_UpdateQuotation.RequestWrapper();
       WS_UpdateQuotation.Quotation  quoteRecord  = new WS_UpdateQuotation.Quotation();
       quoteRecord.QuotationId = AccObj.Id;
       quoteRecord.Client_Has_Requested_Confirmation = true;
       quoteRecord.Client_Has_Requested_Requote = true;
       quoteRecord.Status = 'Quoting';
       request.quotation = quoteRecord;   
       WS_UpdateQuotation.ResponseWrapper  response = WS_UpdateQuotation.doPost(request);
       System.AssertEquals(response.status, 'Error');
       Test.stopTest();
        
    }
    
    static testMethod void quotationsWSBlankTest_Negative() {
       
       Test.startTest();
       WS_UpdateQuotation.RequestWrapper request  = new WS_UpdateQuotation.RequestWrapper();       
       WS_UpdateQuotation.ResponseWrapper  response = WS_UpdateQuotation.doPost(request);
       System.AssertEquals(response.status, 'Error');
       Test.stopTest();
        
    }
    
    static testMethod void QuotationsWSTest_Positive() {
       
       Test.startTest();
       Quotations__c quoteObj = [ Select Id from Quotations__c ];
       WS_UpdateQuotation.RequestWrapper request  = new WS_UpdateQuotation.RequestWrapper();
       WS_UpdateQuotation.Quotation  quoteRecord  = new WS_UpdateQuotation.Quotation();
       quoteRecord.QuotationId = quoteObj.Id;
       quoteRecord.Client_Has_Requested_Confirmation = true;
       quoteRecord.Client_Has_Requested_Requote = true;
       quoteRecord.Status = 'Quoting';
       request.quotation = quoteRecord;
       WS_UpdateQuotation.ResponseWrapper  response = WS_UpdateQuotation.doPost(request);
       System.AssertEquals(response.status, 'Success');
       Test.stopTest();
        
    }
}
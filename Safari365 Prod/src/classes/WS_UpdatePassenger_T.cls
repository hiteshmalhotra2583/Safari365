@isTest
private class WS_UpdatePassenger_T {
   
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

    static testMethod void passengerUpdateWSTest_Negative() {
       
       Test.startTest();
       Account AccObj = [ Select Id, Members_Club_ID__c from Account];
       WS_UpdatePassenger.RequestWrapper request  = new WS_UpdatePassenger.RequestWrapper();
       WS_UpdatePassenger.Passenger passengerObj = new WS_UpdatePassenger.Passenger();
       passengerObj.PassengerId = AccObj.Id;
       passengerObj.FirstName = 'Test';    
       request.Passenger = passengerObj;     
       WS_UpdatePassenger.ResponseWrapper  response = WS_UpdatePassenger.doPost(request);
       System.AssertEquals(response.status, 'Error');
       Test.stopTest();
        
    }
    
    static testMethod void passengerUpdateBlankWSTest_Negative() {
       
       Test.startTest();
       WS_UpdatePassenger.RequestWrapper request  = new WS_UpdatePassenger.RequestWrapper();
       WS_UpdatePassenger.ResponseWrapper  response = WS_UpdatePassenger.doPost(request);
       System.AssertEquals(response.status, 'Error');
       Test.stopTest();
        
    }
    
    static testMethod void passengerUpdateWSTest_Positive() {
       
       Test.startTest(); 
       WS_UpdatePassenger.RequestWrapper request  = new WS_UpdatePassenger.RequestWrapper();
       WS_UpdatePassenger.Passenger passengerObj = new WS_UpdatePassenger.Passenger();
       passengerObj.PassengerId = [ Select Id from Passenger__c limit 1].Id;
       passengerObj.FirstName = 'Test';
        passengerObj.MiddleName = 'TestM';
        passengerObj.LastName = 'TestL';
        passengerObj.PassportNumber = '3435454';
        passengerObj.PassportExpiry = System.Today()+400;
        passengerObj.DOB = System.Today()-5000;
        passengerObj.PassportNationality = 'Canada';
        passengerObj.EmailAddress = 'Test@test.com';
        passengerObj.MobilePhone = '3434343434';
        passengerObj.HomePhone = '2323232323';
        passengerObj.CountryofResidence = 'Canada';
        passengerObj.EmergencyFirstName = 'EFirst';
        passengerObj.EmergencyLastName = 'Elast';
        passengerObj.EmergencyPhoneNumber = '3434343434';
        passengerObj.SpecialDietaryRequirements = true;
        passengerObj.SpecialDietaryRequirementsDetails = 'Testing';
        passengerObj.MedicalInformation = true;
        passengerObj.existingMedicalInformation = true;
        passengerObj.MedicalInformationDetails = 'Testing';
        passengerObj.ExistingMobilityIssues = true;
        passengerObj.ExistingMobilityIssuesDetails = 'Testing';
        passengerObj.Anniversary = System.Today()+40;
        passengerObj.OtherOccasion = 'Testing';
        passengerObj.TravelInsurance = 'I don\'t have travel insurance';
        passengerObj.TravelInsurancePolicyNumber = 'Testing';
        passengerObj.TravelInsuranceProvider = 'Testing';
        passengerObj.TravelInsuranceEmergencyNumber = 'Testing';
        passengerObj.ArrivalFlightDetails = 'Testing';
        passengerObj.DepartureFlightDetails = 'Testing';
        passengerObj.WaiverofLiabilityDate = System.Today()+4;
        passengerObj.WaiverofLiabilityConfirmation = True;
        passengerObj.WaiverOfLiabilityName = 'Testing';    
       request.Passenger = passengerObj;     
       WS_UpdatePassenger.ResponseWrapper  response = WS_UpdatePassenger.doPost(request);
       System.AssertEquals(response.status, 'Success');
       Test.stopTest();
        
    }
}
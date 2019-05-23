@isTest
private class Test_DAL_Passenger {

   static List<Opportunity> opportunitys = new List<Opportunity>();
   static List<Account> accounts = new List<Account>();
   static List<Passenger__c> passengers = new List<Passenger__c>();
   static List<Quotations__c> Quotations = new List<Quotations__c>();
   static List<PassengerQuotationMapping__c> passengersQuotationMappings = new List<PassengerQuotationMapping__c>();
   public static Integer recordCount = 1;
   
    static void setupInsertData()
    {
       User us = TestDataFactory.createUser(true, '', true);
       System.runAs(us){
       Account accountRec = new Account();
       accountRec.Name = 'Unit Test Account';
       accountRec.BillingStreet = '123 Unit Test Street';
       accountRec.BillingCity='Dallas';
       accountRec.BillingState = 'TX';
       accountRec.BillingPostalCode = '75006';
       accountRec.BillingCountry='US';
       accountRec.Industry = 'Commerical';
       accountRec.Newsletter__c= true;
       accounts.add(accountRec);
       
       DAL_BaseObject.InsertDBObjects(accounts);
        
        Map<String,Object>  accountOpportunityMap = new Map<String,Object>();
        for(Account acc:accounts)
        {
            accountOpportunityMap.put('AccountId', acc.ID);
            accountOpportunityMap.put('StageName', 'Prospect');
            accountOpportunityMap.put('Arrival_Date__c',system.today());
            accountOpportunityMap.put('TravelEndDate__c',system.today().addDays(5));
        }
        
        for(Integer i = 0 ; i <recordCount; i++)
        {
            opportunitys.add((Opportunity) TestDataFactory.operationOnObjectRecord(null, 'Opportunity', accountOpportunityMap));
        }
         DAL_BaseObject.InsertDBObjects(opportunitys);
        
        Map<String,Object>  accountMap = new Map<String,Object>();
        for(Opportunity opp:opportunitys)
      {
        accountMap.put('Opportunity__c' ,opp.id );
        accountMap.put('PassengerType__c' ,'Adult');
      }
      
       for(Integer i = 0 ; i <recordCount; i++)
        {
            passengers.add((Passenger__c) TestDataFactory.operationOnObjectRecord(null, DAL_Passenger.OBJECT_NAME, accountMap));
        }
      
       DAL_BaseObject.InsertDBObjects(passengers);
       
        Map<String,Object>  opportunityQuotationMap = new Map<String,Object>();
        for(Opportunity opp:opportunitys)
        {
            opportunityQuotationMap.put('Opportunity__c', opp.ID);
            opportunityQuotationMap.put('TravelStartDate__c',system.today());
            opportunityQuotationMap.put('TravelEndDate__c',system.today().addDays(2));
            opportunityQuotationMap.put('Include_Passenger_Insurance_USD__c', true);
            opportunityQuotationMap.put('Include_Passenger_Insurance_ZAR__c',false);
            opportunityQuotationMap.put('Quotation_Stage__c','Confirmed');
        }
        
        for(Integer i = 0 ; i <recordCount; i++)
        {
            Quotations.add((Quotations__c) TestDataFactory.operationOnObjectRecord(null, 'Quotations__c', opportunityQuotationMap));
        }
        DAL_BaseObject.InsertDBObjects(Quotations);
       
        Map<String,Object>  passengerQuotationMap = new Map<String,Object>();
        passengerQuotationMap.put('Passenger__c',passengers[0].Id);
        passengerQuotationMap.put('Quotation__c',Quotations[0].Id);
        for(Integer i = 0 ; i <recordCount; i++)
        {
            passengersQuotationMappings.add((PassengerQuotationMapping__c) TestDataFactory.operationOnObjectRecord(null, 'PassengerQuotationMapping__c', passengerQuotationMap));
        }
      
       DAL_BaseObject.InsertDBObjects(passengersQuotationMappings);
      }
    }

    static testMethod void getExisitingCouuntTest() {
        setupInsertData();
        Test.startTest();
        String passengerType=passengers[0].PassengerType__c;
        Id oppId = opportunitys[0].Id;
        DAL_Passenger.getExisitingCouunt(passengerType,oppId);
         
         List<String> passengerIds = new List<String>();
         Set<Id> passengerIdSet = new Set<Id>();
         for(Passenger__c p:passengers)
         {
            passengerIds.add(p.id);
            passengerIdSet.add(p.Id);
         }
         DAL_Passenger.getByIds(passengerIds);
         DAL_Passenger.getPrimaryByIds(passengerIds);
         DAL_Passenger.getAllQuotationsRelatedToPassengers(passengerIdSet);
        Test.stopTest();
        
        
    }
}
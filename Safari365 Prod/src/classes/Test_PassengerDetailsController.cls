@isTest
private class Test_PassengerDetailsController {

   static List<Account> accounts = new List<Account>();
   static List<Passenger__c> passengers = new List<Passenger__c>();
   static List<Opportunity> opportunitys = new List<Opportunity>();
   static List<Quotations__c> Quotations = new List<Quotations__c>();
   static List<PassengerQuotationMapping__c> passengerQuotations = new List<PassengerQuotationMapping__c>();
   static List<ExchangeRates__c> exchangeRates = new List<ExchangeRates__c>();
   public static Integer count = 1;

    static void setupInsertData(){
       
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
       Map<String,Object>  accountMap = new Map<String,Object>();
       Map<String,Object>  accountOpportunityMap = new Map<String,Object>();
       Date arrivaleDate = Date.newInstance(2008,1,1);
       Date closeDate = Date.newInstance(2008,1,1); 
        for(Account acc:accounts)
        {
            accountMap.put('Account__c', acc.ID);
            accountOpportunityMap.put('AccountId', acc.ID);
            accountOpportunityMap.put('StageName','Money in the Bank');
            accountOpportunityMap.put('CloseDate',closeDate);
            accountOpportunityMap.put('Arrival_Date__c',arrivaleDate);
        }
        
        Map<String,Object> exchangeRateMap = new Map<String,Object>();
        exchangeRateMap.put('BaseCurrency__c','ZAR');
        for(Integer i = 0 ; i <count; i++)
        {
            exchangeRates.add((ExchangeRates__c) TestDataFactory.operationOnObjectRecord(null, 'ExchangeRates__c', exchangeRateMap));
        }
        DAL_BaseObject.InsertDBObjects(exchangeRates);
        
       for(Integer i = 0 ; i <count; i++)
        {
            opportunitys.add((Opportunity) TestDataFactory.operationOnObjectRecord(null, DAL_Opportunity.OBJECT_NAME, accountOpportunityMap));
        }
    
      insert opportunitys;
      
      for(Opportunity opp:opportunitys)
      {
      	accountMap.put('Opportunity__c' ,opp.id );
        accountMap.put('Last_Name__c' ,'LN' );
      }
      
       for(Integer i = 0 ; i <count; i++)
        {
            passengers.add((Passenger__c) TestDataFactory.operationOnObjectRecord(null, DAL_Passenger.OBJECT_NAME, accountMap));
        }
       }
       DAL_BaseObject.InsertDBObjects(passengers);
       
        Map<String,Object>  opportunityQuotationMap = new Map<String,Object>();
        for(Opportunity opp:opportunitys)
        {
            opportunityQuotationMap.put('Opportunity__c', opp.ID);
            opportunityQuotationMap.put('TravelStartDate__c',system.today());
            opportunityQuotationMap.put('TravelEndDate__c',system.today().addDays(3));
        }
      
       
        for(Integer i = 0 ; i <count; i++)
        {
            Quotations.add((Quotations__c) TestDataFactory.operationOnObjectRecord(null, DAL_Quotations.OBJECT_NAME, opportunityQuotationMap));
        }
        DAL_BaseObject.InsertDBObjects(Quotations);
        
        Map<String,Object>  passengerQuotationMapingMap = new Map<String,Object>();
        passengerQuotationMapingMap.put('Passenger__c',passengers[0].Id);
        passengerQuotationMapingMap.put('Quotation__c',Quotations[0].Id);
        for(Integer i = 0 ; i <count; i++)
        {
            passengerQuotations.add((PassengerQuotationMapping__c) TestDataFactory.operationOnObjectRecord(null, 'PassengerQuotationMapping__c', passengerQuotationMapingMap));
        }
        DAL_BaseObject.InsertDBObjects(passengerQuotations);
       
    }
    

    static testMethod void passengerDetailsControllerTest()
    {
       Test.startTest();
        setupInsertData();
    	Test.setCurrentPageReference(new PageReference('PassengerDetails.myPage'));
        System.currentPageReference().getParameters().put('Id', Quotations[0].id);
        PassengerDetailsController passengersDetail  = new PassengerDetailsController();
        passengersDetail.SelectedPassenger.Last_Name__c='LN';
        passengersDetail.Save();
        
       Test.stopTest();
        
    }
}
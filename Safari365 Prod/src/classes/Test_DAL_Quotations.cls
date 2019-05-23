@isTest
private class Test_DAL_Quotations {

   static List<Opportunity> opportunitys = new List<Opportunity>();
   static List<Account> accounts = new List<Account>();
   static List<Passenger__c> passengers = new List<Passenger__c>();
   static List<Quotations__c> Quotations = new List<Quotations__c>();
   static List<PassengerQuotationMapping__c> passengerQuotations = new List<PassengerQuotationMapping__c>();
   static List<ServiceLineItem__c> slis = new List<ServiceLineItem__c>();
   static List<ServiceLineItemPassengersMapping__c> sliPassengers = new List<ServiceLineItemPassengersMapping__c>();
   static Integer recordCount = 1;
   static List<QuotationLineItem__c> getQuotationLineItemList;
   static QuotationBuilderDatabaseQueries dbQueries = new QuotationBuilderDatabaseQueries();
   static List<ExchangeRates__c> exchangeRates = new List<ExchangeRates__c>();
   
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
        }
        
        Map<String,Object> exchangeRateMap = new Map<String,Object>();
        exchangeRateMap.put('BaseCurrency__c','ZAR');
        for(Integer i = 0 ; i <recordCount; i++)
        {
            exchangeRates.add((ExchangeRates__c) TestDataFactory.operationOnObjectRecord(null, 'ExchangeRates__c', exchangeRateMap));
        }
        DAL_BaseObject.InsertDBObjects(exchangeRates);
        
        for(Integer i = 0 ; i <recordCount; i++)
        {
            opportunitys.add((Opportunity) TestDataFactory.operationOnObjectRecord(null, 'Opportunity', accountOpportunityMap));
        }
        DAL_BaseObject.InsertDBObjects(opportunitys);
        
        
        
        Map<String,Object>  opportunityQuotationMap = new Map<String,Object>();
        Map<String,Object>  accountMap = new Map<String,Object>();
        for(Opportunity opp:opportunitys)
        {
            opportunityQuotationMap.put('Opportunity__c', opp.ID);
            opportunityQuotationMap.put('TravelStartDate__c',system.today());
            opportunityQuotationMap.put('TravelEndDate__c',system.today().addDays(3));
            accountMap.put('Opportunity__c' ,opp.id );
        }
      
        for(Integer i = 0 ; i <recordCount; i++)
        {
            passengers.add((Passenger__c) TestDataFactory.operationOnObjectRecord(null, DAL_Passenger.OBJECT_NAME, accountMap));
        }
        DAL_BaseObject.InsertDBObjects(passengers);
        
        for(Integer i = 0 ; i <recordCount; i++)
        {
            Quotations.add((Quotations__c) TestDataFactory.operationOnObjectRecord(null, DAL_Quotations.OBJECT_NAME, opportunityQuotationMap));
        }
        DAL_BaseObject.InsertDBObjects(Quotations);
        
        Map<String,Object>  passengerQuotationMapingMap = new Map<String,Object>();
        passengerQuotationMapingMap.put('Passenger__c',passengers[0].Id);
        passengerQuotationMapingMap.put('Quotation__c',Quotations[0].Id);
        for(Integer i = 0 ; i <recordCount; i++)
        {
            passengerQuotations.add((PassengerQuotationMapping__c) TestDataFactory.operationOnObjectRecord(null, 'PassengerQuotationMapping__c', passengerQuotationMapingMap));
        }
        DAL_BaseObject.InsertDBObjects(passengerQuotations);
        
       getQuotationLineItemList= dbQueries.GetQuotationLineItemList(Quotations[0].id);
       
       Map<String, Object> quoationServiceLineMap =new Map<String, Object>();
       for(QuotationLineItem__c quoli: getQuotationLineItemList)
       {
       	quoationServiceLineMap.put('QuotationLine__c',quoli.Id);
       }
       
       for(Integer i = 0 ; i <recordCount; i++)
        {
            slis.add((ServiceLineItem__c) TestDataFactory.operationOnObjectRecord(null, 'ServiceLineItem__c', quoationServiceLineMap));
        }
        DAL_BaseObject.InsertDBObjects(slis);
       
       
        Map<String,Object>  passengerSLIMapingMap = new Map<String,Object>();
        passengerSLIMapingMap.put('Passenger__c',passengers[0].Id);
        passengerSLIMapingMap.put('Service_Line_Item__c',slis[0].Id);
        for(Integer i = 0 ; i <recordCount; i++)
        {
            sliPassengers.add((ServiceLineItemPassengersMapping__c) TestDataFactory.operationOnObjectRecord(null, 'ServiceLineItemPassengersMapping__c', passengerSLIMapingMap));
        }
        DAL_BaseObject.InsertDBObjects(sliPassengers);
        
       }   
    }
    
    
    static void setupInsertData2()
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
        }
        
        Map<String,Object> exchangeRateMap = new Map<String,Object>();
        exchangeRateMap.put('BaseCurrency__c','ZAR');
        for(Integer i = 0 ; i <recordCount; i++)
        {
            exchangeRates.add((ExchangeRates__c) TestDataFactory.operationOnObjectRecord(null, 'ExchangeRates__c', exchangeRateMap));
        }
        DAL_BaseObject.InsertDBObjects(exchangeRates);
        
        for(Integer i = 0 ; i <recordCount; i++)
        {
            opportunitys.add((Opportunity) TestDataFactory.operationOnObjectRecord(null, 'Opportunity', accountOpportunityMap));
        }
        DAL_BaseObject.InsertDBObjects(opportunitys);
        
        
        
        Map<String,Object>  opportunityQuotationMap = new Map<String,Object>();
        Map<String,Object>  accountMap = new Map<String,Object>();
        for(Opportunity opp:opportunitys)
        {
            opportunityQuotationMap.put('Opportunity__c', opp.ID);
            opportunityQuotationMap.put('TravelStartDate__c',system.today());
            opportunityQuotationMap.put('TravelEndDate__c',system.today().addDays(3));
            opportunityQuotationMap.put('Valid_Until__c',null);
            accountMap.put('Opportunity__c' ,opp.id );
        }
      
        for(Integer i = 0 ; i <recordCount; i++)
        {
            passengers.add((Passenger__c) TestDataFactory.operationOnObjectRecord(null, DAL_Passenger.OBJECT_NAME, accountMap));
        }
        DAL_BaseObject.InsertDBObjects(passengers);
        
        for(Integer i = 0 ; i <recordCount; i++)
        {
            Quotations.add((Quotations__c) TestDataFactory.operationOnObjectRecord(null, DAL_Quotations.OBJECT_NAME, opportunityQuotationMap));
        }
        DAL_BaseObject.InsertDBObjects(Quotations);
        
        Map<String,Object>  passengerQuotationMapingMap = new Map<String,Object>();
        passengerQuotationMapingMap.put('Passenger__c',passengers[0].Id);
        passengerQuotationMapingMap.put('Quotation__c',Quotations[0].Id);
        for(Integer i = 0 ; i <recordCount; i++)
        {
            passengerQuotations.add((PassengerQuotationMapping__c) TestDataFactory.operationOnObjectRecord(null, 'PassengerQuotationMapping__c', passengerQuotationMapingMap));
        }
        DAL_BaseObject.InsertDBObjects(passengerQuotations);
        
       getQuotationLineItemList= dbQueries.GetQuotationLineItemList(Quotations[0].id);
       
       Map<String, Object> quoationServiceLineMap =new Map<String, Object>();
       for(QuotationLineItem__c quoli: getQuotationLineItemList)
       {
       	quoationServiceLineMap.put('QuotationLine__c',quoli.Id);
       }
       
       for(Integer i = 0 ; i <recordCount; i++)
        {
            slis.add((ServiceLineItem__c) TestDataFactory.operationOnObjectRecord(null, 'ServiceLineItem__c', quoationServiceLineMap));
        }
        DAL_BaseObject.InsertDBObjects(slis);
       
       
        Map<String,Object>  passengerSLIMapingMap = new Map<String,Object>();
        passengerSLIMapingMap.put('Passenger__c',passengers[0].Id);
        passengerSLIMapingMap.put('Service_Line_Item__c',slis[0].Id);
        for(Integer i = 0 ; i <recordCount; i++)
        {
            sliPassengers.add((ServiceLineItemPassengersMapping__c) TestDataFactory.operationOnObjectRecord(null, 'ServiceLineItemPassengersMapping__c', passengerSLIMapingMap));
        }
        DAL_BaseObject.InsertDBObjects(sliPassengers);
        
       }   
    }
    
    
    static testMethod void GetQuotationLineItemDateTest() {
    	
    	Test.startTest();
    	setupInsertData();
    	List<Id> quotationIds = new List<Id>();
    	Set<Id> setquotationIds = new Set<Id>();
    	Set<Date> quotationDates = new Set<Date>();
        
        Date maxDate = getQuotationLineItemList[0].Line_Item_Date__c;
    	List<String> strquotationIds = new List<Id>();
    	Set<Id> opportunityIds = new Set<Id>();
        List<String> opportunityId = new List<String>();
        opportunityId.add(opportunitys[0].id);
    	opportunityIds.add(opportunitys[0].id);
    	quotationIds.add(Quotations[0].Id);
    	strquotationIds.add(Quotations[0].Id);
    	setquotationIds.add(Quotations[0].Id);
    	List<Id> quotationLineItemids = new List<Id>();
    	List<Id> serviceLineItemIds  = new List<Id>();
        Set<Id> serviceLineItemId = new Set<Id>();
        Set<String> chargeTypes = new Set<String>();
        chargeTypes.add('abc');
        chargeTypes.add('xyz');
    	for(ServiceLineItem__c serv:slis)
    	{
    		serviceLineItemIds.add(serv.Id);
            serviceLineItemId.add(serv.Id);
    	}
    	for(QuotationLineItem__c qli:getQuotationLineItemList)
    	{
    		quotationLineItemids.add(qli.Id);
    		quotationDates.add(qli.Line_Item_Date__c);
    	}
    	DAL_Quotations.getAllQuotations(quotationIds);
        DAL_Quotations.getQuotationForWetuById(Quotations[0].Id);
    	DAL_Quotations.getAllQuotationsById(Quotations[0].Id);
    	DAL_Quotations.getAllQuotationsLineItems(strquotationIds);
    	DAL_Quotations.getAllQuotationsLineItems(setquotationIds);
    	DAL_Quotations.getAllQuotationsLineItemsByDate(quotationDates, setquotationIds);
    	DAL_Quotations.getAllbyOpportunityIds(opportunityIds);
    	DAL_Quotations.getAllServiceLineItems(quotationLineItemids);
        DAL_Quotations.getAllServiceLineItemsForPassengerInsurance(quotationLineItemids);
    	DAL_Quotations.getExistingServiceLineItemCount(new list<Date>(quotationDates)[0], quotationLineItemids[0]);
    	DAL_Quotations.getAllQuotationsLineItemsMaxEndDate(Quotations[0].Id);
        DAL_Quotations.getQuotationLineItemByMaxEndDates(setquotationIds,quotationDates);
        DAL_Quotations.getAllQuotationsLineItemsMaxEndDates(setquotationIds);
        DAL_Quotations.getQuotationLineItemByMaxEndDate(Quotations[0].Id,maxDate);
    	DAL_Quotations.getAllServiceLineItemsByIds(serviceLineItemIds);
        DAL_Quotations.getServiceChargeTypeForPassengerInsurance(serviceLineItemId,chargeTypes);
        DAL_Quotations.getQuotationExtraCostingServiceLineItem(quotationIds);
        DAL_Quotations.getPassengerForServiceLineItems(serviceLineItemId);
        DAL_Quotations.getOldConfirmedQuotationForSameOpportunity(opportunityIds,quotationIds);
        DAL_Quotations.getQuotationsFromOppId_DynamiCSOQL(opportunityId);
        DAL_Quotations.getQuotations_DynamiCSOQL(opportunityId);
    	Test.stopTest();
    }
    
    
    static testMethod void GetQuotationLineItemDateTest2() {
    	
    	Test.startTest();
    	setupInsertData2();
    	List<String> opportunityId = new List<String>();
        opportunityId.add(opportunitys[0].id);
        List<Quotations__c> quotations = DAL_Quotations.getQuotationsFromOppId_DynamiCSOQL(opportunityId);
        List<Quotations__c> quotationsList = DAL_Quotations.getQuotations_DynamiCSOQL(opportunityId);
    	Test.stopTest();
       
        
    }
}
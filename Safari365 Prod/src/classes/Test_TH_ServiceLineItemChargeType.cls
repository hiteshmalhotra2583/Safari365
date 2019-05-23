@isTest
private class Test_TH_ServiceLineItemChargeType {

    static List<ServiceLineItem__c> ServiceLineItems = new List<ServiceLineItem__c>();
    static List<Service_Line_Item_ChargeType__c> ServiceLineItemsChargeTypes= new List<Service_Line_Item_ChargeType__c>();
    static List<QuotationLineItem__c> QuotationLineItems = new List<QuotationLineItem__c>();
    static List<Quotations__c> Quotations = new List<Quotations__c>();
   	static List<Opportunity> opportunitys = new List<Opportunity>();
   	static List<Passenger__c> passengers = new List<Passenger__c>();
   	static List<PassengerQuotationMapping__c> selectedPassengers = new List<PassengerQuotationMapping__c>();
   	static List<ExchangeRates__c> exchangeRates = new List<ExchangeRates__c>();
   	static List<Account> accounts = new List<Account>();
   	public static Integer count = 1;
    
    static void setupInsertData(){
        
       User us = TestDataFactory.createUser(true, '', true);
       System.runAs(us)
       {
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
           Date arrivaleDate = Date.newInstance(2008,1,1);
           Date closeDate = Date.newInstance(2008,1,1); 
           for(Account acc:accounts)
           {
               accountOpportunityMap.put('AccountId', acc.ID);
               accountOpportunityMap.put('StageName', 'Money in the Bank');
               accountOpportunityMap.put('CloseDate',closeDate);
               accountOpportunityMap.put('Arrival_Date__c',arrivaleDate);
               accountOpportunityMap.put('TravelEndDate__c',system.today().addDays(5));
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
               opportunitys.add((Opportunity) TestDataFactory.operationOnObjectRecord(null, 'Opportunity', accountOpportunityMap));
           }
           DAL_BaseObject.InsertDBObjects(opportunitys);
           
           Map<String,Object>  opportunityQuotationMap = new Map<String,Object>();
           Map<String,Object>  opportunityPassengerMap = new Map<String,Object>();
           for(Opportunity opp:opportunitys)
           {
               opportunityPassengerMap.put('Opportunity__c', opp.ID);
               opportunityQuotationMap.put('Opportunity__c', opp.ID);
               opportunityQuotationMap.put('TravelStartDate__c',system.today());
               opportunityQuotationMap.put('TravelEndDate__c',system.today().addDays(2));
           }
           
           for(Integer i = 0 ; i <count; i++)
           {
            passengers.add((Passenger__c) TestDataFactory.operationOnObjectRecord(null, DAL_Passenger.OBJECT_NAME, opportunityPassengerMap));
           }
           
           DAL_BaseObject.InsertDBObjects(passengers);
           
           
           for(Integer i = 0 ; i <count; i++)
           {
               Quotations.add((Quotations__c) TestDataFactory.operationOnObjectRecord(null, 'Quotations__c', opportunityQuotationMap));
           }
           
           DAL_BaseObject.InsertDBObjects(Quotations);
           
           Map<String,Object>  passengerQuotationMap = new Map<String,Object>();
           passengerQuotationMap.put('Passenger__c',passengers[0].Id);
           passengerQuotationMap.put('Quotation__c',Quotations[0].Id);
           
           
           for(Integer i = 0 ; i <count; i++)
           {
               selectedPassengers.add((PassengerQuotationMapping__c) TestDataFactory.operationOnObjectRecord(null, 'PassengerQuotationMapping__c', passengerQuotationMap));
           }
           DAL_BaseObject.InsertDBObjects(selectedPassengers);
           
           Set<Id> quotationIds = new Set<Id>();
  		   for(Quotations__c quotat:Quotations)
  		   {
  		  	 quotationIds.add(quotat.id);
  		   }
  		   List<QuotationLineItem__c> quotationLineItems = DAL_Quotations.getAllQuotationsLineItems(quotationIds);
           
           Map<String,Object>  serviceLineQuotationMap = new Map<String,Object>();
           for(QuotationLineItem__c qli:quotationLineItems)
           {
          	 serviceLineQuotationMap.put('QuotationLine__c',qli.Id);
          	 serviceLineQuotationMap.put('Service_Status__c','Confirmed');
           }
           for(Integer i = 0 ; i <count; i++)
           {
               ServiceLineItems.add((ServiceLineItem__c) TestDataFactory.operationOnObjectRecord(null, 'ServiceLineItem__c', serviceLineQuotationMap));
           }
  		    DAL_BaseObject.InsertDBObjects(ServiceLineItems);
  		    
  		   Map<String,Object>  serviceLineChargeTypeMap = new Map<String,Object>();
  		   for(ServiceLineItem__c sli:ServiceLineItems)
           {
          	 serviceLineChargeTypeMap.put('Service_Line_Item__c',sli.Id);
           }
  		   for(Integer i = 0 ; i <count; i++)
           {
               ServiceLineItemsChargeTypes.add((Service_Line_Item_ChargeType__c) TestDataFactory.operationOnObjectRecord(null, 'Service_Line_Item_ChargeType__c', serviceLineChargeTypeMap));
           }
  		    DAL_BaseObject.InsertDBObjects(ServiceLineItemsChargeTypes); 
    	}
    }
    
    @isTest  
  	static void testBeforeUpdatServiceLineItem() {
  		
  		setupInsertData();
  		Test.startTest();
  		   List<Service_Line_Item_ChargeType__c> toUpdateRecords = new List<Service_Line_Item_ChargeType__c>();
  		   for(Service_Line_Item_ChargeType__c sliChargeTypes:ServiceLineItemsChargeTypes)
  	        {
  	        	sliChargeTypes.Overide_Markup__c = true;
  	        	sliChargeTypes.Markup__c=2.2;
  	        	toUpdateRecords.add(sliChargeTypes);
  	        }
  	        
  	        if(!toUpdateRecords.isEmpty())
  	        update toUpdateRecords;
  		Test.stopTest();    
        
  	}
    
}
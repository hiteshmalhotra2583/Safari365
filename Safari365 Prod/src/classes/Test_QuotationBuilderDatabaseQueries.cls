@isTest
private class Test_QuotationBuilderDatabaseQueries {
  
    static List<Opportunity> opportunitys = new List<Opportunity>();
    static List<Account> accounts = new List<Account>();
    static List<Passenger__c> passengers = new List<Passenger__c>();
    static List<Quotations__c> Quotations = new List<Quotations__c>();
    static QuotationBuilderDatabaseQueries dbQueries = new QuotationBuilderDatabaseQueries();
    static List<Opt__c>  opts = new List<Opt__c>();
    static List<SRV__c>  srvs = new List<SRV__c>();
    static List<OPT__c>  db4opts = new List<OPT__c>();
    static List<DB4__c>  db4s= new List<DB4__c>();
    static List<CRM__c>  crms = new List<CRM__c>();
    static List<SOD__c>  sods= new List<SOD__c>();
    static List<OSR__c>  osrs= new List<OSR__c>();
    
    static List<PassengerQuotationMapping__c> passengerQuotations = new List<PassengerQuotationMapping__c>();
    static List<ServiceLineItem__c> slis = new List<ServiceLineItem__c>();
    static List<Service_Line_Item_ChargeType__c> chargeTypes = new List<Service_Line_Item_ChargeType__c>();
    static List<ServiceLineItemPassengersMapping__c> sliPassengers = new List<ServiceLineItemPassengersMapping__c>();
    static Integer recordCount = 1;
    static List<QuotationLineItem__c> getQuotationLineItemList = null;
    static List<QuotationLineItem__c> QuotationsLineItem = new List<QuotationLineItem__c>();
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
            accountMap.put('PassengerType__c' ,'Adult');
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
           
         Map<String,Object>  QuotationQuotationLinitemMap = new Map<String,Object>();
        for(Integer i = 0 ; i <recordCount; i++)
        {
            QuotationQuotationLinitemMap.put('Name','QLI-'+i);
            QuotationQuotationLinitemMap.put('Quotation__c',Quotations[i].Id);
            QuotationQuotationLinitemMap.put('Line_Item_Date__c',Date.today());
            
            QuotationsLineItem.add((QuotationLineItem__c) TestDataFactory.operationOnObjectRecord(null, 'QuotationLineItem__c',QuotationQuotationLinitemMap ));
        }
        DAL_BaseObject.InsertDBObjects(QuotationsLineItem);
        
           
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
       Map<String, Object> carhireTypeServiceTypeMap =new Map<String, Object>();
       for(QuotationLineItem__c quoli: getQuotationLineItemList)
       {
       	carhireTypeServiceTypeMap.put('QuotationLine__c',quoli.Id);
       	carhireTypeServiceTypeMap.put('Service_Type__c','Car Hire');
       	
       }
       
       for(Integer i = 0 ; i <recordCount; i++)
        {
            slis.add((ServiceLineItem__c) TestDataFactory.operationOnObjectRecord(null, 'ServiceLineItem__c', quoationServiceLineMap));
        }
        
        for(Integer i = 0 ; i <recordCount; i++)
        {
            slis.add((ServiceLineItem__c) TestDataFactory.operationOnObjectRecord(null, 'ServiceLineItem__c', carhireTypeServiceTypeMap));
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
        
       
       Map<String, Object> serviceChargeTypeMap =new Map<String, Object>();
       for(ServiceLineItem__c sli: slis)
       {
           serviceChargeTypeMap.put('Service_Line_Item__c',sli.Id);
           serviceChargeTypeMap.put('Selected_Passenger__c',passengers[0].Id);
           serviceChargeTypeMap.put('Nett_Cost__c',10);
           serviceChargeTypeMap.put('Overide_Markup__c',true);
           serviceChargeTypeMap.put('Markup__c',1);
       }
         
       for(Integer i = 0 ; i <recordCount; i++)
        {
            chargeTypes.add((Service_Line_Item_ChargeType__c) TestDataFactory.operationOnObjectRecord(null, 'Service_Line_Item_ChargeType__c', serviceChargeTypeMap));
        }
           
        insert chargeTypes;
           
        for(Integer i = 0 ; i <recordCount; i++)
        {
            srvs.add((SRV__c) TestDataFactory.operationOnObjectRecord(null, 'SRV__c', null));
        }
         insert srvs;
         
         Map<String,Object>  srvOptMap = new Map<String,Object>();
         for(SRV__c srv: srvs)
         {
         	srvOptMap.put('Service__c',srvs[0].CODE__c);
         }
        
        for(Integer i = 0 ; i <recordCount; i++)
        {
            opts.add((Opt__c) TestDataFactory.operationOnObjectRecord(null, DAL_OPT.OBJECT_NAME, srvOptMap));
        }
         insert opts;
        
           Map<String,Object> keyValueMap = new Map<String,Object>();
           for(Integer i = 0 ; i <recordCount; i++)
           {
               keyValueMap.put('Opt_Id__c', opts[i].OPT_ID__c);
               osrs.add((OSR__c) TestDataFactory.operationOnObjectRecord(null, DAL_OSR.OBJECT_NAME, keyValueMap));
           }
           insert osrs;
       }   
    }
   /* 
    static void setupRoomConfigurationData(){
        
        for(Integer i = 0 ; i <recordcount; i++)
        {
            crms.add((CRM__c) TestDataFactory.operationOnObjectRecord(null, 'CRM__c', null));
        }
        insert crms;
        system.debug('crms'+crms);
        
        Map<String,Object> keyValueMap = new Map<String,Object>();
        for(CRM__c crm:crms)
        {
            keyValueMap.put('SOD_ID__c', crm.SOD_ID__c);
            keyValueMap.put('SINGLE_AVAIL__c', true);
            keyValueMap.put('TWIN_AVAIL__c', true);
            keyValueMap.put('TRIPLE_AVAIL__c', true);
            keyValueMap.put('QUAD_AVAIL__c', true);
            keyValueMap.put('OTHER_AVAIL__c', true);
            
        }
    
        for(Integer i = 0 ; i <recordCount; i++)
        sods.add((SOD__c) TestDataFactory.operationOnObjectRecord(null, DAL_SOD.OBJECT_NAME, keyValueMap));
        insert sods;
        
    }
    
     static void setupDB4InsertData(){
        
        for(Integer i = 0 ; i <recordCount; i++)
        {
            db4s.add((DB4__c) TestDataFactory.operationOnObjectRecord(null, 'DB4__c', null));
        }
        insert db4s;
        
        Map<String,Object> db4keyValueMap = new Map<String,Object>();
        for(DB4__c db4:db4s)
        {
            db4keyValueMap.put('ANALYSIS4__c', db4.CODE__c);
        }
    
        for(Integer i = 0 ; i <recordCount; i++)
        db4opts.add((Opt__c) TestDataFactory.operationOnObjectRecord(null, 'Opt__c', db4keyValueMap));
        insert db4opts;
        
    }
    
    static testMethod void getCurrencyCodesTest() {
    	setupDB4InsertData();
    	Test.startTest();
    	 List<String> options = dbQueries.GetCurrencyCodes();
    	 Test.stopTest();
        
        
    }
    static testMethod void getNumberOfNightsTest() {
        
        setupInsertData(); 
       String quotationsId = Quotations[0].Id;
       Test.startTest();
       List<QuotationLineItem__c> quotationLineItemList =  dbQueries.GetQuotationLineItemList(quotationsId);
       List<String> numberOfNights =  dbQueries.GetNumberOfNights(quotationsId,quotationLineItemList[0].Id);
        Test.stopTest();
       
        
    }

    static testMethod void getNumberOfDaysTest() {
        
         setupInsertData(); 
       String quotationsId = Quotations[0].Id;
        Test.startTest();
       List<QuotationLineItem__c> quotationLineItemList =  dbQueries.GetQuotationLineItemList(quotationsId);
       List<String> numberOfdays =  dbQueries.GetNumberOfDays(quotationsId,quotationLineItemList[0].Id);
        Test.stopTest();
    }
    
    static testMethod void getQuotationLineItemsTest() {
       
       setupInsertData(); 
       String quotationsId = Quotations[0].Id;
       String serviceLineItemId = slis[0].Id;
       Test.startTest();
       List<QuotationLineItem__c> quotationLineItems =  dbQueries.GetQuotationLineItems(quotationsId);
       List<QuotationLineItem__c> quotationLineItemList =  dbQueries.GetQuotationLineItemList(quotationsId);
       List<Passenger__c>  passengers = dbQueries.GetQuotationPassengers(quotationsId);
       List<Passenger__c> selectedPassengers = dbQueries.GetServiceLineItemPassengers(serviceLineItemId);
        Test.stopTest();
        
    }
    
    static testMethod void getServiceTypesTest()  
    {
    	 setupInsertData(); 
    	 Test.startTest();
    	 List<String> getServiceTypes = dbQueries.GetServiceTypes();
    	 List<String> options =  dbQueries.GetChargeTypes();
    	  Test.stopTest();
    }
    
    static testMethod void getServiceTypeForSupplierTest()  
    {
    	setupInsertData(); 
    	 Test.startTest();
    	String suppliedId = opts[0].CRM_Lookup__c;
    	List<String> supplierTypes = dbQueries.GetServiceTypeForSupplier(suppliedId);
    	 Test.stopTest();
    }
    
    static testMethod void getLocationForSupplierTest()  
    {
    	setupInsertData(); 
    	Test.startTest();
    	String suppliedId = opts[0].CRM_Lookup__c;
    	List<String> locationNames = dbQueries.GetLocationForSupplier(suppliedId,'');
    	 Test.stopTest();
    	 
    }
    
    static testMethod void getLocationsTest()  
    {
    	setupInsertData(); 
    	Test.startTest();
    	String suppliedName = opts[0].SRV_Name__c;
    	List<String> locationNames = dbQueries.GetLocations(suppliedName);
    	Test.stopTest();
    } 
    
    static testMethod void getSupplierNamesTest()  
    {
    	setupInsertData();
    	Test.startTest();
    	string selectedLocation =opts[0].LOC_Name__c;
    	string selectedServiceType=opts[0].SRV_Name__c;
    	Boolean preferredSupplier= true;
    	String selectedSupplierName = opts[0].CRM_Lookup__c;
    	
    	List<String> options =  dbQueries.GetSupplierNames(selectedLocation,selectedServiceType,preferredSupplier);
    	List<String> dbQuery = dbQueries.GetSuppplierNameLookupQuery(selectedLocation,selectedServiceType,preferredSupplier);
    	List<String> serviceDetails =dbQueries.GetServiceDetails(selectedSupplierName,selectedServiceType,selectedLocation);
    	Test.stopTest();
    } 
    
    
    
    static testMethod void getRoomConfigurationTest()  
    {
    	setupRoomConfigurationData();
    	Test.startTest();
    	String suppliedId = sods[0].CRM_Lookup__c;
    	system.debug('suppliedId'+suppliedId);
    	List<String> options = dbQueries.GetRoomConfiguration(suppliedId,'');
    	Test.stopTest();	
    	
    }
    
    static testMethod void getServiceStatusTest()  
    {
    	Test.startTest();
    	 List<String> options =dbQueries.GetServiceStatus();
    	  Test.stopTest();
    }
    
    static testMethod void RemoveServiceLineItemsTest()  
    {
    	setupInsertData();
    	Test.startTest();
    	dbQueries.RemoveServiceLineItems(slis[0].Id,'1');
    	 Test.stopTest();
    }
    
     static testMethod void loadPassengersForServiceLineItemTest()  
    {
    	setupInsertData();
    	Test.startTest();
    	dbQueries.loadPassengersForServiceLineItem(slis[0].Id);
    	 Test.stopTest();
    }
    
    static testMethod void loadServiceLineItemTest()  
    {
    	setupInsertData();
    	 Test.startTest();
    	dbQueries.loadServiceLineItem(slis[0].Id);
    	 Test.stopTest();
    }
    
    
    static testMethod void GetResidenceCountryFromQuotationIdTest()  
    {
    	setupInsertData();
    	 Test.startTest();
    	dbQueries.GetResidenceCountryFromQuotationId(Quotations[0].Id);
    	Test.stopTest();
    }
    
    
    static testMethod void GetCountryMarkupTest()  
    {
    	Test.startTest();
    	dbQueries.GetCountryMarkup('South Africa');
    	Test.stopTest();
    }
    
    static testMethod void GetServiceTypeMarkupTest()  
    {
    	Test.startTest();
    	dbQueries.GetServiceTypeMarkup('Activity');
    	Test.stopTest();
    }
    
    static testMethod void GetServiceLineItemRelatedToQuotationsTest()  
    {
    	setupInsertData();
    	Test.startTest();
    	dbQueries.GetServiceLineItemRelatedToQuotations(getQuotationLineItemList[0].id);
    	Test.stopTest();
    }
    
    static testMethod void GetChargeTypeRelatedToServiceLineItemTest()  
    {
    	setupInsertData();
    	Test.startTest();
    	dbQueries.GetChargeTypeRelatedToServiceLineItem(slis[0].Id);
    	Test.stopTest();
    }
    
     static testMethod void GetServiceLineItemForWetuCarHireTest()  
    {
    	setupInsertData();
    	Test.startTest();
    	dbQueries.GetServiceLineItemForWetuCarHire(Quotations[0].Id);
    	Test.stopTest();
    }
    
    static testMethod void GetSupplierMarkupTest()  
    {
    	setupInsertData();
    	Test.startTest();
    	dbQueries.GetSupplierMarkup('');
    	Test.stopTest();
    }
    
    static testMethod void GetPaymentDiscountsForQuotationTest()  
    {
    	Test.startTest();
    	dbQueries.GetPaymentDiscountsForQuotation();
    	dbQueries.GetDueDateDifferenceForQuotation();
    	Test.stopTest();
    }
    
    static testMethod void getRelatedQuotationServiceLineItemsTest()  
    {
    	Test.startTest();
    	setupInsertData();
        List<Id> ids = new List<Id>();
    	for(QuotationLineItem__c quotationLineItemLis:getQuotationLineItemList)
    	{
    		ids.add(quotationLineItemLis.id);
    	}
    	dbQueries.getRelatedQuotationServiceLineItems(ids);
    	Test.stopTest();
    }
    
    static testMethod void GetChargeTypeRelatedToServiceLineItemsTest()  
    {
    	Test.startTest();
    	setupInsertData();

        Set<String> serviceLineItemIds = new Set<String>();
    	for(ServiceLineItem__c sl:slis)
    	{
    	serviceLineItemIds.add(sl.id);
    	}
    	
    	dbQueries.GetChargeTypeRelatedToServiceLineItems(serviceLineItemIds);
    	Test.stopTest();
    }
    
    static testMethod void updateChargeTypesTest() {
         Test.startTest();
        setupInsertData();
        String objectToUpdate = '[{"sobjectType":"ChargeTypeUpdate","Status":"Confirmed","ClientNotes":"test","ServiceLineItemId":"'+slis[0].Id+'","ChargeTypeId":null,"NettCost":null,"Markup":null},{"sobjectType":"ChargeTypeUpdate","NettCost":"5001","Markup":28,"ChargeTypeId":"'+chargeTypes[0].Id+'","Status":null,"ClientNotes":null,"ServiceLineItemId":null}]';
    	QuotationLineItemsController.updateChargeTypes(objectToUpdate);
    	Test.stopTest();
    }
	
    static testMethod void deleteSelectedItemsTest() {
         Test.startTest();
        setupInsertData();
        String[] itemsToDelete= new String[]{Quotations[0].Id};

    	QuotationLineItemsController.deleteSelectedItems(itemsToDelete);
    	Test.stopTest();
    }
    
    static testMethod void deleteSelectedItemsTest1() {
         Test.startTest();
        setupInsertData();
        String[] itemsToDelete= new String[]{slis[0].Id};
    	QuotationLineItemsController.deleteSelectedItems(itemsToDelete);
    	Test.stopTest();
    }
    
    static testMethod void deleteSelectedItemsTest2() {
         Test.startTest();
        setupInsertData();
        String[] itemsToDelete= new String[]{chargeTypes[0].Id};
    	QuotationLineItemsController.deleteSelectedItems(itemsToDelete);
    	Test.stopTest();
    }*/
    static testMethod void AllMethodTest()  
    {
    	setupInsertData();
    	Test.startTest();
        List<Id> ids = new List<Id>();
    	for(QuotationLineItem__c quotationLineItemLis:getQuotationLineItemList)
    	{
    		ids.add(quotationLineItemLis.id);
    	}
        Set<String> serviceLineItemIds = new Set<String>();
    	for(ServiceLineItem__c sl:slis)
    	{
    	serviceLineItemIds.add(sl.id);
    	}
        String serviceLineItemId= slis[0].Id;
        Set<String> opportunitysIds = new Set<String>();
    	for(opportunity opp:opportunitys)
    	{
    	opportunitysIds.add(opp.id);
    	}
        Set<String> passengerIds = new Set<String>();
    	for(Passenger__c pass:passengers)
    	{
    		passengerIds.add(pass.id);
    	}
        
       /* dbQueries.getQuotationStageByLineItemId(ids[0]);
        dbQueries.getQuotationStage(Quotations[0].Id);
        dbQueries.getPageDefaultOpenSetting();
        dbQueries.getCrmIdByCode('123');
        dbQueries.DeleteServiceLineChargeType('a1H0E000000FZqLUAW');
        dbQueries.DeleteServiceLineItems(serviceLineItemIds);
        dbQueries.GetCrmCodeToServiceLineItemMapping(ids[0]);
        QuotationBuilderDatabaseQueries.allServiceLineItemRelatedToOpportunityIds(opportunitysIds);
        QuotationBuilderDatabaseQueries.allServiceLineItemRelatedToOpportunity(opportunitysIds);
        dbQueries.GetServiceLineItemForWetu(Quotations[0].Id);
        dbQueries.getQuotationForPricingSummary(Quotations[0].Id);
        dbQueries.GetServiceLineItemsPassengers(serviceLineItemIds);
        dbQueries.DeleteServiceLineItem(serviceLineItemId);
        dbQueries.GetServiceDetailsWithSupplierId('Cape Town','Accommodation','a1V0E0000066mwUUAQ');
        dbQueries.validateDurationIsValid(Date.today(), 1, Quotations[0].Id, '123');
        LegDetail lg= new LegDetail();
        dbQueries.GetServiceLineItemForWetuLegDetail(Quotations[0].Id,lg);
        dbQueries.getTotalPricePerPassengers(serviceLineItemIds, passengerIds,'USD');*/
        
        system.debug('@@@@@'+dbQueries.SaveServiceLineItem('S001','t1','USA','Sname','SUP01','Detail',null,'notes','r01','snotes','Confirmed',String.valueOf(Date.today()),false,new String[0],String.valueOf(Date.today()),'2',Quotations[0].Id,opts[0],passengers,null,null,null,null,null,null,null,null,null,null,null,null));

       Test.stopTest();	
    	
    }
    
}
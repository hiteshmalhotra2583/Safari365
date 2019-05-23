@isTest
private class Test_QuotationServiceHelper {

   static List<Opportunity> opportunitys = new List<Opportunity>();
   static List<Account> accounts = new List<Account>();
   static List<Passenger__c> passengers = new List<Passenger__c>();
   static List<Quotations__c> Quotations = new List<Quotations__c>();
   static List<PassengerQuotationMapping__c> passengerQuotations = new List<PassengerQuotationMapping__c>();
   static List<ServiceLineItem__c> slis = new List<ServiceLineItem__c>();
   static List<ServiceLineItemPassengersMapping__c> sliPassengers = new List<ServiceLineItemPassengersMapping__c>();
   static Integer recordCount = 1;
   static Integer count =5;
   static List<QuotationLineItem__c> getQuotationLineItemList;
   static QuotationBuilderDatabaseQueries dbQueries = new QuotationBuilderDatabaseQueries();
   static List<ExchangeRates__c> exchangeRates = new List<ExchangeRates__c>();
   static List<Opt__c>  opts = new List<Opt__c>();
   @testSetup static void setupInsertData()
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
       
       /*=============================================================================================*/   
          
        Map<String,Object> optkeyValueMap1 = new Map<String,Object>();
        optkeyValueMap1.put('Service__c','AC');
        optkeyValueMap1.put('AC__c','Y');
        optkeyValueMap1.put('CHGEX1__c','0');
        optkeyValueMap1.put('CHGEX2__c','G');
        optkeyValueMap1.put('CHGEX3__c','P');
        optkeyValueMap1.put('CHGEX4__c','2');
        optkeyValueMap1.put('CHGEX5__c','G');
        optkeyValueMap1.put('EX1__c','Conservation Levy');
        optkeyValueMap1.put('EX2__c','PG TIM Vehicle Fee');
        optkeyValueMap1.put('EX3__c','Per Person Extra');
        optkeyValueMap1.put('EX4__c','Per Room Extra');
        optkeyValueMap1.put('EX5__c','Per Group Extra');
        optkeyValueMap1.put('ANALYSIS1__c','PF');
        optkeyValueMap1.put('ANALYSIS2__c','PP');
        optkeyValueMap1.put('ANALYSIS3__c','LA');
        optkeyValueMap1.put('ANALYSIS4__c','ZA');
        optkeyValueMap1.put('SupplierMarkup__c',0.00);
        optkeyValueMap1.put('Description__c','Luxury Safari Tent');
           
        /*optkeyValueMap1.put('CRM_Lookup__c',crms[0].Id);
        optkeyValueMap1.put('SRV_Lookup__c',srvs[0].Id);
        optkeyValueMap1.put('LCL_Lookup__c',lcls[0].Id);
        optkeyValueMap1.put('SOD_Lookup__c',sods[0].Id);*/
        
        optkeyValueMap1.put('FCU__c','Person');
        optkeyValueMap1.put('MPFCU__c',1);
        
    	for(Integer i = 0 ; i <count; i++)
        {
            opts.add((OPT__c) TestDataFactory.operationOnObjectRecord(null, DAL_OPT.OBJECT_NAME, optkeyValueMap1));
        }
        insert opts;  
           
        Map<String,Object> serviceLineItemkeyValueMap1 = new Map<String,Object>();
        serviceLineItemkeyValueMap1.put('Service_Detail__c','Luxury Safari Tent');
        serviceLineItemkeyValueMap1.put('QuotationLine__c',getQuotationLineItemList[0].Id);
        serviceLineItemkeyValueMap1.put('Service_Status__c','Not Booked');
        serviceLineItemkeyValueMap1.put('Provisional_Booking_Expiry_Date__c',system.today());
        serviceLineItemkeyValueMap1.put('Override_details__c',false);
        serviceLineItemkeyValueMap1.put('Room_Configuration__c','TWIN AVAIL');
        serviceLineItemkeyValueMap1.put('Service_Type__c','Accommodation');
        serviceLineItemkeyValueMap1.put('ServiceLocation__c','Timbavati Game Reserve');
        serviceLineItemkeyValueMap1.put('SupplierName__c','Simbavati Hilltop Lodge');
        serviceLineItemkeyValueMap1.put('Selected_OPT_Code__c',opts[0].Code__c);
        serviceLineItemkeyValueMap1.put('Service_Date__c',System.today());
        serviceLineItemkeyValueMap1.put('Wetu_Start_Location__c','a');
        serviceLineItemkeyValueMap1.put('Wetu_End_Location__c','b');
        serviceLineItemkeyValueMap1.put('Basis__c','x');
        serviceLineItemkeyValueMap1.put('Reservation_Number__c','a');
        serviceLineItemkeyValueMap1.put('Service_Duration__c',1);
        serviceLineItemkeyValueMap1.put('ClientNotes__c',' ');
        serviceLineItemkeyValueMap1.put('Crm_Code__c','SIM005');
           
        for(Integer i = 0 ; i <count; i++)
        {
            slis.add((ServiceLineItem__c) TestDataFactory.operationOnObjectRecord(null, QuotationBuilderDatabaseQueries.SERVICELINEITEM_OBJECT_NAME, serviceLineItemkeyValueMap1));
        }
        insert slis;
       
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
     
    @isTest static void allMethodTest(){
         Quotations__c quotation = [SELECT Id FROM Quotations__c LIMIT 1];
         List<ServiceLineItem__c> serviceLineItemList = [SELECT Id,Service_Date__c,SupplierName__c FROM ServiceLineItem__c];
        
        
        Test.startTest();
        	List<LegDetail> legDetail = QuotationServiceHelper.GetLegDetails(quotation);
        	QuotationServiceHelper.FindServiceItemsForLeg(legDetail[0],serviceLineItemList);
        	QuotationServiceHelper.getMonthName(12);
         Test.stopTest();
     } 

}
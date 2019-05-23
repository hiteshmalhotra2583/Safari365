@isTest
private class Test_WetuService {

    public static List<OSR__c> osrs = new List<OSR__c>();
    public static List<LCL__c> lcls = new List<LCL__c>();
    public static List<SRV__c> srvs = new List<SRV__c>();
    public static List<Opt__c>  opts = new List<Opt__c>();
    public static List<OPD__c>  opds = new List<OPD__c>();
    public static List<SOD__c> sods = new List<SOD__c>();
    public static List<CRM__c> crms = new List<CRM__c>();
    public static List<NTS__c>  nts = new List<NTS__c>();
    public static List<NCT__c>  ncts= new List<NCT__c>();
    
    public static List<Account>  accounts = new List<Account>();
    public static List<Opportunity> Opportunities = new List<Opportunity>();
    public static List<Quotations__c> quotations = new List<Quotations__c>();
    public static List<QuotationLineItem__c> QuotationLineItems = new List<QuotationLineItem__c>();
    public static List<ServiceLineItem__c> serviceLineItems = new List<ServiceLineItem__c>();
    public static List<ServiceLineItemPassengersMapping__c> serviceLineItemsPassengers = new List<ServiceLineItemPassengersMapping__c>();
    public static List<PassengerQuotationMapping__c> quotationPassengers = new List<PassengerQuotationMapping__c>();
    
    public static List<Passenger__c>  adultPassengers = new List<Passenger__c>();
    public static List<Passenger__c>  kidsPassengers = new List<Passenger__c>();
    public static List<Passenger__c>  infantPassengers = new List<Passenger__c>();
    public static List<ExchangeRates__c> exchangeRates = new List<ExchangeRates__c>();
    
    public static Integer count =1;
    public static String OSR_PRICE_CODE_EB='EB';
    public static String OSR_PRICE_CODE_ST='ST';
    public static String OSR_PRICE_CODE_S1='S1';
    public static String OPD_RATETYPE_FC='FC';
    public static Integer osrcount =3;
    public static Integer selectedPassengerCount =3;
    public static User us  =null;
    
    @testSetup static void setupTestData()
    {
       us = TestDataFactory.createUser(true, '', true);
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
            Date arrivaleDate = Date.newInstance(2008,1,1);
            Date closeDate = Date.newInstance(2008,1,1); 
            for(Account acc:accounts)
            {
                accountOpportunityMap.put('AccountId', acc.ID);
                accountOpportunityMap.put('StageName', 'Money in the Bank');
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
                Opportunities.add((Opportunity) TestDataFactory.operationOnObjectRecord(null, 'Opportunity', accountOpportunityMap));
            }
            DAL_BaseObject.InsertDBObjects(Opportunities);
            
            Map<String,Object>  opportunityQuotationMap = new Map<String,Object>();
            for(Opportunity opp:Opportunities)
            {
                opportunityQuotationMap.put('Opportunity__c', opp.ID);
                opportunityQuotationMap.put('TravelStartDate__c',system.today());
                opportunityQuotationMap.put('TravelEndDate__c',system.today().addDays(5));
                opportunityQuotationMap.put('Quotation_Stage__c', 'Quoting');
            }
            
            for(Integer i = 0 ; i <count; i++)
            {
                quotations.add((Quotations__c) TestDataFactory.operationOnObjectRecord(null, 'Quotations__c', opportunityQuotationMap));
            }
            DAL_BaseObject.InsertDBObjects(quotations);
    	
            List<String> quotationIds= new List<String>();
            quotationIds.add(quotations[0].Id);                                         
            QuotationLineItems=DAL_Quotations.getAllQuotationsLineItems(quotationIds); 
        
            
            Map<String,Object>  adultPassengerMap = new Map<String,Object>();
            Map<String,Object>  kidPassengerMap = new Map<String,Object>();
            Map<String,Object>  infantPassengerMap = new Map<String,Object>();
            
            adultPassengerMap.put('Given_Age__c', '18');
            kidPassengerMap.put('Given_Age__c', '10');
            infantPassengerMap.put('Given_Age__c', '2');
            
            adultPassengerMap.put('Opportunity__c', Opportunities[0].Id);
            kidPassengerMap.put('Opportunity__c',  Opportunities[0].Id);
            infantPassengerMap.put('Opportunity__c',  Opportunities[0].Id);
            
            adultPassengerMap.put('PassengerType__c', 'Adult');
            kidPassengerMap.put('PassengerType__c',  'Child');
            infantPassengerMap.put('PassengerType__c',  'Infant');
            
            for(Integer i = 0 ; i <count; i++)
            {
                
                adultPassengers.add((Passenger__c) TestDataFactory.operationOnObjectRecord(null, DAL_Passenger.OBJECT_NAME, adultPassengerMap));
            }
            insert adultPassengers;
            
            for(Integer i = 0 ; i <count; i++)
            {
                kidsPassengers.add((Passenger__c) TestDataFactory.operationOnObjectRecord(null, DAL_Passenger.OBJECT_NAME, kidPassengerMap));
            }
            insert kidsPassengers;
            
            
            for(Integer i = 0 ; i <count; i++)
            {
                infantPassengers.add((Passenger__c) TestDataFactory.operationOnObjectRecord(null, DAL_Passenger.OBJECT_NAME, infantPassengerMap));
            }
            insert infantPassengers;
            
            
            Map<String,Object> quotationPassengerkeyValueMap1 = new Map<String,Object>();
            quotationPassengerkeyValueMap1.put('Passenger__c',adultPassengers[0].Id);
            quotationPassengerkeyValueMap1.put('Passenger__c',kidsPassengers[0].Id);
            quotationPassengerkeyValueMap1.put('Passenger__c',infantPassengers[0].Id);
            quotationPassengerkeyValueMap1.put('Quotation__c',quotations[0].id);
            
            quotationPassengers.add((PassengerQuotationMapping__c) TestDataFactory.operationOnObjectRecord(null, 'PassengerQuotationMapping__c',quotationPassengerkeyValueMap1));
            
            insert quotationPassengers;
            
            Map<String,Object> LclkeyValueMap1 = new Map<String,Object>();
            LclkeyValueMap1.put('CODE__c','TIM');
            LclkeyValueMap1.put('DESCR__c','Timbavati Game Reserve');
            
            
            for(Integer i = 0 ; i <1; i++)
            {
                lcls.add((LCL__c) TestDataFactory.operationOnObjectRecord(null, 'LCL__c', LclkeyValueMap1));
            }
            insert lcls;  
            Map<String,Object> CrmkeyValueMap1 = new Map<String,Object>();
            CrmkeyValueMap1.put('NAME__c','Simbavati Hilltop Lodge');
            CrmkeyValueMap1.put('MARKUP__c',0.00);
            CrmkeyValueMap1.put('CODE__c','SIM005');
            CrmkeyValueMap1.put('SOD_ID__c',1);
            
            for(Integer i = 0 ; i <1; i++)
            {
                crms.add((CRM__c) TestDataFactory.operationOnObjectRecord(null, 'CRM__c', CrmkeyValueMap1));
            }
            insert crms;  
            Map<String,Object> SrvkeyValueMap1 = new Map<String,Object>();
            SrvkeyValueMap1.put('NAME__c','Accommodation');
            SrvkeyValueMap1.put('ANALYSIS1__c','ZZ');
            SrvkeyValueMap1.put('ANALYSIS2__c','ZZ');
            SrvkeyValueMap1.put('ANALYSIS3__c','ZZ');
            SrvkeyValueMap1.put('ANALYSIS4__c','ZZ');
            SrvkeyValueMap1.put('ANALYSIS5__c','');
            SrvkeyValueMap1.put('ANALYSIS6__c','');
            SrvkeyValueMap1.put('MESSAGE_CODE__c','AC');
            
            for(Integer i = 0 ; i <1; i++)
            {
                srvs.add((SRV__c) TestDataFactory.operationOnObjectRecord(null, 'SRV__c', SrvkeyValueMap1));
            }
            insert srvs;  
            Map<String,Object> sodkeyValueMap1 = new Map<String,Object>();
            sodkeyValueMap1.put('POLICY_TYPE__c','O');
            sodkeyValueMap1.put('INCLUDE_FRI__c',false);
            sodkeyValueMap1.put('INCLUDE_MON__c',false);
            sodkeyValueMap1.put('INCLUDE_SAT__c',false);
            sodkeyValueMap1.put('INCLUDE_SUN__c',false);
            sodkeyValueMap1.put('INCLUDE_THU__c',false);
            sodkeyValueMap1.put('INCLUDE_TUE__c',false);
            sodkeyValueMap1.put('INCLUDE_WED__c',false);
            sodkeyValueMap1.put('START_MON__c',true);
            sodkeyValueMap1.put('START_TUE__c',true);
            sodkeyValueMap1.put('START_WED__c',true);
            sodkeyValueMap1.put('START_THU__c',true);
            sodkeyValueMap1.put('START_FRI__c',true);
            sodkeyValueMap1.put('START_SAT__c',true);
            sodkeyValueMap1.put('START_SUN__c',true);
            sodkeyValueMap1.put('SINGLE_AVAIL__c',true);
            sodkeyValueMap1.put('TWIN_AVAIL__c',true);
            sodkeyValueMap1.put('TRIPLE_AVAIL__c',true);
            sodkeyValueMap1.put('QUAD_AVAIL__c',true);
            sodkeyValueMap1.put('OTHER_AVAIL__c',true);
            sodkeyValueMap1.put('ADULT_FROM__c',0);
            sodkeyValueMap1.put('ADULT_TO__c',999);
            sodkeyValueMap1.put('CHILD_FROM__c',0);
            sodkeyValueMap1.put('CHILD_TO__c',999);
            sodkeyValueMap1.put('INFANT_FROM__c',0);
            sodkeyValueMap1.put('INFANT_TO__c',999);
            sodkeyValueMap1.put('SOD_ID__c',1);
            sodkeyValueMap1.put('CRM_Lookup__c',crms[0].Id);
            sodkeyValueMap1.put('SINGLE_MAX__c',999);
            sodkeyValueMap1.put('DOUBLE_MAX__c',999);
            sodkeyValueMap1.put('TWIN_MAX__c',999);
            sodkeyValueMap1.put('TRIPLE_MAX__c',999);
              
            for(Integer i = 0 ; i <1; i++)
            {
                sods.add((SOD__c) TestDataFactory.operationOnObjectRecord(null, 'SOD__c', sodkeyValueMap1));
            }
            insert sods;  
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
            optkeyValueMap1.put('CRM_Lookup__c',crms[0].Id);
            optkeyValueMap1.put('SRV_Lookup__c',srvs[0].Id);
            optkeyValueMap1.put('LCL_Lookup__c',lcls[0].Id);
            optkeyValueMap1.put('SOD_Lookup__c',sods[0].Id);
            
            optkeyValueMap1.put('FCU__c','Person');
            optkeyValueMap1.put('MPFCU__c',1);
            
            for(Integer i = 0 ; i <count; i++)
            {
                opts.add((OPT__c) TestDataFactory.operationOnObjectRecord(null, DAL_OPT.OBJECT_NAME, optkeyValueMap1));
            }
            insert opts;
           
            for(Integer i = 0 ; i <count; i++)
            {
                ncts.add((NCT__c) TestDataFactory.operationOnObjectRecord(null, 'NCT__c', null));
            }
            insert ncts;
            
            Map<String,Object> keyValueMapNTS = new Map<String,Object>();
            for(NCT__c nct:ncts)
            {
                keyValueMapNTS.put('CATEGORY__c', nct.NOTECATEGORY__c);
            }
            
            for(Integer i = 0 ; i <=count; i++)
                nts.add((NTS__c) TestDataFactory.operationOnObjectRecord(null, 'NTS__c', keyValueMapNTS));
            insert nts;
            Map<String,Object> OsrkeyValueMap1 = new Map<String,Object>();
            Map<String,Object> OsrkeyValueMap2 = new Map<String,Object>();
            Map<String,Object> OsrkeyValueMap3 = new Map<String,Object>();
            for(OPT__c opt:opts)
            {
                OsrkeyValueMap1.put('PRICE_CODE__c',OSR_PRICE_CODE_EB);
                OsrkeyValueMap2.put('PRICE_CODE__c',OSR_PRICE_CODE_ST);
                OsrkeyValueMap3.put('PRICE_CODE__c',OSR_PRICE_CODE_S1);
                OsrkeyValueMap1.put('Opt_Id__c',opts[0].Opt_Id__c);
                OsrkeyValueMap2.put('Opt_Id__c',opts[0].Opt_Id__c);
                OsrkeyValueMap3.put('Opt_Id__c',opts[0].Opt_Id__c);
                OsrkeyValueMap3.put('STAYPAY_FROM__c',system.today().addDays(-20));
                OsrkeyValueMap3.put('STAYPAY_TO__c',system.today().addDays(20));
                OsrkeyValueMap2.put('STAYPAY_FROM__c',system.today().addDays(-30));
                OsrkeyValueMap2.put('STAYPAY_TO__c',system.today().addDays(30));
                OsrkeyValueMap1.put('STAYPAY_FROM__c',system.today().addDays(-40));
                OsrkeyValueMap1.put('STAYPAY_TO__c',system.today().addDays(40));
                OsrkeyValueMap1.put('STAY1__c',2);
                OsrkeyValueMap1.put('STAY2__c',4);
                OsrkeyValueMap1.put('STAY3__c',6);
                OsrkeyValueMap1.put('STAY4__c',4);
                OsrkeyValueMap1.put('STAY5__c',5);
                OsrkeyValueMap1.put('STAY6__c',2);
                OsrkeyValueMap1.put('STAY7__c',1);
                OsrkeyValueMap1.put('STAY8__c',0);
                OsrkeyValueMap1.put('STAY1__c',1);
                OsrkeyValueMap1.put('DATE_FROM__c',system.today().addDays(-20));
                OsrkeyValueMap1.put('DATE_TO__c',system.today().addDays(20));
                OsrkeyValueMap2.put('DATE_FROM__c',system.today().addDays(-30));
                OsrkeyValueMap2.put('DATE_TO__c',system.today().addDays(30));
                OsrkeyValueMap3.put('DATE_FROM__c',system.today().addDays(-40));
                OsrkeyValueMap3.put('DATE_TO__c',system.today().addDays(40));
                OsrkeyValueMap1.put('MIN_SCU__c',0);
                OsrkeyValueMap1.put('MAX_SCU__c',100);
                OsrkeyValueMap2.put('MIN_SCU__c',0);
                OsrkeyValueMap2.put('MAX_SCU__c',100);
                OsrkeyValueMap3.put('MIN_SCU__c',0);
                OsrkeyValueMap3.put('MAX_SCU__c',100);
                OsrkeyValueMap1.put('APPLY_MON__c', true);
                OsrkeyValueMap1.put('APPLY_TUE__c', true);
                OsrkeyValueMap1.put('APPLY_WED__c', true);
                OsrkeyValueMap1.put('APPLY_THU__c', true);
                OsrkeyValueMap1.put('APPLY_FRI__c', true);
                OsrkeyValueMap1.put('APPLY_SAT__c', true);
                OsrkeyValueMap1.put('APPLY_SUN__c', true); 
                OsrkeyValueMap1.put('SELLBEFORETRAVEL__c',0);
                OsrkeyValueMap1.put('SELL_CURRENCY__c','ZAR');
                OsrkeyValueMap1.put('SALE_FROM__c',system.today().addDays(-100));
                OsrkeyValueMap1.put('SALE_TO__c',system.today().addDays(50));
                OsrkeyValueMap2.put('SELL_CURRENCY__c','ZAR');
                OsrkeyValueMap2.put('SALE_FROM__c',system.today().addDays(-100));
                OsrkeyValueMap2.put('SALE_TO__c',system.today().addDays(50));
                OsrkeyValueMap3.put('SELL_CURRENCY__c','ZAR');
                OsrkeyValueMap3.put('SALE_FROM__c',system.today().addDays(-100));
                OsrkeyValueMap3.put('SALE_TO__c',system.today().addDays(50));
                OsrkeyValueMap1.put('OSR_ID__c',100);
                OsrkeyValueMap2.put('OSR_ID__c',100);
                OsrkeyValueMap3.put('OSR_ID__c',100);
                
            }
            
            
                osrs.add((OSR__c) TestDataFactory.operationOnObjectRecord(null, DAL_OSR.OBJECT_NAME, null));
                osrs.add((OSR__c) TestDataFactory.operationOnObjectRecord(null, DAL_OSR.OBJECT_NAME, null));
                osrs.add((OSR__c) TestDataFactory.operationOnObjectRecord(null, DAL_OSR.OBJECT_NAME, null));
            insert osrs;
            
            
            for(Integer i = 0 ; i < osrs.size(); i++)
            {
                Map<String,Object> opdkeyValueMap1 = new Map<String,Object>();
                opdkeyValueMap1.put('RATE_TYPE__c',OPD_RATETYPE_FC);
                if(i==0)
                {
                    opdkeyValueMap1.put('AGE_CATEGORY__c','AD');
                }
                if(i==1)
                {
                    opdkeyValueMap1.put('AGE_CATEGORY__c','CH');
                }
                if(i==2)
                {
                    opdkeyValueMap1.put('AGE_CATEGORY__c','IN');
                }
                opdkeyValueMap1.put('PRICE_PXB1__c',3628);
                opdkeyValueMap1.put('EX1__c',1);
                opdkeyValueMap1.put('EX2__c',3);
                opdkeyValueMap1.put('EX3__c',3);
                opdkeyValueMap1.put('EX4__c',2);
                opdkeyValueMap1.put('EX5__c',1);
                opdkeyValueMap1.put('OSR_Lookup__c',osrs[0].Id);
                opdkeyValueMap1.put('OSR_ID__c',osrs[0].OSR_ID__c);
                opds.add((OPD__c) TestDataFactory.operationOnObjectRecord(null, DAL_OPD.OBJECT_NAME, opdkeyValueMap1));
            }
           
            insert opds;
            Map<String,Object> serviceLineItemkeyValueMap1 = new Map<String,Object>();
            
            serviceLineItemkeyValueMap1.put('Service_Detail__c','Luxury Safari Tent');
            serviceLineItemkeyValueMap1.put('QuotationLine__c',QuotationLineItems[0].Id);
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
           serviceLineItemkeyValueMap1.put('Wetu_Start_Location_Id__c','28456');
            serviceLineItemkeyValueMap1.put('Wetu_End_Location_Id__c','28456');
            
            for(Integer i = 0 ; i <count; i++)
            {
                //serviceLineItemkeyValueMap1.put('QuotationLine__c',QuotationLineItems[i].Id);
                serviceLineItems.add((ServiceLineItem__c) TestDataFactory.operationOnObjectRecord(null, QuotationBuilderDatabaseQueries.SERVICELINEITEM_OBJECT_NAME, serviceLineItemkeyValueMap1));
            }
            insert serviceLineItems;
       }
    }
    
    
    @isTest static void callWetuServiceTest2() {
        Quotations__c quotation = [SELECT Id FROM Quotations__c limit 1];
        Opportunity opp = [SELECT Id FROM Opportunity limit 1];
        User usr = [SELECT Id FROM User limit 1];
        Test.startTest();
            WetuService.processRequestLtng(quotation.Id);
        	Test.setMock(HttpCalloutMock.class, new Test_MockWetuHttpResponse());
        	WetuService.processRequest( quotation.Id,usr.Id,opp.Id,true);
        Test.stopTest();
    }
    
    @isTest static void createOnlySpecificNullTagTest() {
        
        Test.startTest();
        		WetuServiceHelper.createOnlySpecificNullTag('');
        Test.stopTest();
    }
    
    @isTest static void FindServiceItemsForRouteTest() {
        List<ServiceLineItem__c> serviceLineItemList = [SELECT Id,Basis__c,Reservation_Number__c,Wetu_Start_time__c,Wetu_End_Time__c,Wetu_End_Location_Id__c,Service_Date__c,Service_Duration__c,Service_Type__c,ServiceLocation__c,SupplierName__c,Service_Detail__c,Wetu_Start_Location__c,Wetu_End_Location__c,Wetu_Start_Location_Id__c FROM ServiceLineItem__c];
        Test.startTest();
        	WetuServiceHelper.FindServiceItemsForRoute(serviceLineItemList);
        Test.stopTest();
    }
    
    @isTest static void GetRouteTypeTest() {
        
        Test.startTest();
        	WetuServiceHelper.GetRouteType('Car Rental');
        Test.stopTest();
    }
    
    
    @isTest static void getOPTForItineraryLegDayTest() {
        List<ServiceLineItem__c> serviceLineItemList = [SELECT Id,Basis__c,Reservation_Number__c,Wetu_Start_time__c,Wetu_End_Time__c,Wetu_End_Location_Id__c,Service_Date__c,Service_Duration__c,Service_Type__c,ServiceLocation__c,SupplierName__c,Service_Detail__c,Wetu_Start_Location__c,Wetu_End_Location__c,Wetu_Start_Location_Id__c FROM ServiceLineItem__c];
        Test.startTest();
			WetuServiceHelper.getOPTForItineraryLegDay(serviceLineItemList[0]);
        Test.stopTest();
    }
    
    @isTest static void createCarHireTest() {
        List<ServiceLineItem__c> serviceLineItemList = [SELECT Id,Basis__c,Reservation_Number__c,Wetu_Start_time__c,Wetu_End_Time__c,Wetu_End_Location_Id__c,Service_Date__c,Service_Duration__c,Service_Type__c,ServiceLocation__c,SupplierName__c,Service_Detail__c,Wetu_Start_Location__c,Wetu_End_Location__c,Wetu_Start_Location_Id__c FROM ServiceLineItem__c];
        Test.startTest();
        	WetuServiceHelper.createCarHire(serviceLineItemList[0]);
        Test.stopTest();
    }
    
    @isTest  static void createItineraryRouteTest() {
        Quotations__c quotation = [SELECT Id FROM Quotations__c limit 1];
        Opportunity opp = [SELECT Id FROM Opportunity limit 1];
        User usr = [SELECT Id FROM User limit 1];
        List<ServiceLineItem__c> serviceLineItemList = [SELECT Id,Basis__c,Reservation_Number__c,Wetu_Start_time__c,Wetu_End_Time__c,Wetu_End_Location_Id__c,Service_Date__c,Service_Duration__c,Service_Type__c,ServiceLocation__c,SupplierName__c,Service_Detail__c,Wetu_Start_Location__c,Wetu_End_Location__c,Wetu_Start_Location_Id__c FROM ServiceLineItem__c];
        Test.startTest();
        	//WetuServiceHelper.createItineraryRoute(quotation,opp,serviceLineItemList[0],null,1,1);
        Test.stopTest();
    }
    
    @isTest static void createItineraryLegDayTest() {
        
        Test.startTest();
        
        WetuServiceHelper.createItineraryLegDay();
        
        Test.stopTest();
    }
    
    @isTest static void createItinerayLegDayTagTest() {
        Quotations__c quotation = [SELECT Id FROM Quotations__c limit 1];
        Opportunity opp = [SELECT Id FROM Opportunity limit 1];
        User usr = [SELECT Id FROM User limit 1];
        List<ServiceLineItem__c> serviceLineItemList = [SELECT Id,Basis__c,Reservation_Number__c,Wetu_Start_time__c,Wetu_End_Time__c,Wetu_End_Location_Id__c,Service_Date__c,Service_Duration__c,Service_Type__c,ServiceLocation__c,SupplierName__c,Service_Detail__c,Wetu_Start_Location__c,Wetu_End_Location__c,Wetu_Start_Location_Id__c FROM ServiceLineItem__c];
        Test.startTest();
            LegDayDetail legDayDetail = new LegDayDetail();
            legDayDetail.LegDayServiceLineItem  = serviceLineItemList[0];
            legDayDetail.LegServiceLineItems = new List<ServiceLineItem__c>(); 
            legDayDetail.LegServiceLineItems.add(serviceLineItemList[0]);   
            WetuServiceHelper.createItinerayLegDayTag(new List<LegDayDetail>{legDayDetail});
        Test.stopTest();
    }
    
    static testMethod void WetuResponseHandlerTest() {
        Quotations__c quotation = [SELECT Id FROM Quotations__c limit 1];
        Test.startTest();
        	String request = '<?xml version="1.0" encoding="UTF-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><AuthenticateAndSaveItinerary xmlns="http://wetu.com/Map/ItineraryServiceV7"><itinerary><operator_id>305</operator_id><operator_user_id>490</operator_user_id><operator_identity_id>0</operator_identity_id><operator_theme_id>0</operator_theme_id><type>Personal</type><Days>5</Days><Name>Q-00003703</Name><Language></Language><reference_number>Q-00003703</reference_number><Summary>null</Summary><description>Test ABC</description><client_name>null</client_name><StartDate>2018-02-24T00:00:00Z</StartDate><Legs><ItineraryLeg xsi:type="ItineraryLegByDay"><ItineraryLegId>1</ItineraryLegId><Sequence>0</Sequence><ContentEntityId>15483</ContentEntityId><Nights>3</Nights><Type>Standard</Type><Days><ItineraryLegDay><Day>0</Day></ItineraryLegDay><ItineraryLegDay><Day>1</Day></ItineraryLegDay><ItineraryLegDay><Day>2</Day></ItineraryLegDay></Days></ItineraryLeg></Legs><CarHire></CarHire><RouteHandlingMode>AutoGenerateRoutesFromTravelArrangements</RouteHandlingMode></itinerary><username>marcus@safari365.com</username><password>marcus365</password></AuthenticateAndSaveItinerary></soap:Body></soap:Envelope>';
        	String response = '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><AuthenticateAndSaveItineraryResponse xmlns="http://wetu.com/Map/ItineraryServiceV7"><AuthenticateAndSaveItineraryResult><Name>Q-00003703</Name><Identifier>1efa6c61-a261-4617-90e8-94c1acdddfe2</Identifier><IdentifierKey>6X53RJ</IdentifierKey></AuthenticateAndSaveItineraryResult></AuthenticateAndSaveItineraryResponse></soap:Body></soap:Envelope>';
        	WetuResponseHandler.ProcessResponse(response,request,quotation);
        Test.stopTest();
    }
    
    static testMethod void FindServiceItemsForCarHireTest() {
        Quotations__c quotation = [SELECT Id FROM Quotations__c limit 1];
        Opportunity opp = [SELECT Id FROM Opportunity limit 1];
        NTS__c nts = [SELECT Id FROM NTS__c limit 1];
        User usr = [SELECT Id FROM User limit 1];
        Integer legId=2,dayCounter=3;
        List<ServiceLineItem__c> serviceLineItemList = [SELECT Id,Basis__c,Reservation_Number__c,Wetu_Start_time__c,Wetu_End_Time__c,Wetu_End_Location_Id__c,Service_Date__c,Service_Duration__c,Service_Type__c,ServiceLocation__c,SupplierName__c,Service_Detail__c,Wetu_Start_Location__c,Wetu_End_Location__c,Wetu_Start_Location_Id__c,ClientNotes__c FROM ServiceLineItem__c];
        
        Test.startTest();
        	WetuServiceHelper.createItineraryRoute(quotation,opp,serviceLineItemList[0],nts,legId,dayCounter);
        Test.stopTest();
    }
}
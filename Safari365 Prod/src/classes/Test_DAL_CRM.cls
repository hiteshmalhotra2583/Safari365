@isTest
private class Test_DAL_CRM {

   public static List<OSR__c> osrs = new List<OSR__c>();
    public static List<LCL__c> lcls = new List<LCL__c>();
    public static List<SRV__c> srvs = new List<SRV__c>();
    public static List<Opt__c>  opts = new List<Opt__c>();
    public static List<OPD__c>  opds = new List<OPD__c>();
    public static List<SOD__c> sods = new List<SOD__c>();
    public static List<CRM__c> crms = new List<CRM__c>();
    
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
    
    public static Integer count =1;
    public static String OSR_PRICE_CODE_EB='EB';
    public static String OSR_PRICE_CODE_ST='ST';
    public static String OSR_PRICE_CODE_S1='S1';
    public static String OPD_RATETYPE_FC='FC';
    public static Integer osrcount =3;
    public static Integer selectedPassengerCount =3;
    public static List<ExchangeRates__c> exchangeRates = new List<ExchangeRates__c>();
    
    static void setupTestData()
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
        }
        
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
        sodkeyValueMap1.put('SINGLE_AD_MAX__c',999);
        
          
        for(Integer i = 0 ; i <1; i++)
        {
            sods.add((SOD__c) TestDataFactory.operationOnObjectRecord(null, 'SOD__c', sodkeyValueMap1));
        }
        insert sods;  
        
        Map<String,Object> optkeyValueMap1 = new Map<String,Object>();
        optkeyValueMap1.put('Service__c','AC');
        optkeyValueMap1.put('AC__c','Y');
        optkeyValueMap1.put('Opt_Id__c',1);
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
        optkeyValueMap1.put('Comment__c','Test');
        optkeyValueMap1.put('CRM_Lookup__c',crms[0].Id);
        optkeyValueMap1.put('SRV_Lookup__c',srvs[0].Id);
        optkeyValueMap1.put('LCL_Lookup__c',lcls[0].Id);
        optkeyValueMap1.put('SOD_Lookup__c',sods[0].Id);
        optkeyValueMap1.put('PBX1__c',1);
        optkeyValueMap1.put('PBX2__c',1);
        optkeyValueMap1.put('PBX3__c',1);
        optkeyValueMap1.put('PBX4__c',1);
        optkeyValueMap1.put('PBX5__c',1);
        optkeyValueMap1.put('PBX6__c',1);
        optkeyValueMap1.put('PBX7__c',1); 
        optkeyValueMap1.put('FCU__c','Person');
        optkeyValueMap1.put('MPFCU__c',1);
        
        Map<String,Object> optkeyValueMap2 = new Map<String,Object>();
        optkeyValueMap2.put('Service__c','AC');
        optkeyValueMap2.put('AC__c','N');
        optkeyValueMap2.put('Opt_Id__c',2);
        optkeyValueMap2.put('CHGEX1__c','0');
        optkeyValueMap2.put('CHGEX2__c','G');
        optkeyValueMap2.put('CHGEX3__c','P');
        optkeyValueMap2.put('CHGEX4__c','2');
        optkeyValueMap2.put('CHGEX5__c','G');
        optkeyValueMap2.put('EX1__c','Conservation Levy');
        optkeyValueMap2.put('EX2__c','PG TIM Vehicle Fee');
        optkeyValueMap2.put('EX3__c','Per Person Extra');
        optkeyValueMap2.put('EX4__c','Per Room Extra');
        optkeyValueMap2.put('EX5__c','Per Group Extra');
        optkeyValueMap2.put('ANALYSIS1__c','PF');
        optkeyValueMap2.put('ANALYSIS2__c','PP');
        optkeyValueMap2.put('ANALYSIS3__c','LA');
        optkeyValueMap2.put('ANALYSIS4__c','ZA');
        optkeyValueMap2.put('SupplierMarkup__c',0.00);
        optkeyValueMap2.put('Description__c','Luxury Safari TentN');
        optkeyValueMap2.put('Comment__c','Test');
        optkeyValueMap2.put('CRM_Lookup__c',crms[0].Id);
        optkeyValueMap2.put('SRV_Lookup__c',srvs[0].Id);
        optkeyValueMap2.put('LCL_Lookup__c',lcls[0].Id);
        optkeyValueMap2.put('SOD_Lookup__c',sods[0].Id);
        optkeyValueMap2.put('PBX1__c',1);
        optkeyValueMap2.put('PBX2__c',1);
        optkeyValueMap2.put('PBX3__c',1);
        optkeyValueMap2.put('PBX4__c',1);
        optkeyValueMap2.put('PBX5__c',1);
        optkeyValueMap2.put('PBX6__c',1);
        optkeyValueMap2.put('PBX7__c',1); 
        optkeyValueMap2.put('FCU__c','Person');
        optkeyValueMap2.put('MPFCU__c',4);
        
         Map<String,Object> optkeyValueMap3 = new Map<String,Object>();
        optkeyValueMap3.put('Service__c','AC');
        optkeyValueMap3.put('AC__c','A');
        optkeyValueMap3.put('Opt_Id__c',3);
        optkeyValueMap3.put('CHGEX1__c','0');
        optkeyValueMap3.put('CHGEX2__c','G');
        optkeyValueMap3.put('CHGEX3__c','P');
        optkeyValueMap3.put('CHGEX4__c','2');
        optkeyValueMap3.put('CHGEX5__c','G');
        optkeyValueMap3.put('EX1__c','Conservation Levy');
        optkeyValueMap3.put('EX2__c','PG TIM Vehicle Fee');
        optkeyValueMap3.put('EX3__c','Per Person Extra');
        optkeyValueMap3.put('EX4__c','Per Room Extra');
        optkeyValueMap3.put('EX5__c','Per Group Extra');
        optkeyValueMap3.put('ANALYSIS1__c','PF');
        optkeyValueMap3.put('ANALYSIS2__c','PP');
        optkeyValueMap3.put('ANALYSIS3__c','LA');
        optkeyValueMap3.put('ANALYSIS4__c','ZA');
        optkeyValueMap3.put('SupplierMarkup__c',0.00);
        optkeyValueMap3.put('Description__c','Luxury Safari TentA');
        optkeyValueMap3.put('Comment__c','Test');
        optkeyValueMap3.put('CRM_Lookup__c',crms[0].Id);
        optkeyValueMap3.put('SRV_Lookup__c',srvs[0].Id);
        optkeyValueMap3.put('LCL_Lookup__c',lcls[0].Id);
        optkeyValueMap3.put('SOD_Lookup__c',sods[0].Id);
		optkeyValueMap3.put('PBX1__c',1);
        optkeyValueMap3.put('PBX2__c',1);
        optkeyValueMap3.put('PBX3__c',1);
        optkeyValueMap3.put('PBX4__c',1);
        optkeyValueMap3.put('PBX5__c',1);
        optkeyValueMap3.put('PBX6__c',1);
        optkeyValueMap3.put('PBX7__c',1);        
        optkeyValueMap3.put('FCU__c','Person');
        optkeyValueMap3.put('MPFCU__c',1);
        
         Map<String,Object> optkeyValueMap4 = new Map<String,Object>();
        optkeyValueMap4.put('Service__c','BC');
        optkeyValueMap4.put('AC__c','A');
        optkeyValueMap4.put('Opt_Id__c',4);
        optkeyValueMap4.put('CHGEX1__c','0');
        optkeyValueMap4.put('CHGEX2__c','G');
        optkeyValueMap4.put('CHGEX3__c','P');
        optkeyValueMap4.put('CHGEX4__c','2');
        optkeyValueMap4.put('CHGEX5__c','G');
        optkeyValueMap4.put('EX1__c','Conservation Levy');
        optkeyValueMap4.put('EX2__c','PG TIM Vehicle Fee');
        optkeyValueMap4.put('EX3__c','Per Person Extra');
        optkeyValueMap4.put('EX4__c','Per Room Extra');
        optkeyValueMap4.put('EX5__c','Per Group Extra');
        optkeyValueMap4.put('ANALYSIS1__c','PF');
        optkeyValueMap4.put('ANALYSIS2__c','PP');
        optkeyValueMap4.put('ANALYSIS3__c','LA');
        optkeyValueMap4.put('ANALYSIS4__c','ZA');
        optkeyValueMap4.put('SupplierMarkup__c',0.00);
        optkeyValueMap4.put('Description__c','Luxury Safari Tent2');
        optkeyValueMap4.put('Comment__c','Test');
        optkeyValueMap4.put('CRM_Lookup__c',crms[0].Id);
        optkeyValueMap4.put('SRV_Lookup__c',srvs[0].Id);
        optkeyValueMap4.put('LCL_Lookup__c',lcls[0].Id);
        optkeyValueMap4.put('SOD_Lookup__c',sods[0].Id);
        optkeyValueMap4.put('PBX1__c',1);
        optkeyValueMap4.put('PBX2__c',1);
        optkeyValueMap4.put('PBX3__c',1);
        optkeyValueMap4.put('PBX4__c',1);
        optkeyValueMap4.put('PBX5__c',1);
        optkeyValueMap4.put('PBX6__c',1);
        optkeyValueMap4.put('PBX7__c',1);
        optkeyValueMap4.put('FCU__c','Person');
        optkeyValueMap4.put('MPFCU__c',4);
        
        for(Integer i = 0 ; i <count; i++)
        {
            opts.add((OPT__c) TestDataFactory.operationOnObjectRecord(null, DAL_OPT.OBJECT_NAME, optkeyValueMap1));
            opts.add((OPT__c) TestDataFactory.operationOnObjectRecord(null, DAL_OPT.OBJECT_NAME, optkeyValueMap2));
            opts.add((OPT__c) TestDataFactory.operationOnObjectRecord(null, DAL_OPT.OBJECT_NAME, optkeyValueMap3));
            opts.add((OPT__c) TestDataFactory.operationOnObjectRecord(null, DAL_OPT.OBJECT_NAME, optkeyValueMap4));
        }
       
        insert opts;
         System.debug('opts>>'+opts);
        
        Map<String,Object> OsrkeyValueMap1 = new Map<String,Object>();
        Map<String,Object> OsrkeyValueMap2 = new Map<String,Object>();
        Map<String,Object> OsrkeyValueMap3 = new Map<String,Object>();
        Map<String,Object> OsrkeyValueMap4 = new Map<String,Object>();
        
        System.debug('opts[0].Id>>'+opts[0].Id);
        System.debug('opts[1].Id>>'+opts[1].Id);
        System.debug('opts[2].Id>>'+opts[2].Id);
        
        OsrkeyValueMap1.put('PRICE_CODE__c',OSR_PRICE_CODE_EB);
        OsrkeyValueMap1.put('OPT_ID__c',1);
        OsrkeyValueMap1.put('OPT_Lookup__c',opts[0].Id);
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
        OsrkeyValueMap1.put('MIN_SCU__c',0);
        OsrkeyValueMap1.put('MAX_SCU__c',100);
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
        OsrkeyValueMap1.put('OSR_ID__c',String.valueof(100));
        
        OsrkeyValueMap2.put('PRICE_CODE__c',OSR_PRICE_CODE_ST);
        OsrkeyValueMap2.put('OPT_ID__c',2);    
        OsrkeyValueMap2.put('OPT_Lookup__c',opts[1].Id);
        OsrkeyValueMap2.put('STAYPAY_FROM__c',system.today().addDays(-40));
        OsrkeyValueMap2.put('STAYPAY_TO__c',system.today().addDays(40));
        OsrkeyValueMap2.put('STAY1__c',2);
        OsrkeyValueMap2.put('STAY2__c',4);
        OsrkeyValueMap2.put('STAY3__c',6);
        OsrkeyValueMap2.put('STAY4__c',4);
        OsrkeyValueMap2.put('STAY5__c',5);
        OsrkeyValueMap2.put('STAY6__c',2);
        OsrkeyValueMap2.put('STAY7__c',1);
        OsrkeyValueMap2.put('STAY8__c',0);
        OsrkeyValueMap2.put('STAY1__c',1);
        OsrkeyValueMap2.put('DATE_FROM__c',system.today().addDays(-20));
        OsrkeyValueMap2.put('DATE_TO__c',system.today().addDays(20));
        OsrkeyValueMap2.put('MIN_SCU__c',0);
        OsrkeyValueMap2.put('MAX_SCU__c',100);
        OsrkeyValueMap2.put('APPLY_MON__c', true);
        OsrkeyValueMap2.put('APPLY_TUE__c', true);
        OsrkeyValueMap2.put('APPLY_WED__c', true);
        OsrkeyValueMap2.put('APPLY_THU__c', true);
        OsrkeyValueMap2.put('APPLY_FRI__c', true);
        OsrkeyValueMap2.put('APPLY_SAT__c', true);
        OsrkeyValueMap2.put('APPLY_SUN__c', true); 
        OsrkeyValueMap2.put('SELLBEFORETRAVEL__c',0);
        OsrkeyValueMap2.put('SELL_CURRENCY__c','ZAR');
        OsrkeyValueMap2.put('SALE_FROM__c',system.today().addDays(-100));
        OsrkeyValueMap2.put('SALE_TO__c',system.today().addDays(50));
        OsrkeyValueMap2.put('OSR_ID__c',String.valueof(100));

        OsrkeyValueMap3.put('PRICE_CODE__c',OSR_PRICE_CODE_S1);
        OsrkeyValueMap3.put('OPT_ID__c',3);    
        OsrkeyValueMap3.put('OPT_Lookup__c',opts[2].Id);
        OsrkeyValueMap3.put('STAYPAY_FROM__c',system.today().addDays(-40));
        OsrkeyValueMap3.put('STAYPAY_TO__c',system.today().addDays(40));
        OsrkeyValueMap3.put('STAY1__c',2);
        OsrkeyValueMap3.put('STAY2__c',4);
        OsrkeyValueMap3.put('STAY3__c',6);
        OsrkeyValueMap3.put('STAY4__c',4);
        OsrkeyValueMap3.put('STAY5__c',5);
        OsrkeyValueMap3.put('STAY6__c',2);
        OsrkeyValueMap3.put('STAY7__c',1);
        OsrkeyValueMap3.put('STAY8__c',0);
        OsrkeyValueMap3.put('STAY1__c',1);
        OsrkeyValueMap3.put('DATE_FROM__c',system.today().addDays(-20));
        OsrkeyValueMap3.put('DATE_TO__c',system.today().addDays(20));
        OsrkeyValueMap3.put('MIN_SCU__c',0);
        OsrkeyValueMap3.put('MAX_SCU__c',100);
        OsrkeyValueMap3.put('APPLY_MON__c', true);
        OsrkeyValueMap3.put('APPLY_TUE__c', true);
        OsrkeyValueMap3.put('APPLY_WED__c', true);
        OsrkeyValueMap3.put('APPLY_THU__c', true);
        OsrkeyValueMap3.put('APPLY_FRI__c', true);
        OsrkeyValueMap3.put('APPLY_SAT__c', true);
        OsrkeyValueMap3.put('APPLY_SUN__c', true); 
        OsrkeyValueMap3.put('SELLBEFORETRAVEL__c',0);
        OsrkeyValueMap3.put('SELL_CURRENCY__c','ZAR');
        OsrkeyValueMap3.put('SALE_FROM__c',system.today().addDays(-100));
        OsrkeyValueMap3.put('SALE_TO__c',system.today().addDays(50));
        OsrkeyValueMap3.put('OSR_ID__c',String.valueof(100));
        
        OsrkeyValueMap4.put('PRICE_CODE__c',OSR_PRICE_CODE_S1);
        OsrkeyValueMap4.put('OPT_ID__c',4);    
        OsrkeyValueMap4.put('OPT_Lookup__c',opts[3].Id);
        OsrkeyValueMap4.put('STAYPAY_FROM__c',system.today().addDays(-40));
        OsrkeyValueMap4.put('STAYPAY_TO__c',system.today().addDays(40));
        OsrkeyValueMap4.put('STAY1__c',2);
        OsrkeyValueMap4.put('STAY2__c',4);
        OsrkeyValueMap4.put('STAY3__c',6);
        OsrkeyValueMap4.put('STAY4__c',4);
        OsrkeyValueMap4.put('STAY5__c',5);
        OsrkeyValueMap4.put('STAY6__c',2);
        OsrkeyValueMap4.put('STAY7__c',1);
        OsrkeyValueMap4.put('STAY8__c',0);
        OsrkeyValueMap4.put('STAY1__c',1);
        OsrkeyValueMap4.put('DATE_FROM__c',system.today().addDays(-20));
        OsrkeyValueMap4.put('DATE_TO__c',system.today().addDays(20));
        OsrkeyValueMap4.put('MIN_SCU__c',0);
        OsrkeyValueMap4.put('MAX_SCU__c',100);
        OsrkeyValueMap4.put('APPLY_MON__c', true);
        OsrkeyValueMap4.put('APPLY_TUE__c', true);
        OsrkeyValueMap4.put('APPLY_WED__c', true);
        OsrkeyValueMap4.put('APPLY_THU__c', true);
        OsrkeyValueMap4.put('APPLY_FRI__c', true);
        OsrkeyValueMap4.put('APPLY_SAT__c', true);
        OsrkeyValueMap4.put('APPLY_SUN__c', true); 
        OsrkeyValueMap4.put('SELLBEFORETRAVEL__c',0);
        OsrkeyValueMap4.put('SELL_CURRENCY__c','ZAR');
        OsrkeyValueMap4.put('SALE_FROM__c',system.today().addDays(-100));
        OsrkeyValueMap4.put('SALE_TO__c',system.today().addDays(50));
        OsrkeyValueMap4.put('OSR_ID__c',String.valueof(100));
        
        osrs.add((OSR__c) TestDataFactory.operationOnObjectRecord(null, DAL_OSR.OBJECT_NAME, OsrkeyValueMap4));
        osrs.add((OSR__c) TestDataFactory.operationOnObjectRecord(null, DAL_OSR.OBJECT_NAME, OsrkeyValueMap3));
        osrs.add((OSR__c) TestDataFactory.operationOnObjectRecord(null, DAL_OSR.OBJECT_NAME, OsrkeyValueMap2));
        osrs.add((OSR__c) TestDataFactory.operationOnObjectRecord(null, DAL_OSR.OBJECT_NAME, OsrkeyValueMap1));
        
        System.debug('Before OSR Save');
        System.debug('osrs[0].OPT_Lookup__c>>'+osrs[0].OPT_Lookup__c);
        System.debug('osrs[1].OPT_Lookup__c>>'+osrs[1].OPT_Lookup__c);
        System.debug('osrs[2].OPT_Lookup__c>>'+osrs[2].OPT_Lookup__c);
        
        
        BaseTriggerHandler.bypass('OSRTrigger');
        insert osrs;
        BaseTriggerHandler.clearBypass('OSRTrigger');
        
        System.debug('After OSR Save');
        System.debug('osrs[0].OPT_Lookup__c>>'+osrs[0].OPT_Lookup__c);
        System.debug('osrs[1].OPT_Lookup__c>>'+osrs[1].OPT_Lookup__c);
        System.debug('osrs[2].OPT_Lookup__c>>'+osrs[2].OPT_Lookup__c);
        
        System.debug('Saved OSRs>>'+[SELECT Id,OPT_Lookup__c FROM OSR__c]);
        
        
       	Map<String,Object> opdkeyValueMap1 = new Map<String,Object>();
        opdkeyValueMap1.put('RATE_TYPE__c',OPD_RATETYPE_FC);
        opdkeyValueMap1.put('AGE_CATEGORY__c','AD');
        opdkeyValueMap1.put('PRICE_PXB1__c',3628);
        opdkeyValueMap1.put('PRICE_PXB2__c',3628);
        opdkeyValueMap1.put('PRICE_PXB3__c',3628);
        opdkeyValueMap1.put('PRICE_PXB4__c',3628);
        opdkeyValueMap1.put('PRICE_PXB5__c',3628);
        opdkeyValueMap1.put('PRICE_PXB6__c',3628);
        opdkeyValueMap1.put('PRICE_PXB7__c',3628);
        opdkeyValueMap1.put('EX1__c',1);
        opdkeyValueMap1.put('EX2__c',3);
        opdkeyValueMap1.put('EX3__c',3);
        opdkeyValueMap1.put('EX4__c',2);
        opdkeyValueMap1.put('EX5__c',1);
        opdkeyValueMap1.put('OSR_Lookup__c',osrs[0].Id);
        opdkeyValueMap1.put('OSR_ID__c',String.valueof(osrs[0].OSR_ID__c));
                
        Map<String,Object> opdkeyValueMap11 = new Map<String,Object>();
        opdkeyValueMap11.put('RATE_TYPE__c',OPD_RATETYPE_FC);
        opdkeyValueMap11.put('AGE_CATEGORY__c','AD');
        opdkeyValueMap11.put('PRICE_PXB1__c',3628);
        opdkeyValueMap11.put('PRICE_PXB2__c',3628);
        opdkeyValueMap11.put('PRICE_PXB3__c',3628);
        opdkeyValueMap11.put('PRICE_PXB4__c',3628);
        opdkeyValueMap11.put('PRICE_PXB5__c',3628);
        opdkeyValueMap11.put('PRICE_PXB6__c',3628);
        opdkeyValueMap11.put('PRICE_PXB7__c',3628);
        opdkeyValueMap11.put('EX1__c',1);
        opdkeyValueMap11.put('EX2__c',3);
        opdkeyValueMap11.put('EX3__c',3);
        opdkeyValueMap11.put('EX4__c',2);
        opdkeyValueMap11.put('EX5__c',1);
        opdkeyValueMap11.put('OSR_Lookup__c',osrs[1].Id);
        opdkeyValueMap11.put('OSR_ID__c',String.valueof(osrs[1].OSR_ID__c));
        
        Map<String,Object> opdkeyValueMap12 = new Map<String,Object>();
        opdkeyValueMap12.put('RATE_TYPE__c',OPD_RATETYPE_FC);
        opdkeyValueMap12.put('AGE_CATEGORY__c','AD');
        opdkeyValueMap12.put('PRICE_PXB1__c',3628);
        opdkeyValueMap12.put('PRICE_PXB2__c',3628);
        opdkeyValueMap12.put('PRICE_PXB3__c',3628);
        opdkeyValueMap12.put('PRICE_PXB4__c',3628);
        opdkeyValueMap12.put('PRICE_PXB5__c',3628);
        opdkeyValueMap12.put('PRICE_PXB6__c',3628);
        opdkeyValueMap12.put('PRICE_PXB7__c',3628);
        opdkeyValueMap12.put('EX1__c',1);
        opdkeyValueMap12.put('EX2__c',3);
        opdkeyValueMap12.put('EX3__c',3);
        opdkeyValueMap12.put('EX4__c',2);
        opdkeyValueMap12.put('EX5__c',1);
        opdkeyValueMap12.put('OSR_Lookup__c',osrs[2].Id);
        opdkeyValueMap12.put('OSR_ID__c',String.valueof(osrs[2].OSR_ID__c));
        
        Map<String,Object> opdkeyValueMap13 = new Map<String,Object>();
        opdkeyValueMap13.put('RATE_TYPE__c',OPD_RATETYPE_FC);
        opdkeyValueMap13.put('AGE_CATEGORY__c','AD');
        opdkeyValueMap13.put('PRICE_PXB1__c',3628);
        opdkeyValueMap13.put('PRICE_PXB2__c',3628);
        opdkeyValueMap13.put('PRICE_PXB3__c',3628);
        opdkeyValueMap13.put('PRICE_PXB4__c',3628);
        opdkeyValueMap13.put('PRICE_PXB5__c',3628);
        opdkeyValueMap13.put('PRICE_PXB6__c',3628);
        opdkeyValueMap13.put('PRICE_PXB7__c',3628);
        opdkeyValueMap13.put('EX1__c',1);
        opdkeyValueMap13.put('EX2__c',3);
        opdkeyValueMap13.put('EX3__c',3);
        opdkeyValueMap13.put('EX4__c',2);
        opdkeyValueMap13.put('EX5__c',1);
        opdkeyValueMap13.put('OSR_Lookup__c',osrs[3].Id);
        opdkeyValueMap13.put('OSR_ID__c',String.valueof(osrs[3].OSR_ID__c));
        
        Map<String,Object> opdkeyValueMap2 = new Map<String,Object>();
        opdkeyValueMap2.put('RATE_TYPE__c',OPD_RATETYPE_FC);
        opdkeyValueMap2.put('AGE_CATEGORY__c','CH');
        opdkeyValueMap2.put('PRICE_PXB1__c',3628);
        opdkeyValueMap2.put('PRICE_PXB2__c',3628);
        opdkeyValueMap2.put('PRICE_PXB3__c',3628);
        opdkeyValueMap2.put('PRICE_PXB4__c',3628);
        opdkeyValueMap2.put('PRICE_PXB5__c',3628);
        opdkeyValueMap2.put('PRICE_PXB6__c',3628);
        opdkeyValueMap2.put('PRICE_PXB7__c',3628);
        opdkeyValueMap2.put('EX1__c',1);
        opdkeyValueMap2.put('EX2__c',3);
        opdkeyValueMap2.put('EX3__c',3);
        opdkeyValueMap2.put('EX4__c',2);
        opdkeyValueMap2.put('EX5__c',1);
        opdkeyValueMap2.put('OSR_Lookup__c',osrs[0].Id);
        opdkeyValueMap2.put('OSR_ID__c',String.valueof(osrs[0].OSR_ID__c));
        
        Map<String,Object> opdkeyValueMap21 = new Map<String,Object>();
        opdkeyValueMap21.put('RATE_TYPE__c',OPD_RATETYPE_FC);
        opdkeyValueMap21.put('AGE_CATEGORY__c','CH');
        opdkeyValueMap21.put('PRICE_PXB1__c',3628);
        opdkeyValueMap21.put('PRICE_PXB2__c',3628);
        opdkeyValueMap21.put('PRICE_PXB3__c',3628);
        opdkeyValueMap21.put('PRICE_PXB4__c',3628);
        opdkeyValueMap21.put('PRICE_PXB5__c',3628);
        opdkeyValueMap21.put('PRICE_PXB6__c',3628);
        opdkeyValueMap21.put('PRICE_PXB7__c',3628);
        opdkeyValueMap21.put('EX1__c',1);
        opdkeyValueMap21.put('EX2__c',3);
        opdkeyValueMap21.put('EX3__c',3);
        opdkeyValueMap21.put('EX4__c',2);
        opdkeyValueMap21.put('EX5__c',1);
        opdkeyValueMap21.put('OSR_Lookup__c',osrs[1].Id);
        opdkeyValueMap21.put('OSR_ID__c',String.valueof(osrs[1].OSR_ID__c));
        
        Map<String,Object> opdkeyValueMap22 = new Map<String,Object>();
        opdkeyValueMap22.put('RATE_TYPE__c',OPD_RATETYPE_FC);
        opdkeyValueMap22.put('AGE_CATEGORY__c','CH');
        opdkeyValueMap22.put('PRICE_PXB1__c',3628);
        opdkeyValueMap22.put('PRICE_PXB2__c',3628);
        opdkeyValueMap22.put('PRICE_PXB3__c',3628);
        opdkeyValueMap22.put('PRICE_PXB4__c',3628);
        opdkeyValueMap22.put('PRICE_PXB5__c',3628);
        opdkeyValueMap22.put('PRICE_PXB6__c',3628);
        opdkeyValueMap22.put('PRICE_PXB7__c',3628);
        opdkeyValueMap22.put('EX1__c',1);
        opdkeyValueMap22.put('EX2__c',3);
        opdkeyValueMap22.put('EX3__c',3);
        opdkeyValueMap22.put('EX4__c',2);
        opdkeyValueMap22.put('EX5__c',1);
        opdkeyValueMap22.put('OSR_Lookup__c',osrs[2].Id);
        opdkeyValueMap22.put('OSR_ID__c',String.valueof(osrs[2].OSR_ID__c));
        
        Map<String,Object> opdkeyValueMap23 = new Map<String,Object>();
        opdkeyValueMap23.put('RATE_TYPE__c',OPD_RATETYPE_FC);
        opdkeyValueMap23.put('AGE_CATEGORY__c','CH');
        opdkeyValueMap23.put('PRICE_PXB1__c',3628);
        opdkeyValueMap23.put('PRICE_PXB2__c',3628);
        opdkeyValueMap23.put('PRICE_PXB3__c',3628);
        opdkeyValueMap23.put('PRICE_PXB4__c',3628);
        opdkeyValueMap23.put('PRICE_PXB5__c',3628);
        opdkeyValueMap23.put('PRICE_PXB6__c',3628);
        opdkeyValueMap23.put('PRICE_PXB7__c',3628);
        opdkeyValueMap23.put('EX1__c',1);
        opdkeyValueMap23.put('EX2__c',3);
        opdkeyValueMap23.put('EX3__c',3);
        opdkeyValueMap23.put('EX4__c',2);
        opdkeyValueMap23.put('EX5__c',1);
        opdkeyValueMap23.put('OSR_Lookup__c',osrs[3].Id);
        opdkeyValueMap23.put('OSR_ID__c',String.valueof(osrs[3].OSR_ID__c));
        
        Map<String,Object> opdkeyValueMap3 = new Map<String,Object>();
        opdkeyValueMap3.put('RATE_TYPE__c',OPD_RATETYPE_FC);
        opdkeyValueMap3.put('AGE_CATEGORY__c','IN');
        opdkeyValueMap3.put('PRICE_PXB1__c',3628);
        opdkeyValueMap3.put('PRICE_PXB2__c',3628);
        opdkeyValueMap3.put('PRICE_PXB3__c',3628);
        opdkeyValueMap3.put('PRICE_PXB4__c',3628);
        opdkeyValueMap3.put('PRICE_PXB5__c',3628);
        opdkeyValueMap3.put('PRICE_PXB6__c',3628);
        opdkeyValueMap3.put('PRICE_PXB7__c',3628);
        opdkeyValueMap3.put('EX1__c',1);
        opdkeyValueMap3.put('EX2__c',3);
        opdkeyValueMap3.put('EX3__c',3);
        opdkeyValueMap3.put('EX4__c',2);
        opdkeyValueMap3.put('EX5__c',1);
        opdkeyValueMap3.put('OSR_Lookup__c',osrs[0].Id);
        opdkeyValueMap3.put('OSR_ID__c',String.valueof(osrs[0].OSR_ID__c));
        
        Map<String,Object> opdkeyValueMap31 = new Map<String,Object>();
        opdkeyValueMap31.put('RATE_TYPE__c',OPD_RATETYPE_FC);
        opdkeyValueMap31.put('AGE_CATEGORY__c','IN');
        opdkeyValueMap31.put('PRICE_PXB1__c',3628);
        opdkeyValueMap31.put('PRICE_PXB2__c',3628);
        opdkeyValueMap31.put('PRICE_PXB3__c',3628);
        opdkeyValueMap31.put('PRICE_PXB4__c',3628);
        opdkeyValueMap31.put('PRICE_PXB5__c',3628);
        opdkeyValueMap31.put('PRICE_PXB6__c',3628);
        opdkeyValueMap31.put('PRICE_PXB7__c',3628);
        opdkeyValueMap31.put('EX1__c',1);
        opdkeyValueMap31.put('EX2__c',3);
        opdkeyValueMap31.put('EX3__c',3);
        opdkeyValueMap31.put('EX4__c',2);
        opdkeyValueMap31.put('EX5__c',1);
        opdkeyValueMap31.put('OSR_Lookup__c',osrs[1].Id);
        opdkeyValueMap31.put('OSR_ID__c',osrs[1].OSR_ID__c);
        
        Map<String,Object> opdkeyValueMap32 = new Map<String,Object>();
        opdkeyValueMap32.put('RATE_TYPE__c',OPD_RATETYPE_FC);
        opdkeyValueMap32.put('AGE_CATEGORY__c','IN');
        opdkeyValueMap32.put('PRICE_PXB1__c',3628);
        opdkeyValueMap32.put('PRICE_PXB2__c',3628);
        opdkeyValueMap32.put('PRICE_PXB3__c',3628);
        opdkeyValueMap32.put('PRICE_PXB4__c',3628);
        opdkeyValueMap32.put('PRICE_PXB5__c',3628);
        opdkeyValueMap32.put('PRICE_PXB6__c',3628);
        opdkeyValueMap32.put('PRICE_PXB7__c',3628);
        opdkeyValueMap32.put('EX1__c',1);
        opdkeyValueMap32.put('EX2__c',3);
        opdkeyValueMap32.put('EX3__c',3);
        opdkeyValueMap32.put('EX4__c',2);
        opdkeyValueMap32.put('EX5__c',1);
        opdkeyValueMap32.put('OSR_Lookup__c',osrs[2].Id);
        opdkeyValueMap32.put('OSR_ID__c',String.valueof(osrs[2].OSR_ID__c));
        
        Map<String,Object> opdkeyValueMap33 = new Map<String,Object>();
        opdkeyValueMap33.put('RATE_TYPE__c',OPD_RATETYPE_FC);
        opdkeyValueMap33.put('AGE_CATEGORY__c','IN');
        opdkeyValueMap33.put('PRICE_PXB1__c',3628);
        opdkeyValueMap33.put('PRICE_PXB2__c',3628);
        opdkeyValueMap33.put('PRICE_PXB3__c',3628);
        opdkeyValueMap33.put('PRICE_PXB4__c',3628);
        opdkeyValueMap33.put('PRICE_PXB5__c',3628);
        opdkeyValueMap33.put('PRICE_PXB6__c',3628);
        opdkeyValueMap33.put('PRICE_PXB7__c',3628);
        opdkeyValueMap33.put('EX1__c',1);
        opdkeyValueMap33.put('EX2__c',3);
        opdkeyValueMap33.put('EX3__c',3);
        opdkeyValueMap33.put('EX4__c',2);
        opdkeyValueMap33.put('EX5__c',1);
        opdkeyValueMap33.put('OSR_Lookup__c',osrs[3].Id);
        opdkeyValueMap33.put('OSR_ID__c',osrs[3].OSR_ID__c);
        
        opds.add((OPD__c) TestDataFactory.operationOnObjectRecord(null, DAL_OPD.OBJECT_NAME, opdkeyValueMap3));
        opds.add((OPD__c) TestDataFactory.operationOnObjectRecord(null, DAL_OPD.OBJECT_NAME, opdkeyValueMap31));
        opds.add((OPD__c) TestDataFactory.operationOnObjectRecord(null, DAL_OPD.OBJECT_NAME, opdkeyValueMap32));
        opds.add((OPD__c) TestDataFactory.operationOnObjectRecord(null, DAL_OPD.OBJECT_NAME, opdkeyValueMap33));
        opds.add((OPD__c) TestDataFactory.operationOnObjectRecord(null, DAL_OPD.OBJECT_NAME, opdkeyValueMap2));
        opds.add((OPD__c) TestDataFactory.operationOnObjectRecord(null, DAL_OPD.OBJECT_NAME, opdkeyValueMap21));
        opds.add((OPD__c) TestDataFactory.operationOnObjectRecord(null, DAL_OPD.OBJECT_NAME, opdkeyValueMap22));
        opds.add((OPD__c) TestDataFactory.operationOnObjectRecord(null, DAL_OPD.OBJECT_NAME, opdkeyValueMap23));
        opds.add((OPD__c) TestDataFactory.operationOnObjectRecord(null, DAL_OPD.OBJECT_NAME, opdkeyValueMap1));
        opds.add((OPD__c) TestDataFactory.operationOnObjectRecord(null, DAL_OPD.OBJECT_NAME, opdkeyValueMap11));
        opds.add((OPD__c) TestDataFactory.operationOnObjectRecord(null, DAL_OPD.OBJECT_NAME, opdkeyValueMap12));
        opds.add((OPD__c) TestDataFactory.operationOnObjectRecord(null, DAL_OPD.OBJECT_NAME, opdkeyValueMap13));
        
        insert opds;
        System.Debug('opds>>'+opds);
        
        Map<String,Object> serviceLineItemkeyValueMap1 = new Map<String,Object>();
        
        serviceLineItemkeyValueMap1.put('Service_Detail__c','Luxury Safari Tent||Test ');
        serviceLineItemkeyValueMap1.put('QuotationLine__c',QuotationLineItems[0].Id);
        serviceLineItemkeyValueMap1.put('Service_Status__c','Not Booked');
        serviceLineItemkeyValueMap1.put('Provisional_Booking_Expiry_Date__c',system.today());
        serviceLineItemkeyValueMap1.put('Override_details__c',false);
        serviceLineItemkeyValueMap1.put('Room_Configuration__c','TWIN AVAIL');
        serviceLineItemkeyValueMap1.put('Service_Type__c','Accommodation');
        serviceLineItemkeyValueMap1.put('ServiceLocation__c','Timbavati Game Reserve');
        serviceLineItemkeyValueMap1.put('SupplierName__c','Simbavati Hilltop Lodge');
        serviceLineItemkeyValueMap1.put('Crm_Code__c','SIM005');
        
        for(Integer i = 0 ; i <count; i++)
        {
            //serviceLineItemkeyValueMap1.put('QuotationLine__c',QuotationLineItems[i].Id);
            serviceLineItems.add((ServiceLineItem__c) TestDataFactory.operationOnObjectRecord(null, 
            								QuotationBuilderDatabaseQueries.SERVICELINEITEM_OBJECT_NAME,
            							   serviceLineItemkeyValueMap1));
        }
        insert serviceLineItems;
    }
    
    static testMethod void getCrmFromServiceLineItemsTest() {
       setupTestData(); 
      Test.startTest();
       DAL_CRM.getCrmFromServiceLineItems(serviceLineItems);
       DAL_CRM.getById(crms[0].Id);
      Test.stopTest();
    }
}
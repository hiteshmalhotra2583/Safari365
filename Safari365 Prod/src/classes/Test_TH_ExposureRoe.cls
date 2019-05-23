@isTest
private class Test_TH_ExposureRoe {

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
    static List<Additional_Cost__c> adcostList = new List<Additional_Cost__c>();
    static List<Exposure_ROE__c> exposureROEs = new List<Exposure_ROE__c>();
 
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
            accountOpportunityMap.put('Number_of_Photo_Books_Owed__c', 50.00);
            accountOpportunityMap.put('Client_Display_Currency__c', 'USD');
            accountOpportunityMap.put('StageName', 'Quotation');
            
        }
        
         Map<String,Object> exchangeRateMap = new Map<String,Object>();
        exchangeRateMap.put('BaseCurrency__c','USD');
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
            opportunityQuotationMap.put('TravelEndDate__c',system.today().addDays(500));
            opportunityQuotationMap.put('Include_Passenger_Insurance_USD__c',true);
            opportunityQuotationMap.put('Include_Passenger_Insurance_ZAR__c',false);
            opportunityQuotationMap.put('Include_Photobooks_USD__c',true);
            opportunityQuotationMap.put('Include_Photobooks_ZAR__c',false);
            opportunityQuotationMap.put('Quotation_Stage__c','Confirmed');
            opportunityQuotationMap.put('Primary_by_Consultant__c',false);
            
            
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
        
         Map<String,Object>  exposureRoeMap = new Map<String,Object>();
         exposureRoeMap.put('Quotation__c',Quotations[0].Id);
        for(Integer i = 0 ; i <recordCount; i++)
        {
            exposureROEs.add((Exposure_ROE__c) TestDataFactory.operationOnObjectRecord(null, 'Exposure_ROE__c', exposureRoeMap));
        }
       
         DAL_BaseObject.InsertDBObjects(exposureROEs);
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
           
       for(Integer i = 0 ; i <recordcount; i++)
        {
            crms.add((CRM__c) TestDataFactory.operationOnObjectRecord(null, 'CRM__c', null));
        }
        insert crms;
        system.debug('crms'+crms);
        
        Map<String,Object> keyValueMapSOD = new Map<String,Object>();
        for(CRM__c crm:crms)
        {
            keyValueMapSOD.put('SOD_ID__c', crm.SOD_ID__c);
            keyValueMapSOD.put('SINGLE_AVAIL__c', true);
            keyValueMapSOD.put('TWIN_AVAIL__c', true);
            keyValueMapSOD.put('TRIPLE_AVAIL__c', true);
            keyValueMapSOD.put('QUAD_AVAIL__c', true);
            keyValueMapSOD.put('OTHER_AVAIL__c', true);
            
        }
    
        for(Integer i = 0 ; i <recordCount; i++)
        sods.add((SOD__c) TestDataFactory.operationOnObjectRecord(null, DAL_SOD.OBJECT_NAME, keyValueMapSOD));
        insert sods;
           
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
           
           
           Additional_Cost__c adcost1 = new Additional_Cost__c();
           adcost1.Value_In_ZAR__c=400;
           adcost1.Value_In_USD__c=35;
           adcost1.Type__c='Photobook';
           adcost1.Name='Photobook Additional Cost In';
           adcostList.add(adcost1);
           Additional_Cost__c adcost2 = new Additional_Cost__c();
           adcost2.Value_In_ZAR__c=600;
           adcost2.Value_In_USD__c=50;
           adcost2.Type__c='Travel Insurance';
           adcost2.Name='Travel Insurance';
           adcostList.add(adcost2);
           insert adcostList;
           
       }   
    }
    
    
    static testMethod void afterInsertTest() {
        
        Test.startTest();
        setupInsertData();
        Test.stopTest();
    }
}
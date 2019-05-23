@isTest
private class Test_QuotationPricingController {
    
    static List<Opportunity> opportunitys = new List<Opportunity>();
    static List<Account> accounts = new List<Account>();
    static List<Passenger__c> passengers = new List<Passenger__c>();
    static List<Quotations__c> Quotations = new List<Quotations__c>();
    static List<Service_Line_Item_ChargeType__c> serviceChargeTypes = new List<Service_Line_Item_ChargeType__c>();
    static QuotationBuilderDatabaseQueries dbQueries = new QuotationBuilderDatabaseQueries();
    static List<Opt__c>  opts = new List<Opt__c>();
    static List<SRV__c>  srvs = new List<SRV__c>();
    static List<OPT__c>  db4opts = new List<OPT__c>();
    static List<DB4__c>  db4s= new List<DB4__c>();
    static List<CRM__c>  crms = new List<CRM__c>();
    static List<SOD__c>  sods= new List<SOD__c>();
    static List<PassengerQuotationMapping__c> passengerQuotations = new List<PassengerQuotationMapping__c>();
    static List<ServiceLineItem__c> slis = new List<ServiceLineItem__c>();
    static List<ServiceLineItemPassengersMapping__c> sliPassengers = new List<ServiceLineItemPassengersMapping__c>();
    static Integer recordCount = 1;
    static List<QuotationLineItem__c> getQuotationLineItemList = null;
    static List<QuotationLineItem__c> QuotationsLineItem = new List<QuotationLineItem__c>();
    static List<ExchangeRates__c> exchangeRates = new List<ExchangeRates__c>();
    
    static void setupInsertData()
    {
        User us = TestDataFactory.createUser(true, 'TH_Quotations', true);
        System.runAs(us){
        	 BaseTriggerHandler.bypass('TH_Quotations');
            //New Accounts
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
                accountOpportunityMap.put('Client_Display_Currency__c','USD');
            }
            Map<String,Object>  accountOpportunityMap1 = new Map<String,Object>();
            for(Account acc:accounts)
            {
                accountOpportunityMap1.put('AccountId', acc.ID);
                accountOpportunityMap1.put('StageName', 'Prospect');
                accountOpportunityMap1.put('Client_Display_Currency__c','AUD');
            }
            Map<String,Object>  accountOpportunityMap2 = new Map<String,Object>();
            for(Account acc:accounts)
            {
                accountOpportunityMap2.put('AccountId', acc.ID);
                accountOpportunityMap2.put('StageName', 'Prospect');
                accountOpportunityMap2.put('Client_Display_Currency__c','EUR');
            }
            Map<String,Object>  accountOpportunityMap3 = new Map<String,Object>();
            for(Account acc:accounts)
            {
                accountOpportunityMap3.put('AccountId', acc.ID);
                accountOpportunityMap3.put('StageName', 'Prospect');
                accountOpportunityMap3.put('Client_Display_Currency__c','GBP');
            }
            
            //New Exchange Rates
            Map<String,Object> exchangeRateMap = new Map<String,Object>();
            exchangeRateMap.put('BaseCurrency__c','ZAR');
            for(Integer i = 0 ; i <recordCount; i++)
            {
                exchangeRates.add((ExchangeRates__c) TestDataFactory.operationOnObjectRecord(null, 'ExchangeRates__c', exchangeRateMap));
            }
            DAL_BaseObject.InsertDBObjects(exchangeRates);
            
            //New Opportunity One
            for(Integer i = 0 ; i <recordCount; i++)
            {
                opportunitys.add((Opportunity) TestDataFactory.operationOnObjectRecord(null, 'Opportunity', accountOpportunityMap));
            }
            //New Opportunity Two
            for(Integer i = 0 ; i <recordCount; i++)
            {
                opportunitys.add((Opportunity) TestDataFactory.operationOnObjectRecord(null, 'Opportunity', accountOpportunityMap1));
            }
            //New Opportunity Three
            for(Integer i = 0 ; i <recordCount; i++)
            {
                opportunitys.add((Opportunity) TestDataFactory.operationOnObjectRecord(null, 'Opportunity', accountOpportunityMap2));
            }
            //New Opportunity Four
            for(Integer i = 0 ; i <recordCount; i++)
            {
                opportunitys.add((Opportunity) TestDataFactory.operationOnObjectRecord(null, 'Opportunity', accountOpportunityMap3));
            }
            DAL_BaseObject.InsertDBObjects(opportunitys);
            
            //For Quotation One
            Map<String,Object>  opportunityQuotationMap = new Map<String,Object>();
            opportunityQuotationMap.put('Opportunity__c', opportunitys[0].ID);
            opportunityQuotationMap.put('TravelStartDate__c',system.today());
            opportunityQuotationMap.put('TravelEndDate__c',system.today().addDays(3));
            opportunityQuotationMap.put('ROE_ZAR_to_CC__c',2);
            opportunityQuotationMap.put('ROE_USD_to_CC__c',2);
            opportunityQuotationMap.put('ROE_EUR_to_CC__c',2);
            
            //For Quotation Two
            Map<String,Object>  opportunityQuotationMap1 = new Map<String,Object>();
            opportunityQuotationMap1.put('Opportunity__c', opportunitys[1].ID);
            opportunityQuotationMap1.put('TravelStartDate__c',system.today());
            opportunityQuotationMap1.put('TravelEndDate__c',system.today().addDays(3));
            opportunityQuotationMap1.put('ROE_ZAR_to_CC__c',2);
            opportunityQuotationMap1.put('ROE_USD_to_CC__c',2);
            opportunityQuotationMap1.put('ROE_EUR_to_CC__c',2);
            
            //For Quotation Three
            Map<String,Object>  opportunityQuotationMap2 = new Map<String,Object>();
            opportunityQuotationMap2.put('Opportunity__c', opportunitys[2].ID);
            opportunityQuotationMap2.put('TravelStartDate__c',system.today());
            opportunityQuotationMap2.put('TravelEndDate__c',system.today().addDays(3));
            opportunityQuotationMap2.put('ROE_ZAR_to_CC__c',2);
            opportunityQuotationMap2.put('ROE_USD_to_CC__c',2);
            opportunityQuotationMap2.put('ROE_EUR_to_CC__c',2);
            
            //For Quotation Four
            Map<String,Object>  opportunityQuotationMap3 = new Map<String,Object>();
            opportunityQuotationMap3.put('Opportunity__c', opportunitys[0].ID);
            opportunityQuotationMap3.put('TravelStartDate__c',system.today());
            opportunityQuotationMap3.put('TravelEndDate__c',system.today().addDays(3));
            opportunityQuotationMap3.put('ROE_ZAR_to_CC__c',2);
            opportunityQuotationMap3.put('ROE_USD_to_CC__c',2);
            opportunityQuotationMap3.put('ROE_EUR_to_CC__c',2);
            
            Map<String,Object>  accountMap = new Map<String,Object>();
            accountMap.put('Opportunity__c' ,opportunitys[0].id );
            
            //New Passengers
            for(Integer i = 0 ; i <recordCount; i++)
            {
                passengers.add((Passenger__c) TestDataFactory.operationOnObjectRecord(null, DAL_Passenger.OBJECT_NAME, accountMap));
            }
            DAL_BaseObject.InsertDBObjects(passengers);
            
            //New Quotations One
            for(Integer i = 0 ; i <recordCount; i++)
            {
                Quotations.add((Quotations__c) TestDataFactory.operationOnObjectRecord(null, DAL_Quotations.OBJECT_NAME, opportunityQuotationMap));
            }
            //New Quotations Two
            for(Integer i = 0 ; i <recordCount; i++)
            {
                Quotations.add((Quotations__c) TestDataFactory.operationOnObjectRecord(null, DAL_Quotations.OBJECT_NAME, opportunityQuotationMap1));
            }
            //New Quotations Three
            for(Integer i = 0 ; i <recordCount; i++)
            {
                Quotations.add((Quotations__c) TestDataFactory.operationOnObjectRecord(null, DAL_Quotations.OBJECT_NAME, opportunityQuotationMap2));
            }
            //New Quotations Four
            for(Integer i = 0 ; i <recordCount; i++)
            {
                Quotations.add((Quotations__c) TestDataFactory.operationOnObjectRecord(null, DAL_Quotations.OBJECT_NAME, opportunityQuotationMap3));
            }
            
            DAL_BaseObject.InsertDBObjects(Quotations);
            
            
            //Quotation Line Item
            Map<String,Object>  QuotationQuotationLinitemMap = new Map<String,Object>();
            Integer rc=4;
            for(Integer i = 0 ; i <rc; i++)
            {
                QuotationQuotationLinitemMap.put('Name','QLI-'+i);
                QuotationQuotationLinitemMap.put('Quotation__c',Quotations[i].Id);
                QuotationQuotationLinitemMap.put('Line_Item_Date__c',Date.today());
                
                QuotationsLineItem.add((QuotationLineItem__c) TestDataFactory.operationOnObjectRecord(null, 'QuotationLineItem__c',QuotationQuotationLinitemMap ));
            }
            DAL_BaseObject.InsertDBObjects(QuotationsLineItem);   
            
            //New PassengerQuotationMapping
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
                quoationServiceLineMap.put('Total__c',22.22);
                quoationServiceLineMap.put('Sale_in_USD__c',22.22);
                quoationServiceLineMap.put('Sale_in_Eur__c',22.22);
                quoationServiceLineMap.put('Nett_Cost__c',22.22);
                quoationServiceLineMap.put('Nett_Cost_in_USD__c',22.22);
                quoationServiceLineMap.put('Nett_Cost_in_EUR__c',22.22);
            }
            
            //New SRV
            for(Integer i = 0 ; i <recordCount; i++)
            {
                srvs.add((SRV__c) TestDataFactory.operationOnObjectRecord(null, 'SRV__c', null));
            }
            insert srvs;
            
            //New Service
            Map<String,Object>  srvOptMap = new Map<String,Object>();
            for(SRV__c srv: srvs)
            {
                srvOptMap.put('Service__c',srvs[0].CODE__c);
            }
            
            //New OPT
            for(Integer i = 0 ; i <recordCount; i++)
            {
                opts.add((Opt__c) TestDataFactory.operationOnObjectRecord(null, DAL_OPT.OBJECT_NAME, srvOptMap));
            }
            insert opts;
            
            //New Service Line Items
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
            
            serviceLineItemkeyValueMap1.put('Total__c',5);
            serviceLineItemkeyValueMap1.put('Photobooks_Sale_in_ZAR__c',5);
            serviceLineItemkeyValueMap1.put('Insurance_Sale_in_ZAR__c',5);
            
            serviceLineItemkeyValueMap1.put('Sale_in_USD__c',5);
            serviceLineItemkeyValueMap1.put('Photobooks_Sale_in_USD__c',5);
            serviceLineItemkeyValueMap1.put('Insurance_Sale_in_USD__c',5);
            
            serviceLineItemkeyValueMap1.put('Sale_in_Eur__c',5);
            
            for(Integer i = 0 ; i <recordCount; i++)
            {
                slis.add((ServiceLineItem__c) TestDataFactory.operationOnObjectRecord(null, 'ServiceLineItem__c', serviceLineItemkeyValueMap1));
            }
            
            DAL_BaseObject.InsertDBObjects(slis);
            
            //New ServiceLine Item Passengers Mapping
            Map<String,Object>  passengerSLIMapingMap = new Map<String,Object>();
            passengerSLIMapingMap.put('Passenger__c',passengers[0].Id);
            passengerSLIMapingMap.put('Service_Line_Item__c',slis[0].Id);
            for(Integer i = 0 ; i <recordCount; i++)
            {
                sliPassengers.add((ServiceLineItemPassengersMapping__c) TestDataFactory.operationOnObjectRecord(null, 'ServiceLineItemPassengersMapping__c', passengerSLIMapingMap));
            }
            DAL_BaseObject.InsertDBObjects(sliPassengers);
            BaseTriggerHandler.clearBypass('TH_Quotations');
            
             //New Service Line Item ChargeType Mapping
            Map<String,Object>  serviceLineItemChargeTypeMap = new Map<String,Object>();
            serviceLineItemChargeTypeMap.put('Total__c',5000);
            serviceLineItemChargeTypeMap.put('Selected_Passenger__c',passengers[0].Id);
            serviceLineItemChargeTypeMap.put('Service_Line_Item__c',slis[0].Id);
            serviceLineItemChargeTypeMap.put('Currency__c','USD');
            for(Integer i = 0 ; i <recordCount; i++)
            {
                serviceChargeTypes.add((Service_Line_Item_ChargeType__c) TestDataFactory.operationOnObjectRecord(null, 'Service_Line_Item_ChargeType__c', serviceLineItemChargeTypeMap));
            }
            
            //New Service Line Item ChargeType Mapping
            Map<String,Object>  serviceLineItemChargeTypeMap2 = new Map<String,Object>();
            serviceLineItemChargeTypeMap2.put('Total__c',5000);
            serviceLineItemChargeTypeMap2.put('Selected_Passenger__c',passengers[0].Id);
            serviceLineItemChargeTypeMap2.put('Service_Line_Item__c',slis[0].Id);
            serviceLineItemChargeTypeMap2.put('Currency__c','ZAR');
            for(Integer i = 0 ; i <recordCount; i++)
            {
                serviceChargeTypes.add((Service_Line_Item_ChargeType__c) TestDataFactory.operationOnObjectRecord(null, 'Service_Line_Item_ChargeType__c', serviceLineItemChargeTypeMap2));
            }
            
            //New Service Line Item ChargeType Mapping
            Map<String,Object>  serviceLineItemChargeTypeMap3 = new Map<String,Object>();
            serviceLineItemChargeTypeMap3.put('Total__c',5000);
            serviceLineItemChargeTypeMap3.put('Selected_Passenger__c',passengers[0].Id);
            serviceLineItemChargeTypeMap3.put('Service_Line_Item__c',slis[0].Id);
            serviceLineItemChargeTypeMap3.put('Currency__c','EUR');
            for(Integer i = 0 ; i <recordCount; i++)
            {
                serviceChargeTypes.add((Service_Line_Item_ChargeType__c) TestDataFactory.operationOnObjectRecord(null, 'Service_Line_Item_ChargeType__c', serviceLineItemChargeTypeMap3));
            }
            
            DAL_BaseObject.InsertDBObjects(serviceChargeTypes);
        }   
    }
    
    static testMethod void testMethodOneTest()  
    {
        setupInsertData();
        //Quotation One currency USD
        String quotationId = Quotations[0].Id;
        List<QuotationLineItem__c> quoLineItem = [ select Id,Quotation__c FROM QuotationLineItem__c where Quotation__c = :quotationId];
        List<Id> qliId = new List<Id>();
        for(QuotationLineItem__c qli:quoLineItem){
            qliId.add(qli.Id);
        }
        List<ServiceLineItem__c> serLineItem = [select Id,Name,Service_Status__c,Reservation_Number__c FROM ServiceLineItem__c where QuotationLine__c In :qliId];
        List<ServiceLineItem__c> serLineItemList = new List<ServiceLineItem__c>();
        Integer i=1;
        for(ServiceLineItem__c sli:serLineItem){
            sli.Service_Status__c = 'Confirmed';
            sli.Reservation_Number__c = 'Confirmed_'+i;
            serLineItemList.add(sli);
            i++;
        }
        BaseTriggerHandler.bypass('TH_Quotations');
        update serLineItemList;
        Test.startTest();
        QuotationPricingController.getQuotationPricingDetails(quotationId);
        QuotationPricingController.updateQuotataionSalesValue(quotationId,2,3,4,1,2,'2018-02-20','2018-02-20');
        Test.stopTest();
        BaseTriggerHandler.clearBypass('TH_Quotations');	
        
    }
    
    static testMethod void testMethodTwoTest()  
    {
        setupInsertData();
        //Quotation Two Currency AUD
        String quotationId = Quotations[1].Id;
        List<QuotationLineItem__c> quoLineItem = [ select Id,Quotation__c FROM QuotationLineItem__c where Quotation__c = :quotationId];
        List<Id> qliId = new List<Id>();
        for(QuotationLineItem__c qli:quoLineItem){
            qliId.add(qli.Id);
        }
        List<ServiceLineItem__c> serLineItem = [select Id,Name,Service_Status__c,Reservation_Number__c FROM ServiceLineItem__c where QuotationLine__c In :qliId];
        List<ServiceLineItem__c> serLineItemList = new List<ServiceLineItem__c>();
        Integer i=1;
        for(ServiceLineItem__c sli:serLineItem)
        {
            sli.Service_Status__c = 'Confirmed';
            sli.Reservation_Number__c = 'Confirmed_'+i;
            serLineItemList.add(sli);
            i++;
        }
        BaseTriggerHandler.bypass('TH_Quotations');
        update serLineItemList;
        Test.startTest();
        QuotationPricingController.getQuotationPricingDetails(quotationId);
        QuotationPricingController.updateQuotataionSalesValue(quotationId,2,3,4,1,2,'2018-02-20','2018-02-20');
        Test.stopTest();
        BaseTriggerHandler.clearBypass('TH_Quotations');	
        
    }
    
    static testMethod void testMethodThreeTest()  
    {
        setupInsertData();
        //Quotation Three Currency EUR
        String quotationId = Quotations[2].Id;
        List<QuotationLineItem__c> quoLineItem = [ select Id,Quotation__c FROM QuotationLineItem__c where Quotation__c = :quotationId];
        List<Id> qliId = new List<Id>();
        for(QuotationLineItem__c qli:quoLineItem){
            qliId.add(qli.Id);
        }
        List<ServiceLineItem__c> serLineItem = [select Id,Name,Service_Status__c,Reservation_Number__c FROM ServiceLineItem__c where QuotationLine__c In :qliId];
        List<ServiceLineItem__c> serLineItemList = new List<ServiceLineItem__c>();
        Integer i=1;
        for(ServiceLineItem__c sli:serLineItem){
            sli.Service_Status__c = 'Confirmed';
            sli.Reservation_Number__c = 'Confirmed_'+i;
            serLineItemList.add(sli);
            i++;
        }
        BaseTriggerHandler.bypass('TH_Quotations');
        update serLineItemList;
        Test.startTest();
        QuotationPricingController.getQuotationPricingDetails(quotationId);
        QuotationPricingController.updateQuotataionSalesValue(quotationId,2,3,4,1,2,'2018-02-20','2018-02-20');
        Test.stopTest();
        BaseTriggerHandler.clearBypass('TH_Quotations');	
        
    }
    
    static testMethod void testMethodFourTest()  
    {
        setupInsertData();
        //Quotation Four Currency GBP
        String quotationId = Quotations[3].Id;
        List<QuotationLineItem__c> quoLineItem = [ select Id,Quotation__c FROM QuotationLineItem__c where Quotation__c = :quotationId];
        List<Id> qliId = new List<Id>();
        for(QuotationLineItem__c qli:quoLineItem){
            qliId.add(qli.Id);
        }
        List<ServiceLineItem__c> serLineItem = [select Id,Name,Service_Status__c,Reservation_Number__c FROM ServiceLineItem__c where QuotationLine__c In :qliId];
        List<ServiceLineItem__c> serLineItemList = new List<ServiceLineItem__c>();
        Integer i=1;
        for(ServiceLineItem__c sli:serLineItem){
            sli.Service_Status__c = 'Confirmed';
            sli.Reservation_Number__c = 'Confirmed_'+i;
            serLineItemList.add(sli);
            i++;
        }
        BaseTriggerHandler.bypass('TH_Quotations');
        update serLineItemList;
        Test.startTest();
        QuotationPricingController.getQuotationPricingDetails(quotationId);
        QuotationPricingController.updateQuotataionSalesValue(quotationId,2,3,4,1,2,'2018-02-20','2018-02-20');
        Test.stopTest();
        BaseTriggerHandler.clearBypass('TH_Quotations');	
        
    }
}
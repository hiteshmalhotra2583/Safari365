@isTest
private class Test_SchedulerToCheckBookingConfirmation {
  
    static List<Opportunity> opportunitys = new List<Opportunity>();
    static List<Account> accounts = new List<Account>();
    static List<Passenger__c> passengers = new List<Passenger__c>();
    static List<Quotations__c> Quotations = new List<Quotations__c>();
    static List<QuotationLineItem__c> quotationLineItems = new List<QuotationLineItem__c>();
    static List<PassengerQuotationMapping__c> passengerQuotations = new List<PassengerQuotationMapping__c>();
    static List<ServiceLineItem__c> slis = new List<ServiceLineItem__c>();
    static List<ServiceLineItemPassengersMapping__c> sliPassengers = new List<ServiceLineItemPassengersMapping__c>();
    static Integer recordCount = 1;
    static List<QuotationLineItem__c> getQuotationLineItemList;
    static QuotationBuilderDatabaseQueries dbQueries = new QuotationBuilderDatabaseQueries();
    static List<ExchangeRates__c> exchangeRates = new List<ExchangeRates__c>();
    
    static List<CRM__c> crms = new List<CRM__c>(); 
    static List<Opt__c>  opts = new List<Opt__c>();
    static List<NTS__c>  nts = new List<NTS__c>();
    static List<NCT__c>  ncts= new List<NCT__c>();
    static List<NTS__c>  crmsnts = new List<NTS__c>();
    static Integer count =1; 
    
    
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
            
            //USD
            Map<String,Object> exchangeRateMap = new Map<String,Object>();
            exchangeRateMap.put('BaseCurrency__c','USD');
            exchangeRateMap.put('USD__c',1.0d);
            //AUD
            Map<String,Object> exchangeRateMap1 = new Map<String,Object>();
            exchangeRateMap1.put('BaseCurrency__c','AUD');
            exchangeRateMap1.put('AUD__c',1.0d);
            //EUR
            Map<String,Object> exchangeRateMap2 = new Map<String,Object>();
            exchangeRateMap2.put('BaseCurrency__c','EUR');
            exchangeRateMap2.put('EUR__c',1.0d);
            //GBP
            Map<String,Object> exchangeRateMap3 = new Map<String,Object>();
            exchangeRateMap3.put('BaseCurrency__c','GBP');
            exchangeRateMap3.put('GBP__c',1.0d);
            
            for(Integer i = 0 ; i <recordCount; i++)
            {
                exchangeRates.add((ExchangeRates__c) TestDataFactory.operationOnObjectRecord(null, 'ExchangeRates__c', exchangeRateMap));
            }
            for(Integer i = 0 ; i <recordCount; i++)
            {
                exchangeRates.add((ExchangeRates__c) TestDataFactory.operationOnObjectRecord(null, 'ExchangeRates__c', exchangeRateMap1));
            }
            for(Integer i = 0 ; i <recordCount; i++)
            {
                exchangeRates.add((ExchangeRates__c) TestDataFactory.operationOnObjectRecord(null, 'ExchangeRates__c', exchangeRateMap2));
            }
            for(Integer i = 0 ; i <recordCount; i++)
            {
                exchangeRates.add((ExchangeRates__c) TestDataFactory.operationOnObjectRecord(null, 'ExchangeRates__c', exchangeRateMap3));
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
            opportunityQuotationMap.put('Itinerary_Summary__c','21123');
            opportunityQuotationMap.put('Quotation_Stage__c','Raised Invoice');
            opportunityQuotationMap.put('Raised_Booking_Confirmation_Date__c',System.today() + 5);
            opportunityQuotationMap.put('ROE_ZAR_to_CC__c',2);
            opportunityQuotationMap.put('ROE_USD_to_CC__c',2);
            opportunityQuotationMap.put('ROE_EUR_to_CC__c',2);
            
            //For Quotation Two
            Map<String,Object>  opportunityQuotationMap1 = new Map<String,Object>();
            opportunityQuotationMap1.put('Opportunity__c', opportunitys[1].ID);
            opportunityQuotationMap1.put('TravelStartDate__c',system.today());
            opportunityQuotationMap1.put('TravelEndDate__c',system.today().addDays(3));
            opportunityQuotationMap1.put('Quotation_Stage__c','Raised Invoice');
            opportunityQuotationMap1.put('ROE_ZAR_to_CC__c',2);
            opportunityQuotationMap1.put('ROE_USD_to_CC__c',2);
            opportunityQuotationMap1.put('ROE_EUR_to_CC__c',2);
            
            //For Quotation Three
            Map<String,Object>  opportunityQuotationMap2 = new Map<String,Object>();
            opportunityQuotationMap2.put('Opportunity__c', opportunitys[2].ID);
            opportunityQuotationMap2.put('TravelStartDate__c',system.today());
            opportunityQuotationMap2.put('TravelEndDate__c',system.today().addDays(3));
            opportunityQuotationMap2.put('Quotation_Stage__c','Raised Invoice');
            opportunityQuotationMap2.put('ROE_ZAR_to_CC__c',2);
            opportunityQuotationMap2.put('ROE_USD_to_CC__c',2);
            opportunityQuotationMap2.put('ROE_EUR_to_CC__c',2);
            
            //For Quotation Four
            Map<String,Object>  opportunityQuotationMap3 = new Map<String,Object>();
            opportunityQuotationMap3.put('Opportunity__c', opportunitys[0].ID);
            opportunityQuotationMap3.put('TravelStartDate__c',system.today());
            opportunityQuotationMap3.put('TravelEndDate__c',system.today().addDays(3));
            opportunityQuotationMap3.put('Itinerary_Summary__c','21123');
            opportunityQuotationMap3.put('Quotation_Stage__c','Raised Invoice');
            opportunityQuotationMap3.put('ROE_ZAR_to_CC__c',2);
            opportunityQuotationMap3.put('ROE_USD_to_CC__c',2);
            opportunityQuotationMap3.put('ROE_EUR_to_CC__c',2);
            
            Map<String,Object>  accountMap = new Map<String,Object>();
            accountMap.put('Opportunity__c' ,opportunitys[0].id );
            
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
            
            BaseTriggerHandler.bypass('OpportunityTriggerHandler');
            DAL_BaseObject.InsertDBObjects(Quotations);
            BaseTriggerHandler.clearBypass('OpportunityTriggerHandler');
            
            Map<String,Object>  passengerQuotationMapingMap = new Map<String,Object>();
            passengerQuotationMapingMap.put('Passenger__c',passengers[0].Id);
            passengerQuotationMapingMap.put('Quotation__c',Quotations[0].Id);
            for(Integer i = 0 ; i <recordCount; i++)
            {
                passengerQuotations.add((PassengerQuotationMapping__c) TestDataFactory.operationOnObjectRecord(null, 'PassengerQuotationMapping__c', passengerQuotationMapingMap));
            }
            DAL_BaseObject.InsertDBObjects(passengerQuotations);
            
            Map<String,Object>  quotationLineItemQuotationMapingMap = new Map<String,Object>();
            quotationLineItemQuotationMapingMap.put('Quotation__c',Quotations[0].Id);
           
            for(Integer i = 0 ; i <recordCount; i++)
            {
                quotationLineItems.add((QuotationLineItem__c) TestDataFactory.operationOnObjectRecord(null, 'QuotationLineItem__c', quotationLineItemQuotationMapingMap));
            }
            DAL_BaseObject.InsertDBObjects(quotationLineItems);
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
            serviceLineItemkeyValueMap1.put('QuotationLine__c',quotationLineItems[0].Id);
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
            
            for(Integer i = 0 ; i <count; i++)
            {
                ncts.add((NCT__c) TestDataFactory.operationOnObjectRecord(null, 'NCT__c', null));
            }
            insert ncts;
            
            Map<String,Object> keyValueMap = new Map<String,Object>();
            for(NCT__c nct:ncts)
            {
                keyValueMap.put('CATEGORY__c', nct.NOTECATEGORY__c);
            }
            
            for(Integer i = 0 ; i <=count; i++)
                nts.add((NTS__c) TestDataFactory.operationOnObjectRecord(null, 'NTS__c', keyValueMap));
            
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
            
            Map<String,Object> keyValueMap2 = new Map<String,Object>();
            for(CRM__c crm:crms)
            {
                keyValueMap2.put('SUPPLIER_CODE__c', crm.CODE__c);
            }
            
            for(Integer i = 0 ; i <=count; i++)
                crmsnts.add((NTS__c) TestDataFactory.operationOnObjectRecord(null, 'NTS__c', keyValueMap2));   
            insert crmsnts;
            /*=============================================================================================*/   
            
            Map<String,Object>  passengerSLIMapingMap = new Map<String,Object>();
            passengerSLIMapingMap.put('Passenger__c',passengers[0].Id);
            passengerSLIMapingMap.put('Service_Line_Item__c',slis[0].Id);
            for(Integer i = 0 ; i <recordCount; i++)
            {
                sliPassengers.add((ServiceLineItemPassengersMapping__c) TestDataFactory.operationOnObjectRecord(null, 'ServiceLineItemPassengersMapping__c', passengerSLIMapingMap));
            }
            DAL_BaseObject.InsertDBObjects(sliPassengers);
            
            GoogleDriveSetting__c GDSetting= new GoogleDriveSetting__c();
            GDSetting.Access_Token__c='ya29.Gly7Bf_N4RntWboIxqzepsNUK6peHCP128fFoFIngVB0jYcbfcu1pohoYe4Ix35AD5VT2rEUpJbBzoGmhO5usEX_iOEMVIlsW0texKNF7cx4SGkBCBkTeKeAg0YB3w';
            GDSetting.Expired_In__c='3600';
            GDSetting.Client_Id__c = '1064689029437-o8cb1ese4j3vr2cjne1jj7d5nupe40qd.apps.googleusercontent.com';
            GDSetting.Client_Secret__c = '0fOjg-EicipIWsIxRbLwbYGy';
            GDSetting.Refresh_Token__c = '1/PNE2SPiiVlD-c229simV0WbsTxmriVaB-ksm1CZKdEw';
            GDSetting.TeamDrive_Folder_Id__c ='0AGVNCjd9GIIQUk9PVA';
            GDSetting.Last_Updated__c=DateTime.Now().adddays(-1);
            insert GDSetting;
            
        }   
        
    }
    
     @isTest static void testSchedulerToCheckBookingConfirmationClass(){
        Test.startTest();
         AsyncApexJob aa = new AsyncApexJob();
       
        SchedulerToCheckBookingConfirmation stcbkconf =  new SchedulerToCheckBookingConfirmation();
        String schedule = '0 0 23 * * ?';
        system.schedule('Nightly Update', schedule, stcbkconf);
         
        Test.stopTest();
     }
}
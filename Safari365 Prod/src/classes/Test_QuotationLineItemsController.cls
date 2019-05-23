@istest
private class Test_QuotationLineItemsController {
    
    static List<Opportunity> opportunitys = new List<Opportunity>();
    static List<Account> accounts = new List<Account>();
    static List<Passenger__c> passengers = new List<Passenger__c>();
    static List<Quotations__c> Quotations = new List<Quotations__c>();
    static QuotationBuilderDatabaseQueries dbQueries = new QuotationBuilderDatabaseQueries();
    static List<OPT__c>  opts = new List<OPT__c>();
    static List<SRV__c>  srvs = new List<SRV__c>();
    static List<DB4__c>  db4s= new List<DB4__c>();
    static List<CRM__c>  crms = new List<CRM__c>();
    static List<SOD__c>  sods= new List<SOD__c>();
    static List<NCT__c>  ncts= new List<NCT__c>();
    static List<NTS__c>  nts= new List<NTS__c>();
    static List<NTS__c>  crmsnts= new List<NTS__c>();
    static List<LCL__c>  lcls= new List<LCL__c>();
    static List<OPD__c>  opds = new List<OPD__c>();
    static List<OSR__c>  osrs = new List<OSR__c>();
    
    Static Integer count =2;
    static List<PassengerQuotationMapping__c> passengerQuotations = new List<PassengerQuotationMapping__c>();
    static List<ServiceLineItem__c> slis = new List<ServiceLineItem__c>();
    static List<Service_Line_Item_ChargeType__c> sliChilds = new List<Service_Line_Item_ChargeType__c>();
    static List<ServiceLineItemPassengersMapping__c> sliPassengers = new List<ServiceLineItemPassengersMapping__c>();
    static Integer recordCount = 1;
    static List<QuotationLineItem__c> getQuotationLineItemList;
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
            
            /*=============================================================================================*/   
            Map<String,Object> keyValueMapOSR = new Map<String,Object>();
            keyValueMapOSR.put('OSR_ID__c', String.valueof(1));
            for(Integer i = 0 ; i <count; i++)
                osrs.add((OSR__c) TestDataFactory.operationOnObjectRecord(null, DAL_OSR.OBJECT_NAME, keyValueMapOSR));
            
            insert osrs;
            
            Map<String,Object> keyValueMapOPD = new Map<String,Object>();
            keyValueMapOPD.put('OSR_ID__c', String.valueof(1));
            
            for(Integer i = 0 ; i <count; i++)
            {
                opds.add((OPD__c) TestDataFactory.operationOnObjectRecord(null, DAL_OPD.OBJECT_NAME, keyValueMapOPD));
            }
            insert opds;
            
            
            
            
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
            
            Map<String,Object> keyValueMapSOD = new Map<String,Object>();
            for(CRM__c crm:crms)
            {
                keyValueMapSOD.put('SOD_ID__c', crms[0].SOD_ID__c);
            }
            
            for(Integer i = 0 ; i <count; i++){
                sods.add((SOD__c) TestDataFactory.operationOnObjectRecord(null,DAL_SOD.OBJECT_NAME , keyValueMapSOD));
            }
            insert sods;
            
            Map<String,Object> keyValueMapLCL = new Map<String,Object>();
            keyValueMapLCL.put('CODE__c','123');
            keyValueMapLCL.put('DESCR__c','123');
            for(Integer i = 0 ; i <count; i++){
                lcls.add((LCL__c) TestDataFactory.operationOnObjectRecord(null, 'LCL__c', keyValueMapLCL));
            }
            insert lcls;
            
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
            optkeyValueMap1.put('SOD_Lookup__c',sods[0].Id);
			optkeyValueMap1.put('LCL_Lookup__c',lcls[0].Id);
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
            
            serviceLineItemkeyValueMap1.put('Provisional_Booking_Expiry_Date__c',system.today());
            serviceLineItemkeyValueMap1.put('Override_details__c',false);
            serviceLineItemkeyValueMap1.put('Room_Configuration__c','TWIN AVAIL');
            serviceLineItemkeyValueMap1.put('Service_Type__c','Accommodation');
            serviceLineItemkeyValueMap1.put('ServiceLocation__c','Timbavati Game Reserve');
            serviceLineItemkeyValueMap1.put('Selected_Supplier_Id__c','123');
            serviceLineItemkeyValueMap1.put('SupplierName__c','Simbavati Hilltop Lodge');
            serviceLineItemkeyValueMap1.put('Selected_OPT_Code__c',opts[0].Code__c);
            serviceLineItemkeyValueMap1.put('Service_Date__c',System.today());
            serviceLineItemkeyValueMap1.put('Wetu_Start_Location__c','123');
            serviceLineItemkeyValueMap1.put('Wetu_End_Location__c','123');
            serviceLineItemkeyValueMap1.put('Wetu_Start_Location_Id__c','123');
            serviceLineItemkeyValueMap1.put('Wetu_End_Location_Id__c','123');
            serviceLineItemkeyValueMap1.put('Basis__c','x');
            serviceLineItemkeyValueMap1.put('Crm_Code__c','SIM005');
            serviceLineItemkeyValueMap1.put('Nett_Cost_in_EUR__c',10);
            serviceLineItemkeyValueMap1.put('Nett_Cost_in_USD__c',10);
            serviceLineItemkeyValueMap1.put('Nett_Cost__c',10);
            serviceLineItemkeyValueMap1.put('Sale_in_Eur__c',10);
            serviceLineItemkeyValueMap1.put('Sale_in_USD__c',10);
            serviceLineItemkeyValueMap1.put('Total__c',10);
            serviceLineItemkeyValueMap1.put('ClientNotes__c','abcd');
            serviceLineItemkeyValueMap1.put('Reservation_Number__c','123');
            serviceLineItemkeyValueMap1.put('Supplier_Notes__c','abcd');
            serviceLineItemkeyValueMap1.put('Service_Status__c','Confirmed');
            serviceLineItemkeyValueMap1.put('Provisional_Booking_Expiry_Date__c',date.today());
            serviceLineItemkeyValueMap1.put('Do_Not_Override_NetCost__c',true);
            serviceLineItemkeyValueMap1.put('Service_Duration__c',1.0);
            serviceLineItemkeyValueMap1.put('ClientNotes__c','123');
            serviceLineItemkeyValueMap1.put('Room_Configuration__c','123');
            serviceLineItemkeyValueMap1.put('Wetu_Start_time__c','01:00:00');
            serviceLineItemkeyValueMap1.put('Wetu_End_Time__c','01:00:00');
            serviceLineItemkeyValueMap1.put('Start_Terminal__c','123');
            serviceLineItemkeyValueMap1.put('End_Terminal__c','123');
            serviceLineItemkeyValueMap1.put('Checkin_Time__c','01:00:00');
            serviceLineItemkeyValueMap1.put('Ticket_Class__c','123');
            
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
            
            
            
            Map<String,Object> keyValueMap2 = new Map<String,Object>();
            for(CRM__c crm:crms)
            {
                keyValueMap2.put('SUPPLIER_CODE__c', crm.CODE__c);
            }
            
            for(Integer i = 0 ; i <=count; i++)
                crmsnts.add((NTS__c) TestDataFactory.operationOnObjectRecord(null, 'NTS__c', keyValueMap2));   
            
            /*=============================================================================================*/ 
            
            Map<String, Object> ServiceLineChildMap =new Map<String, Object>();
            ServiceLineChildMap.put('Service_Line_Item__c',slis[0].Id);
            ServiceLineChildMap.put('Selected_Passenger__c',passengers[0].Id);
             ServiceLineChildMap.put('Extra__c','123');
            for(Integer i = 0 ; i <recordCount; i++)
            {
                sliChilds.add((Service_Line_Item_ChargeType__c) TestDataFactory.operationOnObjectRecord(null, 'Service_Line_Item_ChargeType__c', ServiceLineChildMap));
            }
            DAL_BaseObject.InsertDBObjects(sliChilds);
            
            
            
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
    
    static testMethod void test_AllMethodsOfQuotationLineItemsController(){
        setupInsertData();
        String sliId = slis[0].Id;
        String[] data = new String[]{sliId};
            Test.startTest();
        QuotationLineItemsController.GetQuotationLineItemDate(getQuotationLineItemList[0].Id);
        QuotationLineItemsController.orderServiceLineItem(data);
        QuotationLineItemsController.getQuotationStage(Quotations[0].Id);
        QuotationLineItemsController.getQuotationLineItems(Quotations[0].Id);
        QuotationLineItemsController.getQuotationLineItemList(Quotations[0].Id);
        QuotationLineItemsController.getRelatedRecords(getQuotationLineItemList[0].Id);
        QuotationLineItemsController.getTreeTableCol();
        QuotationLineItemsController.getGrandChildRecords(slis[0].Id);
        QuotationLineItemsController.deleteServiceLineItem('');
        QuotationLineItemsController.deleteServiceLineChargeType('');
        QuotationLineItemsController.getPageDefaultOpenSetting();
        QuotationLineItemsController.getServiceStatus();
        QuotationLineItemsController.getCrmIdByCode('');
        QuotationLineItemsController.deleteSelectedItems(data);
        Test.stopTest(); 
    }
    
    static testMethod void test_AllMethodsOfQuotationBuilderDatabaseQueries(){
        setupInsertData();
        String sliId = slis[0].Id;
        String[] data = new String[]{sliId};
            Test.startTest();
        String serviceClientNotes = slis[0].ClientNotes__c;
        String serviceReservationNumber =  slis[0].Reservation_Number__c;
        String serviceSupplierNotes = slis[0].Supplier_Notes__c;
        String serviceStatus = slis[0].Service_Status__c;
        String serviceExpiryDate = String.valueOf(slis[0].Provisional_Booking_Expiry_Date__c);
        Boolean notOverrideNetCost = slis[0].Do_Not_Override_NetCost__c;
        String serviceDuration = String.valueOf(slis[0].Service_Duration__c);
        Set<String> serviceLineItemIds = new Set<String>();
        serviceLineItemIds.add(slis[0].Id);
        Set<String> selectedPassengers = new Set<String>();
        selectedPassengers.add(sliChilds[0].Selected_Passenger__c);
        Set<String> opportunityIds = new Set<String>();
        opportunityIds.add(opportunitys[0].Id);
        List<Id> quotationLineItemIds = new List<Id>();
        quotationLineItemIds.add(getQuotationLineItemList[0].Id);
        QuotationBuilderDatabaseQueries qbdq = new QuotationBuilderDatabaseQueries();
        qbdq.UpdateServiceLineItem(sliId,serviceClientNotes,serviceReservationNumber,serviceSupplierNotes,serviceStatus,serviceExpiryDate,notOverrideNetCost);
        //qbdq.RemoveServiceLineItems(sliId,serviceDuration);
        qbdq.loadPassengersForServiceLineItem(sliId);
        qbdq.loadServiceLineItem(slis[0].Id);
        qbdq.GetResidenceCountryFromQuotationId(Quotations[0].Id);
        qbdq.GetCountryMarkup('USA');
        qbdq.GetServiceTypeMarkup('Transport');
        qbdq.GetSupplierMarkup('123');
        qbdq.getPaymentDiscountsForQuotation();
        qbdq.getDueDateDifferenceForQuotation();
        qbdq.getRelatedQuotationServiceLineItems(quotationLineItemIds);
        qbdq.GetChargeTypeRelatedToServiceLineItems(serviceLineItemIds);
        qbdq.GetServiceTypes();
        qbdq.GetServiceTypeForSupplier(opts[0].CRM_Lookup__c);
        qbdq.GetLocationForSupplier(opts[0].CRM_Lookup__c,'INSERT');
        qbdq.GetLocations(opts[0].SRV_Name__c);
        qbdq.GetSupplierNames(opts[0].LOC_Name__c,opts[0].SRV_Name__c,true);
        qbdq.GetRoomConfiguration(opts[0].CRM_Lookup__c,'INSERT');
        qbdq.GetSuppplierNameLookupQuery(opts[0].LOC_Name__c,opts[0].SRV_Name__c,true);
        qbdq.GetServiceDetails(opts[0].CRM_Name__c,opts[0].SRV_Name__c,opts[0].LOC_Name__c);
        qbdq.GetServiceDetailsWithSupplierId(opts[0].CRM_Lookup__c,opts[0].SRV_Name__c,opts[0].LOC_Name__c);
        qbdq.GetNumberOfDays(Quotations[0].Id,getQuotationLineItemList[0].Id);
        qbdq.GetNumberOfNights(Quotations[0].Id,getQuotationLineItemList[0].Id);
        qbdq.GetCurrencyCodes();
        qbdq.GetChargeTypes(); 
        qbdq.GetQuotationPassengers(Quotations[0].Id);
        qbdq.GetServiceLineItemPassengers(slis[0].Id);
        qbdq.PopulateServiceChargeTypeInserviceLineItems(slis,passengers,sliPassengers,opts[0],1.0,1.0,true,1.0,crms[0].Id);
        ChargeTypeExtraRate cter = new ChargeTypeExtraRate();
        cter.ExtraRateDescription = new Map<String,String>();
        cter.ExtraRateDescription.put('123','123');
        cter.OPD = opds[0];
        qbdq.CreateExtraChargePerDayPerPerson(slis,passengers,'123',cter,'USD', 1.0,opts[0],1.0,1.0,1.0);
        qbdq.CreateExtraChargePerDayPerServiceLineItem(slis[0],passengers,'123',cter,'USD',1.0,opts[0],1.0,1.0,true,1.0,1.0);
        qbdq.CreateExtraChargePnlyOnFirstServiceLineItem(slis,passengers,'123',cter,'USD',1.0,opts[0],1.0,1.0,true,1.0,1.0);
        qbdq.validateDurationIsValid(date.today(), 1, Quotations[0].Id, '123');
        qbdq.CreateServiceLineItemChargeType(slis[0], passengers[0], 'USD',1.0,1.0,1.0,opts[0],opds[0],true,1.0,1.0);
        qbdq.GetServiceLineItemForWetu(Quotations[0].Id);
        LegDetail currentLeg = new LegDetail();
        qbdq.GetServiceLineItemForWetuLegDetail(Quotations[0].Id,currentLeg);
        qbdq.GetServiceLineItemForWetuCarHire(Quotations[0].Id);
        qbdq.getTotalPricePerPassengers(serviceLineItemIds,selectedPassengers,'USD');
        qbdq.getQuotationForPricingSummary(Quotations[0].Id);
        qbdq.GetServiceLineItemsPassengers(serviceLineItemIds);
        QuotationBuilderDatabaseQueries.allServiceLineItemRelatedToOpportunityIds(opportunityIds);
        QuotationBuilderDatabaseQueries.allServiceLineItemRelatedToOpportunity(opportunityIds);
        String[] passengerToBeSaved = new String[]{'1','2'};
        qbdq.SaveServiceLineItem(slis[0].Name,slis[0].Service_Type__c,slis[0].ServiceLocation__c,
                                 slis[0].Name,slis[0].Selected_Supplier_Id__c,
                                 slis[0].Service_Detail__c,String.valueOf(getQuotationLineItemList[0].Id),
                                 slis[0].ClientNotes__c,
                                 slis[0].Reservation_Number__c,slis[0].Supplier_Notes__c, 
                                 slis[0].Service_Status__c, String.valueOf(slis[0].Provisional_Booking_Expiry_Date__c),
                                 true,passengerToBeSaved,String.valueOf(slis[0].Service_Date__c),'1',
                                 String.valueOf(Quotations[0].Id),opts[0],passengers, slis[0].Room_Configuration__c,
                                 slis[0].Wetu_Start_Location__c,slis[0].Wetu_Start_Location_Id__c,slis[0].Wetu_End_Location__c,slis[0].Wetu_End_Location_Id__c,
                                 slis[0].Wetu_Start_time__c,slis[0].Wetu_End_time__c,slis[0].Start_Terminal__c,
                                 slis[0].End_Terminal__c,'1',slis[0].Checkin_Time__c,slis[0].Ticket_Class__c);
        
        ChargeTypeUpdate ctu = new ChargeTypeUpdate();
        ctu.ChargeTypeId = sliChilds[0].Id;
        ctu.ServiceLineItemId = slis[0].Id;
        ctu.Markup = '123';
        ctu.NettCost = '123';
        ctu.ClientNotes = '123';
        ctu.Status = '123';
        Set<ChargeTypeUpdate> chargeTypesToUpdate = new Set<ChargeTypeUpdate>();
        chargeTypesToUpdate.add(ctu);
        qbdq.updateChargeTypes(chargeTypesToUpdate);
        qbdq.RemoveServiceLineItems(slis[0].Id, '1');
        Test.stopTest(); 
    }
    
}
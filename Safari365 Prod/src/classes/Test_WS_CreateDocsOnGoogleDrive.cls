@isTest
private class Test_WS_CreateDocsOnGoogleDrive {
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
            
            Map<String,Object> exchangeRateMap = new Map<String,Object>();
            exchangeRateMap.put('BaseCurrency__c','USD');
            exchangeRateMap.put('USD__c',10);
            
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
                opportunityQuotationMap.put('Iternary_Language__c','En');
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
                //serviceLineItemkeyValueMap1.put('QuotationLine__c',QuotationLineItems[i].Id);
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
    
    @isTest static void testingAllMethodTest(){
        String fileName='Intinerary Doc',fileBody='',fileType='application/vnd.google-apps.spreadsheet';
        fileBody='UEsDBBQAAAgAAHw2t0yFbDmKLgAAAC4AAAAIAAAAbWltZXR5cGVhcHBsaWNhdGlvbi92bmQub2FzaXMub3BlbmRvY3VtZW50LnNwcmVhZHNoZWV0UEsDBBQAAAgAAHw2t0wSxxW/6AQAAOgEAAAYAAAAVGh1bWJuYWlscy90aHVtYm5haWwucG5niVBORw0KGgoAAAANSUhEUgAAAMcAAAD/CAMAAABy8jI0AAADAFBMVEUDAwMKCgoTExMaGhokJCQuLi4xMTFERERKSkpTU1NcXFxiYmJra2tzc3N8fHyEhISLi4uTk5OdnZ2kpKSurq60tLS5ubnExMTOzs7U1NTc3Nzj4+Pr6+vz8/P+/v4AAAD/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////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';
        Passenger__c passengers = [SELECT Id FROM Passenger__c limit 1];
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        RestContext.request = req;
        RestContext.response = res;
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new GoogleDriveMockResponse());
        WS_CreateDocsOnGoogleDrive.createDocsOnGoogleDrive(passengers.Id,fileName,fileBody,fileType);
        Test.stopTest();
    }
}
@isTest
private class Test_QuotationClientFacingDocController {
    
    static List<Opportunity> opportunitys = new List<Opportunity>();
    static List<Account> accounts = new List<Account>();
    static List<Passenger__c> passengers = new List<Passenger__c>();
    static List<Quotations__c> Quotations = new List<Quotations__c>();
    static List<PassengerQuotationMapping__c> passengerQuotations = new List<PassengerQuotationMapping__c>();
    static List<ServiceLineItem__c> slis = new List<ServiceLineItem__c>();
    static List<ServiceLineItemPassengersMapping__c> sliPassengers = new List<ServiceLineItemPassengersMapping__c>();
    static Integer recordCount = 1;
    static List<QuotationLineItem__c> getQuotationLineItemList = new List<QuotationLineItem__c>();
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
                opportunityQuotationMap.put('Itinerary_Summary__c','how are you I am good');
                opportunityQuotationMap.put('Wetu_Identifier__c','abcedeccc');
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
            
            //Create Quotation Line Item
            Map<String,Object>  QuotationQuotationLinitemMap = new Map<String,Object>();
            for(Integer i = 0 ; i <recordCount; i++)
            {
                QuotationQuotationLinitemMap.put('Name','QLI-'+i);
                QuotationQuotationLinitemMap.put('Quotation__c',Quotations[i].Id);
                QuotationQuotationLinitemMap.put('Line_Item_Date__c',Date.today());
                
                getQuotationLineItemList.add((QuotationLineItem__c) TestDataFactory.operationOnObjectRecord(null, 'QuotationLineItem__c',QuotationQuotationLinitemMap ));
            }
            DAL_BaseObject.InsertDBObjects(getQuotationLineItemList);
            
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
    
    @isTest static void testAllMethodsOne(){
        Quotations__c quotation = [SELECT Id,Iternary_Language__c FROM Quotations__c LIMIT 1];
        String fileName ='Intinerary Doc';
        String fileType='application/vnd.google-apps.spreadsheet';
        String fileContents='UEsDBBQAAAgAAJZNv0yFbDmKLgAAAC4AAAAIAAAAbWltZXR5cGVhcHBsaWNhdGlvbi92bmQub2FzaXMub3BlbmRvY3VtZW50LnNwcmVhZHNoZWV0UEsDBBQAAAgAAJZNv0wpZuRVoRIAAKESAAAYAAAAVGh1bWJuYWlscy90aHVtYm5haWwucG5niVBORw0KGgoAAAANSUhEUgAAAMcAAAD/CAMAAABy8jI0AAADAFBMVEUCAgILCwsTExMbGxsjIyMrKyszMzM8PDxCQkJLS0tTU1NbW1tjY2Nra2tzc3N7e3uBgYGLi4uTk5Oampqjo6Orq6uzs7O8vLzBwcHLy8vT09Pb29vj4+Pr6+v09PT+/v4AAAD///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////8/KsCgAAAPXElEQVR42u2di5qcqBKA8S7KHURBod7/LU/h9GQmm+xm853OTE4OzLS2FCA/xaUUpQn8GY5UjspROSpH5agcleO/cgld/onw52Ywkjy+EexGPL7ll/SSlv4hkvkXc6ihIU3bDdM0/0vXETLPI+m/LyhuapqS2tS1A5keovHvkpuG5RkcPDKygSPrT1SCtmglfUfQvOw9IUVbJ+EQHwqKf5uaJ+45HBwTimTKcp54zmqRbIo7naiF4sVOCGwydPSQxcLWEzJy5HVYQU/TGu5APMHFxvUGRLeuSADXSprZMmpGt8/tAds8LRHCwqnKoCmT41rKwhD2PH0ootbmdERgsu3e63YAPgMjR+qGDDNRuWmzITaR8UUfjiw7kbk38Ig3k5Af+kjd1ba56GOE0BCzzjCR3RN5otanJhmiYSfdpXCPoZrpWfoY5tlczXB6MsFBKGypb3QIucUML1hFVuKhI/nksVSdog/MxxLI4I8rvcS7XgHRuQVjbC8c0JIcIqayr5iQibDJ7FBbRVb26KJ4lj7cXZk7a+1xc2DalLQukR5QJ/6V42KUlyJ/cIAbyHA+4gUyf2kfdMBugL5yNKWnQg5U2N1z0YViTSoye3PkC56lj61Uhqa/j+8MoW9sO+iwdlA8/QtHYuRrfXCshPwRr+Qrvejj6jPktkmvHOmFoySCuW5f9PCmDz08hyMsdzUFQZhZPJS6hemq0M7YauzRYsHOxOWOnKgaixwXaRPmYd6a3RJ7x6O+tABF7rLXSy4ZV1gkQ04tKeU9ky00c/Qmt0NcsJkE0mN7K52kbsJTOBxj7O4VHec74rAVt1ExjbnxgtmM/RXjnq3qktxLZg1jBoOx4AXfvsRLku8ohBJ6KxsWMSmNqevitwqIkusEB5c741Ey5jlj2D1nZ55Tr/4Mu6RyVI7KUTkqR+WoHJWjclSOylE5KkflqByVo3JUjspROSpH5agclaNyVI7KUTkqR+WoHJWjclSOylE5KkflqByVo3JUjspROSpH5agclaNyVI7KUTkqR+WoHJWjclSOylE5KkflqByVo3JUjspROSpH5agclaNyVI4P5sjfWzPzOr8XOv/j8pr52/U9U8zhgziEmNy3/nSB9yuIvixI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';
        Test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new GoogleDriveMockResponse());
        QuotationClientFacingDocController.quotationUploadOnGoogleDrive(quotation.Id,fileName,fileType,fileContents);
        Test.stopTest();
    }
    
    @isTest static void testAllMethodsTwo(){
        Quotations__c quotation = [SELECT Id,Iternary_Language__c FROM Quotations__c LIMIT 1];
        Test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new GoogleDriveMockResponse());
        QuotationClientFacingDocController.getAllClientFacingDoc(quotation.Id);
        Test.stopTest();
    }
    
    @isTest static void testAllMethodsThree(){
        String documentId = '1sW8Fl_Zo6kjfOhVYxAMwjha9AT19GQ6VReP5mLMOFXE';
        Test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new GoogleDriveMockResponse());
        QuotationClientFacingDocController.removeGoogleDriveDocument(documentId);
        Test.stopTest();
    }
}
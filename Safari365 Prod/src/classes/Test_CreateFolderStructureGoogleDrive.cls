@isTest
private class Test_CreateFolderStructureGoogleDrive {
    
    static List<Opportunity> opportunitys = new List<Opportunity>();
    static List<Account> accounts = new List<Account>();
    static List<Passenger__c> passengers = new List<Passenger__c>();
    static List<Quotations__c> Quotations = new List<Quotations__c>();
    static List<PassengerQuotationMapping__c> passengerQuotations = new List<PassengerQuotationMapping__c>();
    static List<ServiceLineItem__c> slis = new List<ServiceLineItem__c>();
    static List<ServiceLineItemPassengersMapping__c> sliPassengers = new List<ServiceLineItemPassengersMapping__c>();
    static Integer recordCount = 1;
    static Integer count =1; 
    static List<QuotationLineItem__c> getQuotationLineItemList;
    static QuotationBuilderDatabaseQueries dbQueries = new QuotationBuilderDatabaseQueries();
    static List<ExchangeRates__c> exchangeRates = new List<ExchangeRates__c>();
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
                opportunityQuotationMap.put('Opportunity__c', opp.Id);
                opportunityQuotationMap.put('TravelStartDate__c',system.today());
                opportunityQuotationMap.put('TravelEndDate__c',system.today().addDays(3));
                accountMap.put('Opportunity__c' ,opp.Id );
                accountMap.put('Is_Primary__c' ,true);
                accountMap.put('Account__c' ,accounts[0].Id);
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
            
            for(Integer i = 0 ; i <count; i++)
            {
                
                slis.add((ServiceLineItem__c) TestDataFactory.operationOnObjectRecord(null, 'ServiceLineItem__c', quoationServiceLineMap));
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
    
    @isTest static void createFolderGoogleDriveTest1(){
        List<Quotations__c> quotationList = [SELECT Id,Iternary_Language__c FROM Quotations__c];
        List<Id> quotationIds = new List<Id>();
        for(Quotations__c quotation:quotationList){
            quotationIds.add(quotation.Id);
        }
        Test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new GoogleDriveMockResponse());
        CreateFolderStructureGoogleDrive.createFolderGoogleDriveClassic(quotationList[0].Id);
        CreateFolderStructureGoogleDrive.createFolderGoogleDrive(quotationIds);
        CreateFolderStructureGoogleDrive.createFolderGoogleDrive(quotationIds);
        Test.stopTest();
    }  
     
}
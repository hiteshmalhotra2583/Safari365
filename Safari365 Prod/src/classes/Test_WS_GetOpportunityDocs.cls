@isTest
private class Test_WS_GetOpportunityDocs {
    
    public static List<Opportunity> opportunitys = new List<Opportunity>();
    public static List<Account> accounts = new List<Account>();
    public static List<Passenger__c> passengers = new List<Passenger__c>();
    public static List<Quotations__c> Quotations = new List<Quotations__c>();
    public static List<GoogleDoc> googleDocuments = new List<GoogleDoc>();
    
    public static Integer recordCount = 1;
    
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
            
            String urlLink = 'https://docs.google.com/spreadsheets/d/1sW8Fl_Zo6kjfOhVYxAMwjha9AT19GQ6VReP5mLMOFXE/edit?usp=drivesdk';
            Map<String,Object> googleDocMap = new Map<String,Object>();
            googleDocMap.put('Url',urlLink);
            googleDocMap.put('ParentId',Quotations[0].Id);
            googleDocMap.put('Name','Client Facing Documentation');
            
            for(Integer i = 0 ; i <recordCount; i++)
            {
                googleDocuments.add((GoogleDoc) TestDataFactory.operationOnObjectRecord(null, 'GoogleDoc', googleDocMap));
            }
            DAL_BaseObject.InsertDBObjects(googleDocuments);
            
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
        Quotations__c quotation = [SELECT Id,Name FROM Quotations__c limit 1];
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        RestContext.request = req;
        RestContext.response = res;
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new GoogleDriveMockResponse());
        WS_GetOpportunityDocs.getGoogleDriveOpportunityDocs(quotation.Id);
        Test.stopTest();
    }
    
    
}
@isTest
private class WS_UpdateOpportunity_T {
  
   public static User admin_User;
    @testSetup
   static void setupInsertData(){
   
        List<Account>  accounts = new List<Account>();
        List<Opportunity>  Opportunities = new List<Opportunity>();
        Integer count =1;
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Map <String,Object> MapFieldsAndValueAcc = new Map <String,Object>();
        MapFieldsAndValueAcc.put('RecordTypeId', devRecordTypeId );
        MapFieldsAndValueAcc.put('LastName', 'TestL');
        for(Integer i = 0 ; i <count; i++){
            Account AccObj = (Account) TestDataFactory.operationOnObjectRecord(null, 'Account', MapFieldsAndValueAcc);
            accounts.add(AccObj);
        }
        insert accounts; 
        Map <String,Object> MapFieldsAndValue = new Map <String,Object>();
        MapFieldsAndValue.put('AccountId', accounts[0].Id);
        MapFieldsAndValue.put('StageName', 'TL Quotation');
        MapFieldsAndValue.put('TravelEndDate__c', System.Today()+4);
        MapFieldsAndValue.put('Client_Display_Currency__c','USD');
        Opportunities.add((Opportunity) TestDataFactory.operationOnObjectRecord(null, 'Opportunity', MapFieldsAndValue));
        insert Opportunities;
                
    }
    
     static testMethod void quotationsWSBlankTest_Negative() {
       
       Test.startTest();
       WS_UpdateOpportunity.RequestWrapper request  = new WS_UpdateOpportunity.RequestWrapper(null);
       WS_UpdateOpportunity.ResponseWrapper  response = WS_UpdateOpportunity.doPost(request);
       System.AssertEquals(response.status, 'Error');
       Test.stopTest();
        
    }
    
    static testMethod void QuotationsWSTest_Positive() {
       
       Test.startTest();
        admin_User = TestDataFactory.createUser(true,'', true);
        
        system.runAs(admin_User)
        {
	       WS_UpdateOpportunity.OpportunityInfoWrapper OppRecord  = new WS_UpdateOpportunity.OpportunityInfoWrapper ();
	       OppRecord.CurrencyType  = 'USD';
	       OppRecord.OpportunityId = [ Select Id from Opportunity ].Id;
	       WS_UpdateOpportunity.RequestWrapper request  = new WS_UpdateOpportunity.RequestWrapper(OppRecord);
	       WS_UpdateOpportunity.ResponseWrapper  response = WS_UpdateOpportunity.doPost(request);
	       System.AssertEquals(response.status, 'Success');
        }
       Test.stopTest();
        
    }
}
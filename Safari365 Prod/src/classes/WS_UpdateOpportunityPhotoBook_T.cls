@isTest
private class WS_UpdateOpportunityPhotoBook_T {
   
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
        MapFieldsAndValue.put('May_we_use_your_photographs__c',true);
        Opportunities.add((Opportunity) TestDataFactory.operationOnObjectRecord(null, 'Opportunity', MapFieldsAndValue));
        insert Opportunities;
                
    }
    
     static testMethod void quotationsWSBlankTest_Negative() {
       
       Test.startTest();
       WS_UpdateOpportunityPhotoBook.RequestWrapper request  = new WS_UpdateOpportunityPhotoBook.RequestWrapper(null);
       WS_UpdateOpportunityPhotoBook.ResponseWrapper  response = WS_UpdateOpportunityPhotoBook.doPost(request);
       system.AssertEquals(response.status, 'Error');
       Test.stopTest();
        
    }
    
    static testMethod void QuotationsWSTest_Positive() {
       
       Test.startTest();
        admin_User = TestDataFactory.createUser(true,'', true);
        
        system.runAs(admin_User)
        {
	       WS_UpdateOpportunityPhotoBook.OpportunityInfoWrapper oppRecord  = new WS_UpdateOpportunityPhotoBook.OpportunityInfoWrapper ();
	       oppRecord.photobookTitle  = 'Berlin trip';
	       Opportunity recordFromDB = [ Select Id ,May_we_use_your_photographs__c FROM Opportunity ];
	       system.debug('recordFromDB'+recordFromDB);
	       oppRecord.OpportunityId = recordFromDB.Id;
	       WS_UpdateOpportunityPhotoBook.RequestWrapper request  = new WS_UpdateOpportunityPhotoBook.RequestWrapper(oppRecord);
	       WS_UpdateOpportunityPhotoBook.ResponseWrapper  response = WS_UpdateOpportunityPhotoBook.doPost(request);
	       Opportunity recordFromDB2 = [ Select Id ,May_we_use_your_photographs__c FROM Opportunity ];
	        system.debug('after recordFromDB'+recordFromDB2);
	       system.AssertEquals(response.status, 'Success');
	       system.AssertEquals(recordFromDB.May_we_use_your_photographs__c, true);
        }
       Test.stopTest();
        
    }
}
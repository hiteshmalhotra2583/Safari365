@isTest
private class WS_GetInitiateForgetIdWorkflow_T {
   
   @testSetup
   static void setupInsertData(){
   
        List<Account>  accounts = new List<Account>();
        List<Opportunity>  Opportunities = new List<Opportunity>();
        Integer count =1;
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Map <String,Object> MapFieldsAndValueAcc = new Map <String,Object>();
        MapFieldsAndValueAcc.put('RecordTypeId', devRecordTypeId );
        MapFieldsAndValueAcc.put('LastName', 'TestL');
        MapFieldsAndValueAcc.put('PersonEmail', 'TestL@test.com');
        
        for(Integer i = 0 ; i <count; i++){
            Account AccObj = (Account) TestDataFactory.operationOnObjectRecord(null, 'Account', MapFieldsAndValueAcc);
            accounts.add(AccObj);
        }
        insert accounts; 
    }

    static testMethod void GetInitiateForgetIdWorkflowTest_Negative() {
       
       Test.startTest();
       WS_GetInitiateForgetIdWorkflow.RequestWrapper request  = new WS_GetInitiateForgetIdWorkflow.RequestWrapper();   
       request.EmailId = 'Not@Test.com';
       WS_GetInitiateForgetIdWorkflow.ResponseWrapper  response = WS_GetInitiateForgetIdWorkflow.doPost(request);
       System.AssertEquals(response.status, 'Error');
       Test.stopTest();
        
    }
    static testMethod void GetInitiateForgetIdWorkflowTest_Positive() {
       
       Test.startTest();
       WS_GetInitiateForgetIdWorkflow.RequestWrapper request  = new WS_GetInitiateForgetIdWorkflow.RequestWrapper();   
       request.EmailId = 'TestL@test.com'; 
       WS_GetInitiateForgetIdWorkflow.ResponseWrapper  response = WS_GetInitiateForgetIdWorkflow.doPost(request);
       System.AssertEquals(response.status, 'Success');
       Test.stopTest();
        
    }
}
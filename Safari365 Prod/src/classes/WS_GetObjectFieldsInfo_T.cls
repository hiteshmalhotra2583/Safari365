@isTest
private class WS_GetObjectFieldsInfo_T {
      
    static testMethod void accountFieldTest_Negative() {
       
       Test.startTest();
       WS_GetObjectFieldsInfo.RequestWrapper request  = new WS_GetObjectFieldsInfo.RequestWrapper('Account_N'); 
       WS_GetObjectFieldsInfo.ResponseWrapper  response = WS_GetObjectFieldsInfo.doPost(request);
       System.AssertEquals(response.status, 'Error');
       Test.stopTest();
        
    }
    static testMethod void accountFieldTest_Positive() {
       
       Test.startTest();
       WS_GetObjectFieldsInfo.RequestWrapper request  = new WS_GetObjectFieldsInfo.RequestWrapper('Account');
       WS_GetObjectFieldsInfo.ResponseWrapper  response = WS_GetObjectFieldsInfo.doPost(request);
       System.AssertEquals(response.status, 'Success');
       Test.stopTest();
        
    }
}
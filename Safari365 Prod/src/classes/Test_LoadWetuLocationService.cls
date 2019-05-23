@isTest
private class Test_LoadWetuLocationService {

    
        @isTest
    static void TestService()
    {
        Test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new Test_MockWetuPinHttpResponse());
        // Call method to test.
        LoadWetuLocationService.loadWetuLocation();
        Test.stopTest();
        
    }
        
}
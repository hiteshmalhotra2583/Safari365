@isTest
global class Test_MockWetuPinHttpResponse  implements HttpCalloutMock {
    
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        
        string url ='https://wetu.com/API/Pins/'+Label.WetuAPI+'/List?All=include&modifiedsince='+LoadWetuLocationService.getLastMonthDate();
        
        System.assertEquals(url, req.getEndpoint());
        System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('[{"id":64,"name":"Sun City Cascades Hotel","type":"Accommodation","last_modified":"2017-10-24T15:17:35.213"}]');
        res.setStatusCode(200);
        return res;
        
    }
}
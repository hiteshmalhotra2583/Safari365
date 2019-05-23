@isTest
global class Test_MockWetuHttpResponse implements HttpCalloutMock {

     // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
       
        string url ='https://wetu.com/Map/ItineraryServiceV7.asmx';
        
        System.assertEquals(url, req.getEndpoint());
        System.assertEquals('POST', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'text/xml; charset=utf-8');
        res.setBody('{"disclaimer": "https://openexchangerates.org/terms/","license": "https://openexchangerates.org/license/", "timestamp":1449877801,"base": "USD","rates": { "AED":3.672538,"AFN":66.809999}}');
        res.setStatusCode(200);
        return res;
    }
}
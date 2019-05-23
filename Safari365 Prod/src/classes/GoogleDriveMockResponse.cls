global class GoogleDriveMockResponse implements HttpCalloutMock {
 // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        String resBody='{';
           resBody += '"id": "1sW8Fl_Zo6kjfOhVYxAMwjha9AT19GQ6VReP5mLMOFXE",';
           resBody += '"access_token": "ya29.Gly7Bf_N4RntWboIxqzepsNUK6peHCP128fFoFIngVB0jYcbfcu1pohoYe4Ix35AD5VT2rEUpJbBzoGmhO5usEX_iOEMVIlsW0texKNF7cx4SGkBCBkTeKeAg0YB3w",';
           resBody += '"expires_in": "3600",';
           resBody += '"spreadsheetId": "1sW8Fl_Zo6kjfOhVYxAMwjha9AT19GQ6VReP5mLMOFXE",';
           resBody += '"kind": "drive#fileList",';
           resBody += '"incompleteSearch": false,';
               resBody += '"files": [{';
               resBody += '"kind": "drive#file",';
               resBody += '"id": "1sW8Fl_Zo6kjfOhVYxAMwjha9AT19GQ6VReP5mLMOFXE",';
               resBody += '"name": "Intinerary Doc",';
               resBody += '"mimeType": "application/vnd.google-apps.spreadsheet"';
               resBody += '},{';
               resBody += '"kind": "drive#file",';
               resBody += '"id": "1pfHle3jQuH9Q-swDt0M58lZ2JrUJnNt1",';
               resBody += '"name": "Client Facing Documentation",';
               resBody += '"mimeType": "application/vnd.google-apps.folder",';
        	   resBody += '"teamDriveId": "0AGVNCjd9GIIQUk9PVA"';
        	   resBody +=  '},{';
               resBody += '"kind": "drive#file",';
               resBody += '"id": "1pfHle3jQuH9Q-swDt0M58lZ2JrUJnNt1",';
               resBody += '"name": "Q-00003360",';
               resBody += '"mimeType": "application/vnd.google-apps.folder",';
        	   resBody += '"teamDriveId": "0AGVNCjd9GIIQUk9PVA"';
        	   resBody +=  '},{';
               resBody += '"kind": "drive#file",';
               resBody += '"id": "1pfHle3jQuH9Q-swDt0M58lZ2JrUJnNt1",';
               resBody += '"name": "Internal Documentation - Travelling Files",';
               resBody += '"mimeType": "application/vnd.google-apps.folder",';
        	   resBody += '"teamDriveId": "0AGVNCjd9GIIQUk9PVA"';
        	   resBody +=  '}],';
        	   resBody += '"items": [{';
               resBody += '"kind": "drive#childReference",';
               resBody += '"id": "1bHjhU9BwivgmSFWuMbKKjQprRRM7Jbgv",';
        	   resBody += '"mimeType": "application/vnd.openxmlformats-officedocument.wordprocessingml.document",';
               resBody += '"modifiedDate": "2018-06-14T13:08:32.657Z",';
               resBody += '"selfLink": "https://www.googleapis.com/drive/v2/files/1SARvvFLAYH9P17ZA0DJWhhva-P30yyS8/children/1bHjhU9BwivgmSFWuMbKKjQprRRM7Jbgv",';
        	   resBody += '"alternateLink": "https://drive.google.com/a/safari365.com/file/d/1FYBAAM-XIOIm_2mI-8J-hO3xwtGlhh8H/view?usp=drivesdk",';       
        	   resBody += '"childLink": "https://www.googleapis.com/drive/v2/files/1bHjhU9BwivgmSFWuMbKKjQprRRM7Jbgv"';
               resBody += '},{';
               resBody += '"kind": "drive#file",';
               resBody += '"id": "1FYBAAM-XIOIm_2mI-8J-hO3xwtGlhh8H",';
        	   resBody += '"mimeType": "application/vnd.openxmlformats-officedocument.wordprocessingml.document",';
        	   resBody += '"modifiedDate": "2018-06-14T13:08:32.657Z",';
               resBody += '"selfLink": "https://www.googleapis.com/drive/v2/files/1FYBAAM-XIOIm_2mI-8J-hO3xwtGlhh8H",';
        	   resBody += '"alternateLink": "https://drive.google.com/a/safari365.com/file/d/1FYBAAM-XIOIm_2mI-8J-hO3xwtGlhh8H/view?usp=drivesdk",';
               resBody += '"childLink": "https://www.googleapis.com/drive/v2/files/1bHjhU9BwivgmSFWuMbKKjQprRRM7Jbgv"';
               resBody += '}]';
           resBody +=   '}';
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(resBody);
        res.setStatusCode(200);
        return res;
    }
}
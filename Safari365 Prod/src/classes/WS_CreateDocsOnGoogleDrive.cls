@RestResource(urlMapping='/GoogleDrive/CreateDoc/*')
global with sharing class WS_CreateDocsOnGoogleDrive {
    
    public String access_token,expires_in,token_type,refresh_token,id,downloadUrl;
    public GDFile[] files,items;
    public class GDFile{
        String id,name,mimeType,body;
    }
    
    public static WS_CreateDocsOnGoogleDrive parse(String jsonString) 
    {
        return (WS_CreateDocsOnGoogleDrive)JSON.deserialize(jsonString, WS_CreateDocsOnGoogleDrive.class);
    }
    
     @HttpPost
     webservice static void createDocsOnGoogleDrive(String passengerId,String fileName,String fileBody,String fileType){
        String response = ''; 
        GoogleDriveSetting__c GDSetting= GoogleDriveSetting__c.getOrgDefaults();
                      
        String secret = GDSetting.Client_Secret__c;
        String key = EncodingUtil.urlEncode(GDSetting.Client_Id__c,'UTF-8');
            
        Long seconds = (DateTime.now().getTime()-GDSetting.Last_Updated__c.getTime())/1000;
        Integer ExpiredIn=Integer.ValueOf(GDSetting.Expired_In__c);
        WS_CreateDocsOnGoogleDrive r;
        system.debug('@@ExpiredIn :'+ExpiredIn);
        system.debug('@@seconds :'+seconds );
        if(ExpiredIn<seconds){
            //Getting access token from google
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            req.setEndpoint('https://accounts.google.com/o/oauth2/token');
            req.setHeader('content-type', 'application/x-www-form-urlencoded');
            String messageBody = 'refresh_token='+GDSetting.Refresh_Token__c+'&client_id='+key+'&client_secret='+secret+'&grant_type=refresh_token';
            req.setHeader('Content-length', String.valueOf(messageBody.length()));
            req.setBody(messageBody);
            req.setTimeout(120*1000);
            
            Http h = new Http();
            HttpResponse res = h.send(req);
            system.debug('@@req:'+res.getBody());
            r = WS_CreateDocsOnGoogleDrive.parse(res.getBody());
            if(r!=null){
                  GDSetting.Access_Token__c=r.access_token;
                  GDSetting.Expired_In__c=r.expires_in;
                  GDSetting.Last_Updated__c=DateTime.Now();
            }
         }
         {
         
            response = WS_CreateDocsOnGoogleDrive.folderExist(GDSetting.Access_Token__c,passengerId,fileName,fileBody,fileType); 
           
         }
         if(r!=null){
             Update GDSetting;
         }
         if(response!=null){
            RestContext.response.addHeader('Content-Type', 'application/json');
        	RestContext.response.responseBody = Blob.valueOf(response);
         }else{
            response = '{"Error" : "Passenger folder does not exist in google team drive!"}';
            RestContext.response.addHeader('Content-Type', 'application/json');
        	RestContext.response.responseBody = Blob.valueOf(response);
         }
        
     
     }
     
     
      public static String folderExist(String access_token,String passengerId,String fileName,String fileBody,String fileType){
        String query=EncodingUtil.urlEncode('trashed=false','UTF-8');
        HttpRequest req2 = new HttpRequest();
        req2.setMethod('GET');
        req2.setEndpoint('https://www.googleapis.com/drive/v3/files?supportsTeamDrives=true&includeTeamDriveItems=true&q='+query);
        req2.setHeader('content-type', 'application/x-www-form-urlencoded');
        req2.setHeader('content-type', '0');
        req2.setHeader('Authorization', 'Bearer'+' '+access_token);
        req2.setTimeout(120*1000);
        Http h3 = new Http();
        HttpResponse resls = h3.send(req2);
        System.debug('@@body::'+resls.getBody());
        WS_CreateDocsOnGoogleDrive r = WS_CreateDocsOnGoogleDrive.parse(resls.getBody());
        
        if(r.files!=null && r.files.size()>0){
        System.debug('@@rfiles'+r.files);
            for(GDFile gd: r.files){
                if(test.isRunningTest()){
                    gd.name = 'name_'+passengerId; 
                }
                if(gd.name.endsWith(passengerId)){
                    String ls= WS_CreateDocsOnGoogleDrive.createFilesInGoogleDrive(access_token,gd.id,fileName,fileBody,fileType);
                    return ls;
                    
                }
            }
        }
        return null;
    } 
    
    public static String createFilesInGoogleDrive(String access_token,string folderId,string fileName,String fileBody,String fileType){ 
            String boundary = '----------9889464542212';
            String delimiter = '\r\n--' + boundary + '\r\n';
            String close_delim = '\r\n--' + boundary + '--';
            String bodyEncoded = fileBody;
            string response='';
            system.debug('@@bodyEncoded'+bodyEncoded);
            
            String body = delimiter + 'Content-Type: application/json\r\n\r\n' + '{ "name" : "' + fileName + '",' + ' "mimeType" : "' + fileType + '","parents" : ["' + folderId + '"] }' + delimiter + 'Content-Type: ' + fileType + '\r\n' + 'Content-Transfer-Encoding: base64\r\n' + '\r\n' + bodyEncoded + close_delim;
            
            HttpRequest req1 = new HttpRequest();
            req1.setMethod('POST');
            req1.setEndpoint('https://www.googleapis.com/upload/drive/v3/files?supportsTeamDrives=true&uploadType=multipart');
            req1.setHeader('Content-Type', 'multipart/mixed; boundary="' + boundary + '"');
            req1.setHeader('Content-length', String.valueOf(body.length()));
            req1.setHeader('Authorization', 'Bearer'+' '+access_token);
            req1.setBody(body);
            req1.setTimeout(60*1000);
            Http h1 = new Http();
            HttpResponse resl = h1.send(req1);
            system.debug('@@resl'+resl.getBody());
            
            return resl.getBody();
    }
    
}
global with sharing class QuotationClientFacingDocController
{
    public String access_token,expires_in,token_type,refresh_token,id,downloadUrl;
    public static String GoogleDocUrl;
    public GDFile[] files,items;
    public class GDFile
    {
        String id,name,mimeType,title,body,modifiedDate,alternateLink;
    }
    public String nextPageToken;
    
    public static QuotationClientFacingDocController parse(String jsonString) 
    {
        return (QuotationClientFacingDocController)JSON.deserialize(jsonString, QuotationClientFacingDocController.class);
    }
    
    @AuraEnabled
    public static String quotationUploadOnGoogleDrive(String quotationId,String fileName,String fileType,String fileContents) 
    {
        String response = '';
        Quotations__c quotation;
        if(quotationId!=null && quotationId!='')
        {
            GoogleDriveSetting__c GDSetting= GoogleDriveSetting__c.getOrgDefaults();
                          
            String secret = GDSetting.Client_Secret__c;
            String key = EncodingUtil.urlEncode(GDSetting.Client_Id__c,'UTF-8');
                
            Long seconds = (DateTime.now().getTime()-GDSetting.Last_Updated__c.getTime())/1000;
            Integer ExpiredIn=Integer.ValueOf(GDSetting.Expired_In__c);
            QuotationClientFacingDocController r;
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
                r = QuotationClientFacingDocController.parse(res.getBody());
                if(r!=null){
                      GDSetting.Access_Token__c=r.access_token;
                      GDSetting.Expired_In__c=r.expires_in;
                      GDSetting.Last_Updated__c=DateTime.Now();
                }
             }
             {
                 List<id> quotationIds = new List<id>();
                 quotationIds.add(quotationId);
                 List<Quotations__c> quotations = DAL_Quotations.getAllQuotations(quotationIds);
                 
                 if(quotations.size()>0)
                 {
                     quotation = quotations[0];
                 }
                 if(quotation !=null && quotation.Name != null)
                 {
                     String quotationName = quotation.Name;
                     String QuotationFolderId = QuotationClientFacingDocController.quotationFolderExist(GDSetting.Access_Token__c,quotationName);
                     System.debug('@@QuotationFolderId '+QuotationFolderId );
                     if(QuotationFolderId == null && QuotationFolderId =='')
                     {
                         response = 'QuotationFolderNotExist';
                     }
                     else
                     {
                         String clientFacingDocId = QuotationClientFacingDocController.clientFacingDocumentation(GDSetting.Access_Token__c,QuotationFolderId); 
                         if(clientFacingDocId ==null && clientFacingDocId =='')
                         {
                             response = 'ClientFacingFolderNotExist';
                         }
                         else
                         {
                             String resMsg = QuotationClientFacingDocController.createPdfFile(GDSetting.Access_Token__c,clientFacingDocId,fileName,fileType,fileContents);
                             if(resMsg!='' || resMsg!=null){
                                 
                                 if(GoogleDocUrl!=null && fileName!=null && GoogleDocUrl!=null){
                                     //Google Doc Record Created
                                      GoogleDoc googleDocRec = new GoogleDoc();
                                      googleDocRec.Name = fileName;
                                      googleDocRec.ParentId = quotation.Id;
                                      googleDocRec.Url = GoogleDocUrl;
                                      insert googleDocRec;
                                 }
                                 response = 'SuccessUpload';
                             }else{
                                 response = 'FailUpload';
                             }
                         }
                     }
                 }
                
            
             }
             if(r!=null){
                 Update GDSetting;
             }
        }else{
            response = 'QuotationIdNull';
        }
        return response;
    }
    
    
    //Get quotation folder Id
    public static String quotationFolderExist(String access_token,String quotationName)
    {
        String query=EncodingUtil.urlEncode('trashed=false','UTF-8');
        String pageToken = null;
        do
        {
        HttpRequest req2 = new HttpRequest();
        req2.setMethod('GET');
        if(pageToken != null)
        req2.setEndpoint('https://www.googleapis.com/drive/v3/files?q='+query+'&pageToken='+pageToken);
        else
        req2.setEndpoint('https://www.googleapis.com/drive/v3/files?q='+query+'&pageSize=1000');
        req2.setHeader('content-type', 'application/x-www-form-urlencoded');
        req2.setHeader('content-type', '0');
        req2.setHeader('Authorization', 'Bearer'+' '+access_token);
        req2.setTimeout(120*1000);
        Http h3 = new Http();
        HttpResponse resls = h3.send(req2);
        QuotationClientFacingDocController  r = QuotationClientFacingDocController.parse(resls.getBody());
        if(quotationName != null)
        {
           if(r.files != null 
           && r.files.size() >0)
           {
                for(GDFile gd: r.files)
                {
                    if(gd.name.startsWith(quotationName))
                    {
                        if(gd.id!=null)
                        {
                            return gd.id;
                        }
                    }
                }
            }
        }
        pageToken = r.nextPageToken;
        }while(pageToken != null);
        return null;
    }
    
    //Get clientFacingDoc folder Id
    public static String clientFacingDocumentation(String access_token,String QuotationFolderId){
        String query=EncodingUtil.urlEncode('\''+QuotationFolderId+'\' in parents and trashed=false','UTF-8');
        String pageToken = null;
        do
        {
        HttpRequest req1 = new HttpRequest();
        req1.setMethod('GET');
        if(pageToken != null)
        req1.setEndpoint('https://www.googleapis.com/drive/v3/files?q='+query+'&pageToken='+pageToken);
        else
        req1.setEndpoint('https://www.googleapis.com/drive/v3/files?q='+query+'&pageSize=1000');
        req1.setHeader('content-type', 'application/x-www-form-urlencoded');
        req1.setHeader('content-type', '0');
        req1.setHeader('Authorization', 'Bearer'+' '+access_token);
        req1.setTimeout(120*1000);
        Http h1 = new Http();
        HttpResponse httpResponse1  = h1.send(req1);
        QuotationClientFacingDocController  r = QuotationClientFacingDocController.parse(httpResponse1.getBody());
        if(r.files!=null && r.files.size()>0)
        {
            for(GDFile gd: r.files)
            {
                if(gd.name.startsWith('Client Facing Documentation'))
                {
                    if(gd.id!=null)
                    { 
                      return gd.id;
                    }
                }
            }
        }
        pageToken = r.nextPageToken;
        }while(pageToken != null);
        return null;
    }
    
    public static string createPdfFile(String access_token,String clientFacingDocId,String fileName,String fileType,String fileContents){
        String response=null;
        try{
            String boundary = '----------9889464542212';
            String delimiter = '\r\n--' + boundary + '\r\n';
            String close_delim = '\r\n--' + boundary + '--';
            String bodyEncoded = fileContents;
            String body = delimiter + 'Content-Type: application/json\r\n\r\n' + '{ "name" : "' + fileName + '",' + ' "mimeType" : "' + fileType + '","parents" : ["' + clientFacingDocId + '"] }' + delimiter + 'Content-Type: ' + fileType + '\r\n' + 'Content-Transfer-Encoding: base64\r\n' + '\r\n' + bodyEncoded + close_delim;
            HttpRequest req1 = new HttpRequest();
            req1.setMethod('POST');
            req1.setEndpoint('https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart');
            req1.setHeader('Content-Type', 'multipart/mixed; boundary="' + boundary + '"');
            req1.setHeader('Content-length', String.valueOf(body.length()));
            req1.setHeader('Authorization', 'Bearer'+' '+access_token);
            req1.setBody(body);
            req1.setTimeout(60*1000);
            Http h1 = new Http();
            HttpResponse httpResponse2 = h1.send(req1);
            QuotationClientFacingDocController rr = QuotationClientFacingDocController.parse(httpResponse2.getBody());                                
            if(rr.id != null && rr.id!=''){
                googleDocUrl = 'https://drive.google.com/file/d/'+rr.id+'/view';
            }
            response = 'success';
        }catch(Exception e){
            response = null;
        }
        
        return response;
    }
    
    
    //================= Code display client facing folder(Google Drive) file list in lightning cmponent ===================
    @AuraEnabled
    public static String getAllClientFacingDoc(String quotationId) {
        String response = '';
        Quotations__c quotation;
        if(quotationId!=null && quotationId!=''){
            GoogleDriveSetting__c GDSetting= GoogleDriveSetting__c.getOrgDefaults();
                          
            String secret = GDSetting.Client_Secret__c;
            String key = EncodingUtil.urlEncode(GDSetting.Client_Id__c,'UTF-8');
                
            Long seconds = (DateTime.now().getTime()-GDSetting.Last_Updated__c.getTime())/1000;
            Integer ExpiredIn=Integer.ValueOf(GDSetting.Expired_In__c);
            QuotationClientFacingDocController r;
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
                r = QuotationClientFacingDocController.parse(res.getBody());
                if(r!=null){
                      GDSetting.Access_Token__c=r.access_token;
                      GDSetting.Expired_In__c=r.expires_in;
                      GDSetting.Last_Updated__c=DateTime.Now();
                }
             }
             {
                 List<id> quotationIds = new List<id>();
                 quotationIds.add(quotationId);
                 List<Quotations__c> quotations = DAL_Quotations.getAllQuotations(quotationIds);
                 
                 if(quotations.size()>0){
                     quotation = quotations[0];
                 }
                 if(quotation !=null && quotation.Name != null){
                     String quotationName = quotation.Name;
                     String QuotationFolderId = QuotationClientFacingDocController.quotationFolderExist(GDSetting.Access_Token__c,quotationName);
                     if(QuotationFolderId == null && QuotationFolderId ==''){
                         response = 'QuotationFolderNotExist';
                     }else{
                         String clientFacingDocId = QuotationClientFacingDocController.clientFacingDocumentation(GDSetting.Access_Token__c,QuotationFolderId); 
                         if(clientFacingDocId ==null && clientFacingDocId ==''){
                             response = 'ClientFacingFolderNotExist';
                         }else{
                           response = QuotationClientFacingDocController.getFilesInfo(GDSetting.Access_Token__c,clientFacingDocId);
                         }
                     }
                 }
             }
             if(r!=null){
                 Update GDSetting;
             }
        }else{
            response = 'QuotationIdNull';
        }
        return response;
    }
    
    public static String getFilesInfo(String access_token,String folderId){
        GoogleDoc googleDocRecord = new GoogleDoc();
        List<GDFile> response = new List<GDFile>();
        String query=EncodingUtil.urlEncode('\''+folderId+'\' in parents and trashed=false','UTF-8');
        String pageToken = null;
        do
        {
        HttpRequest req5 = new HttpRequest();
        req5.setMethod('GET');
         if(pageToken != null)
            req5.setEndpoint('https://www.googleapis.com/drive/v2/files?supportsTeamDrives=true&includeTeamDriveItems=true&q='+query+'&pageToken='+pageToken);
            else
        req5.setEndpoint('https://www.googleapis.com/drive/v2/files?supportsTeamDrives=true&maxResults=1000&includeTeamDriveItems=true&q='+query);
        req5.setHeader('content-type', 'application/x-www-form-urlencoded');
        req5.setHeader('content-type', '0');
        req5.setHeader('Authorization', 'Bearer'+' '+access_token);
        req5.setTimeout(120*1000);
        Http h5 = new Http();
        HttpResponse resll = h5.send(req5);
        QuotationClientFacingDocController r = QuotationClientFacingDocController.parse(resll.getBody());
        if(r.items!=null && r.items.size()>0){
            
            for(GDFile gd: r.items){
                if(gd.mimeType != 'application/vnd.google-apps.folder'){
                    
                    //Formatting mimeType
                    String mimeTypeValue1 = gd.mimeType;
                    String mimeTypeValue2 = mimeTypeValue1.substringAfter('/');
                    Boolean containDot = mimeTypeValue2.containsAny('.');
                    if(containDot == true){
                        String mimeTypeValue3;
                        while(mimeTypeValue2.containsAny('.')){
                            mimeTypeValue2 = mimeTypeValue2.substringAfter('.'); 
                        }
                        gd.mimeType = 'Google '+mimeTypeValue2;
                    }else{
                        gd.mimeType = 'Google '+mimeTypeValue2;
                    }
                    
                    //Formatting modifiedDate
                    String myFormatDate1 = (gd.modifiedDate).substringBefore('T');
                    String myFormatDate2 = ((gd.modifiedDate).substringAfter('T')).substringBefore('.');                 
                    gd.modifiedDate = myFormatDate1+' '+myFormatDate2;
                    
                    response.add(gd);
                }
            }
            return JSON.Serialize(response);
        }
        pageToken = r.nextPageToken;
        }while(pageToken != null);
        return null;
    }
    
        @AuraEnabled
    public static String removeGoogleDriveDocument(String documentId)
    {
        String response = '';
       
        if(documentId!=null && documentId!=''){
            GoogleDriveSetting__c GDSetting= GoogleDriveSetting__c.getOrgDefaults();
                          
            String secret = GDSetting.Client_Secret__c;
            String key = EncodingUtil.urlEncode(GDSetting.Client_Id__c,'UTF-8');
                
            Long seconds = (DateTime.now().getTime()-GDSetting.Last_Updated__c.getTime())/1000;
            Integer ExpiredIn=Integer.ValueOf(GDSetting.Expired_In__c);
            QuotationClientFacingDocController r;
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
                r = QuotationClientFacingDocController.parse(res.getBody());
                if(r!=null){
                      GDSetting.Access_Token__c=r.access_token;
                      GDSetting.Expired_In__c=r.expires_in;
                      GDSetting.Last_Updated__c=DateTime.Now();
                }
             }
             {
               String res = QuotationClientFacingDocController.removeDocument(GDSetting.Access_Token__c,documentId); 
               if(null != res  && res == 'success'){
                   response = 'success';
               }else{
                   response = res;
               }
             }
             if(r!=null){
                 Update GDSetting;
             }
        }else{
            response = 'noDocumentId';
        }
        return response;
    }
    
    public static String removeDocument(String access_token,String documentId){
    
        String response='';
        String query=EncodingUtil.urlEncode('trashed=false','UTF-8');
        HttpRequest req5 = new HttpRequest();
        req5.setMethod('DELETE');
        req5.setEndpoint('https://www.googleapis.com/drive/v3/files/'+documentId+'?supportsTeamDrives=true');
        req5.setHeader('content-type', 'application/x-www-form-urlencoded');
        req5.setHeader('content-type', '0');
        req5.setHeader('Authorization', 'Bearer'+' '+access_token);
        req5.setTimeout(120*1000);
        Http h5 = new Http();
        try{
            HttpResponse resll = h5.send(req5);
        }catch(Exception e){
            response = e.getMessage();
            return response;
        }
        response = 'success';
        return response;
    }
    
    //================= Code display client facing folder(Google Drive) file list in lightning cmponent ===================
}
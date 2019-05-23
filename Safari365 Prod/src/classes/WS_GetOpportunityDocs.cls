@RestResource(urlMapping='/Safari365/Opportunity/GetGoogleTeamDriveDoc/*')
global with sharing class WS_GetOpportunityDocs
{
    public String access_token,expires_in,token_type,refresh_token,id,downloadUrl;
    public GDFile[] files,items;
    public String nextPageToken;
    public class GDFile{
        String id,name,mimeType,body;
    }
    
    public static WS_GetOpportunityDocs parse(String jsonString) 
    {
        return (WS_GetOpportunityDocs )JSON.deserialize(jsonString, WS_GetOpportunityDocs.class);
    }
    
     @HttpPost
     webservice static void getGoogleDriveOpportunityDocs(String quotationId){        
        String response = '';
        Quotations__c quotation;
        if(quotationId!=null && quotationId!='')
        {
            GoogleDriveSetting__c GDSetting= GoogleDriveSetting__c.getOrgDefaults();
            String secret = GDSetting.Client_Secret__c;
            String key = EncodingUtil.urlEncode(GDSetting.Client_Id__c,'UTF-8');
            Long seconds = (DateTime.now().getTime()-GDSetting.Last_Updated__c.getTime())/1000;
            Integer ExpiredIn=Integer.ValueOf(GDSetting.Expired_In__c);
            WS_GetOpportunityDocs r;
            if(ExpiredIn<seconds)
            {
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
                r = WS_GetOpportunityDocs.parse(res.getBody());
                if(r!=null)
                {
                      GDSetting.Access_Token__c=r.access_token;
                      GDSetting.Expired_In__c=r.expires_in;
                      GDSetting.Last_Updated__c=DateTime.Now();
                }
            }
           
           try
            { 
                List<id> quotationIds = new List<id>();
                quotationIds.add(quotationId);
                List<Quotations__c> quotations = DAL_Quotations.getAllQuotations(quotationIds);
                system.debug('@@WS_GetOpportunityDocs:::quotations'+quotations);
                if(quotations.size()>0)
                {
                    quotation = quotations[0];
                }
            }catch(Exception e){
                 response = '{"Error" : '+e.getMessage()+'}';
            }
        
            if(quotation !=null && quotation.Name != null)
            {
                 String quotationName = quotation.Name;
                 String QuotationFolderId = WS_GetOpportunityDocs.quotationFolderExist(GDSetting.Access_Token__c,quotationName,GDSetting.TeamDrive_Folder_Id__c); 
                 if(QuotationFolderId == null && QuotationFolderId =='')
                 {
                     response = '{"Error" : "Quotation Folder Does Not Exist!"}';
                 }else
                 {
                     String clientFacingDocId = WS_GetOpportunityDocs.clientFacingDocumentation(GDSetting.Access_Token__c,QuotationFolderId); 
                     if(clientFacingDocId ==null && clientFacingDocId =='')
                     {
                         response = '{"Error" : "Client Facing Document Folder Does Not Exist!"}';
                     }else
                     {
                         response = WS_GetOpportunityDocs.getFilesInfo(GDSetting.Access_Token__c,clientFacingDocId);
                     }
                 }  
             }
             else
             {
                 response = '{"Error" : "Quotation Does Not Exist!"}';
             } 
         if(r!=null)
         {
             Update GDSetting;
         }
        }
        else
        {
            response = '{"Error" : "Please Enter Quotation Id!"}';
        }
        if(response!=null && response!=''){
            RestContext.response.addHeader('Content-Type', 'application/json');
            RestContext.response.responseBody = Blob.valueOf(response);
        }else{
            response = '{"Error" : "Quotation Folder Does Not Exist!"}';
            RestContext.response.addHeader('Content-Type', 'application/json');
            RestContext.response.responseBody = Blob.valueOf(response);
        }
        
    }
        
    //Get quotation folder Id
    public static String quotationFolderExist(String access_token,String quotationName,String teamDriveFolderId)
    {
        String query=EncodingUtil.urlEncode('trashed=false','UTF-8');
        String pageToken = null;
        do
        {
        HttpRequest req2 = new HttpRequest();
        req2.setMethod('GET');
        if(pageToken != null)
        req2.setEndpoint('https://www.googleapis.com/drive/v3/files?q='+query+'&pageSize=1000&pageToken='+pageToken);
        else
        req2.setEndpoint('https://www.googleapis.com/drive/v3/files?q='+query+'&pageSize=1000');
        req2.setHeader('content-type', 'application/x-www-form-urlencoded');
        req2.setHeader('content-type', '0');
        req2.setHeader('Authorization', 'Bearer'+' '+access_token);
        req2.setTimeout(120*1000);
        Http h3 = new Http();
        HttpResponse resls = h3.send(req2);
        WS_GetOpportunityDocs  r = WS_GetOpportunityDocs.parse(resls.getBody());
        if(quotationName != null)
        {
           if(r.files!=null && r.files.size()>0)
           {
	            for(GDFile gd: r.files)
	            {
	                //System.debug('@@gd.name : '+gd.name);
	                if(gd.name.startsWith(quotationName))
	                {
	                    //System.debug('@@found quotation'+quotationName);
	                    if(gd.id != null)
	                    {
	                        //System.debug('@@quotation folder id'+gd.id);
	                        return gd.id;
	                    }
	                }
	            }
            }
        }
         pageToken = r.nextPageToken;
        system.debug('pageToken:::'+pageToken);
      }while(pageToken != null);
        return null;
    } 
    
    //Get clientFacingDoc folder Id
    public static String clientFacingDocumentation(String access_token,String QuotationFolderId)
    {
        String query=EncodingUtil.urlEncode('\''+QuotationFolderId+'\' in parents and trashed=false','UTF-8');
        String pageToken = null;
        do
        {
        HttpRequest req1 = new HttpRequest();
        req1.setMethod('GET');
        if(pageToken != null)
        req1.setEndpoint('hhttps://www.googleapis.com/drive/v3/files?q='+query+'&pageToken='+pageToken);
        else
        req1.setEndpoint('https://www.googleapis.com/drive/v3/files?q='+query);
        req1.setHeader('content-type', 'application/x-www-form-urlencoded');
        req1.setHeader('content-type', '0');
        req1.setHeader('Authorization', 'Bearer'+' '+access_token);
        req1.setTimeout(120*1000);
        Http h1 = new Http();
        HttpResponse httpResponse1  = h1.send(req1);
        
        WS_GetOpportunityDocs  r = WS_GetOpportunityDocs.parse(httpResponse1.getBody());
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
       system.debug('pageToken:::'+pageToken);
      }while(pageToken != null);
      return null;
    }
    
    public static String getFilesInfo(String access_token,String folderId)
    {
        GoogleDoc googleDocRecord = new GoogleDoc();
        List<GDFile> response = new List<GDFile>();
        String query=EncodingUtil.urlEncode('\''+folderId+'\' in parents and trashed=false','UTF-8');
        HttpRequest req5 = new HttpRequest();
        req5.setMethod('GET');
        req5.setEndpoint('https://www.googleapis.com/drive/v3/files?q='+query+'&pageSize=1000');
        req5.setHeader('content-type', 'application/x-www-form-urlencoded');
        req5.setHeader('content-type', '0');
        req5.setHeader('Authorization', 'Bearer'+' '+access_token);
        req5.setTimeout(120*1000);
        Http h5 = new Http();
        HttpResponse resll = h5.send(req5);
        WS_GetOpportunityDocs r = WS_GetOpportunityDocs.parse(resll.getBody());
        if(r.files!=null && r.files.size()>0)
        {
            for(GDFile gd: r.files)
            {
                if(gd.mimeType != 'application/vnd.google-apps.folder')
                {
                    String FileId = gd.id;
                    HttpRequest req6 = new HttpRequest();
                    req6.setMethod('GET');
                    if(gd.mimeType == 'application/vnd.google-apps.spreadsheet' || gd.mimeType == 'application/vnd.ms-excel')
                    {                
                        system.debug('@@FileId'+FileId);
                        req6.setEndpoint('https://www.googleapis.com/drive/v3/files/'+FileId+'/export?supportsTeamDrives=true&mimeType=application/x-vnd.oasis.opendocument.spreadsheet');
                    }
                    else if(gd.mimeType == 'application/vnd.google-apps.document')
                    {                             
                        req6.setEndpoint('https://www.googleapis.com/drive/v3/files/'+FileId+'/export?supportsTeamDrives=true&mimeType=application/vnd.openxmlformats-officedocument.wordprocessingml.document');
                    }
                    else if(gd.mimeType == 'image/png' || gd.mimeType == 'image/jpg' || gd.mimeType == 'application/pdf')
                    {
                        req6.setEndpoint('https://www.googleapis.com/drive/v3/files/'+FileId+'?alt=media&supportsTeamDrives=true');
                    }else
                    {
                        continue;
                    }
                    
                    req6.setHeader('content-type', 'application/x-www-form-urlencoded');
                    req6.setHeader('content-type', '0');
                    req6.setHeader('Authorization', 'Bearer'+' '+access_token);
                    req6.setTimeout(60*1000);
                    Http h6 = new Http();
                    HttpResponse resll6 = h6.send(req6);
                    system.debug('resll6 getBodyAsBlob'+resll6.getBodyAsBlob());
                    
                    String urlLink = 'https://docs.google.com/spreadsheets/d/'+gd.id+'/edit?usp=drivesdk';
                    googleDocRecord = [SELECT Id, Url FROM GoogleDoc WHERE Url=:urlLink];
                    if(googleDocRecord != null)
                    gd.id = googleDocRecord.Id;
                    else
                    gd.id = '';
                    
                    //gd.body = EncodingUtil.base64Encode(resll6.getBodyAsBlob());
                    response.add(gd);
                }
            }
            
            return JSON.Serialize(response);
        }
        return null;
    }
}
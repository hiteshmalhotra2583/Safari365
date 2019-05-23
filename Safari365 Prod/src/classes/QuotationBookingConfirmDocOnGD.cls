global with sharing class QuotationBookingConfirmDocOnGD{
    //=====================================================================================================================    
    public String access_token,expires_in,token_type,refresh_token,id,spreadsheetId;
    public static String cellBorder='',cellWrap='',mergeCell='',cellBold='',quotationName='',googleDocName='',googleDocUrl='';
    public static String itineraryconfirmationheading='',itineraryconfirmationbooking='',itineraryconfirmationcancerlation='',confirmed='',itinerarycomplimentaryservicesnote15='',itinerarycomplimentaryservicesnote14='',itinerarycomplimentaryservicesnote13='',itineraryconfirmationcancerlation2='',itineraryconfirmationterms='',itineraryconfirmationterms2='',itineraryconfirmationterms3='',itineraryconfirmationbooking2='',itineraryconfirmationbooking3='',itineraryconfirmationbooking1='',itinerarytotal='',itineraryconsultantcd='',itineraryreservationdetails='',itineraryconsultant='',itineraryphone='',itineraryemail='',itineraryreservationstatus='',itineraryquotationnumber='',itineraryquotationname='',itineraryquotationvaliduntil='',itinerarydigitalitinerary='',itinerarydigitalitinerarynote='',itinerarydate='',itineraryservice='',itinerarypassengers='',itinerarydestination='',itinerarydescription='',itinerarytraveldetails='',itinerarycomplimentaryservices='',itinerarycomplimentaryservicesnote='',itinerarycomplimentaryservicesnote3='',itinerarycomplimentaryservicesnote2='',itinerarycomplimentaryservicesnote4='',itineraryconfirmationcompservices='',itineraryconfirmationcompservices2='',itineraryconfirmationcompservices3='',itinerarycomplimentaryservicesnote5='',itinerarybookingsteps='',itinerarybookingstepsnote='',itinerarybookingstepsnote2='',itineraryconfirmationpayment='',itinerarydetailedinclusions='';
    public static String itinerarytotal1='',itinerarytotal2='',paxbreakdown='';
    public static Date validUntil;
    public static QuotationPricingSummaryWrapper summary = new QuotationPricingSummaryWrapper();
    public static Map<String,Decimal> CCROEForUSDZAREURMap =  new Map<String,Decimal>();
    public GDFile[] files,items;
    public String nextPageToken;
    public class GDFile{
        String id,name;
    }
    //=====================================================================================================================   
    global static void changeLabelToSpecfiedLanguage(String selectedLanguage)
    {
        try
        {
            Util_LabelTranslate t = new Util_LabelTranslate();
            itineraryconfirmationheading = (t.translate('itineraryconfirmationheading',selectedLanguage)).replace('"', '').trim();
            itineraryconsultantcd = (t.translate('itineraryconsultantcd',selectedLanguage)).replace('"', '').trim();
            itineraryreservationdetails = (t.translate('itineraryreservationdetails',selectedLanguage)).replace('"', '').trim();
            itineraryconsultant = (t.translate('itineraryconsultant',selectedLanguage)).replace('"', '').trim();
            itineraryphone = (t.translate('itineraryphone',selectedLanguage)).replace('"', '').trim();
            itineraryemail = (t.translate('itineraryemail',selectedLanguage)).replace('"', '').trim();
            itineraryreservationstatus = (t.translate('itineraryreservationstatus',selectedLanguage)).replace('"', '').trim();
            itineraryquotationnumber = (t.translate('itineraryquotationnumber',selectedLanguage)).replace('"', '').trim();
            itineraryquotationname = (t.translate('itineraryquotationname',selectedLanguage)).replace('"', '').trim();
            itineraryquotationvaliduntil = (t.translate('itineraryquotationvaliduntil',selectedLanguage)).replace('"', '').trim();
            itinerarydigitalitinerary = (t.translate('itinerarydigitalitinerary',selectedLanguage)).replace('"', '').trim();
            itinerarydigitalitinerarynote = (t.translate('itinerarydigitalitinerarynote',selectedLanguage)).replace('"', '').trim();
            itinerarydate = (t.translate('itinerarydate',selectedLanguage)).replace('"', '').trim();
            itineraryservice = (t.translate('itineraryservice',selectedLanguage)).replace('"', '').trim();
            itinerarypassengers = (t.translate('itinerarypassengers',selectedLanguage)).replace('"', '').trim();
            itinerarydestination = (t.translate('itinerarydestination',selectedLanguage)).replace('"', '').trim();
            itinerarydescription = (t.translate('itinerarydescription',selectedLanguage)).replace('"', '').trim();
            itinerarytraveldetails = (t.translate('itinerarytraveldetails',selectedLanguage)).replace('"', '').trim();
            itinerarytotal = (t.translate('itinerarytotal',selectedLanguage)).replace('"', '').trim();
            itinerarycomplimentaryservices = (t.translate('itinerarycomplimentaryservices',selectedLanguage)).replace('"', '').trim();
            itineraryconfirmationcompservices = (t.translate('itineraryconfirmationcompservices',selectedLanguage)).replace('"', '').trim();
            itineraryconfirmationcompservices2 = (t.translate('itineraryconfirmationcompservices2',selectedLanguage)).replace('"', '').trim();
            itineraryconfirmationcompservices3 = (t.translate('itineraryconfirmationcompservices3',selectedLanguage)).replace('"', '').trim();
            itinerarycomplimentaryservicesnote5 = (t.translate('itinerarycomplimentaryservicesnote5',selectedLanguage)).replace('"', '').trim();
            itinerarybookingsteps = (t.translate('itinerarybookingsteps',selectedLanguage)).replace('"', '').trim();
            itinerarycomplimentaryservices = (t.translate('itinerarycomplimentaryservices',selectedLanguage)).replace('"', '').trim();
            itinerarycomplimentaryservicesnote = (t.translate('itinerarycomplimentaryservicesnote',selectedLanguage)).replace('"', '').trim();
            itinerarycomplimentaryservicesnote3 = (t.translate('itinerarycomplimentaryservicesnote3',selectedLanguage)).replace('"', '').trim();
            itinerarycomplimentaryservicesnote2 = (t.translate('itinerarycomplimentaryservicesnote2',selectedLanguage)).replace('"', '').trim();
            itinerarycomplimentaryservicesnote4 = (t.translate('itinerarycomplimentaryservicesnote4',selectedLanguage)).replace('"', '').trim();
            itinerarycomplimentaryservicesnote5 = (t.translate('itinerarycomplimentaryservicesnote5',selectedLanguage)).replace('"', '').trim();
            itinerarycomplimentaryservicesnote13 = (t.translate('itinerarycomplimentaryservicesnote13',selectedLanguage)).replace('"', '').trim();
            itinerarycomplimentaryservicesnote14 = (t.translate('itinerarycomplimentaryservicesnote14',selectedLanguage)).replace('"', '').trim();
            itinerarycomplimentaryservicesnote15 = (t.translate('itinerarycomplimentaryservicesnote15',selectedLanguage)).replace('"', '').trim();
            itineraryconfirmationbooking = (t.translate('itineraryconfirmationbooking',selectedLanguage)).replace('"', '').trim();
            itineraryconfirmationbooking1 = (t.translate('itineraryconfirmationbooking1',selectedLanguage)).replace('"', '').trim();
            itineraryconfirmationbooking2 = (t.translate('itineraryconfirmationbooking2',selectedLanguage)).replace('"', '').trim();
            itineraryconfirmationbooking3 = (t.translate('itineraryconfirmationbooking3',selectedLanguage)).replace('"', '').trim();
            itineraryconfirmationpayment = (t.translate('itineraryconfirmationpayment',selectedLanguage)).replace('"', '').trim();
            itineraryconfirmationcancerlation = (t.translate('itineraryconfirmationcancerlation',selectedLanguage)).replace('"', '').trim();
            itineraryconfirmationcancerlation2 = (t.translate('itineraryconfirmationcancerlation2',selectedLanguage)).replace('"', '').trim();
            itineraryconfirmationterms = (t.translate('itineraryconfirmationterms',selectedLanguage)).replace('"', '').trim();
            itineraryconfirmationterms2 = (t.translate('itineraryconfirmationterms2',selectedLanguage)).replace('"', '').trim();
            itineraryconfirmationterms3 = (t.translate('itineraryconfirmationterms3',selectedLanguage)).replace('"', '').trim();
            confirmed = (t.translate('confirmed',selectedLanguage)).replace('"', '').trim();
            itinerarydetailedinclusions = (t.translate('itinerarydetailedinclusions',selectedLanguage)).replace('"', '').trim();
            itinerarytotal1 = (t.translate('itinerarytotal1',selectedLanguage)).replace('"', '').trim();
            itinerarytotal2 = (t.translate('itinerarytotal2',selectedLanguage)).replace('"', '').trim();
            paxbreakdown = (t.translate('paxbreakdown',selectedLanguage)).replace('"', '').trim();
            
        }catch (VisualforceException e) { 
        }
        
    }
    
    webservice static String createOrNotQuotationBookingConfirmDocOnGD(String quotationId)
    {
        String response =  QuotationBookingConfirmDocOnGD.createOrNotQuotationBookingConfirmDocOnGDLtng(quotationId);
        return response;
    }
    
    @AuraEnabled
    public static String createOrNotQuotationBookingConfirmDocOnGDLtng(String quotationId){
        List<id> quotationIds = new List<id>();
        quotationIds.add(quotationId);
        List<Quotations__c> quotations = DAL_Quotations.getAllQuotations(quotationIds);
        Quotations__c quotation;
        if(quotations.size()>0)
        {
            quotation = quotations[0];
        }
        
        if(String.isBlank(quotation.Iternary_Language__c))
        {
            return 'Please Select Itinerary Language!';
        }
        else if( quotation.Quotation_Stage__c != 'Raised Invoice')
        {
            return 'Quotation Stage Is Not Raised Invoice!';
        }
        else
        {
            String folderStatus = QuotationBookingConfirmDocOnGD.createQuotationBookingConfirmDocOnGD(quotationId);
            if((folderStatus !=null && folderStatus!='') ||folderStatus=='folderNotExist')
            {
                return 'Quotation Folder Does Not Exist In Google Drive!';
            }
            else
            {
                //Google Doc Record Created
                GoogleDoc googleDocRec = new GoogleDoc();
                googleDocRec.Name = GoogleDocName;
                googleDocRec.ParentId = quotation.Id;
                googleDocRec.Url = GoogleDocUrl;
                insert googleDocRec;
                
                if(quotation.Client_Has_Requested_Requote__c == true)
                {
                    quotation.Client_Has_Requested_Requote__c = false;
                }
                quotation.Update_CC_ROE_Fields__c = false;
                quotation.Raised_Booking_Confirmation_Date__c = system.today();
                quotation.Deposit_Due_Date__c= system.today().addDays(Integer.valueof(System.Label.Deposit_Due_Date));
                BaseTriggerHandler.bypass('TH_Quotations');
                 update quotation;
                BaseTriggerHandler.clearBypass('TH_Quotations');
                return 'true';
            }
        }
    }
    
    
    public static String createQuotationBookingConfirmDocOnGD(String quotationId)
    {
        
        GoogleDriveSetting__c GDSetting= GoogleDriveSetting__c.getOrgDefaults();
        String secret = GDSetting.Client_Secret__c;
        String key = EncodingUtil.urlEncode(GDSetting.Client_Id__c,'UTF-8');
        if(quotationId!=null)
        {
            Long seconds = (DateTime.now().getTime()-GDSetting.Last_Updated__c.getTime())/1000;
            Integer ExpiredIn=Integer.ValueOf(GDSetting.Expired_In__c);
            QuotationBookingConfirmDocOnGD r;
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
                req.setTimeout(60*1000);
                
                Http h = new Http();
                HttpResponse res = h.send(req);
                system.debug('@@req:'+res.getBody());
                r = QuotationBookingConfirmDocOnGD.parse(res.getBody());
                if(r!=null)
                {
                    GDSetting.Access_Token__c=r.access_token;
                    GDSetting.Expired_In__c=r.expires_in;
                    GDSetting.Last_Updated__c=DateTime.Now();
                }
            }
            {
                String QuotationFolderId = QuotationBookingConfirmDocOnGD.quotationFolderExist(GDSetting.Access_Token__c,quotationId); 
                if(Test.isRunningTest())
                {
                    if(QuotationFolderId ==null || QuotationFolderId =='')
                    {
                        QuotationFolderId= '1pfHle3jQuH9Q-swDt0M58lZ2JrUJnNt1';
                    }
                }
                if(QuotationFolderId ==null || QuotationFolderId =='')
                {
                    return 'folderNotExist';
                }
                String spreadsheetId = QuotationBookingConfirmDocOnGD.createSpreadSheet(GDSetting.Access_Token__c);
                QuotationBookingConfirmDocOnGD.updateDataSpreadSheet(GDSetting.Access_Token__c,spreadsheetId,quotationId);
                QuotationBookingConfirmDocOnGD.updateDataSpreadSheetFormating(GDSetting.Access_Token__c,spreadsheetId);
                QuotationBookingConfirmDocOnGD.clientFacingDocumentation(GDSetting.Access_Token__c,QuotationFolderId,spreadsheetId);
                
            }
            if(r!=null)
            {
                Update GDSetting;
            }  
        }
        return null;
        
    }
    
    
    public static QuotationBookingConfirmDocOnGD parse(String jsonString)
    {
        return (QuotationBookingConfirmDocOnGD)JSON.deserialize(jsonString, QuotationBookingConfirmDocOnGD.class);
    }
    
    //Get quotation folder Id
    public static String quotationFolderExist(String access_token,String quotationId)
    {
        GoogleDriveSetting__c GDSetting= GoogleDriveSetting__c.getOrgDefaults();  
        String teamDriveId = GDSetting.TeamDrive_Folder_Id__c; 
        String corporaString = 'teamDrive';
        String pageToken = null;
        String query=EncodingUtil.urlEncode('trashed=false','UTF-8');
        do
        {
        HttpRequest req2 = new HttpRequest();
        req2.setMethod('GET');
        if(pageToken != null)
        req2.setEndpoint('https://www.googleapis.com/drive/v3/files?supportsTeamDrives=true&includeTeamDriveItems=true&pageSize=1000&corpora='+corporaString+'&teamDriveId='+teamDriveId+'&q='+query+'&pageToken='+pageToken);
        else
        req2.setEndpoint('https://www.googleapis.com/drive/v3/files?supportsTeamDrives=true&includeTeamDriveItems=true&pageSize=1000&corpora='+corporaString+'&teamDriveId='+teamDriveId+'&q='+query);
        req2.setHeader('content-type', 'application/x-www-form-urlencoded');
        req2.setHeader('content-type', '0');
        req2.setHeader('Authorization', 'Bearer'+' '+access_token);
        req2.setTimeout(120*1000);
        Http h3 = new Http();
        HttpResponse resls = h3.send(req2);
        QuotationBookingConfirmDocOnGD r = QuotationBookingConfirmDocOnGD.parse(resls.getBody());
        List<id> quotationIds = new List<id>();
        quotationIds.add(quotationId);
        List<Quotations__c> quotations = DAL_Quotations.getAllQuotations(quotationIds);
        Quotations__c quotation;
        if(quotations.size()>0)
        {
            quotation = quotations[0];
        }
        
        quotationName = quotation.Name;
        if(quotationName!=null){
            if(r.files!=null && r.files.size()>0){
                for(GDFile gd: r.files){
                    if(gd.name.startsWith(quotationName)){
                        if(gd.id!=null){
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
    
    //Get Internal Documentation - Travelling Files folder Id
    public static void clientFacingDocumentation(String access_token,String QuotationFolderId,String spreadsheetId){
        GoogleDriveSetting__c GDSetting= GoogleDriveSetting__c.getOrgDefaults();  
        String teamDriveId = GDSetting.TeamDrive_Folder_Id__c; 
        String corporaString = 'teamDrive';
        String pageToken = null;
        String query=EncodingUtil.urlEncode('\''+QuotationFolderId+'\' in parents and trashed=false','UTF-8');
        do
        {
        HttpRequest req1 = new HttpRequest();
        req1.setMethod('GET');
        if(pageToken != null)
        req1.setEndpoint('https://www.googleapis.com/drive/v3/files?supportsTeamDrives=true&includeTeamDriveItems=true&pageSize=1000&corpora='+corporaString+'&teamDriveId='+teamDriveId+'&q='+query+'&pageToken='+pageToken);
        else
        req1.setEndpoint('https://www.googleapis.com/drive/v3/files?supportsTeamDrives=true&includeTeamDriveItems=true&pageSize=1000&corpora='+corporaString+'&teamDriveId='+teamDriveId+'&q='+query);
        req1.setHeader('content-type', 'application/x-www-form-urlencoded');
        req1.setHeader('content-type', '0');
        req1.setHeader('Authorization', 'Bearer'+' '+access_token);
        req1.setTimeout(120*1000);
        Http h1 = new Http();
        HttpResponse httpResponse1  = h1.send(req1);
        QuotationBookingConfirmDocOnGD r = QuotationBookingConfirmDocOnGD.parse(httpResponse1.getBody());
        if(r.files!=null && r.files.size()>0)
        {
            for(GDFile gd: r.files)
            {
                if(gd.name.startsWith('Internal Documentation - Travelling Files'))
                {
                    if(gd.id!=null)
                    {
                        //Create google sheet on Internal Documentation - Travelling Files folder
                        String parentId = gd.id;
                        String fileName = 'Quotation Booking Confirmation Doc_'+quotationName;
                        String body ='{"name": "'+fileName+'","mimeType": "application/vnd.google-apps.spreadsheet","parents":["'+parentId+'"]}';
                        HttpRequest req2 = new HttpRequest();
                        req2.setMethod('POST');
                        req2.setEndpoint('https://www.googleapis.com/drive/v3/files/'+spreadsheetId+'/copy?supportsTeamDrives=true');
                        req2.setHeader('content-type', 'application/json; charset=UTF-8');
                        req2.setHeader('Authorization', 'Bearer'+' '+access_token);
                        req2.setBody(body);
                        req2.setTimeout(60*1000);
                        Http h2 = new Http();
                        HttpResponse httpResponse2 = h2.send(req2);
                        QuotationBookingConfirmDocOnGD rr = QuotationBookingConfirmDocOnGD.parse(httpResponse2.getBody());
                        if(rr.id != null && rr.id!='')
                        {
                            googleDocName = fileName;
                            googleDocUrl = 'https://docs.google.com/spreadsheets/d/'+rr.id+'/edit?usp=drivesdk';
                        }
                        //Delete google sheet from google drive
                        HttpRequest req3 = new HttpRequest();
                        req3.setMethod('DELETE');
                        req3.setEndpoint('https://www.googleapis.com/drive/v3/files/'+spreadsheetId);
                        req3.setHeader('content-type', 'application/json; charset=UTF-8');
                        req3.setHeader('Authorization', 'Bearer'+' '+access_token);
                        req3.setBody(body);
                        req3.setTimeout(60*1000);
                        Http h3 = new Http();
                        HttpResponse httpResponse3 = h3.send(req3);
                        
                    }
                }
            }
        }
          pageToken = r.nextPageToken;
            system.debug('pageToken:::'+pageToken);
        }while(pageToken != null);
    }   
    
    public static String createSpreadSheet(String access_token)
    {
        HttpRequest req1 = new HttpRequest();
        req1.setMethod('POST');
        req1.setEndpoint('https://sheets.googleapis.com/v4/spreadsheets');
        req1.setHeader('content-type', 'application/JSON');
        req1.setHeader('Authorization', 'Bearer'+' '+access_token);
        String messageBody='{"properties": {"title": "V1 Booking Confirmation Docs"}}';
        req1.setBody(messageBody);
        req1.setHeader('Content-length', String.valueOf(messageBody.length()));
        req1.setTimeout(60*1000);
        Http h2 = new Http();
        HttpResponse resl = h2.send(req1);
        QuotationBookingConfirmDocOnGD r = QuotationBookingConfirmDocOnGD.parse(resl.getBody()); 
        return r.spreadsheetId;
    }
    
    public static void updateDataSpreadSheet(String access_token,String spreadsheetId,String quotationId){
        HttpRequest req1 = new HttpRequest();
        req1.setMethod('POST');
        req1.setEndpoint('https://sheets.googleapis.com/v4/spreadsheets/'+spreadsheetId+'/values:batchUpdate');
        req1.setHeader('content-type', 'application/JSON');
        req1.setHeader('Authorization', 'Bearer'+' '+access_token);
        String messageBody=QuotationBookingConfirmDocOnGD.getBodyContent(quotationId);
        req1.setBody(messageBody);
        req1.setHeader('Content-length', String.valueOf(messageBody.length()));
        req1.setTimeout(60*1000);
        Http h2 = new Http();
        HttpResponse resl = h2.send(req1);
        
    }
    
    public static void updateDataSpreadSheetFormating(String access_token,String spreadsheetId){
        String messageBody;
        HttpRequest req1 = new HttpRequest();
        req1.setMethod('POST');
        req1.setEndpoint('https://sheets.googleapis.com/v4/spreadsheets/'+spreadsheetId+':batchUpdate');
        req1.setHeader('content-type', 'application/JSON');
        req1.setHeader('Authorization', 'Bearer'+' '+access_token);
        
        /*===== Formating Cell Data =====*/
        if(cellBorder != null && cellBorder != '')
            cellBorder = cellBorder.removeEnd(','); 
        if(mergeCell != null && mergeCell != '')
            mergeCell = mergeCell.removeEnd(',');
        if(cellbold != null && cellbold != '')
            cellbold = cellbold.removeEnd(',');
        messageBody  = '{"requests":[';
        messageBody += '{"mergeCells":{"range":{"sheetId":0,"startRowIndex":1,"endRowIndex":2,"startColumnIndex":1,"endColumnIndex":7},"mergeType":"MERGE_ALL"}},';
        messageBody += '{"mergeCells":{"range":{"sheetId":0,"startRowIndex":2,"endRowIndex":3,"startColumnIndex":1,"endColumnIndex":7},"mergeType":"MERGE_ALL"}},';
        messageBody += '{"repeatCell":{"range":{"sheetId":0,"startRowIndex":3,"endRowIndex":4},"cell":{"userEnteredFormat":{"textFormat":{"fontSize":11,"bold":true,"underline":true}}},"fields":"userEnteredFormat(backgroundColor,textFormat,horizontalAlignment)"}},';
        messageBody += '{"repeatCell":{"range":{"sheetId":0,"startRowIndex":8,"endRowIndex":9},"cell":{"userEnteredFormat":{"textFormat":{"fontSize":11,"bold":true,"underline":true}}},"fields":"userEnteredFormat(backgroundColor,textFormat,horizontalAlignment)"}},';
        messageBody += '{"repeatCell":{"range":{"sheetId":0,"startRowIndex":12,"endRowIndex":13,"startColumnIndex":1,"endColumnIndex":7},"cell":{"userEnteredFormat":{"textFormat":{"fontSize":11,"bold":true,"underline":false},"backgroundColor":{"red":0.9,"green":0.9,"blue":0.9}}},"fields":"userEnteredFormat(backgroundColor,textFormat,horizontalAlignment)"}}';
        if(mergeCell != null && mergeCell != ''){
            messageBody += ','+mergeCell+','; 
        }else{
            messageBody += ',';
        }
        messageBody += '{"repeatCell":{"range":{"sheetId":0,"startRowIndex":6,"endRowIndex":7,"startColumnIndex":5,"endColumnIndex":7},"cell":{"userEnteredFormat":{"wrapStrategy":"WRAP","verticalAlignment":"TOP"}},"fields":"userEnteredFormat(wrapStrategy,verticalAlignment)"}}'; 
        if(cellbold != null && cellBold != ''){
            messageBody +=  ','+cellbold+',';
        }else{
            messageBody += ',';
        }
        messageBody += '{"repeatCell":{"range":{"sheetId":0,"startRowIndex":1,"endRowIndex":2},"cell":{"userEnteredFormat":{"textFormat":{"fontSize":18,"bold":true}}},"fields":"userEnteredFormat(backgroundColor,textFormat,horizontalAlignment)"}}';
        if(cellBorder != null && cellBorder != ''){
            messageBody += ','+cellBorder+','; 
        }else{
            messageBody += ',';
        }
        messageBody += '{"updateDimensionProperties":{"range":{"sheetId":0,"dimension":"ROWS","startIndex":2,"endIndex":3},"properties":{"pixelSize":155},"fields":"pixelSize"}},';
        messageBody += '{"updateDimensionProperties":{"range":{"sheetId":0,"dimension":"COLUMNS","startIndex":6,"endIndex":7},"properties":{"pixelSize":380},"fields":"pixelSize"}},';
        messageBody += '{"updateDimensionProperties":{"range":{"sheetId":0,"dimension":"COLUMNS","startIndex":5,"endIndex":6},"properties":{"pixelSize":170},"fields":"pixelSize"}},';
        messageBody += '{"updateDimensionProperties":{"range":{"sheetId":0,"dimension":"COLUMNS","startIndex":4,"endIndex":5},"properties":{"pixelSize":100},"fields":"pixelSize"}},';
        messageBody += '{"updateDimensionProperties":{"range":{"sheetId":0,"dimension":"COLUMNS","startIndex":3,"endIndex":4},"properties":{"pixelSize":100},"fields":"pixelSize"}},';
        messageBody += '{"updateDimensionProperties":{"range":{"sheetId":0,"dimension":"COLUMNS","startIndex":2,"endIndex":3},"properties":{"pixelSize":120},"fields":"pixelSize"}},';
        messageBody += '{"updateDimensionProperties":{"range":{"sheetId":0,"dimension":"COLUMNS","startIndex":1,"endIndex":2},"properties":{"pixelSize":110},"fields":"pixelSize"}},';
        messageBody += '{"updateDimensionProperties":{"range":{"sheetId":0,"dimension":"COLUMNS","startIndex":0,"endIndex":1},"properties":{"pixelSize":20},"fields":"pixelSize"}},';
        //messageBody += '{"hideGridlines":true"},';
        messageBody += '{"updateBorders":{"range":{"sheetId":0,"startRowIndex":1,"endRowIndex":12,"startColumnIndex":1,"endColumnIndex":7},"top":{"style":"SOLID","width":1},"bottom":{"style":"SOLID","width":1},"left":{"style":"SOLID","width":1},"right":{"style":"SOLID","width":1}}},';
        messageBody += '{"updateBorders":{"range":{"sheetId":0,"startRowIndex":12,"endRowIndex":13,"startColumnIndex":1,"endColumnIndex":7},"top":{"style":"SOLID","width":1},"bottom":{"style":"SOLID","width":1},"left":{"style":"SOLID","width":1},"right":{"style":"SOLID","width":1}}}';
        if(cellWrap != null && cellWrap != '')
        messageBody += ','+cellWrap;
        messageBody += ']}';
        /*===== Formating Cell Data =====*/
        
        req1.setBody(messageBody);
        req1.setHeader('Content-length', String.valueOf(messageBody.length()));
        req1.setTimeout(60*1000);
        Http h2 = new Http();
        HttpResponse resl = h2.send(req1);
        System.debug('===='+resl.getBody());
        
        
    }
    
    public static String getBodyContent(String quotationId){
        Integer cell=15,no=2,oldCell,startToRwBorder;
        Integer lastCell;
        String quotationLabelLanguage;
        
        List<id> quotationIds = new List<id>();
        quotationIds.add(quotationId);
        List<Quotations__c> quotations = DAL_Quotations.getAllQuotations(quotationIds);
        Quotations__c quotation;
        if(quotations.size()>0){
            quotation = quotations[0];
        }
        
        validUntil = system.Today().addDays(Integer.valueof(Label.Valid_Until_Days));
        if(quotation.Iternary_Language__c!=null){
            QuotationBookingConfirmDocOnGD.changeLabelToSpecfiedLanguage(quotation.Iternary_Language__c);
        }
        
        String accountName = quotation.Opportunity__r.Account.Name;
        String opportunityOwner = quotation.Opportunity__r.Owner.Name;
        String phone = quotation.Opportunity__r.Owner.Phone;
        String email = quotation.Opportunity__r.Owner.Email;
        String quotationStage = quotation.Quotation_Stage__c;
        String quotationName = quotation.Opportunity__r.Name+'_'+quotation.Quotation_Name__c;
        Date quotationValidUntil = quotation.Valid_Until__c;
        String quotationNumber = quotation.Name;
        String wetuLink = quotation.WETU_Link__c;
        Decimal totalSaleInZar = quotation.Total_Sale_In_Zar__c;
        Decimal totalSaleInUSD = quotation.Total_Sale_In_USD__c;
        String currencyValue = quotation.Currency__c;
         Decimal quotationSaleTotalInCC;
        if(currencyValue=='USD')
        {
            quotationSaleTotalInCC = quotation.Quotation_Sale_Total_in_CC_USD__c;
        }
        else if(currencyValue=='EUR')
        {
            quotationSaleTotalInCC = quotation.Quotation_Sale_Total_in_CC_EUR__c;
        }
        else if(currencyValue=='AUD')
        {
            quotationSaleTotalInCC = quotation.Quotation_Sale_Total_in_CC_AUD__c;
        }
        else if(currencyValue=='GBP')
        {
            quotationSaleTotalInCC = quotation.Quotation_Sale_Total_in_CC_GBP__c;
        }
        //Decimal noOfPhotoBook = quotation.No_of_PhotoBook__c;
        Decimal includeInsuranceForPassengers = quotation.Include_insurance_for_passengers__c;
        
        List<LegDetail> legDetails = QuotationServiceHelper.GetLegDetails(quotation);
        Map<String, LegDetail> supplierNameToLegDetailsMap = QuotationServiceHelper.supplierNameToLegDetailsMap;
        List<ServiceLineItem__c> allServiceLineItems = QuotationServiceHelper.allServiceLineItems;
        List<ServiceLineItem__c> serviceLineItemsDetail;
        List<ServiceLineItem__c> serLiItDe=new List<ServiceLineItem__c>();
        
        String body;
        body = '{"valueInputOption":"USER_ENTERED","data":[{';
        body += '"range":"Sheet1!B2:G2","majorDimension":"COLUMNS","values":[["'+itineraryconfirmationheading+' '+accountName+'"]]},';
        
        body += '{"range":"Sheet1!B3:G3","majorDimension":"COLUMNS","values":[[\'=IMAGE("https://safari365--c.documentforce.com/servlet/servlet.ImageServer?id=0154G0000065vlC&oid=00DD0000000lFNO",4,150,1000)\']]},';
        
        body += '{"range":"Sheet1!B4:C4","majorDimension":"COLUMNS","values":[["'+itineraryconsultantcd+'"]]},';
        body += '{"range":"Sheet1!B5:C5","majorDimension":"COLUMNS","values":[["'+itineraryconsultant+' '+opportunityOwner+'"]]},';
        body += '{"range":"Sheet1!B6:C6","majorDimension":"COLUMNS","values":[["'+itineraryphone+' '+phone+'"]]},';
        body += '{"range":"Sheet1!B7:C7","majorDimension":"COLUMNS","values":[["'+itineraryemail+' '+email+'"]]},';
        body += '{"range":"Sheet1!G4:G5","majorDimension":"COLUMNS","values":[["'+itineraryreservationdetails+'"]]},';
        //body += '{"range":"Sheet1!G5:G6","majorDimension":"COLUMNS","values":[["Reservation Status: Confirmed"]]},';
        body += '{"range":"Sheet1!G5:G6","majorDimension":"COLUMNS","values":[["'+itineraryreservationstatus+' '+confirmed+'"]]},';
        body += '{"range":"Sheet1!G6:G7","majorDimension":"COLUMNS","values":[["'+itineraryquotationnumber+' '+quotationNumber+'"]]},';
        body += '{"range":"Sheet1!G7:G8","majorDimension":"COLUMNS","values":[["'+itineraryquotationname+' '+quotationName+'"]]},';
        //body += '{"range":"Sheet1!G8:G9","majorDimension":"COLUMNS","values":[["'+DepositDueDate+' '+validStringUntil+'"]]},';
        
        body += '{"range":"Sheet1!B9:C9","majorDimension":"COLUMNS","values":[["'+itinerarydigitalitinerary+'"]]},';
        body += '{"range":"Sheet1!B10:G10","majorDimension":"COLUMNS","values":[["'+itinerarydigitalitinerarynote+'"]]},';
        body += '{"range":"Sheet1!B11:G11","majorDimension":"COLUMNS","values":[["'+wetuLink+'"]]},';
        body += '{"range":"Sheet1!B13:B14","majorDimension":"COLUMNS","values":[["'+itinerarydate+'"]]},';
        body += '{"range":"Sheet1!C13:C14","majorDimension":"COLUMNS","values":[["'+itineraryservice+'"]]},';
        body += '{"range":"Sheet1!D13:D14","majorDimension":"COLUMNS","values":[["'+itinerarypassengers+'"]]},';
        body += '{"range":"Sheet1!E13:E14","majorDimension":"COLUMNS","values":[["'+itinerarydestination+'"]]},';
        body += '{"range":"Sheet1!F13:F14","majorDimension":"COLUMNS","values":[["'+itinerarydescription+'"]]},';
        body += '{"range":"Sheet1!G13:G14","majorDimension":"COLUMNS","values":[["'+itinerarytraveldetails+'"]]},';
        
        Map<String,Date> uniqueRecord = new Map<String,Date>();
        if(legDetails != null && supplierNameToLegDetailsMap != null && allServiceLineItems != null){
            for (String key : supplierNameToLegDetailsMap.keySet()){
                
                serviceLineItemsDetail = QuotationServiceHelper.FindServiceItemsForLeg(supplierNameToLegDetailsMap.get(key),allServiceLineItems);
                for(ServiceLineItem__c sli:serviceLineItemsDetail)
                {
                    
                    /*if(!uniqueRecord.containsKey(sli.Service_Type__c+'_'+sli.ServiceLocation__c+'_'+sli.Name+'_'+sli.Service_Detail__c)){
                         uniqueRecord.put(sli.Service_Type__c+'_'+sli.ServiceLocation__c+'_'+sli.Name+'_'+sli.Service_Detail__c,sli.Service_Date__c);
                         serLiItDe.add(sli);
                    }
                     uniqueRecord.put(sli.Service_Type__c+'_'+sli.ServiceLocation__c+'_'+sli.Name+'_'+sli.Service_Detail__c,sli.Service_Date__c);
                    */
                    String name ;
                    if(sli.Service_Type__c !='Accommodation')
                    {
                     name = sli.Name+sli.Service_Date__c;
                    }
                    else
                    {
                        name = sli.Name;
                    }
                    if(!uniqueRecord.containsKey(key) && name ==key )
                    {
                        uniqueRecord.put(key,sli.Service_Date__c);
                        serLiItDe.add(sli);
                    }
                    else if(uniqueRecord.containsKey(key) && sli.Service_Type__c =='Accommodation')
                    {
                        uniqueRecord.put(key,sli.Service_Date__c);
                    }
                }
            }
            Set<Id> serviceLineIdSet = new Set<Id>(); 
            for(ServiceLineItem__c sli:serLiItDe)
            {
                serviceLineIdSet.add(sli.Id);
            }
           
            List<ServiceLineItemPassengersMapping__c>  serviceLineItemPassengerMappings  = DAL_ServiceLineItemPassengersMapping.getPassengerCountBySerLineItemId(serviceLineIdSet);
            
            Map<Id, List<Id>> adultCountMap = new Map<Id,List<Id>>();
            Map<Id, List<Id>> childCountMap = new Map<Id,List<Id>>();
            Map<Id, List<Id>> InfantCountMap = new Map<Id,List<Id>>();
            for(ServiceLineItemPassengersMapping__c sLipm:serviceLineItemPassengerMappings)
            {
                 if(sLipm.Passenger__r.PassengerType__c =='Adult')
                 {
                    List<Id> adultPassengerIds  = null;
                    if(null != adultCountMap.get(sLipm.Service_Line_Item__c))
                    {
                        adultPassengerIds = adultCountMap.get(sLipm.Service_Line_Item__c);
                    }
                    else
                    {
                        adultPassengerIds = new List<Id>();
                    }
                    
                    adultPassengerIds.add(sLipm.Id);
                    adultCountMap.put(sLipm.Service_Line_Item__c,adultPassengerIds);
                 }
                 else if (sLipm.Passenger__r.PassengerType__c =='Child')
                 {
                    List<Id> childPassengerIds  = null;
                    if(null != childCountMap.get(sLipm.Service_Line_Item__c))
                    {
                        childPassengerIds = childCountMap.get(sLipm.Service_Line_Item__c);
                    }
                    else
                    {
                        childPassengerIds = new List<Id>();
                    }
                    
                    childPassengerIds.add(sLipm.Id);
                    childCountMap.put(sLipm.Service_Line_Item__c,childPassengerIds);
                 }
                 else if(sLipm.Passenger__r.PassengerType__c =='Infant')
                 {
                    List<Id> InfantPassengerIds  = null;
                    if(null != InfantCountMap.get(sLipm.Service_Line_Item__c))
                    {
                        InfantPassengerIds = InfantCountMap.get(sLipm.Service_Line_Item__c);
                    }
                    else
                    {
                        InfantPassengerIds = new List<Id>();
                    }
                    
                    InfantPassengerIds.add(sLipm.Id);
                    InfantCountMap.put(sLipm.Service_Line_Item__c,InfantPassengerIds);
                 }
            }
            
            Integer ii=1;
            String dateRecord;
            for(ServiceLineItem__c sli:serLiItDe){
                List<Service_Line_Item_ChargeType__c> serviceLineItemChargeType =  DAL_ServiceLineItemChargeType.getServiceLineItemChargeTypeById(sli.Id);
               
                String totalAdult = '0';
                String totalChild = '0';
                String totalInfant = '0';
                if( null != adultCountMap.get(sli.Id))
                totalAdult = String.valueof(adultCountMap.get(sli.Id).size());
                
                if( null != childCountMap.get(sli.Id))
                totalChild = String.valueof(childCountMap.get(sli.Id).size());
                
                if( null != InfantCountMap.get(sli.Id))
                totalInfant = String.valueof(InfantCountMap.get(sli.Id).size());
                Date dt = sli.Service_Date__c;
                Date dt2 = null;
                if(sli.Service_Type__c !='Accommodation')
                {   
                     
                    dt2 = uniqueRecord.get(sli.Name);
                }
                else
                {
                    dt2 = uniqueRecord.get(sli.Name).addDays(1);
                }
                if( dt2 != null && dt.day()!=dt2.day()){
                    dateRecord = dt.day()+' - '+dt2.day()+' '+(QuotationServiceHelper.getMonthName(dt.month()))+' '+dt.year(); 
                }else{
                    dateRecord = dt.day()+' '+(QuotationServiceHelper.getMonthName(dt.month()))+' '+dt.year(); 
                }
                cellbold += '{"repeatCell":{"range":{"sheetId":0,"startRowIndex":'+(cell-1)+',"endRowIndex":'+cell+'},"cell":{"userEnteredFormat":{"textFormat":{"fontSize":10,"bold":false}}},"fields":"userEnteredFormat(backgroundColor,textFormat,horizontalAlignment)"}},';
                body += '{"range":"Sheet1!B'+cell+':B'+(cell+1)+'","majorDimension":"COLUMNS","values":[["'+dateRecord+'"]]},';
                body += '{"range":"Sheet1!C'+cell+':C'+(cell+1)+'","majorDimension":"COLUMNS","values":[["'+sli.Service_Type__c+'"]]},';
                body += '{"range":"Sheet1!D'+cell+':D'+(cell+1)+'","majorDimension":"COLUMNS","values":[["'+totalAdult+'/'+totalChild+'/'+totalInfant+'"]]},';
                body += '{"range":"Sheet1!E'+cell+':E'+(cell+1)+'","majorDimension":"COLUMNS","values":[["'+sli.ServiceLocation__c+'"]]},';
                body += '{"range":"Sheet1!F'+cell+':F'+(cell+1)+'","majorDimension":"COLUMNS","values":[["'+sli.SupplierName__c+'"]]},';
                if( null != sli.Wetu_Start_Location__c && null != sli.Wetu_End_Location__c)
                {
                body += '{"range":"Sheet1!G'+cell+':G'+(cell+1)+'","majorDimension":"COLUMNS","values":[["'+sli.Service_Detail__c+'-'+sli.Wetu_Start_Location__c+' to '+sli.Wetu_End_Location__c+'"]]},';
                }
                else
                {
                body += '{"range":"Sheet1!G'+cell+':G'+(cell+1)+'","majorDimension":"COLUMNS","values":[["'+sli.Service_Detail__c+'"]]},';
                }
                if(serviceLineItemChargeType.size()>0 ){
                    Integer cnt=1;
                    for(Service_Line_Item_ChargeType__c slict:serviceLineItemChargeType ){
                        if(slict.Extra__c!=null){
                            cell += 1;
                            body += '{"range":"Sheet1!G'+cell+':G'+(cell+1)+'","majorDimension":"COLUMNS","values":[["'+slict.Extra__c+' (Extra '+cnt+')"]]},';
                            cnt++;
                        }
                    }
                }
                
                if(sli.ClientNotes__c!=null){
                    cell += 1;
                    body += '{"range":"Sheet1!G'+cell+':G'+(cell+1)+'","majorDimension":"COLUMNS","values":[["Client Service Notes:'+sli.ClientNotes__c+'"]]},';
                }
                
                if(ii==1){
                    cellBorder += '{"updateBorders":{"range":{"sheetId":0,"startRowIndex":13,"endRowIndex":'+cell+',"startColumnIndex":1,"endColumnIndex":7},"top":{"style":"SOLID","width":1},"bottom":{"style":"SOLID","width":1},"left":{"style":"SOLID","width":1},"right":{"style":"SOLID","width":1}}},';
                }else{
                    cellBorder += '{"updateBorders":{"range":{"sheetId":0,"startRowIndex":'+oldCell+',"endRowIndex":'+cell+',"startColumnIndex":1,"endColumnIndex":7},"top":{"style":"SOLID","width":1},"bottom":{"style":"SOLID","width":1},"left":{"style":"SOLID","width":1},"right":{"style":"SOLID","width":1}}},';
                    
                }
                oldCell = cell;
                cell += 2;
                ii++;
            }
        }
        
        cell++;
        /*=== Bold Heading ===*/
        cellBorder += '{"updateBorders":{"range":{"sheetId":0,"startRowIndex":'+(cell-1)+',"endRowIndex":'+cell+',"startColumnIndex":6,"endColumnIndex":7},"top":{"style":"SOLID","width":1},"bottom":{"style":"SOLID","width":1},"left":{"style":"SOLID","width":1},"right":{"style":"SOLID","width":1}}},';
        cellbold += '{"repeatCell":{"range":{"sheetId":0,"startRowIndex":'+(cell-1)+',"endRowIndex":'+cell+',"startColumnIndex":6,"endColumnIndex":7},"cell":{"userEnteredFormat":{"textFormat":{"fontSize":11,"bold":true,"underline":false},"backgroundColor":{"red":0.9,"green":0.9,"blue":0.9}}},"fields":"userEnteredFormat(backgroundColor,textFormat,horizontalAlignment)"}},';
        body += '{"range":"Sheet1!G'+cell+':G'+(cell+1)+'","majorDimension":"COLUMNS","values":[["'+itineraryconfirmationpayment+'"]]},';
        cell++;
        startToRwBorder = cell-1;
        body += '{"range":"Sheet1!G'+cell+':G'+(cell+1)+'","majorDimension":"COLUMNS","values":[["'+itinerarytotal+' : '+currencyValue+' : '+quotationSaleTotalInCC+'"]]},';
        cell++;
        cell += 1;   
        cellBorder += '{"updateBorders":{"range":{"sheetId":0,"startRowIndex":'+(cell-1)+',"endRowIndex":'+cell+',"startColumnIndex":6,"endColumnIndex":7},"top":{"style":"SOLID","width":1},"bottom":{"style":"SOLID","width":1},"left":{"style":"SOLID","width":1},"right":{"style":"SOLID","width":1}}},';
        cellbold += '{"repeatCell":{"range":{"sheetId":0,"startRowIndex":'+(cell-1)+',"endRowIndex":'+cell+',"startColumnIndex":6,"endColumnIndex":7},"cell":{"userEnteredFormat":{"textFormat":{"fontSize":11,"bold":true,"underline":false},"backgroundColor":{"red":0.9,"green":0.9,"blue":0.9}}},"fields":"userEnteredFormat(backgroundColor,textFormat,horizontalAlignment)"}},';
        body += '{"range":"Sheet1!G'+cell+':G'+(cell+1)+'","majorDimension":"COLUMNS","values":[["Deposits and payment schedule"]]},';
        Summary = QuotationPricingHelper.getQuotationPricingDetails(quotation.Id,CCROEForUSDZAREURMap);
        if(Summary.PaymentClientCurrency!=null)
        {
            //String DepositDueDate = Summary.PaymentClientCurrency.DepositDueDate!=null?Summary.PaymentClientCurrency.DepositDueDate:'';
            String DepositDueDate = UTIL_Date.formatGivenDateToString(system.today().addDays(Integer.valueof(system.Label.Deposit_Due_Date)));
            String DepositDueAmount = Summary.PaymentClientCurrency.DepositDueAmount!=null?Summary.PaymentClientCurrency.DepositDueAmount:'';
            String BalanceDueDate = Summary.PaymentClientCurrency.BalanceDueDate!=null?Summary.PaymentClientCurrency.BalanceDueDate:'';
            String BalanceDueAmount = Summary.PaymentClientCurrency.DepositDueAmount!=null?Summary.PaymentClientCurrency.BalanceDueAmount:'';
            
            cell++;                  
            body += '{"range":"Sheet1!G'+cell+':G'+(cell+1)+'","majorDimension":"COLUMNS","values":[["Deposit Due Date : '+DepositDueDate+'"]]},'; 
            cell++;                  
            body += '{"range":"Sheet1!G'+cell+':G'+(cell+1)+'","majorDimension":"COLUMNS","values":[["Deposit Due Amount : '+DepositDueAmount+'"]]},'; 
            cell++;                  
            body += '{"range":"Sheet1!G'+cell+':G'+(cell+1)+'","majorDimension":"COLUMNS","values":[["Balance Due Date : '+BalanceDueDate+'"]]},'; 
            cell++;                  
            body += '{"range":"Sheet1!G'+cell+':G'+(cell+1)+'","majorDimension":"COLUMNS","values":[["Balance Due Amount : '+BalanceDueAmount+'"]]},'; 
        }
        
        cell += 2;        
        /*=== Bold Heading ===*/
        cellBorder += '{"updateBorders":{"range":{"sheetId":0,"startRowIndex":'+(cell-1)+',"endRowIndex":'+cell+',"startColumnIndex":6,"endColumnIndex":7},"top":{"style":"SOLID","width":1},"bottom":{"style":"SOLID","width":1},"left":{"style":"SOLID","width":1},"right":{"style":"SOLID","width":1}}},';
        cellbold += '{"repeatCell":{"range":{"sheetId":0,"startRowIndex":'+(cell-1)+',"endRowIndex":'+cell+',"startColumnIndex":6,"endColumnIndex":7},"cell":{"userEnteredFormat":{"textFormat":{"fontSize":11,"bold":true,"underline":false},"backgroundColor":{"red":0.9,"green":0.9,"blue":0.9}}},"fields":"userEnteredFormat(backgroundColor,textFormat,horizontalAlignment)"}},';
        body += '{"range":"Sheet1!G'+cell+':G'+(cell+1)+'","majorDimension":"COLUMNS","values":[["'+paxbreakdown+'"]]},';
         
        if(Summary.TotalPricePerPersonSummaryClientCurrency!=null){
            for(TotalPricePerPersonSummaryWrapper totalPriPerSumCliCurrency:Summary.TotalPricePerPersonSummaryClientCurrency){
                if(currencyValue == 'USD')
                {
                    cell++;
                    String clientUSD = totalPriPerSumCliCurrency.PassengerName + system.Label.curUSD +  totalPriPerSumCliCurrency.TotalAmountINUSD;
                    body += '{"range":"Sheet1!G'+cell+':G'+(cell+1)+'","majorDimension":"COLUMNS","values":[["'+clientUSD+':"]]},';
                }
                if(currencyValue == 'EUR')
                {
                    cell++;
                    String clientEUR = totalPriPerSumCliCurrency.PassengerName+ system.Label.curEUR +totalPriPerSumCliCurrency.TotalAmountINEUR;
                    body += '{"range":"Sheet1!G'+cell+':G'+(cell+1)+'","majorDimension":"COLUMNS","values":[["'+clientEUR+':"]]},';
                }
                if(currencyValue == 'AUD')
                {
                    cell++;
                    String clientAUD = totalPriPerSumCliCurrency.PassengerName+ system.Label.curAUD +totalPriPerSumCliCurrency.TotalAmountINAUD;
                    body += '{"range":"Sheet1!G'+cell+':G'+(cell+1)+'","majorDimension":"COLUMNS","values":[["'+clientAUD+':"]]},';
                }
                if(currencyValue == 'GBP')
                {
                    cell++;
                    String clientGBP = totalPriPerSumCliCurrency.PassengerName+ system.Label.curGBP +totalPriPerSumCliCurrency.TotalAmountInGBP;
                    body += '{"range":"Sheet1!G'+cell+':G'+(cell+1)+'","majorDimension":"COLUMNS","values":[["'+clientGBP+':"]]},';
                }
                
            }
        }
        
        cellBorder += '{"updateBorders":{"range":{"sheetId":0,"startRowIndex":'+oldCell+',"endRowIndex":'+cell+',"startColumnIndex":1,"endColumnIndex":7},"top":{"style":"SOLID","width":1},"bottom":{"style":"SOLID","width":1},"left":{"style":"SOLID","width":1},"right":{"style":"SOLID","width":1}}},';
        cellBorder += '{"updateBorders":{"range":{"sheetId":0,"startRowIndex":'+startToRwBorder+',"endRowIndex":'+cell+',"startColumnIndex":6,"endColumnIndex":7},"top":{"style":"SOLID","width":1},"bottom":{"style":"SOLID","width":1},"left":{"style":"SOLID","width":1},"right":{"style":"SOLID","width":1}}},';
        /*===========table over================*/
        /*=== Bold Heading ===*/
        cell += 2;
        Integer cellMerge = cell-1;
        /*=== Bold Heading ===*/
        cellBorder += '{"updateBorders":{"range":{"sheetId":0,"startRowIndex":'+(cell-1)+',"endRowIndex":'+cell+',"startColumnIndex":1,"endColumnIndex":7},"top":{"style":"SOLID","width":1},"bottom":{"style":"SOLID","width":1},"left":{"style":"SOLID","width":1},"right":{"style":"SOLID","width":1}}},';
        cellbold += '{"repeatCell":{"range":{"sheetId":0,"startRowIndex":'+(cell-1)+',"endRowIndex":'+cell+',"startColumnIndex":1,"endColumnIndex":7},"cell":{"userEnteredFormat":{"textFormat":{"fontSize":11,"bold":true,"underline":false},"backgroundColor":{"red":0.9,"green":0.9,"blue":0.9}}},"fields":"userEnteredFormat(backgroundColor,textFormat,horizontalAlignment)"}},';
        body += '{"range":"Sheet1!B'+cell+':C'+cell+'","majorDimension":"COLUMNS","values":[["'+itinerarybookingsteps+'"]]},';
        cell++; 
        body += '{"range":"Sheet1!B'+cell+':G'+cell+'","majorDimension":"COLUMNS","values":[["'+itineraryconfirmationbooking+'"]]},'; 
        cell++; 
        body += '{"range":"Sheet1!B'+cell+':G'+cell+'","majorDimension":"COLUMNS","values":[["'+itineraryconfirmationbooking1+'"]]},'; 
        cell++; 
        body += '{"range":"Sheet1!B'+cell+':G'+cell+'","majorDimension":"COLUMNS","values":[["'+wetuLink+'"]]},';
        cell++; 
        body += '{"range":"Sheet1!B'+cell+':G'+cell+'","majorDimension":"COLUMNS","values":[["'+itineraryconfirmationbooking2+'"]]},'; 
        cell++; 
        body += '{"range":"Sheet1!B'+cell+':G'+cell+'","majorDimension":"COLUMNS","values":[["'+itineraryconfirmationbooking3+'"]]},'; 

        cell += 2;
        /*=== Bold Heading ===*/
        cellBorder += '{"updateBorders":{"range":{"sheetId":0,"startRowIndex":'+(cell-1)+',"endRowIndex":'+cell+',"startColumnIndex":1,"endColumnIndex":7},"top":{"style":"SOLID","width":1},"bottom":{"style":"SOLID","width":1},"left":{"style":"SOLID","width":1},"right":{"style":"SOLID","width":1}}},';
        cellbold += '{"repeatCell":{"range":{"sheetId":0,"startRowIndex":'+(cell-1)+',"endRowIndex":'+cell+',"startColumnIndex":1,"endColumnIndex":7},"cell":{"userEnteredFormat":{"textFormat":{"fontSize":11,"bold":true,"underline":false},"backgroundColor":{"red":0.9,"green":0.9,"blue":0.9}}},"fields":"userEnteredFormat(backgroundColor,textFormat,horizontalAlignment)"}},';
        body += '{"range":"Sheet1!B'+cell+':C'+cell+'","majorDimension":"COLUMNS","values":[["'+itineraryconfirmationcancerlation+'"]]},';
        cell++; 
        body += '{"range":"Sheet1!B'+cell+':G'+cell+'","majorDimension":"COLUMNS","values":[["'+itineraryconfirmationcancerlation2+'"]]},'; 
        cell += 2;
        cellBorder += '{"updateBorders":{"range":{"sheetId":0,"startRowIndex":'+(cell-1)+',"endRowIndex":'+cell+',"startColumnIndex":1,"endColumnIndex":7},"top":{"style":"SOLID","width":1},"bottom":{"style":"SOLID","width":1},"left":{"style":"SOLID","width":1},"right":{"style":"SOLID","width":1}}},';
        cellbold += '{"repeatCell":{"range":{"sheetId":0,"startRowIndex":'+(cell-1)+',"endRowIndex":'+cell+',"startColumnIndex":1,"endColumnIndex":7},"cell":{"userEnteredFormat":{"textFormat":{"fontSize":11,"bold":true,"underline":false},"backgroundColor":{"red":0.9,"green":0.9,"blue":0.9}}},"fields":"userEnteredFormat(backgroundColor,textFormat,horizontalAlignment)"}},';
        body += '{"range":"Sheet1!B'+cell+':C'+cell+'","majorDimension":"COLUMNS","values":[["'+itineraryconfirmationterms+'"]]},';
        cell++; 
        body += '{"range":"Sheet1!B'+cell+':G'+cell+'","majorDimension":"COLUMNS","values":[["'+itineraryconfirmationterms2+'"]]},'; 
        cell++; 
        body += '{"range":"Sheet1!B'+cell+':G'+cell+'","majorDimension":"COLUMNS","values":[["'+itineraryconfirmationterms3+'"]]},'; 
        cell += 2;
        /*=== Bold Heading ===*/
        cellBorder += '{"updateBorders":{"range":{"sheetId":0,"startRowIndex":'+(cell-1)+',"endRowIndex":'+cell+',"startColumnIndex":1,"endColumnIndex":7},"top":{"style":"SOLID","width":1},"bottom":{"style":"SOLID","width":1},"left":{"style":"SOLID","width":1},"right":{"style":"SOLID","width":1}}},';
        cellbold += '{"repeatCell":{"range":{"sheetId":0,"startRowIndex":'+(cell-1)+',"endRowIndex":'+cell+',"startColumnIndex":1,"endColumnIndex":7},"cell":{"userEnteredFormat":{"textFormat":{"fontSize":11,"bold":true,"underline":false},"backgroundColor":{"red":0.9,"green":0.9,"blue":0.9}}},"fields":"userEnteredFormat(backgroundColor,textFormat,horizontalAlignment)"}},';
        body += '{"range":"Sheet1!B'+cell+':C'+cell+'","majorDimension":"COLUMNS","values":[["'+itinerarycomplimentaryservices+'"]]},';
        cell++;    
        cellbold += '{"repeatCell":{"range":{"sheetId":0,"startRowIndex":'+(cell-1)+',"endRowIndex":'+cell+'},"cell":{"userEnteredFormat":{"textFormat":{"fontSize":11,"bold":true}}},"fields":"userEnteredFormat(backgroundColor,textFormat,horizontalAlignment)"}},';
        body += '{"range":"Sheet1!B'+cell+':G'+cell+'","majorDimension":"COLUMNS","values":[["'+itinerarycomplimentaryservicesnote14+'"]]},'; 
        cell++;
        body += '{"range":"Sheet1!B'+cell+':G'+cell+'","majorDimension":"COLUMNS","values":[["'+itinerarycomplimentaryservicesnote3+' '+includeInsuranceForPassengers+' '+itinerarycomplimentaryservicesnote4+'"]]},'; 
        cell++;
        cellbold += '{"repeatCell":{"range":{"sheetId":0,"startRowIndex":'+(cell-1)+',"endRowIndex":'+cell+'},"cell":{"userEnteredFormat":{"textFormat":{"fontSize":11,"bold":true}}},"fields":"userEnteredFormat(backgroundColor,textFormat,horizontalAlignment)"}},';
        body += '{"range":"Sheet1!B'+cell+':G'+cell+'","majorDimension":"COLUMNS","values":[["'+itinerarycomplimentaryservicesnote15+'"]]},'; 
        cell++;
        body += '{"range":"Sheet1!B'+cell+':G'+cell+'","majorDimension":"COLUMNS","values":[["'+itinerarycomplimentaryservicesnote5+'"]]},'; 
        cell++;
        cellbold += '{"repeatCell":{"range":{"sheetId":0,"startRowIndex":'+(cell-1)+',"endRowIndex":'+cell+'},"cell":{"userEnteredFormat":{"textFormat":{"fontSize":11,"bold":true}}},"fields":"userEnteredFormat(backgroundColor,textFormat,horizontalAlignment)"}},';
        body += '{"range":"Sheet1!B'+cell+':G'+cell+'","majorDimension":"COLUMNS","values":[["'+itinerarycomplimentaryservicesnote13+'"]]},'; 
        cell++;
        body += '{"range":"Sheet1!B'+cell+':G'+cell+'","majorDimension":"COLUMNS","values":[["'+itinerarycomplimentaryservicesnote+' '+itinerarycomplimentaryservicesnote2+'"]]},'; 
        cell += 2;
        /*=== Bold Heading ===*/
        cellBorder += '{"updateBorders":{"range":{"sheetId":0,"startRowIndex":'+(cell-1)+',"endRowIndex":'+cell+',"startColumnIndex":1,"endColumnIndex":7},"top":{"style":"SOLID","width":1},"bottom":{"style":"SOLID","width":1},"left":{"style":"SOLID","width":1},"right":{"style":"SOLID","width":1}}},';
        cellbold += '{"repeatCell":{"range":{"sheetId":0,"startRowIndex":'+(cell-1)+',"endRowIndex":'+cell+',"startColumnIndex":1,"endColumnIndex":7},"cell":{"userEnteredFormat":{"textFormat":{"fontSize":11,"bold":true,"underline":false},"backgroundColor":{"red":0.9,"green":0.9,"blue":0.9}}},"fields":"userEnteredFormat(backgroundColor,textFormat,horizontalAlignment)"}},';
        body += '{"range":"Sheet1!B'+cell+':E'+cell+'","majorDimension":"COLUMNS","values":[["'+itinerarydetailedinclusions+'"]]},';
        cell++; 
        
        Set<String> crmCodes = new Set<String>();
        for(ServiceLineItem__c slid:serLiItDe)
        {
            crmCodes.add(slid.Crm_Code__c);
        }
        
        Map<String,Map<String,String>> uniqueRecMaps = null;
        if(! crmCodes.isEmpty())
         uniqueRecMaps = DAL_ServiceLineItem.getCrmCategoryMapByCrmCodes(crmCodes); 
        
        for(ServiceLineItem__c sli:serLiItDe)
        {
            body += '{"range":"Sheet1!B'+cell+':C'+cell+'","majorDimension":"COLUMNS","values":[["'+sli.SupplierName__c+'"]]},'; 
            if(null != sli.Crm_Code__c 
               && null != uniqueRecMaps
               && ! uniqueRecMaps.isEmpty())
            {
                Map<String,String> uniqueRec = uniqueRecMaps.get(sli.Crm_Code__c);
                if(null != uniqueRec)
                {
                    for (String key : uniqueRec.keySet())
                    {
                        if(key == 'OPI')
                        {
                            cell++; 
                            body += '{"range":"Sheet1!B'+cell+':C'+cell+'","majorDimension":"COLUMNS","values":[["Included : '+uniqueRec.get(key)+'"]]},';
                        }
                        
                        if(key == 'OPX')
                        { 
                            cell++; 
                            body += '{"range":"Sheet1!B'+cell+':C'+cell+'","majorDimension":"COLUMNS","values":[["Excluded : '+uniqueRec.get(key)+'"]]},';
                        }
                    }
                }
            } 
            cell += 2;
        }
        cellBorder += '{"updateBorders":{"range":{"sheetId":0,"startRowIndex":'+oldCell+',"endRowIndex":'+cell+',"startColumnIndex":1,"endColumnIndex":7},"top":{"style":"SOLID","width":1},"bottom":{"style":"SOLID","width":1},"left":{"style":"SOLID","width":1},"right":{"style":"SOLID","width":1}}},';
        cellWrap = '{"repeatCell":{"range":{"sheetId":0,"startRowIndex":12,"endRowIndex":'+cell+'},"cell":{"userEnteredFormat":{"wrapStrategy":"WRAP","verticalAlignment":"TOP"}},"fields":"userEnteredFormat(wrapStrategy,verticalAlignment)"}}'; 
        for(Integer i=cellMerge;i<=cell;i++){
            mergeCell += '{"mergeCells":{"range":{"sheetId":0,"startRowIndex":'+i+',"endRowIndex":'+(i+1)+',"startColumnIndex":1,"endColumnIndex":7},"mergeType":"MERGE_ALL"}},';
            
        }
        
        body += ']}';
        return body;
    }
}
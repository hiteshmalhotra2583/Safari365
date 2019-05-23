global with sharing class QuotationVoucherDocOnGD{
    //=====================================================================================================================    
    public String access_token,expires_in,token_type,refresh_token,id,spreadsheetId;
    public static String cellBorder='',cellWrap='',mergeCell='',cellBold='',quotationName='',googleDocName='',googleDocUrl='';
    public static String itineraryvoucherheading='',itineraryvouchercontact='',itineraryvouchercontact2='',itineraryvouchercontact3='',itineraryvouchercontact4='',itineraryvouchercontact5='',itineraryreservationdetails='',itineraryquotationnumber='',itineraryquotationname='',itineraryvoucherarrival='',itineraryvoucherdepart='',itineraryvoucherguests='',itinerarydate='',itineraryvoucherprovider='',itineraryvoucherservices='',itineraryvoucherresno='',itinerarypassengers='';
    public GDFile[] files,items;
    public String nextPageToken;
    public class GDFile{
        String id,name;
    }
    //=====================================================================================================================   
    global static void changeLabelToSpecfiedLanguage(String selectedLanguage)
    {
        try{
            Util_LabelTranslate t = new Util_LabelTranslate();
            itineraryvoucherheading = (t.translate('itineraryvoucherheading',selectedLanguage)).replace('"', '').trim();
            
            itineraryvouchercontact = (t.translate('itineraryvouchercontact',selectedLanguage)).replace('"', '').trim();
            itineraryvouchercontact2 = (t.translate('itineraryvouchercontact2',selectedLanguage)).replace('"', '').trim();
            itineraryvouchercontact3 = (t.translate('itineraryvouchercontact3',selectedLanguage)).replace('"', '').trim();
            itineraryvouchercontact4 = (t.translate('itineraryvouchercontact4',selectedLanguage)).replace('"', '').trim();
            itineraryvouchercontact5 = (t.translate('itineraryvouchercontact5',selectedLanguage)).replace('"', '').trim();
            
            itineraryreservationdetails = (t.translate('itineraryreservationdetails',selectedLanguage)).replace('"', '').trim();
            itineraryquotationnumber = (t.translate('itineraryquotationnumber',selectedLanguage)).replace('"', '').trim();
            itineraryquotationname = (t.translate('itineraryquotationname',selectedLanguage)).replace('"', '').trim();
            itineraryvoucherarrival = (t.translate('itineraryvoucherarrival',selectedLanguage)).replace('"', '').trim();
            itineraryvoucherdepart = (t.translate('itineraryvoucherdepart',selectedLanguage)).replace('"', '').trim();
            
            itineraryvoucherguests = (t.translate('itineraryvoucherguests',selectedLanguage)).replace('"', '').trim();
            
            itinerarydate = (t.translate('itinerarydate',selectedLanguage)).replace('"', '').trim();
            itineraryvoucherprovider = (t.translate('itineraryvoucherprovider',selectedLanguage)).replace('"', '').trim();
            itineraryvoucherservices = (t.translate('itineraryvoucherservices',selectedLanguage)).replace('"', '').trim();
            itineraryvoucherresno = (t.translate('itineraryvoucherresno',selectedLanguage)).replace('"', '').trim();
            itinerarypassengers = (t.translate('itinerarypassengers',selectedLanguage)).replace('"', '').trim();
        }catch (VisualforceException e) { 
        }
    }
    
    webservice static String createOrNotQuotationVoucherDocOnGD(String quotationId)
    {
        String response = QuotationVoucherDocOnGD.createOrNotQuotationVoucherDocOnGDLtng(quotationId);
        return response;
    }
    
    @AuraEnabled
    public static String createOrNotQuotationVoucherDocOnGDLtng(String quotationId){
        List<id> quotationIds = new List<id>();
        quotationIds.add(quotationId);
        List<Quotations__c> quotations = DAL_Quotations.getAllQuotations(quotationIds);
        List<PassengerQuotationMapping__c> pQMs = DAL_Passenger.getAllPassengerQuotation(quotationIds);
        Boolean isCheckWaiverLiabilty=false;
        for(PassengerQuotationMapping__c pQM :pQMs)
        {
            if(! pQM.Passenger__r.Waiver_Of_Liability__c)
            {
                isCheckWaiverLiabilty = true;
                break;
            }
        }
        
        Quotations__c quotation;
        if(quotations.size()>0){
            quotation = quotations[0];
        }
        
        if(String.isBlank(quotation.Iternary_Language__c))
        {
            return 'Please Select Itinerary Language!';
        }
        else if( quotation.Quotation_Stage__c !='Confirmed')
        {
            return 'Quotation Stage Is Not Confirmed!';
        }
        else if(isCheckWaiverLiabilty)
        {
            return 'Please Check The Passenger Forms all clients need to check they accept the waiver liabilty, before you can create a voucher!';
        }
        else{
           String folderStatus = QuotationVoucherDocOnGD.createQuotationVoucherDocOnGD(quotationId);
            if(folderStatus !=null || folderStatus=='folderNotExist'){
                return 'Please speak to system Admin to correct this issue Google folders not linked!';
            }else{
                //Google Doc Record Created
                GoogleDoc googleDocRec = new GoogleDoc();
                googleDocRec.Name = GoogleDocName;
                googleDocRec.ParentId = quotation.Id;
                googleDocRec.Url = GoogleDocUrl;
                insert googleDocRec;
                
                if(quotation.Client_Has_Requested_Requote__c == true)
                {
                    quotation.Client_Has_Requested_Requote__c = false;
                    update quotation;
                }
                return 'true';
            }
        }
        //return 'false';            
    }
     
   public static String createQuotationVoucherDocOnGD(String quotationId)
   {
           
    GoogleDriveSetting__c GDSetting= GoogleDriveSetting__c.getOrgDefaults();
                  
    String secret = GDSetting.Client_Secret__c;
    String key = EncodingUtil.urlEncode(GDSetting.Client_Id__c,'UTF-8');
    
    if(quotationId!=null){
       
        Long seconds = (DateTime.now().getTime()-GDSetting.Last_Updated__c.getTime())/1000;
        Integer ExpiredIn=Integer.ValueOf(GDSetting.Expired_In__c);
        QuotationVoucherDocOnGD r;
        if(ExpiredIn<seconds){
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
            r = QuotationVoucherDocOnGD.parse(res.getBody());
            if(r!=null){
                 GDSetting.Access_Token__c=r.access_token;
                 GDSetting.Expired_In__c=r.expires_in;
                 GDSetting.Last_Updated__c=DateTime.Now();
            }
        }
        {
            String QuotationFolderId = QuotationVoucherDocOnGD.quotationFolderExist(GDSetting.Access_Token__c,quotationId);   
            if(Test.isRunningTest()){
                if(QuotationFolderId ==null || QuotationFolderId ==''){
                    QuotationFolderId= '1pfHle3jQuH9Q-swDt0M58lZ2JrUJnNt1';
                }
            }
            if(QuotationFolderId ==null || QuotationFolderId ==''){
                return 'folderNotExist';
            } 
            String spreadsheetId = QuotationVoucherDocOnGD.createSpreadSheet(GDSetting.Access_Token__c);
            QuotationVoucherDocOnGD.updateDataSpreadSheet(GDSetting.Access_Token__c,spreadsheetId,quotationId);
            QuotationVoucherDocOnGD.updateDataSpreadSheetFormating(GDSetting.Access_Token__c,spreadsheetId);
            QuotationVoucherDocOnGD.clientFacingDocumentation(GDSetting.Access_Token__c,QuotationFolderId,spreadsheetId);
            
        }
        if(r!=null){
             Update GDSetting;
        }  
   }
   
      return null;                
  }
  
  
    public static QuotationVoucherDocOnGD parse(String jsonString){
        return (QuotationVoucherDocOnGD)JSON.deserialize(jsonString, QuotationVoucherDocOnGD.class);
    }
    
         //Get quotation folder Id
    public static String quotationFolderExist(String access_token,String quotationId){
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
        System.debug('@@body11::'+resls.getBody());
        QuotationVoucherDocOnGD r = QuotationVoucherDocOnGD.parse(resls.getBody());
        
        List<id> quotationIds = new List<id>();
        quotationIds.add(quotationId);
        List<Quotations__c> quotations = DAL_Quotations.getAllQuotations(quotationIds);
        Quotations__c quotation;
        if(quotations.size()>0){
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
        
        String query=EncodingUtil.urlEncode('\''+QuotationFolderId+'\' in parents and trashed=false','UTF-8');
        HttpRequest req1 = new HttpRequest();
        req1.setMethod('GET');
        req1.setEndpoint('https://www.googleapis.com/drive/v3/files?supportsTeamDrives=true&includeTeamDriveItems=true&pageSize=1000&corpora='+corporaString+'&teamDriveId='+teamDriveId+'&q='+query);
        req1.setHeader('content-type', 'application/x-www-form-urlencoded');
        req1.setHeader('content-type', '0');
        req1.setHeader('Authorization', 'Bearer'+' '+access_token);
        req1.setTimeout(120*1000);
        Http h1 = new Http();
        HttpResponse httpResponse1  = h1.send(req1);
        System.debug('@@body11::'+httpResponse1.getBody());
        QuotationVoucherDocOnGD r = QuotationVoucherDocOnGD.parse(httpResponse1.getBody());
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
                        String fileName = 'Quotation Voucher Doc_'+quotationName;
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
                        QuotationVoucherDocOnGD rr = QuotationVoucherDocOnGD.parse(httpResponse2.getBody());
                        if(rr.id != null 
                            && rr.id!='')
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
        
    }
    
    public static String createSpreadSheet(String access_token){
        HttpRequest req1 = new HttpRequest();
        req1.setMethod('POST');
        req1.setEndpoint('https://sheets.googleapis.com/v4/spreadsheets');
        req1.setHeader('content-type', 'application/JSON');
        req1.setHeader('Authorization', 'Bearer'+' '+access_token);
        String messageBody='{"properties": {"title": "V1 Voucher Doc"}}';
        req1.setBody(messageBody);
        req1.setHeader('Content-length', String.valueOf(messageBody.length()));
        req1.setTimeout(60*1000);
        Http h2 = new Http();
        HttpResponse resl = h2.send(req1);
        
        
        System.debug('===='+resl.getBody());
        QuotationVoucherDocOnGD r = QuotationVoucherDocOnGD.parse(resl.getBody()); 
        
        return r.spreadsheetId;
    }
    
    public static void updateDataSpreadSheet(String access_token,String spreadsheetId,String quotationId){
        HttpRequest req1 = new HttpRequest();
        req1.setMethod('POST');
        req1.setEndpoint('https://sheets.googleapis.com/v4/spreadsheets/'+spreadsheetId+'/values:batchUpdate');
        req1.setHeader('content-type', 'application/JSON');
        req1.setHeader('Authorization', 'Bearer'+' '+access_token);
        String messageBody=QuotationVoucherDocOnGD.getBodyContent(quotationId);
        req1.setBody(messageBody);
        req1.setHeader('Content-length', String.valueOf(messageBody.length()));
        req1.setTimeout(60*1000);
        Http h2 = new Http();
        HttpResponse resl = h2.send(req1);
        System.debug('===='+resl.getBody());
        
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
        messageBody += '{"mergeCells":{"range":{"sheetId":0,"startRowIndex":1,"endRowIndex":2,"startColumnIndex":1,"endColumnIndex":6},"mergeType":"MERGE_ALL"}},';
        messageBody += '{"mergeCells":{"range":{"sheetId":0,"startRowIndex":2,"endRowIndex":3,"startColumnIndex":1,"endColumnIndex":6},"mergeType":"MERGE_ALL"}},';
        messageBody += '{"mergeCells":{"range":{"sheetId":0,"startRowIndex":11,"endRowIndex":12,"startColumnIndex":1,"endColumnIndex":6},"mergeType":"MERGE_ALL"}},';
        messageBody += '{"repeatCell":{"range":{"sheetId":0,"startRowIndex":4,"endRowIndex":5},"cell":{"userEnteredFormat":{"textFormat":{"fontSize":11,"bold":true,"underline":true}}},"fields":"userEnteredFormat(backgroundColor,textFormat,horizontalAlignment)"}},';
        messageBody += '{"repeatCell":{"range":{"sheetId":0,"startRowIndex":10,"endRowIndex":11},"cell":{"userEnteredFormat":{"textFormat":{"fontSize":11,"bold":true,"underline":true}}},"fields":"userEnteredFormat(backgroundColor,textFormat,horizontalAlignment)"}},';
        messageBody += '{"repeatCell":{"range":{"sheetId":0,"startRowIndex":12,"endRowIndex":13,"startColumnIndex":1,"endColumnIndex":6},"cell":{"userEnteredFormat":{"textFormat":{"fontSize":11,"bold":true,"underline":true},"backgroundColor":{"red":0.8,"green":0.8,"blue":0.8}}},"fields":"userEnteredFormat(backgroundColor,textFormat,horizontalAlignment)"}}';
        if(mergeCell != null && mergeCell != ''){
            messageBody += ','+mergeCell+','; 
        }else{
            messageBody += ',';
        }
        messageBody += '{"repeatCell":{"range":{"sheetId":0,"startRowIndex":1,"endRowIndex":2},"cell":{"userEnteredFormat":{"textFormat":{"fontSize":18,"bold":true}}},"fields":"userEnteredFormat(backgroundColor,textFormat,horizontalAlignment)"}}';
        if(cellbold != null && cellBold != ''){
            messageBody +=  ','+cellbold+',';
        }else{
            messageBody += ',';
        }
        messageBody += '{"repeatCell":{"range":{"sheetId":0,"startRowIndex":6,"endRowIndex":7,"startColumnIndex":3,"endColumnIndex":6},"cell":{"userEnteredFormat":{"wrapStrategy":"WRAP","verticalAlignment":"TOP"}},"fields":"userEnteredFormat(wrapStrategy,verticalAlignment)"}}'; 
        if(cellBorder != null && cellBorder != ''){
            messageBody += ','+cellBorder+','; 
        }else{
            messageBody += ',';
        }
        messageBody += '{"updateDimensionProperties":{"range":{"sheetId":0,"dimension":"ROWS","startIndex":2,"endIndex":3},"properties":{"pixelSize":145},"fields":"pixelSize"}},';
        messageBody += '{"updateDimensionProperties":{"range":{"sheetId":0,"dimension":"COLUMNS","startIndex":2,"endIndex":4},"properties":{"pixelSize":400},"fields":"pixelSize"}},';
        messageBody += '{"updateDimensionProperties":{"range":{"sheetId":0,"dimension":"ROWS","startIndex":11,"endIndex":12},"properties":{"pixelSize":40},"fields":"pixelSize"}},';
        messageBody += '{"updateBorders":{"range":{"sheetId":0,"startRowIndex":1,"endRowIndex":12,"startColumnIndex":1,"endColumnIndex":6},"top":{"style":"SOLID","width":1},"bottom":{"style":"SOLID","width":1},"left":{"style":"SOLID","width":1},"right":{"style":"SOLID","width":1}}},';
        messageBody += '{"updateBorders":{"range":{"sheetId":0,"startRowIndex":12,"endRowIndex":13,"startColumnIndex":1,"endColumnIndex":6},"top":{"style":"SOLID","width":1},"bottom":{"style":"SOLID","width":1},"left":{"style":"SOLID","width":1},"right":{"style":"SOLID","width":1}}}';
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
        Integer cell=15,no=2,oldCell,startToRwBorder,cellMerge;
        Integer lastCell;
        String quotationLabelLanguage;
        
        List<id> quotationIds = new List<id>();
        quotationIds.add(quotationId);
        List<Quotations__c> quotations = DAL_Quotations.getAllQuotations(quotationIds);
        Quotations__c quotation;
        if(quotations.size() >0)
        {
            quotation = quotations[0];
        }
        
        if(quotation.Iternary_Language__c!=null)
        {
           QuotationVoucherDocOnGD.changeLabelToSpecfiedLanguage(quotation.Iternary_Language__c);
        }
       
        String opportunityOwner = quotation.Opportunity__r.Owner.Name;
        String quotationStage = quotation.Quotation_Stage__c;
        String quotationName = quotation.Opportunity__r.Name+'_'+quotation.Quotation_Name__c;
        Date quotationValidUntil = quotation.Valid_Until__c;
        String quotationNumber = quotation.Name;
        Decimal totalSaleInZar = quotation.Total_Sale_In_Zar__c;
        Decimal totalSaleInUSD = quotation.Total_Sale_In_USD__c;
        String currencyValue = quotation.Currency__c;
        Datetime travelStartDate = quotation.TravelStartDate__c;
        Datetime travelEndDate = quotation.TravelEndDate__c;
        Decimal quotationSaleTotalInCC = quotation.Quotation_Sale_Total_in_CC__c;
        
        List<LegDetail> legDetails = QuotationServiceHelper.GetLegDetails(quotation);
        Map<String, LegDetail> supplierNameToLegDetailsMap = QuotationServiceHelper.supplierNameToLegDetailsMap;
        List<ServiceLineItem__c> allServiceLineItems = QuotationServiceHelper.allServiceLineItems;
        List<ServiceLineItem__c> serviceLineItemsDetail;
        List<ServiceLineItem__c> serLiItDe=new List<ServiceLineItem__c>();
        
        String body;
        body = '{"valueInputOption":"USER_ENTERED","data":[{';
        body += '"range":"Sheet1!B2:D2","majorDimension":"COLUMNS","values":[["'+itineraryvoucherheading+'"]]},';
        body += '{"range":"Sheet1!B3:D3","majorDimension":"COLUMNS","values":[[\'=IMAGE("https://safari365--c.documentforce.com/servlet/servlet.ImageServer?id=0154G0000065vlC&oid=00DD0000000lFNO",4,140,1130)\']]},';
        
        body += '{"range":"Sheet1!B5:C5","majorDimension":"COLUMNS","values":[["'+itineraryvouchercontact+'"]]},';
        body += '{"range":"Sheet1!B6:C6","majorDimension":"COLUMNS","values":[["'+itineraryvouchercontact2+'"]]},';
        body += '{"range":"Sheet1!B7:C7","majorDimension":"COLUMNS","values":[["'+itineraryvouchercontact3+'"]]},';
        body += '{"range":"Sheet1!B8:C8","majorDimension":"COLUMNS","values":[["'+itineraryvouchercontact4+'"]]},';
        body += '{"range":"Sheet1!B9:C9","majorDimension":"COLUMNS","values":[["'+itineraryvouchercontact5+' '+opportunityOwner+'"]]},';
        
        body += '{"range":"Sheet1!D5:D6","majorDimension":"COLUMNS","values":[["'+itineraryreservationdetails+'"]]},';
        body += '{"range":"Sheet1!D6:D7","majorDimension":"COLUMNS","values":[["'+itineraryquotationnumber+' '+quotationNumber+'"]]},';
        body += '{"range":"Sheet1!D7:D8","majorDimension":"COLUMNS","values":[["'+itineraryquotationname+' '+quotationName+'"]]},';
        body += '{"range":"Sheet1!D8:D9","majorDimension":"COLUMNS","values":[["'+itineraryvoucherarrival+' '+travelStartDate+'"]]},';
        body += '{"range":"Sheet1!D9:D10","majorDimension":"COLUMNS","values":[["'+itineraryvoucherdepart+' '+travelEndDate+'"]]},';
        
        body += '{"range":"Sheet1!B11:C11","majorDimension":"COLUMNS","values":[["Guests Travelling"]]},';
        body += '{"range":"Sheet1!B12:D12","majorDimension":"COLUMNS","values":[[""]]},';
        
        cellMerge = 12;
        body += '{"range":"Sheet1!B13:B14","majorDimension":"COLUMNS","values":[["'+itinerarydate+'"]]},';
        body += '{"range":"Sheet1!C13:C14","majorDimension":"COLUMNS","values":[["'+itineraryvoucherprovider+'"]]},';
        body += '{"range":"Sheet1!D13:D14","majorDimension":"COLUMNS","values":[["'+itineraryvoucherservices+'"]]},';
        body += '{"range":"Sheet1!E13:E14","majorDimension":"COLUMNS","values":[["'+itineraryvoucherresno+'"]]},';
        body += '{"range":"Sheet1!F13:F14","majorDimension":"COLUMNS","values":[["'+itinerarypassengers+'"]]},';
        
        Map<String,Date> uniqueRecord = new Map<String,Date>();
        if(legDetails != null && supplierNameToLegDetailsMap != null && allServiceLineItems != null){
            for (String key : supplierNameToLegDetailsMap.keySet()){
                 
                 serviceLineItemsDetail = QuotationServiceHelper.FindServiceItemsForLeg(supplierNameToLegDetailsMap.get(key),allServiceLineItems);
                 for(ServiceLineItem__c sli:serviceLineItemsDetail)
                 {
                    
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
            Set<String> codes = new Set<String>(); 
            for(ServiceLineItem__c sli:serLiItDe)
            {
                serviceLineIdSet.add(sli.Id);
                codes.add(sli.Crm_Code__c);
            }
           
            List<ServiceLineItemPassengersMapping__c>  serviceLineItemPassengerMappings  = DAL_ServiceLineItemPassengersMapping.getPassengerCountBySerLineItemId(serviceLineIdSet);
            Map<String, String> addressMap = DAL_ServiceLineItem.getAddressByCrmCodeMap(codes);
            Map<String, String> phoneNumberMap = DAL_ServiceLineItem.getPhoneMobileNumberByCrmCodes(codes);
            Map<String, String>  gpsDetailMap = DAL_ServiceLineItem.getGPSDetailByCrmCodes(codes);
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
            for(ServiceLineItem__c sli:serLiItDe)
            {
                
                String totalAdult = '0';
                String totalChild = '0';
                String totalInfant = '0';
                if( null != adultCountMap.get(sli.Id))
                totalAdult = String.valueof(adultCountMap.get(sli.Id).size());
                
                if( null != childCountMap.get(sli.Id))
                totalChild = String.valueof(childCountMap.get(sli.Id).size());
                
                if( null != InfantCountMap.get(sli.Id))
                totalInfant = String.valueof(InfantCountMap.get(sli.Id).size());
            
                //String address = DAL_ServiceLineItem.getAddressByCrmCode(sli.Crm_Code__c);
                //String phoneMobile = DAL_ServiceLineItem.getPhoneMobileNumberByCrmCode(sli.Crm_Code__c);
                //String GPSDetail = DAL_ServiceLineItem.getGPSDetailByCrmCode(sli.Crm_Code__c);
                String address = addressMap.get(sli.Crm_Code__c);
                String phoneMobile = phoneNumberMap.get(sli.Crm_Code__c);
                String GPSDetail = gpsDetailMap.get(sli.Crm_Code__c);
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
                
                cellbold += '{"repeatCell":{"range":{"sheetId":0,"startRowIndex":'+(cell-1)+',"endRowIndex":'+cell+'},"cell":{"userEnteredFormat":{"textFormat":{"fontSize":10,"bold":true}}},"fields":"userEnteredFormat(backgroundColor,textFormat,horizontalAlignment)"}},';
                body += '{"range":"Sheet1!B'+cell+':B'+(cell+1)+'","majorDimension":"COLUMNS","values":[["'+dateRecord+'"]]},';
                body += '{"range":"Sheet1!C'+cell+':C'+(cell+1)+'","majorDimension":"COLUMNS","values":[["'+sli.SupplierName__c+'"]]},';
                body += '{"range":"Sheet1!D'+cell+':D'+(cell+1)+'","majorDimension":"COLUMNS","values":[["'+sli.Service_Detail__c+'"]]},';
                body += '{"range":"Sheet1!E'+cell+':E'+(cell+1)+'","majorDimension":"COLUMNS","values":[["'+sli.Reservation_Number__c+'"]]},';
                body += '{"range":"Sheet1!F'+cell+':F'+(cell+1)+'","majorDimension":"COLUMNS","values":[["'+totalAdult+'/'+totalChild+'/'+totalInfant+'"]]},';
                
                if(address != null){
                    cell += 1;
                    body += '{"range":"Sheet1!C'+cell+':C'+(cell+1)+'","majorDimension":"COLUMNS","values":[["'+address+'"]]},';
                }
                
                if(phoneMobile != null){
                    cell += 1;
                    body += '{"range":"Sheet1!C'+cell+':C'+(cell+1)+'","majorDimension":"COLUMNS","values":[["'+phoneMobile+'"]]},';
                }
                
                if(GPSDetail != null){
                    cell += 1;
                    body += '{"range":"Sheet1!C'+cell+':C'+(cell+1)+'","majorDimension":"COLUMNS","values":[["'+GPSDetail+'"]]},';
                }
                
                if(sli.ClientNotes__c!=null){
                    cell += 2;
                    mergeCell += '{"mergeCells":{"range":{"sheetId":0,"startRowIndex":'+(cell-1)+',"endRowIndex":'+cell+',"startColumnIndex":1,"endColumnIndex":6},"mergeType":"MERGE_ALL"}},';
                    body += '{"range":"Sheet1!B'+cell+':D'+(cell+1)+'","majorDimension":"COLUMNS","values":[["Notes: '+sli.ClientNotes__c+'"]]},';
                }
                cell += 1;
                body += '{"range":"Sheet1!C'+cell+':C'+(cell+1)+'","majorDimension":"COLUMNS","values":[[""]]},';
                
                if(ii==1){
                    cellBorder += '{"updateBorders":{"range":{"sheetId":0,"startRowIndex":13,"endRowIndex":'+cell+',"startColumnIndex":1,"endColumnIndex":6},"top":{"style":"SOLID","width":1},"bottom":{"style":"SOLID","width":1},"left":{"style":"SOLID","width":1},"right":{"style":"SOLID","width":1}}},';
                }else{
                    cellBorder += '{"updateBorders":{"range":{"sheetId":0,"startRowIndex":'+oldCell+',"endRowIndex":'+cell+',"startColumnIndex":1,"endColumnIndex":6},"top":{"style":"SOLID","width":1},"bottom":{"style":"SOLID","width":1},"left":{"style":"SOLID","width":1},"right":{"style":"SOLID","width":1}}},';
                
                }
                
                oldCell = cell;
                cell += 2;
                ii++;
            }
        }
        
        cellWrap += '{"repeatCell":{"range":{"sheetId":0,"startRowIndex":11,"endRowIndex":'+cell+'},"cell":{"userEnteredFormat":{"wrapStrategy":"WRAP","verticalAlignment":"TOP"}},"fields":"userEnteredFormat(wrapStrategy,verticalAlignment)"}}'; 
        body += ']}';
        return body;
    }
}
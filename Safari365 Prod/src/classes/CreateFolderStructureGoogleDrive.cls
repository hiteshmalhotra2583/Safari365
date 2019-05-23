global with sharing class CreateFolderStructureGoogleDrive {

    //=====================================================================================================================    
    public String access_token,expires_in,token_type,refresh_token,id;
    public GDFile[] files,items;
    public class GDFile{
        String id,name;
    }
    //=====================================================================================================================   
    webservice static String createFolderGoogleDriveClassic(String quotationId)
    {
        String response = CreateFolderStructureGoogleDrive.createFolderGoogleDriveLtng(quotationId);
        return response;
    }
    
    @AuraEnabled
    public static String createFolderGoogleDriveLtng(String quotationId)
    {
        try{
            List<id> quotationIds = new List<id>();
       	 	quotationIds.add(quotationId);
        	CreateFolderStructureGoogleDrive.createFolderGoogleDrive(quotationIds);
            return 'true';
        }catch(Exception e){
            return e.getMessage();
        } 
    }
    
  //=====================================================================================================================
  @future(callout=true)
  public static void createFolderGoogleDrive(List<Id> quotationIds)
  {
       Map<String,Quotations__c> quotationFolderUrlMap = new Map<String,Quotations__c>();
       List<Quotations__c> updateQuotations = new List<Quotations__c>();
       Map<Id,List<Passenger__c>> passengerMap = new Map<Id,List<Passenger__c>>();
       List<Passenger__c> passengerList=new List<Passenger__c>();
       String passengerName = '';
       String QuotationNo = '';
       Integer NoPax = 0;  
       Date startDate; 
       String accountId,opportId;
       
       List<Id> qid = new List<Id>();           
       List<Quotations__c> allQuotations = DAL_Quotations.getAllQuotations(quotationIds);
       
       for(Quotations__c quo : allQuotations)
       {
          QuotationNo = quo.Name;
          startDate = quo.TravelStartDate__c;
          qid.add(quo.Id);
          passengerMap = CreateFolderStructureGoogleDrive.getPassengerForQuotation(qid);
          //System.debug('@@passengerMap '+passengerMap);
          for(Id mapKey:passengerMap.keyset())
          {
              passengerList = passengerMap.get(mapKey);
          }
          //System.debug('@@passengerList'+passengerList);
          if(passengerList.size() > 0)
          {
              NoPax = passengerList.size();
              
              for(Passenger__c passenger:passengerList)
              {
                   if(passenger.Is_Primary__c==true)
                   {
                      passengerName = passenger.PassengerName__c;
                      if(passenger.New_Account__c!=null)
                      accountId = passenger.New_Account__c;
                      else if(passenger.Account__c!=null)
                      accountId = passenger.Account__c;
                      opportId = passenger.Opportunity__c;
                   }
               }                       
               //system.debug('@QuotationNo : '+QuotationNo+'@passengerName : '+passengerName+'@NoPax : '+NoPax+'@startDate : '+startDate+'@account Id : '+accountId +'opp Id :'+opportId );
               //if(QuotationNo!=NULL && passengerName!=NULL && NoPax!=NULL && startDate!=NULL)
               if(QuotationNo!= null)
               {
                    
                    Account acct = DAL_Account.getAccountById(accountId);
                    Opportunity oppt = DAL_Opportunity.getOpportunityById(opportId);                            
                    
                    String accName =acct.Name;
                    String accId = acct.Id;
                    GoogleDriveSetting__c GDSetting= GoogleDriveSetting__c.getOrgDefaults();
                                  
                    String secret = GDSetting.Client_Secret__c;
                    String key = EncodingUtil.urlEncode(GDSetting.Client_Id__c,'UTF-8');
                    String FolderName;
                    if(accId!=null && accName!=null && accId!='' && accName!='')
                    {
                        FolderName = accName+'_'+accId;
                    }
                    
                    if(FolderName!=null)
                    {
                        Long seconds = (DateTime.now().getTime()-GDSetting.Last_Updated__c.getTime())/1000;
                        Integer ExpiredIn=Integer.ValueOf(GDSetting.Expired_In__c);
                        CreateFolderStructureGoogleDrive r;
                        
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
                            
                            r = CreateFolderStructureGoogleDrive.parse(res.getBody());
                            if(r!=null)
                            {
                                 GDSetting.Access_Token__c=r.access_token;
                                 GDSetting.Expired_In__c=r.expires_in;
                                 GDSetting.Last_Updated__c=DateTime.Now();
                            }
                         }
                        {
                            //Account Folder
                            String teamDriveGDId = CreateFolderStructureGoogleDrive.createAccOppFolder(GDSetting.Access_Token__c,FolderName,null, true);
                            String myDdiveGDId = CreateFolderStructureGoogleDrive.createAccOppFolder(GDSetting.Access_Token__c,FolderName,null, false);
                            
                            if(oppt.Name!=null && oppt.Id!=null)
                            {
                                String teamDrivequotationFolderID='';
                                String myDrivequotationFolderID='';
                               //Opportunity Folder
                               //String teamDriveoppFolderId = CreateFolderStructureGoogleDrive.createAccOppFolder(GDSetting.Access_Token__c,oppt.Name+'_'+oppt.Id,teamDriveGDId,true); 
                               //String myDriveoppFolderId = CreateFolderStructureGoogleDrive.createAccOppFolder(GDSetting.Access_Token__c,oppt.Name+'_'+oppt.Id,myDdiveGDId,false);
                                String teamDriveoppFolderId = CreateFolderStructureGoogleDrive.createAccOppFolder(GDSetting.Access_Token__c,oppt.Id,teamDriveGDId,true); 
                                String myDriveoppFolderId = CreateFolderStructureGoogleDrive.createAccOppFolder(GDSetting.Access_Token__c,oppt.Id,myDdiveGDId,false);  
                               
                               String quotationFolderExistId = CreateFolderStructureGoogleDrive.quotationFolderAlreadyExist(GDSetting.Access_Token__c,QuotationNo,true,teamDriveGDId);
                               String myDrivequotationFolderExistId = CreateFolderStructureGoogleDrive.quotationFolderAlreadyExist(GDSetting.Access_Token__c,QuotationNo,false,'');
                               
                               if(quotationFolderExistId != null && quotationFolderExistId != '')
                               {
                                   //Opportunity Folder => Quotation Folder
                                   teamDrivequotationFolderID = quotationFolderExistId;
                                   myDrivequotationFolderID = myDrivequotationFolderExistId;
                               }else
                               {
                                   //Opportunity Folder => Quotation Folder
                                   //teamDrivequotationFolderID = CreateFolderStructureGoogleDrive.createAccOppFolder(GDSetting.Access_Token__c,QuotationNo+'_'+passengerName+'_'+NoPax+'_'+startDate,teamDriveoppFolderId,true);
                                   teamDrivequotationFolderID = CreateFolderStructureGoogleDrive.createAccOppFolder(GDSetting.Access_Token__c,QuotationNo,teamDriveoppFolderId,true);
                                   //myDrivequotationFolderID = CreateFolderStructureGoogleDrive.createAccOppFolder(GDSetting.Access_Token__c,QuotationNo+'_'+passengerName+'_'+NoPax+'_'+startDate,myDriveoppFolderId,false);
                                   myDrivequotationFolderID = CreateFolderStructureGoogleDrive.createAccOppFolder(GDSetting.Access_Token__c,QuotationNo,myDriveoppFolderId,false);
                                   
                               }
                               quotationFolderUrlMap.put('https://drive.google.com/drive/u/1/folders/'+teamDrivequotationFolderID,quo);
                               // System.debug('teamDriveoppFolderId : '+teamDriveoppFolderId);
                               // System.debug('myDriveoppFolderId : '+myDriveoppFolderId);
                              //  System.debug('teamDrivequotationFolderID : '+teamDrivequotationFolderID);
                              // System.debug('myDrivequotationFolderExistId : '+myDrivequotationFolderExistId);
                                
                               //Opportunity Folder => Photobooks Folder
                               CreateFolderStructureGoogleDrive.createAccOppFolder(GDSetting.Access_Token__c,'Photobooks',teamDriveoppFolderId,true); 
                               //Opportunity Folder => Quotation Folder => Client Facing Documentation
                               String clientFacDocFolderId = CreateFolderStructureGoogleDrive.createAccOppFolder(GDSetting.Access_Token__c,'Client Facing Documentation',myDrivequotationFolderID,false);
                               //Opportunity Folder => Quotation Folder => Internal Documentation - Travelling Files
                               CreateFolderStructureGoogleDrive.createAccOppFolder(GDSetting.Access_Token__c,'Internal Documentation - Travelling Files',teamDrivequotationFolderID,true);
                               //Opportunity Folder => Quotation Folder => Client Facing Documentation => Passengers
                               String passengerFolderId = CreateFolderStructureGoogleDrive.createAccOppFolder(GDSetting.Access_Token__c,'Passengers',clientFacDocFolderId,false);
                               //Opportunity Folder => Quotation Folder => Client Facing Documentation => Passengers => List Of Passenger
                               for(Passenger__c passenger:passengerList)
                               {
                                   //system.debug('passenger.Name:::'+passenger.Name);
                                   //system.debug('passenger.Id:::'+passenger.Id);
                                   CreateFolderStructureGoogleDrive.createAccOppFolder(GDSetting.Access_Token__c,passenger.Name+'_'+passenger.Id,passengerFolderId,false);
                               }
                           
                            }
                        }
                       
                        if(r!=null)
                        {
                           Update GDSetting;
                        }  
                    }      
               }
           
           }
           
       }     
      
      //Update quotations 26-12-2018
      if(quotationFolderUrlMap!=null){
          for(String quoFolderUrl : quotationFolderUrlMap.keyset()) {
              if(!String.isBlank(quoFolderUrl)){
                  Quotations__c quot = new Quotations__c();
                  quot = quotationFolderUrlMap.get(quoFolderUrl);
                  quot.Team_Drive_Quotation_Folder_Url__c = quoFolderUrl;
                  updateQuotations.add(quot);
              }
          }
          update updateQuotations;
      }
  }
  
    public static String quotationFolderAlreadyExist(String access_token,String quotationName,
                                                     Boolean teamDrive,String teamDriveGDId)
    {
        String query=EncodingUtil.urlEncode('trashed=false','UTF-8');
        String endpoint;
        if(teamDrive)
        {
            endpoint='https://www.googleapis.com/drive/v3/files?supportsTeamDrives=true&pageSize=1000&includeTeamDriveItems=true&teamDriveId='+teamDriveGDId+'&q='+query;
           // System.debug('teamDrive = true : '+endpoint);
        }
        else
        {
            endpoint='https://www.googleapis.com/drive/v3/files?supportsTeamDrives=false&pageSize=1000&includeTeamDriveItems=false&q='+query;
           // System.debug('teamDrive = false : '+endpoint);
        }
        
        HttpRequest req2 = new HttpRequest();
        req2.setMethod('GET');
        req2.setEndpoint(endpoint); //'https://www.googleapis.com/drive/v3/files?supportsTeamDrives=true&includeTeamDriveItems=true&q='+query
        req2.setHeader('content-type', 'application/x-www-form-urlencoded');
        req2.setHeader('content-type', '0');
        req2.setHeader('Authorization', 'Bearer'+' '+access_token);
        req2.setTimeout(120*1000);
        Http h3 = new Http();
        HttpResponse resls = h3.send(req2);
        //System.debug('@@body11::'+resls.getBody());
        CreateFolderStructureGoogleDrive  r = CreateFolderStructureGoogleDrive.parse(resls.getBody());
        if(quotationName!=null)
        {
           if(r.files!=null && r.files.size()>0)
           {
                for(GDFile gd: r.files)
                {
                    if(gd.name.startsWith(quotationName))
                    {
                        if(gd.id!=null)
                        {
                            return gd.id;
                        }
                        return null;
                    }
                }
            }
        }
        
        return null;
    }  
    
    public static CreateFolderStructureGoogleDrive parse(String jsonString){
        return (CreateFolderStructureGoogleDrive)JSON.deserialize(jsonString, CreateFolderStructureGoogleDrive.class);
    }
  
    public static String folderExistNew(String access_token,String folderName,String parentId,Boolean teamDrive){
        
        String query=EncodingUtil.urlEncode('name=\''+folderName+'\' and trashed=false','UTF-8');
        GoogleDriveSetting__c GDSetting= GoogleDriveSetting__c.getOrgDefaults();  
        String teamDriveId = GDSetting.TeamDrive_Folder_Id__c; 
        String corporaString = 'teamDrive';
        String teamDriveEndpoint = 'https://www.googleapis.com/drive/v3/files?supportsTeamDrives=true&pageSize=1000&includeTeamDriveItems=true&corpora='+corporaString+'&teamDriveId='+teamDriveId+'&q=';
        String myDriveEndPoint = 'https://www.googleapis.com/drive/v3/files?pageSize=1000&q=';
        
        HttpRequest req2 = new HttpRequest();
        req2.setMethod('GET');
        
        if(parentId!=null && parentId!=''){
            query=EncodingUtil.urlEncode('title=\''+folderName+'\' and trashed=false','UTF-8');
            req2.setEndpoint('https://www.googleapis.com/drive/v2/files/'+parentId+'/children?maxResults=1000&q='+query);
        }
        else{
            if(teamDrive == true)
            {
                req2.setEndpoint(teamDriveEndpoint+query);
            }
            else
            {
                 req2.setEndpoint(myDriveEndPoint+query);
            }
        }
        //system.debug('endpoint to check the exist folder :::'+ req2.getEndpoint());
        req2.setHeader('content-type', 'application/x-www-form-urlencoded');
        req2.setHeader('content-type', '0');
        req2.setHeader('Authorization', 'Bearer'+' '+access_token);
        req2.setTimeout(60*1000);
        Http h3 = new Http();
        HttpResponse resls = h3.send(req2);
        
        CreateFolderStructureGoogleDrive r = CreateFolderStructureGoogleDrive.parse(resls.getBody());
        if(r.files!=null && r.files.size()>0){
            return r.files[0].id;
        }
        if(r.items!=null && r.items.size()>0){
            return r.items[0].id;
        }
        return null;
    }
    
    public static String createAccOppFolder(String access_token,String folderName,String parentId,Boolean teamDrive)
    {
       
        String fileId = CreateFolderStructureGoogleDrive.folderExistNew(access_token,folderName,parentId,teamDrive);
        String teamDriveEndpoint = 'https://www.googleapis.com/drive/v3/files?supportsTeamDrives=true';
        String myDriveEndPoint = 'https://www.googleapis.com/drive/v3/files';
        
        if(fileId==null)
        {
            GoogleDriveSetting__c GDSetting= GoogleDriveSetting__c.getOrgDefaults();                                          
            HttpRequest req1 = new HttpRequest();
            req1.setMethod('POST');
            if(teamDrive==true)
            {
                req1.setEndpoint(teamDriveEndpoint);
                //system.debug('@@teamDriveEndpoint createAccOppFolder'+teamDriveEndpoint);
            }
            else
            {
                req1.setEndpoint(myDriveEndPoint);
                // system.debug('@@teamDriveEndpoint myDriveEndPoint'+myDriveEndPoint);
            }
            req1.setHeader('content-type', 'application/JSON');
            req1.setHeader('Authorization', 'Bearer'+' '+access_token);
            req1.setTimeout(60*1000);
            if(parentId!=NULL && parentId!=''){
                req1.setBody('{"name": "'+folderName+'","mimeType": "application/vnd.google-apps.folder","parents":["'+parentId+'"]}');
            }else{
                String teamId = GDSetting.TeamDrive_Folder_Id__c;                
                if(teamDrive==true)
                {
                    req1.setBody('{"name": "'+folderName+'","mimeType": "application/vnd.google-apps.folder","parents":["'+teamId+'"]}');
                }
                else
                {
                    String myDriveId = GDSetting.MyDrive_Folder_Id__c; 
                    req1.setBody('{"name": "'+folderName+'","mimeType": "application/vnd.google-apps.folder","parents":["'+myDriveId+'"]}');  
                }  
            }
            Http h2 = new Http();
            HttpResponse resl = h2.send(req1);
            CreateFolderStructureGoogleDrive r = CreateFolderStructureGoogleDrive.parse(resl.getBody());
            fileId=r.id;
        }
        return fileId;
        
    }
        
  
  //=====================================================================================================================
   
    public static Map<Id,List<Passenger__c>> getPassengerForQuotation(List<Id> quotationIds)
    {
        List<PassengerQuotationMapping__c> PassengerQuotationMappings = DAL_Passenger.getAllPassengerQuotation(quotationIds) ;
        
        List<String> PassengerIds = new List<String>();
        Map<Id,Set<Id>> quotationPassengermapping = new Map<Id,Set<Id>>();
        Map<Id,List<Passenger__c>> result = new Map<Id,List<Passenger__c>>();
        
        for(Id qid:quotationIds)
        { 
            Set<Id> pIds = new Set<Id>();
            for(PassengerQuotationMapping__c pqm:PassengerQuotationMappings)
            {
                PassengerIds.add(pqm.Passenger__c);
                pIds.add(pqm.Passenger__c);
            }
            quotationPassengermapping.put(qid,pIds);
        }
        
        List<Passenger__c>  Passengers = DAL_Passenger.getByIds(PassengerIds);
        for(Id qid:quotationPassengermapping.keySet())
        {
            Set<Id> pIds = quotationPassengermapping.get(qid);
            List<Passenger__c>  PassengerForQuotation = new List<Passenger__c>();
            for(Passenger__c p :Passengers)
            {
                if(pIds.Contains(p.Id))
                {
                    PassengerForQuotation.add(p);
                }
            }
            result.put(qid,PassengerForQuotation);
        }                
        
        return result;        
    }    
}
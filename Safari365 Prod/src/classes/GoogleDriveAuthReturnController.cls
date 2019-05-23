public class GoogleDriveAuthReturnController {

    GoogleDriveSetting__c GDSetting= GoogleDriveSetting__c.getOrgDefaults();
    private String key = GDSetting.Client_Id__c;
    private String secret = GDSetting.Client_Secret__c;
    
    private String redirect_uri ='https://'+System.URL.getSalesforceBaseUrl().getHost()+'/apex/GoogleDriveAuthReturn';
    private String salesforceIdentificationToken;
    private String access_token,expires_in,token_type,refresh_token;
    public static GoogleDriveAuthReturnController parse(String jsonString) 
    {
        return (GoogleDriveAuthReturnController )JSON.deserialize(jsonString, GoogleDriveAuthReturnController.class);
    }
    public GoogleDriveAuthReturnController (){
        salesforceIdentificationToken = ApexPages.currentPage().getParameters().get('code');
        
        
    }
    
    public PageReference redirect() {
       System.debug('salesforceIdentificationToken:: '+salesforceIdentificationToken);
        
        //Getting access token from google
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint('https://accounts.google.com/o/oauth2/token');
        req.setHeader('content-type', 'application/x-www-form-urlencoded');
        String messageBody = 'code='+salesforceIdentificationToken+'&client_id='+key+'&client_secret='+secret+'&redirect_uri='+redirect_uri+'&grant_type=authorization_code';
        req.setHeader('Content-length', String.valueOf(messageBody.length()));
        req.setBody(messageBody);
        req.setTimeout(60*1000);
    
        Http h = new Http();
        HttpResponse res = h.send(req);
        system.debug('@@req:'+res.getBody());
        GoogleDriveAuthReturnController r = GoogleDriveAuthReturnController.parse(res.getBody());
        //system.debug('r '+r);
        if(r.access_token!=null){
             //GoogleDriveSetting__c GDSetting= GoogleDriveSetting__c.getOrgDefaults();
             GDSetting.Access_Token__c=r.access_token;
             GDSetting.Expired_In__c=r.expires_in;
             GDSetting.Last_Updated__c=DateTime.Now();
             if(r.refresh_token!=null){
                 GDSetting.Refresh_Token__c=r.refresh_token;
             }
             
             Update GDSetting;
        }
        return new PageReference('/apex/GoogleDriveApp'); 
           
    }
    
    
}
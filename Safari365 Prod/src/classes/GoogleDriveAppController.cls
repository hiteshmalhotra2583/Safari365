public class GoogleDriveAppController{
    public Boolean googleDriveConnected {get;set;}
    
    GoogleDriveSetting__c GDSetting= GoogleDriveSetting__c.getOrgDefaults();
    private String key = GDSetting.Client_Id__c;
    private String secret = GDSetting.Client_Secret__c;
    private String redirect_uri ='https://'+System.URL.getSalesforceBaseUrl().getHost()+'/apex/GoogleDriveAuthReturn';
    public GoogleDriveAppController(){
        googleDriveConnected=false;
        GoogleDriveSetting__c GDSetting= GoogleDriveSetting__c.getOrgDefaults();
        if(GDSetting.Refresh_Token__c!=null && GDSetting.Refresh_Token__c!=''){
            googleDriveConnected=true;
        }
    }
            
    public PageReference newAuthorizationCode(){ 
        String key = EncodingUtil.urlEncode(key ,'UTF-8');
        String uri = EncodingUtil.urlEncode(redirect_uri ,'UTF-8');
        
        String authuri = 'https://accounts.google.com/o/oauth2/v2/auth?'+
        'client_id='+key+
        '&access_type=offline'+
        '&response_type=code'+
        '&scope=https://www.googleapis.com/auth/drive'+
        '&redirect_uri='+uri+
        '&state=securitytoken&';
        
        
        PageReference pr = new PageReference(authuri); return pr; 
      }   
    
    
}
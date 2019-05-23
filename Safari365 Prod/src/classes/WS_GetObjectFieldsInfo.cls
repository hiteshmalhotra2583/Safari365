@RestResource(urlMapping='/Safari365/MembersClub/GetFieldsInfo/*')
global with sharing class WS_GetObjectFieldsInfo
{
    private static final String SUCCESS = 'Success';
    private static final String ERROR = 'Error';
    private static final String BLANK_STRING = '';
    
    @Httppost
    global static ResponseWrapper doPost(RequestWrapper requestWrapper)
    {
        ResponseWrapper returnResponse = new ResponseWrapper();
        try{
            List<ObjectFieldUtility.FieldInfo> lstFieldInfo = ObjectFieldUtility.getAllfieldsDescription(requestWrapper.ObjectAPIName);
            returnResponse.status  = SUCCESS;
            returnResponse.fieldInfos = lstFieldInfo;
        }catch(Exception ex){
            returnResponse.status  = Error;
            returnResponse.errorMessage ='Object not Found';
        }
        returnResponse.requestWrapper = requestWrapper;
        
        return returnResponse;
    }
    
    global class ResponseWrapper
    {
        webservice String status;
        webservice String errorMessage;
        public List<ObjectFieldUtility.FieldInfo> fieldInfos;
        webservice RequestWrapper requestWrapper;
    }
        
    global class RequestWrapper
    {
        webservice String ObjectAPIName;
        
        public RequestWrapper(String ObjectAIIName) {
            this.ObjectAPIName = ObjectAIIName;
        }
    }   
            
}

/* 
/services/apexrest/Safari365/MembersClub/GetAccount/*

Request ---
{
"requestWrapper":{
"ObjectAPIName" : "Account"
}
}
*/
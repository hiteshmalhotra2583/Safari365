@RestResource(urlMapping='/Safari365/GoogleDocUrl/*')
global with sharing class WS_GetGoogleDocUrl {
    
     @HttpPost
     webservice static void getGoogleDocUrl(String googleDocId){ 
         String response='';
         GoogleDoc googleDocRecord = new GoogleDoc();
         if(googleDocId != null && googleDocId != ''){
         
           try{
               googleDocRecord = [SELECT Id, Url, ParentId, Name, IsDeleted, OwnerId FROM GoogleDoc WHERE Id=:googleDocId];
           }catch(Exception e){
               response = '{"Error":'+e.getMessage()+'}';
           }
           
           if(googleDocRecord != null){
                if(googleDocRecord.Url!='' && googleDocRecord.Url != null){
                    response = '{"Url" :"'+googleDocRecord.Url+'"}';
                }
                else{
                    response = '{"Error":"No Record Found!"}';
                } 
           }
         }
          if(response != '' && response != null){
                RestContext.response.addHeader('Content-Type', 'application/json');
                RestContext.response.responseBody = Blob.valueOf(response);
          }else{
                response = '{"Error":"Please Enter googleDocId!"}';
                RestContext.response.addHeader('Content-Type', 'application/json');
                RestContext.response.responseBody = Blob.valueOf(response);
         }
     }
     
}
@RestResource(urlMapping='/Safari365/MembersClub/UpdateOpportunityPhotoBookFields/*')
global  with sharing class WS_UpdateOpportunityPhotoBook
{
    private static final String SUCCESS = 'Success';
    private static final String ERROR = 'Error';
    private static final String BLANK_STRING = '';
    
    @Httppost
    global static ResponseWrapper doPost(RequestWrapper requestWrapper)
    {
        ResponseWrapper returnResponse = new ResponseWrapper();
        returnResponse.requestWrapper = requestWrapper;
        
        try{
            if(requestWrapper.opportunityInfo != null 
               && requestWrapper.opportunityInfo.opportunityId != null
               && requestWrapper.opportunityInfo.opportunityId != '' )
             {
                
                 Opportunity opportunity = DAL_Opportunity.getOpportunityById(requestWrapper.opportunityInfo.opportunityId);
                 Account account = DAL_Account.getPersonAccountById(opportunity.accountId);
                 system.debug('account'+account);
                 
                 if(null != requestWrapper.opportunityInfo.shippingCity && requestWrapper.opportunityInfo.shippingCity !='')
                 account.ShippingCity  = requestWrapper.opportunityInfo.shippingCity;
                 if(null != requestWrapper.opportunityInfo.shippingCountry && requestWrapper.opportunityInfo.shippingCountry !='')
                 account.ShippingCountry  = requestWrapper.opportunityInfo.shippingCountry;
                 if(null != requestWrapper.opportunityInfo.shippingPostalCode && requestWrapper.opportunityInfo.shippingPostalCode !='')
                 account.ShippingPostalCode = requestWrapper.opportunityInfo.shippingPostalCode;
                 if(null != requestWrapper.opportunityInfo.shippingState && requestWrapper.opportunityInfo.shippingState !='')
                 account.ShippingState = requestWrapper.opportunityInfo.shippingState;
                 if(null != requestWrapper.opportunityInfo.shippingStreet && requestWrapper.opportunityInfo.shippingStreet !='')
                 account.ShippingStreet = requestWrapper.opportunityInfo.shippingStreet;
                 if( null != requestWrapper.opportunityInfo.shippingLatitude  &&  requestWrapper.opportunityInfo.shippingLatitude !='')
                 account.ShippingLatitude = Decimal.valueof(requestWrapper.opportunityInfo.shippingLatitude);
                 if(  null != requestWrapper.opportunityInfo.shippingLongitude  && requestWrapper.opportunityInfo.shippingLongitude !='')
                 account.ShippingLongitude = Decimal.valueof(requestWrapper.opportunityInfo.shippingLongitude);
                 system.debug('after account'+account);
                 
                 if(  null != requestWrapper.opportunityInfo.photobookStage  && requestWrapper.opportunityInfo.photobookStage !='')
                 opportunity.Photobook_Stage__c = requestWrapper.opportunityInfo.photobookStage;
                 if(null != requestWrapper.opportunityInfo.photobookMissingImages && requestWrapper.opportunityInfo.photobookMissingImages !='')
                 opportunity.Photobook_Missing_Images__c =  Boolean.valueof(requestWrapper.opportunityInfo.photobookMissingImages);
                 
                 if(null != requestWrapper.opportunityInfo.photoBookTrackingNumber && requestWrapper.opportunityInfo.photoBookTrackingNumber !='')
                 opportunity.PhotoBook_Tracking_Number__c = requestWrapper.opportunityInfo.photoBookTrackingNumber;
                 
                 if(null != requestWrapper.opportunityInfo.photobookTitle && requestWrapper.opportunityInfo.photobookTitle !='')
                 opportunity.Photobook_Title__c = requestWrapper.opportunityInfo.photobookTitle;
                 
                 if(null != requestWrapper.opportunityInfo.mayWeUseYoupPhotographs && requestWrapper.opportunityInfo.mayWeUseYoupPhotographs !='')
                 opportunity.May_we_use_your_photographs__c = Boolean.valueof(requestWrapper.opportunityInfo.mayWeUseYoupPhotographs);
                 
                 if(null != requestWrapper.opportunityInfo.printExtraPhotoSharedOnFB && requestWrapper.opportunityInfo.printExtraPhotoSharedOnFB !='')
                 opportunity.Print_extra_photo_Shared_on_FB__c =  Boolean.valueof(requestWrapper.opportunityInfo.printExtraPhotoSharedOnFB);

                BaseTriggerHandler.byPass('OpportunityTriggerHandler');
                    update account;
                    update opportunity;
                BaseTriggerHandler.clearBypass('OpportunityTriggerHandler');
                returnResponse.status  = SUCCESS;
            }
            else {
                returnResponse.status  = Error;
                returnResponse.errorMessage ='Opportunity Not found';
            }
        }catch(Exception ex){
            system.debug('exception occured'+ex);
            returnResponse.status  = Error;
            returnResponse.errorMessage = ex.getMessage();
        }
     
       return returnResponse;
    }
    
   
    global class ResponseWrapper {
        webservice String status;
        webservice String errorMessage;        
        webservice RequestWrapper requestWrapper;
    }
        
    global class RequestWrapper {
        
        webservice opportunityInfoWrapper opportunityInfo;
        
        public RequestWrapper(opportunityInfoWrapper oppWrap) {
            this.opportunityInfo = oppWrap;
        }
    }   
    
    global class opportunityInfoWrapper {
        webservice String opportunityId;
        webservice String photobookStage;
        webservice String photobookMissingImages;
        webservice String photoBookTrackingNumber;
        webservice String photobookTitle;
        webservice String mayWeUseYoupPhotographs;
        webservice String printExtraPhotoSharedOnFB;
        webservice String deliveryNotes;
        webservice String shippingCity;
        webservice String shippingCountry;
        webservice String shippingPostalCode;
        webservice String shippingState;
        webservice String shippingStreet;
        webservice String shippingLatitude;
        webservice String shippingLongitude;



 
    }     
    
        
}
/********************************************************

{
    "requestWrapper": {
        "opportunityInfo":{
            "OpportunityId":"0060E000007jk8A",
            "photobookStage":"Not Loaded",
            "photobookMissingImages":"true",
             "photoBookTrackingNumber":"22",
            "photobookTitle":"PhotBook",
            "mayWeUseYoupPhotographs":"true",
            "printExtraPhotoSharedOnFB":"true",
            "deliveryNotes":"Safari PhotoBook",
            "shippingCity":"CapeTown",
            "shippingCountry":"RSA",
            "shippingPostalCode":"8000",
            "shippingState":"Capewtown",
            "shippingStreet":"Cape",
            "shippingLatitude":"",
            "shippingLongitude":""
        }   
    }
}

   PhotoBook Stage all possible value 
Not Loaded
Started Loading
Uploaded
Ready to be Printed
At Printers
Sent
Client No Longer Interested
}


***********************************************************/
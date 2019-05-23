trigger ExposureRoeTrigger on Exposure_ROE__c (after insert ,after update) {
    
    new TH_ExposureRoe().run(); 
}
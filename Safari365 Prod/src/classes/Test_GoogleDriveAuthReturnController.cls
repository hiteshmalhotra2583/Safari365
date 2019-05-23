@isTest
private class Test_GoogleDriveAuthReturnController {
        @testSetup static void setupInsertData()
    {
        User us = TestDataFactory.createUser(true, '', true);
        System.runAs(us){
            GoogleDriveSetting__c GDSetting= new GoogleDriveSetting__c();
            GDSetting.Access_Token__c='ya29.Gly7Bf_N4RntWboIxqzepsNUK6peHCP128fFoFIngVB0jYcbfcu1pohoYe4Ix35AD5VT2rEUpJbBzoGmhO5usEX_iOEMVIlsW0texKNF7cx4SGkBCBkTeKeAg0YB3w';
            GDSetting.Expired_In__c='3600';
            GDSetting.Client_Id__c = '1064689029437-o8cb1ese4j3vr2cjne1jj7d5nupe40qd.apps.googleusercontent.com';
            GDSetting.Client_Secret__c = '0fOjg-EicipIWsIxRbLwbYGy';
            //GDSetting.Refresh_Token__c = '1/PNE2SPiiVlD-c229simV0WbsTxmriVaB-ksm1CZKdEw';
            GDSetting.TeamDrive_Folder_Id__c ='0AGVNCjd9GIIQUk9PVA';
            GDSetting.Last_Updated__c=DateTime.Now().adddays(-1);
            insert GDSetting;
            
        }   
        
    }
    @isTest static void createQuotationItineraryDocOnGDTestLtng(){
        
        Test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new GoogleDriveMockResponse());
        
        PageReference myVfPage = Page.GoogleDriveAuthReturn;
        Test.setCurrentPage(myVfPage);
        
        // Put Id into the current page Parameters
        ApexPages.currentPage().getParameters().put('code','xyz');
        
        GoogleDriveAuthReturnController ac = new GoogleDriveAuthReturnController();
        ac.redirect();
        Test.stopTest();
    }
    
}
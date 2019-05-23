@isTest
private class Test_CustomLabelTranslator_CTRL {
       
    @isTest static void createQuotationItineraryDocOnGDTestLtng(){
        
        Test.startTest();
        PageReference myVfPage = Page.CustomLabelTranslator_VF;
        Test.setCurrentPage(myVfPage);
        
        // Put Id into the current page Parameters
        ApexPages.currentPage().getParameters().put('label_lang','US');
        ApexPages.currentPage().getParameters().put('label','test');
        
        CustomLabelTranslator_CTRL ac = new CustomLabelTranslator_CTRL();
        Test.stopTest();
    }
    
}
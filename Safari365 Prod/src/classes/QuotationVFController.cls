public class QuotationVFController {
    public String recId{get;set;}
    public String parentID;
    public Quotations__c quotation ;

    public QuotationVFController(ApexPages.StandardController stdController) {
		parentID = System.currentPagereference().getParameters().get('retURL').replace('/','');
    }

    /*public void CreateNewQuotation()
    {
        if (parentID != null){
            quotation  = new Quotations__c();
            quotation.Opportunity__c=parentid;
            
            insert quotation;
            this.recId =quotation.Id;
        }
    }*/
}
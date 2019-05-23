@isTest
private class TLQTest{
    public static testMethod void testTLQ() {

        Test.startTest();
        
        
        
        Account a = new Account();
        a.Name='test2';
        a.Newsletter__c=true;
   //     a.RecordTypeId = '012D0000000Jjz7';
        insert a;     
        
        Opportunity o = new Opportunity();
        o.name = 'test opp';
        o.AccountId = a.Id;
        o.stagename = 'Teststage';
        o.CloseDate = System.Today();
        BaseTriggerHandler.bypass('OpportunityTriggerHandler');
        insert o;
       
        
        TL_Quotation__c tlq = new TL_Quotation__c();
        tlq.Opportunity__c = o.Id;
        tlq.Sales__c=200.00;
        
        tlq.Primary_Quotation__c = true;
        tlq.Travel_Date__c= system.today();
        
        insert tlq;
        
        tlq.ROE__c= 7.00;
        tlq.COS__c=300.00;
        update tlq;
        
        TL_Quotation__c tlq2 = new TL_Quotation__c();
        tlq2.Opportunity__c = o.Id;
        tlq2.Sales__c=200.00;
        
        tlq2.Primary_Quotation__c = true;
        
        insert tlq2;
        
        tlq2.ROE__c= 7.00;
        tlq2.COS__c=300.00;
        update tlq2;
        
   //     delete tlq;
        
        o.Primary_TL_Quotation__c = tlq.id;
        o.Arrival_Date__c=tlq.Travel_Date__c;
       // o.Invoice_Date__c=tlq.Travel_Date__c;
        update o;
        
        o.Primary_TL_Quotation__c = tlq2.id;
          o.Arrival_Date__c=tlq2.Travel_Date__c;
        //o.Invoice_Date__c=tlq2.Travel_Date__c;
        update o;
        BaseTriggerHandler.bypass('OpportunityTriggerHandler');
      //  system.assertEquals(inv.Id,[select AccountId from Contact where Id=:case1.ContactId].AccountId);
        Test.stopTest();
    }

}
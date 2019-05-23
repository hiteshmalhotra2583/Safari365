@isTest(SeeAllData=true)
private class Batch_LeadNurtureNewsLetter_Test  {
    public static List<Lead_Nurture__c> lst_LeadNurture;
    static void setupData(){      
        lst_LeadNurture = new List<Lead_Nurture__c>();
        
        lst_LeadNurture.add(getLeadNurture(new Lead_Nurture__c(Email__c='Test@NewTest.com',Active_and_outdoor_adventure__c=true)));
        lst_LeadNurture.add(getLeadNurture(new Lead_Nurture__c(Email__c='Test@NewTest.com',Beach_relaxation__c=true)));
        lst_LeadNurture.add(getLeadNurture(new Lead_Nurture__c(Email__c='Test@NewTest.com',Botswana__c=true)));
        lst_LeadNurture.add(getLeadNurture(new Lead_Nurture__c(Email__c='Test@NewTest.com',Family_safaris__c=true)));
        lst_LeadNurture.add(getLeadNurture(new Lead_Nurture__c(Email__c='Test@NewTest.com',Food_and_Wine__c=true)));
        lst_LeadNurture.add(getLeadNurture(new Lead_Nurture__c(Email__c='Test@NewTest.com',History_and_culture__c=true)));
        lst_LeadNurture.add(getLeadNurture(new Lead_Nurture__c(Email__c='Test@NewTest.com',Honeymoons_and_romance__c=true)));
        lst_LeadNurture.add(getLeadNurture(new Lead_Nurture__c(Email__c='Test@NewTest.com',Kenya__c=true)));
        lst_LeadNurture.add(getLeadNurture(new Lead_Nurture__c(Email__c='Test@NewTest.com',Namibia__c=true)));
        lst_LeadNurture.add(getLeadNurture(new Lead_Nurture__c(Email__c='Test@NewTest.com',Rwanda__c=true)));
        lst_LeadNurture.add(getLeadNurture(new Lead_Nurture__c(Email__c='Test@NewTest.com',South_Africa__c=true)));
        lst_LeadNurture.add(getLeadNurture(new Lead_Nurture__c(Email__c='Test@NewTest.com',Tanzania__c=true)));
        lst_LeadNurture.add(getLeadNurture(new Lead_Nurture__c(Email__c='Test@NewTest.com',Uganda__c=true)));
        lst_LeadNurture.add(getLeadNurture(new Lead_Nurture__c(Email__c='Test@NewTest.com',Victoria_Falls__c=true)));
        lst_LeadNurture.add(getLeadNurture(new Lead_Nurture__c(Email__c='Test@NewTest.com',Walking_safaris__c=true)));
        lst_LeadNurture.add(getLeadNurture(new Lead_Nurture__c(Email__c='Test@NewTest.com',Wildlife_and_safari_experiences__c=true)));
        lst_LeadNurture.add(getLeadNurture(new Lead_Nurture__c(Email__c='Test@NewTest.com',Zanzibar_and_Pemba__c=true)));
        lst_LeadNurture.add(getLeadNurture(new Lead_Nurture__c(Email__c='Test@NewTest.com',Zambia__c=true)));
        insert lst_LeadNurture;
    }
    static Lead_Nurture__c getLeadNurture(Lead_Nurture__c leadNearture_Obj){
        leadNearture_Obj.Newsletter__c=true;
        leadNearture_Obj.First_Name__c='testOne';
        leadNearture_Obj.Last_Name__c='testLast';
        return leadNearture_Obj;
    } 
    static testMethod void callmethod_Scheduler_Test() {                      
        Test.startTest();            
        setupData();            
        Batch_LeadNurtureNewsLetter m = new Batch_LeadNurtureNewsLetter();            
        String sch = '20 40 8 10 2 ?';            
        system.schedule('Batch Lead Nurt Test', sch, m);        
        Test.stopTest();         
    } 
}
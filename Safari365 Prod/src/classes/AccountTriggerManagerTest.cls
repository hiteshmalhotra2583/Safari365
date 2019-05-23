@isTest
private class AccountTriggerManagerTest 
{
    static Account accountObj;
    static Account personAccountObj;
    static void setupData(){
        Recordtype rt = [ select id from recordtype where name='person Account'];
        accountObj = new Account(recordtypeid=rt.id, FirstName='testFirst', lastName='test Last', Phone='4343343434', PersonEmail='test@fakememail.com',Salutation='Mr.');
        insert accountObj;
    }
    
    
    static void setupData1(){
        Recordtype rt = [ select id from recordtype where name='person Account'];
        personAccountObj = new Account(recordtypeid=rt.id, FirstName='testFirst', lastName='test Last', Phone='4343343434', PersonEmail='tes22@fakememail.com',Salutation='Mr.');
        insert personAccountObj;
        Opportunity opp = new Opportunity();
            opp.Name = 'Test Opportunity';
            opp.AccountId = personAccountObj.Id;
            opp.CloseDate = date.today();
            opp.StageName = 'TL Quotation';
            
            insert opp;
        
    }
    
    
    /*public static testMethod void RunTestMethod1()
    {
        test.startTest();
            setupData();
            UpdateMemberIdonAccount obj = new UpdateMemberIdonAccount ();
            Database.executeBatch(obj, 10);
        test.stopTest();
    }
    public static testMethod void RunTestMethod2()
    {
        test.startTest();
            setupData();
            List<Account> lst_Ac = new List<Account>();
            
            lst_Ac.add(accountObj);
            AccountTriggerManager.createlead(lst_Ac);
            Account account = [ Select Members_Club_ID__c from Account Where Id=:accountObj.Id];
            System.debug('----- '+ account.Members_Club_ID__c);
            List<Lead> lst_lead = [ Select Id from Lead Where ConvertedAccountId=:accountObj.Id];
            System.assertEquals(account.Members_Club_ID__c,lst_lead[0].Id );
        test.stopTest();
    }*/
    
     public static testMethod void RunTestMethod3()
    {
        test.startTest();
            setupData1();
            personAccountObj.PersonEmail='Change@email.com';
            update personAccountObj;
        test.stopTest();
    }
    
}
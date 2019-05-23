@isTest
public class Test_Trigger_PAD {
    @isTest
    private static void test() {
        
        Profile p = [select id from profile where name='Standard User' LIMIT 1]; 
        
        User u = new User(alias = 'standt', email='standarduser@testorg.com',emailencodingkey='UTF-8', 
                          lastname='Testing', languagelocalekey='en_US', localesidkey='en_US', 
                          profileid = p.Id, timezonesidkey='America/Los_Angeles', 
                          username='standarduser@seb.com', ByPassTrigger__c ='TH_Quotations;OPTTriggerHandler', ByPassValidation__c =true);
         
        System.runAs(u) {
            System.assert(Trigger_PAD.canRun('TH_Quotations') == false);
            System.assert(Trigger_PAD.canRun('OPDTriggerHandler') == true);
            
            Trigger_PAD.deactivateTrigger('OPDTriggerHandler');
            System.assert(Trigger_PAD.canRun('OPDTriggerHandler') == false);
            
            Trigger_PAD.activateTrigger('TH_Quotations');
            System.assert(Trigger_PAD.canRun('TH_Quotations') == true);          
         }
    }
}
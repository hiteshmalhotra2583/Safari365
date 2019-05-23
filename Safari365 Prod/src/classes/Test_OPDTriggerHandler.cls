@isTest
private class Test_OPDTriggerHandler {
    
    public static List<OPD__c>  opds = new List<OPD__c>();
    public static List<OSR__c>  osrs = new List<OSR__c>();
    public static Integer count =3;
    
    @testSetup static void setupInsertData()
    {
        User us = TestDataFactory.createUser(true, '', true);
        System.runAs(us){
            Map<String,Object> keyValueMap1 = new Map<String,Object>();
            keyValueMap1.put('OSR_ID__c', String.valueof(1));
            for(Integer i = 0 ; i <count; i++)
                osrs.add((OSR__c) TestDataFactory.operationOnObjectRecord(null, 'OSR__c', keyValueMap1));
            
            insert osrs;
            
            Map<String,Object> keyValueMap = new Map<String,Object>();
            keyValueMap.put('OSR_ID__c', String.valueof(1));
            
            for(Integer i = 0 ; i <count; i++)
            {
                opds.add((OPD__c) TestDataFactory.operationOnObjectRecord(null, 'OPD__c', keyValueMap));
            }
            insert opds;
        }
    }
    
    @isTest static void testingAllMethodTest(){
        Test.startTest();
        OPDTriggerHandler opdTriHand = new OPDTriggerHandler();
        Test.stopTest();
    }
    
   /* @isTest static void testingAllMethod2Test(){
        List<OPD__c> opds = [SELECT Id,OSR_ID__c FROM OPD__c];
        Test.startTest();
        OPDTriggerHandler opdTriHand = new OPDTriggerHandler();
        //opdTriHand.processRecords(opds);
        Test.stopTest();
    }*/
    
}
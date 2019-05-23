@isTest
private class Test_DeleteRecordsFromSalesforce {

    public static Integer recordsCount =100;
    static List<NTS__c> nts= new List<NTS__c>();
    static void setupTestData()
    {
    	for(Integer i = 0 ; i <recordsCount; i++)
        {
            nts.add((NTS__c) TestDataFactory.operationOnObjectRecord(null, 'NTS__c', null));
        }
        
        insert nts;
    }
   
    public static SettingsToDeleteRecord__mdt createRecordsDelete(String objectName, String fieldValue
        , String fieldName, String operator, boolean active) 
    {
        Map<String, Object> jsonFields = new Map<String, Object>();
        SettingsToDeleteRecord__mdt recordsToDelete = new SettingsToDeleteRecord__mdt();
        jsonFields.put('ObjectName__c', objectName);
        jsonFields.put('FieldValue__c', fieldValue);
        jsonFields.put('FieldName__c', fieldName);
        jsonFields.put('Operator__c', operator);
        jsonFields.put('Active__c', active);
        
        recordsToDelete = (SettingsToDeleteRecord__mdt)JSON.deserialize(JSON.serialize(jsonFields), SettingsToDeleteRecord__mdt.class);
        return recordsToDelete;
    }
    
    
   
    static testMethod void deleteScheduleTest() {
    	setupTestData();
    	Test.startTest();
    	
    	DeleteRecordsFromSalesforce.DeleteRecords();
    	
    	Test.stopTest();
        
    }
}
@isTest
private class Test_LookupWetuEndLocation {

   public static List<WetuLocation__c>  wetuLocations = new List<WetuLocation__c>();
   public static Integer count =5;
    
    static void setupInsertData(){
        
        for(Integer i = 0 ; i <count; i++)
        {
            wetuLocations.add((WetuLocation__c) TestDataFactory.operationOnObjectRecord(null,'WetuLocation__c', null));
        }
        insert wetuLocations;
        
    }
    
    
    static testMethod void searchWetuLocationTest() {
     
      setupInsertData();
      Test.startTest();
      LookupWetuEndLocation.searchWetuLocation('WetuLocation__c', 'Location_Name__c', 'Location_Type__c', 
                                 1,'Location_Name__c',(String) wetuLocations[0].get('Location_Name__c'));
      Test.stopTest();
    }
    
}
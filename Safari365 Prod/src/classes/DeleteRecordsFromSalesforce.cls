global class DeleteRecordsFromSalesforce implements Schedulable{
	
	private static final String CLASS_NAME = DeleteRecordsFromSalesforce.class.getName();
	@testVisible
    private static List<SettingsToDeleteRecord__mdt> recordsToDelete;
    
	public static  void DeleteRecords(){
        
        UTIL_LogGenerator logger = new UTIL_LogGenerator();
        logger.start(CLASS_NAME,'DeleteRecords' );
        if(Test.isrunningTest())
        {
          recordsToDelete = [SELECT ObjectName__c,FieldValue__c,FieldName__c,Operator__c FROM SettingsToDeleteRecord__mdt where Active__c =true and TestCase__c = true ];
        }else
        {
        recordsToDelete = [SELECT ObjectName__c,FieldValue__c,FieldName__c,Operator__c FROM SettingsToDeleteRecord__mdt where Active__c =true ];
        }
        logger.log('recordsToDelete',recordsToDelete);
        Map<String, SettingsToDeleteRecord__mdt> objectNameQueryMap  = new Map<String, SettingsToDeleteRecord__mdt>();
        for(SettingsToDeleteRecord__mdt recordToDelete:recordsToDelete)
        {
        	objectNameQueryMap.put(recordToDelete.ObjectName__c, recordToDelete);
        }
        List<sObject> objectsToDelete = new List<sObject>();
      
	        for(String key:objectNameQueryMap.keySet())
	        {
	            SettingsToDeleteRecord__mdt recordToDelete=objectNameQueryMap.get(key);
	            String query = 'Select Id from '+ recordToDelete.ObjectName__c+' where '+recordToDelete.FieldName__c + recordToDelete.Operator__c + recordToDelete.FieldValue__c +' limit 49000';
	            logger.log(query);
	            List<sObject> objects =Database.query(query);
	            Integer sizeOfRows = objects.size();
	            logger.log('Query Object size',objects.size());
	            objects.sort();
	            objectsToDelete.addAll(objects);
	            DAL_BaseObject.DeleteDBObjectsAsync(objectsToDelete);
	        }
        logger.end();
	}
	
	global void execute(SchedulableContext bc){
       DeleteRecordsFromSalesforce.DeleteRecords();
   }
}
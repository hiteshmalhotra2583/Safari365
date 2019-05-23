global virtual class DAL_BaseObject 
{
    global enum DatabaseOperation {DBO_INSERT, DBO_UPDATE, DBO_DELETE, DBO_UNDELETE}
    
    private static final String CONTACT_EMAIL_SUFFIX = '@mailinator.com';
    private static final String ERROR_UNABLE_TO_DELETE = 'Unable to delete the following: ' + al.StringUtils.LF;
    private static final String ERROR_UNABLE_TO_SAVE = 'Unable to save the following: ' + al.StringUtils.LF;
    private static final String SUCCESSFULL_DELETE_MESSAGE = 'Successfully deleted an object with ID: ';
    
    //Used to retrieve recordtypes during a transaction context, will be filled with all recordtypes in system.
    private static List<RecordType> ALL_RECORD_TYPES = null;
    private static Map<String, Map<String, RecordType>> ALL_RECORD_TYPES_BYOBJECT_MAP = null;
    private static Map<ID, RecordType> ALL_RECORD_TYPES_BYID_MAP = null;
    private static String MASTER_RECORDTYPE_NAME = 'Master';
    
    public static final String COUNT_ALIAS = 'num';
    public static final String CUSTOM_FIELD_SUFFIX = '__c';
    public static final String SUM_ALIAS = 'sum';
    
    // Field names todo: refactor - FIELD_ must be the prefix
    public static final String ID_FIELD = 'Id';
    public static final String NAME_FIELD = 'Name';
    public static final String OWNER_ID_FIELD = 'OwnerId';
    public static final String RECORDTYPE_ID_FIELD = 'RecordTypeID';
    public static final String DESCRIPTION_FIELD = 'Description';
    
    public static final String SEARCH_TERM_FMT = '{0}{1}{0}';
    public static final String LIKE_WILD_CARD_CHAR = '%';
    public static final String SOQL_OFFSET_FMT = ' OFFSET {0}';
    private static final Set<String> DEFAULT_SEARCH_FIELDS = new Set<String> {ID_FIELD, NAME_FIELD};
    
    //Various Lengths
    public static final Integer FL_NAME = 80;
    private static final Integer DEFAULT_NAME_LEN = 15;
    
    public static final String SUBJECT_FMT = '{0} - {1}';

    private static final Map<Integer, DatabaseOperation> DATABASE_OPP_MAP = new Map<Integer, DatabaseOperation>
    {
        DatabaseOperation.DBO_INSERT.ordinal() => DatabaseOperation.DBO_INSERT,
        DatabaseOperation.DBO_UPDATE.ordinal() => DatabaseOperation.DBO_UPDATE,
        DatabaseOperation.DBO_DELETE.ordinal() => DatabaseOperation.DBO_DELETE,
        DatabaseOperation.DBO_UNDELETE.ordinal() => DatabaseOperation.DBO_UNDELETE
    };

    public class DatabaseException extends Exception {}
    
    public static Boolean InsertDBObjects(List<SObject> listOfObjects, Boolean allInsertsMustSucceed) 
    {
        return UpdateDatabase(listOfObjects, DatabaseOperation.DBO_INSERT, allInsertsMustSucceed);
    }
    
    public static void InsertDBObjectsAsync(List<SObject> listOfObjects)
    {
        if (!listOfObjects.isEmpty())
        {
            if (listOfObjects.size() > UTIL_Constants.MAX_DML_BATCH)
                Database.executeBatch(new Batch_LargeListDBOperation(listOfObjects, DAL_BaseObject.DatabaseOperation.DBO_INSERT), UTIL_Constants.MAX_APEX_BATCH);
            else
                insertDBObjects(listOfObjects);
        }
    }
    
    public static void DeleteDBObjectsAsync(List<SObject> listOfObjects)
    {
        if (!listOfObjects.isEmpty())
        {
            if (listOfObjects.size() > UTIL_Constants.MAX_DML_BATCH)
                Database.executeBatch(new Batch_LargeListDBOperation(listOfObjects, DAL_BaseObject.DatabaseOperation.DBO_DELETE), UTIL_Constants.MAX_APEX_BATCH);
            else
                deleteDBObjects(listOfObjects);
        }
    }
    
    public static void UpdateDBObjectsAsync(List<SObject> listOfObjects)
    {
        if (!listOfObjects.isEmpty())
        {
            if (listOfObjects.size() > UTIL_Constants.MAX_DML_BATCH)
                Database.executeBatch(new Batch_LargeListDBOperation(listOfObjects, DAL_BaseObject.DatabaseOperation.DBO_UPDATE), UTIL_Constants.MAX_APEX_BATCH);
            else
                updateDBObjects(listOfObjects);
        }
    }
    
    public static Boolean InsertDBObjects(List<SObject> listOfObjects)
    {
        return InsertDBObjects(listOfObjects, true);
    }
    
    public static Boolean InsertDBObject(SObject obj)
    {
        return InsertDBObjects(New List<SObject>{obj});
    }

    public static Boolean UpdateDBObjects(List<SObject> listOfObjects, Boolean allUpdatesMustSucceed)
    {
        return UpdateDatabase(listOfObjects, DatabaseOperation.DBO_UPDATE, allUpdatesMustSucceed);
    }

    public static Boolean UpdateDBObject(SObject obj)
    {
        return UpdateDBObjects(new List<SObject>{obj});
    }

    public static Boolean UpdateDBObjects(List<SObject> listOfObjects)
    {
        return UpdateDBObjects(listOfObjects, true);
    }

    public static Boolean DeleteDBObjects(List<SObject> listOfObjects, Boolean allDeletesMustSucceed)
    {
        return UpdateDatabase(listOfObjects, DatabaseOperation.DBO_DELETE, allDeletesMustSucceed);
    }

    public static Boolean DeleteDBObjects(List<SObject> listOfObjects)
    {
        return DeleteDBObjects(listOfObjects, true);
    }
    
    public static Boolean DeleteDBObject(SObject obj)
    {
        return DeleteDBObjects(new List<SObject> {obj});
    }

    private static Boolean UpdateDatabase(List<SObject> listOfObjects, DatabaseOperation operation, Boolean allOperationsMustSucceed) 
    {
        Savepoint saveTransaction = null;

        if (listOfObjects.isEmpty())
            return false;

        List<SObject> listToUpdate = new List<SObject>();

        //remove duplicates (if we are doing delete or update)
        if (operation == DatabaseOperation.DBO_UPDATE || operation == DatabaseOperation.DBO_DELETE) {
            Set<SObject> setOfObject = new Set<SObject>();
            setOfObject.addAll(listOfObjects);
            listToUpdate.addAll(setOfObject);
        } else
            listToUpdate.addAll(listOfObjects);

        //On large diverse operations we get the following error, sorting seems to sort it out
        //System.TypeException: Cannot have more than 10 chunks in a single operation.
        //Please rearrange the data to reduce chunking.
        listToUpdate.sort();


        if (allOperationsMustSucceed)
            saveTransaction = Database.setSavepoint();

        Database.SaveResult[] saveResults = null;
        Database.Deleteresult[] deleteResults = null;
        try 
        {
            if (operation == DatabaseOperation.DBO_INSERT)
                saveResults = Database.insert(listToUpdate, allOperationsMustSucceed);
            else if (operation == DatabaseOperation.DBO_UPDATE)
                saveResults = Database.update(listToUpdate, allOperationsMustSucceed);
            else if (operation == DatabaseOperation.DBO_DELETE)
                deleteResults = Database.delete(listToUpdate, allOperationsMustSucceed);

            Integer objIndex = 0;

            if (saveResults != null)
                for (Database.SaveResult saveResult : saveResults) 
                {
                    
                    if (!saveResult.isSuccess()) {
                        Database.Error[] listofErrors = saveResult.getErrors();
                        for (Database.Error error : listofErrors) {
                            String errorMessage = ERROR_UNABLE_TO_SAVE + al.SObjectUtils.toString(listToUpdate[objIndex]);
                            errorMessage += al.StringUtils.LF + error.getStatusCode() + ' - ' + error.getMessage();
                        }
                    }

                    objIndex++;
                }
            else if (deleteResults != null)
                for (Database.Deleteresult deleteResult : deleteResults) 
                {
                    
                    if (!deleteResult.isSuccess()) 
                    {
                        Database.Error[] listofErrors = deleteResult.getErrors();
                        for (Database.Error error : listofErrors) 
                        {
                            String errorMessage = ERROR_UNABLE_TO_DELETE + al.SObjectUtils.toString(listToUpdate[objIndex]);
                            errorMessage += al.StringUtils.LF + error.getStatusCode() + ' - ' + error.getMessage();
                        }
                    }

                    objIndex++;
                }

        }
        catch (Exception error) 
        {
            if (saveTransaction != null)
                Database.rollback(saveTransaction);

            SystemUtil.logException(error);

            throw error;
        }

        return (saveResults != null || deleteResults != null);
    }
    
    public static DatabaseOperation getTriggerDBOperation()
    {
        if (trigger.isInsert)
            return DatabaseOperation.DBO_INSERT;
        else if (trigger.isUpdate)
            return DatabaseOperation.DBO_UPDATE;
        else if (trigger.isDelete)
            return DatabaseOperation.DBO_DELETE;
        else
            return DatabaseOperation.DBO_UNDELETE;
    }
    
    public static String generateRandomNumber()
    {
        return al.RandomStringUtils.randomNumeric(DEFAULT_NAME_LEN);
    }

    public static Double generateRandomDouble()
    {
        Double randomDouble = Math.random() * Math.pow(10 , DEFAULT_NAME_LEN );
        return randomDouble;
    }

    public static String generateRandomNumber(Integer length)
    {
        return al.RandomStringUtils.randomNumeric(length);
    }     

    public static String generateRandomName() 
    {
        return al.RandomStringUtils.randomAlphabetic(DEFAULT_NAME_LEN);
    }

    public static String generateRandomDescription() 
    {
        return al.RandomStringUtils.randomAlphabetic(FL_NAME);
    }

    public static String generateRandomEmail() 
    {
        return generateRandomName() + CONTACT_EMAIL_SUFFIX;
    }
    
    public static String generateRandomPhoneNumber(Integer length)
    {
        return '+' + al.RandomStringUtils.randomNumeric(length);
    }
    
    public static List<RecordType> getRecordTypesForCurrentUser(SObjectType objectType)
    {
        List<RecordType> recordTypes = new List<RecordType>();
        Set<ID> recordTypeIds = new Set<ID>();

        Schema.DescribeSObjectResult dsr = objectType.getDescribe();

        List<Schema.RecordTypeInfo> recordTypeInfos = dsr.getRecordTypeInfos();
        for( Schema.RecordTypeInfo recordTypeInfo : recordTypeInfos)
        {
            if(recordTypeInfo.isAvailable())
                if(!MASTER_RECORDTYPE_NAME.equals(recordTypeInfo.Name))
                    recordTypeIds.add(recordTypeInfo.getRecordTypeId());
        }
        
        recordTypes = getRecordTypesByIds(recordTypeIds);
        
        return recordTypes;
    }

    public static String getRecordTypeById(Id recordTypeID)
    {           
        populateRecordTypesMap();
        
        RecordType recordType = ALL_RECORD_TYPES_BYID_MAP.get(recordTypeID);
        
        if (recordType != null)
            return recordType.Name;
        else
            return al.StringUtils.EMPTY;
    }
    
    public static List<RecordType> getRecordTypesByIds(Set<ID> recordTypeIds)
    {   
        populateRecordTypesMap();
        
        List<RecordType> recordTypes = new List<RecordType>();
                        
        for (ID recordTypeId : recordTypeIds)
        {
            RecordType recordType = ALL_RECORD_TYPES_BYID_MAP.get(recordTypeID);
            if (recordType != null)
                recordTypes.add(recordType);
        }
        
        return recordTypes;
    }

    /*
    * @description Method will retrieve the Id for the RecordType of an Object by DeveloperName (if it exists), else it will return a null
    * This method can be called many times in the same transaction context but will only ever do one query
    */
    public static Id getRecordTypeByDeveloperName(SObjectType objectType, String recordTypeName)
    {
        populateRecordTypesMap();
        
        Map<String, RecordType> recordTypesMap = ALL_RECORD_TYPES_BYOBJECT_MAP.get(objectType.getDescribe().getLocalName());    
        
        if (recordTypesMap == null)
            return null;
            
        RecordType recordType = recordTypesMap.get(recordTypeName);
        
        if (recordType == null)
            return null;
            
        return recordType.Id;
    }
    
    /*
    * @description Method will ensure all recordtypes are retrieved and popualted into map (assuminng map hasn't already been populated)
    */
    private static void populateRecordTypesMap()
    {
        if (ALL_RECORD_TYPES == null)
        {
            ALL_RECORD_TYPES_BYOBJECT_MAP = new Map<String, Map<String, RecordType>>();
            
            ALL_RECORD_TYPES =
            [
                SELECT Id,
                        DeveloperName,
                        SobjectType,
                        Name,
                        Description
                FROM RecordType
                LIMIT 10000
            ];
            
            ALL_RECORD_TYPES_BYID_MAP = new Map<ID, RecordType>();
            
            for (RecordType recordType : ALL_RECORD_TYPES)
            {
                ALL_RECORD_TYPES_BYID_MAP.put(recordType.Id, recordType);
                
                Map<String, RecordType> recordTypesMap = ALL_RECORD_TYPES_BYOBJECT_MAP.get(recordType.SobjectType); 
                    
                if (recordTypesMap == null)
                {
                    recordTypesMap = new Map<String, RecordType>();
                    ALL_RECORD_TYPES_BYOBJECT_MAP.put(recordType.SobjectType, recordTypesMap);  
                }
                
                recordTypesMap.put(recordType.DeveloperName, recordType);   
            }
            
        }
    }
    
    public static Set<Id> getRecordTypesByDeveloperNames(Set<String> developerNames)
    {
        List<RecordType> recordTypes = 
        [
            SELECT Id
            FROM RecordType
            WHERE DeveloperName IN :developerNames
        ];
        
        return extractListIds(recordTypes);
    }

    public static List<RecordType> getRecordTypes(SObjectType objectType)
    {
        return
        [
            SELECT 
                Id,
                Name,
                DeveloperName,
                Description
            FROM 
                RecordType
            WHERE 
                SobjectType = :objectType.getDescribe().getLocalName()          
        ];
    }
    
    public static Set<Id> extractListIds(List<SObject> objectList)
    {
        return SystemUtil.extractListIds(objectList, ID_FIELD);
    }
    
    /*
    * @description Method will ensure that the string passed will fit inside a name field.
    */
    public static String fitToName(String input) 
    {
        return al.StringUtils.abbreviate(input, 0, FL_NAME);
    }

    public static SObject newObject(String sobjectTypeName) 
    {
        SObjectType objType = SystemUtil.getSObjectTypeByName(sobjectTypeName);
        if (objType == null)
            return null;

        return objType.newSObject();
    }
}
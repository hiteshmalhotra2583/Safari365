public class SystemUtil
{
    private static final String EMAIl_REGEX ='([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';

    public class AssertionException extends exception {}
    public class InvalidMethodParametersException extends exception {}

    private static final String JSON_STRING_FMT = '"{0}"';
    private static final String JSON_QUOTE = '"';
    
    public virtual class JlException extends Exception {}
    public class RecordTypeException extends JlException {}
    public class PageReferenceException extends JlException {}
    public class DataGenerationException extends JlException {}
    
    private static Integer FISCAL_YEAR_START_MONTH = 7;
    private static Integer YEAR_END_MONTH = 12;

    public static void justThrow()
    {
        throw new JlException();
    }
    public static void justThrow(String message)
    {
        throw new JlException(message);
    }

    public static void throwDataGenerationException(String what, String why)
    {
        throw new DataGenerationException(String.format(UTIL_Constants.XM_GEN_ERROR, new List<String> {what, why}));
    }

    public static void throwFieldValueAsertionException(String subject, String fieldName, Object expected, Object got, String message)
    {
        throw new AssertionException(String.format(UTIL_Constants.XM_ASSERT_VALUE, new List<String> {subject, fieldName, String.valueOf(expected), String.valueOf(got), message}));
    }

    public static void throwInvalidMethodParametersException(String methodName, String message)
    {
        throw new InvalidMethodParametersException(String.format(UTIL_Constants.XM_INVALID_METHOD_PARAMS, new List<String> {methodName, message}));
    }
    
    public static List<SObject> extractListFromMap(Map<String, List<SObject>> objectMap)
    {
        List<SObject> objectList = new List<SObject>();
                
        if (objectMap != null &&  objectMap.values() != null && !objectMap.values().isEmpty())
            for (List<SObject> valuesList : objectMap.values())
                objectList.addAll(valuesList);              

        
        return objectList;
    }   

    public static Boolean matches(SObject obj, Map<String, Object> filter)
    {
        Boolean bMatches;

        for (String name : filter.keySet()) {
            Object fieldVal = obj.get(name);
            Object filterVal = filter.get(name);

            // Special case: we assume a match when [boolean] false == null.
            // Extend these special cases, as needed (e.g. string null = ''). Also, we may want to specify a "strict match" at some stage.
            if (filterVal instanceof Boolean && (Boolean)filterVal == false)
                bMatches = fieldVal == false || fieldVal == null;
            else
                bMatches = fieldVal == filterVal;

            if (!bMatches) return false;
        }

        return true;
    }

    public static List<SObject> findWhere(List<SObject> objects, String fieldName, Object value)
    {
        return findWhere(objects, new Map<String, Object>{ fieldName => value });
    }

    public static List<SObject> findWhere(List<SObject> objects, Map<String, Object> filter)
    {
        List<SObject> result = new List<SObject>();
        for (SObject obj : objects)
            if (matches(obj, filter))
                result.add(obj);

        return result;
    }

    public static List<SObject> omitWhere(List<SObject> objects, String fieldName, Object value)
    {
        return omitWhere(objects, new Map<String, Object>{ fieldName => value });
    }

    public static List<SObject> omitWhere(List<SObject> objects, Map<String, Object> filter)
    {
        if (objects == null) return null;

        List<SObject> result = new List<SObject>();
        for (SObject obj : objects)
            if (!matches(obj, filter))  {
                result.add(obj);
            }

        return result;
    }

    public static Set<ID> omit(Set<ID> masterList, Set<ID> toBeOmitted)
    {
        if (masterList == null) return null;
        Set<ID> result = masterList.clone();
        result.removeAll(toBeOmitted);
        return result;
    }

    public static Set<ID> concat(Set<ID> set1, Set<ID> set2)
    {
        Set<ID> result = new Set<ID>(set1);
        result.addAll(set2);
        return result;
    }

     public static List<SObject> excludeItemsFromList(List<SObject> sourceItems, List<SObject> excludeItems)
     {
        List<SObject> resultList = new List<SObject>();
        
        if (sourceItems == null || sourceItems.isEmpty())
            return resultList;
            
        if (excludeItems == null || excludeItems.isEmpty())
        {
            resultList.addAll(sourceItems);
            return resultList;
        }
            
        Set<SObject> objectSet = new Set<SObject>(sourceItems);
        objectSet.removeAll(excludeItems);
        resultList.addAll(objectSet);
        
        return resultList;
    }

    public static Boolean hasSObjectField(SObject so, String fieldName)
    {
        try
        {
            so.get(fieldName);
            return true;
        }
        catch( Exception ex )
        {
            return false;
        }
    }

    public static Map<Id, String> getRecordTypeMap(String objectType)
    {
        Map<Id, String> recordTypeMap = new Map<Id, String>();
        List<RecordType> recordTypes = [SELECT Id, DeveloperName FROM RecordType WHERE SobjectType = :objectType];

        for(RecordType recordType : recordTypes)
            recordTypeMap.put(recordType.Id, recordType.DeveloperName);

        return recordTypeMap;
    }
    
    public static Set<Id> extractListIds(List<SObject> objects, String fieldName, Boolean removeNulls)
    {
        Set<Id> Ids = new Set<Id>();

        ID itemId;
        if (objects != null)
            for (SObject item : objects)
            {
                itemId = (Id)item.get(fieldName);
                if (!removeNulls || itemId != null)
                    Ids.add(itemId);
            }

        return Ids;
    }

    public static Set<Id> extractListIds(List<SObject> objects, String fieldName)
    {
        return extractListIds(objects, fieldName, false);
    }
    
    public static Set<Id> extractListIds(List<SObject> objects)
    {
        return extractListIds(objects, false);
    }

    public static Set<Id> extractListIds(List<SObject> objects, Boolean removeNulls)
    {
        Set<Id> result = (new Map<Id, SObject>(objects)).keySet();
        if (removeNulls)
            result.remove(null);
        return result;
    }
    
    public static Map<Id, Set<Id>> convertListToMapSet(List<SObject> objectList, String objectFieldName,String KeyFieldName)
    {
         Map<Id, Set<Id>> objectMap = new Map<Id, Set<Id>>();
    
        if (objectList != null)
            for (SObject item : objectList)
            {
                Id idFromField = (Id)item.get(objectFieldName);

                if ( !objectMap.containsKey(idFromField))
                {
                    Set<Id> SetInMap = new Set<Id>();
                    SetInMap.add((Id)item.get(KeyFieldName));
                    objectMap.put(idFromField , SetInMap);
                }
                else
                {
                    Set<Id> SetInMap = objectMap.get(idFromField);
                    SetInMap.add((Id)item.get(KeyFieldName));
                }
            }
         
        return objectMap;
    }

    public static Map<Id, List<SObject>> convertListToMap(List<SObject> objectList, String objectFieldName)
    {
         Map<Id, List<SObject>> objectMap = new Map<Id, List<SObject>>();
         
         if (objectList != null)
             for (SObject item : objectList)
             {
                Id idFromField = (Id)item.get(objectFieldName);

                if ( !objectMap.containsKey(idFromField))
                {
                    List<SObject> listInMap = new List<SObject>();
                    listInMap.add(item);
                    objectMap.put(idFromField , listInMap);
                }
                else
                {
                    List<SObject> listInMap = objectMap.get(idFromField);
                    listInMap.add(item);
                }
             }
         
         return objectMap;
    }

    public static Map<Id, SObject> convertListToSingleMap(List<SObject> objectList, String objectFieldName)
    {
         Map<Id, SObject> objectMap = new Map<Id, SObject>();
         
         if (objectList != null)
             for (SObject item : objectList)
             {
                Id idFromField = (Id)item.get(objectFieldName);
                objectMap.put(idFromField, item);
             }
         
         return objectMap;
    }

    public static String getCompoundKey(SObject obj, String[] objectFieldNames)
    {
        String result = '';

        for (String field : objectFieldNames)
            result += String.valueOf(obj.get(field));

        return result;
    }

    public static Map<String, SObject> convertListToSingleMap(List<SObject> objectList, String[] objectFieldNames)
    {
        Map<String, SObject> objectMap = new Map<String, SObject>();

        if (objectList != null)
            for (SObject item : objectList)
                objectMap.put(getCompoundKey(item, objectFieldNames), item);

        return objectMap;
    }

	public static void logException(Exception error)
	{
		if (error instanceof System.DMLException)
		{
			System.DMLException dmlError = (System.DMLException)error;
			for (Integer i = 0; i < dmlError.getNumDml(); i++)
				System.debug(dmlError.getDmlMessage(i));
		}
		else
			System.debug(error);
	}

    public static void processException(Exception error, SObject so)
    {
        logException(error);

        if (error instanceof System.DMLException)
        {
            System.DMLException dmlError = (System.DMLException)error;

            if (dmlError.getNumDml() > 0)
                so.addError(dmlError.getDmlMessage(0), false);
            else
                so.addError(error, false);
        }
        else
            so.addError(error, false);
    }

    public static List<Id> setToList(Set<Id> aSet) 
    {
        List<Id> returnValue = null;
        if (aSet != null)
            returnValue = new List<Id>(aSet);
        return returnValue;
    }

    public static List<String> setToList(Set<String> aSet) 
    {
        List<String> returnValue = null;
        if (aSet != null)
            returnValue = new List<String>(aSet);
        return returnValue;
    }    
    
	
	
	public static SObjectType getSObjectTypeByName(String sobjectTypeName)
	{
    	if (String.isBlank(sobjectTypeName))
      		return null;
      
    	return Schema.getGlobalDescribe().get(sobjectTypeName);
	}
	
	public static Boolean isEmpty(String str)
    {
        return str == null || str == '';
    }
	
	public static List<Schema.PicklistEntry> getPicklistEntries(String objType, String fieldName)
	{
		Schema.SObjectType token = Schema.getGlobalDescribe().get(objType);
		return getPicklistEntries(token, fieldName);
	}

	public static List<Schema.PicklistEntry> getPicklistEntries(Schema.SObjectType token, String fieldName)
	{
		Schema.DescribeSObjectResult describe = token.getDescribe();
		Map<String, Schema.SObjectField> fieldMap = describe.fields.getMap();
		return fieldMap.get(fieldName).getDescribe().getPickListValues();
	}

	public static Map<String,String> getPicklistEntriesMap(Schema.SObjectType token, String fieldName)
	{
		List<Schema.PicklistEntry> picklistEntries = getPicklistEntries(token, fieldName);
		Map<String,String> picklistEntriesMap = new Map<String,String>();
		for(Schema.PicklistEntry picklistEntry : picklistEntries)
      		picklistEntriesMap.put(picklistEntry.getLabel(),picklistEntry.getValue());

    	return picklistEntriesMap;
	}
	
	public static Date dateTimeToDate(Datetime inDate)
    {
        return Date.newinstance(inDate.year(), inDate.month(), inDate.day());
    }

    // =================== Testing Helpers
    public static void assertEmptyList(List<SObject> items, String message)
    {
        assertSizeEquals(items, 0, message);
    }

    public static void assertSizeEquals(List<SObject> items, Integer size, String message)
    {
        if (items.size() != size) 
        {
            String msg = String.format('Assertion error: List is size {0}, and should be {1}. {2}', new String[] {string.valueOf(items.size()), string.valueOf(size), message != null ? ', for: ' + message : ''});
            throw new AssertionException(msg);
        }
    }

    public static void assertIDSetEquals(Set<ID> set1, Set<ID> set2, String message)
    {
        if (set1.size() != set2.size())
        {
            String msg = String.format('Assertion error: Lists of mismatching size {0} and {1}. {2}', new String[] {string.valueOf(set1.size()), string.valueOf(set2.size()), message != null ? ', for: ' + message : ''});
            throw new AssertionException(msg);
        }

        for (ID s : set1)
            if (!set2.contains(s))
            {
                String msg = String.format('Assertion error: List content mismatch - Element {0} not found. {1}', new String[] {s, message != null ? ', for: ' + message : ''});
                throw new AssertionException(msg);
            }
    }
    
    public static void assertDateSetEquals(Set<Date> set1, Set<Date> set2, String message)
    {
        if (set1.size() != set2.size())
        {
            String msg = String.format('Assertion error: Lists of mismatching size {0} and {1}. {2}', new String[] {string.valueOf(set1.size()), string.valueOf(set2.size()), message != null ? ', for: ' + message : ''});
            throw new AssertionException(msg);
        }

        for (Date s : set1)
            if (!set2.contains(s))
            {
                String msg = String.format('Assertion error: List content mismatch - Element {0} not found. {1}', new String[] {s.format(), message != null ? ', for: ' + message : ''});
                throw new AssertionException(msg);
            }
    }

    public static void assertObjectValues(SObject obj, String[] fieldNames, Object[] values, String message)
    {
        String objName = obj.getSObjectType().getDescribe().getLocalName();
        for (Integer i = 0; i < Math.min(fieldNames.size(), values.size()); i++)
            if (obj.get(fieldNames[i]) != values[i])
                throwFieldValueAsertionException(objName, fieldNames[i], values[i], obj.get(fieldNames[i]), message);
    }

    /**
     * Remove all matching items from a list
     *
     * @param   sourceItems The list containing the original source items
     * @param   deleteItems The set of items we want to remove
     * @return  A list containing the remaining items after removing matching deleteItems
     */
    public static List<String> removeItems(List<String> sourceItems, Set<String> deleteItems)
    {
        List<String> result = new List<String>(sourceItems);
        
        if (sourceItems.isEmpty() || deleteItems.isEmpty())
            return result;
            
        //Loop backwards through the list so that the index remains valid
        for(Integer i = result.size() - 1; i >= 0; i--)
            if (deleteItems.contains(result[i]))
                    result.remove(i);
                    
        return result;
    }
       


	public static String formatDateStringToString(String dateString){
       
        String o_Year =dateString.substring(0,dateString.indexof('-')); 
        String o_Month = dateString.substring(dateString.indexof('-')+1,dateString.lastindexof('-'));
        String o_day = dateString.substring(dateString.lastindexof('-')+1,dateString.length()); 
        String s = o_day+'/'+o_Month+'/'+o_Year;
                     
        return s;
    }
    
    public static Date convertStringToDate(String dateString){
       
        if(String.isBlank(dateString))
            return null;
            
        Long longDate = null;
        try{
            longDate = Long.valueOf(dateString);    
        }catch(Typeexception ex){
            longDate = 0;
        }
        if(longDate != null){
            Date dt = Datetime.newInstance(longDate).date();
            return dt;
        }
        
        String o_Day =dateString.substring(0,dateString.indexof('/')); 
        String o_Month = dateString.substring(dateString.indexof('/')+1,dateString.lastindexof('/'));
        String o_Year = dateString.substring(dateString.lastindexof('/')+1,dateString.length()); 
        Date d  = date.newinstance(Integer.valueOf(o_Year), Integer.valueOf(o_Month), Integer.valueOf(o_Day));
        return d;
     
    }
     
    public static Date convertSToDate(String dateString){
       
        if(String.isBlank(dateString))
            return null;
        
        String o_Day =dateString.substring(0,dateString.indexof('/')); 
        String o_Month = dateString.substring(dateString.indexof('/')+1,dateString.lastindexof('/'));
        String o_Year = dateString.substring(dateString.lastindexof('/')+1,dateString.length()); 
        Date d  = date.newinstance(Integer.valueOf(o_Year), Integer.valueOf(o_Month), Integer.valueOf(o_Day));
        return d;
    }
     
      public static Date convertStToDate(String dateString){
       
        if(String.isBlank(dateString))
            return null;
        
        String o_Month =dateString.substring(0,dateString.indexof('/')); 
        String o_Day = dateString.substring(dateString.indexof('/')+1,dateString.lastindexof('/'));
        String o_Year = dateString.substring(dateString.lastindexof('/')+1,dateString.length()); 
        Date d  = date.newinstance(Integer.valueOf(o_Year), Integer.valueOf(o_Month), Integer.valueOf(o_Day));
        return d;
     }
        
    public static Date convertStringToDateYYYYDDMM(String dateString){
       
        String o_Year = dateString.substring(0,dateString.indexof('-')); 
        String o_Month = dateString.substring(dateString.indexof('-')+1,dateString.lastindexof('-'));
        String o_day = dateString.substring(dateString.lastindexof('-')+1,dateString.length()); 
        Date d  = date.newinstance(Integer.valueOf(o_Year), Integer.valueOf(o_Month), Integer.valueOf(o_Day));
        return d;
    }

    
    public static Boolean convertStringtoBoolean(String booleanStr)
	{
		Boolean b = Boolean.valueOf(booleanStr);
		return b;
	}
	
	public static Integer convertStringtoInteger(String integerStr)
	{
		Integer i = 0;
		if(!String.isBlank(integerStr))
		{
			 i = Integer.valueOf(integerStr);
		}
		return i;
	}
	
	public static Decimal convertStringtoDecimal(String decimalStr)
	{
		Decimal d = Decimal.valueOf(decimalStr);
		return d;
	}
    
	public static boolean checkEmailAddressRegex(String emailAddress)
    {
        boolean flag = false;
        Pattern MyPattern = Pattern.compile(EMAIl_REGEX);
        // Then instantiate a new Matcher object "MyMatcher"
        Matcher MyMatcher = MyPattern.matcher(emailAddress);
        if(!MyMatcher.matches()) 
           flag = true;
        
        return flag;
    } 
    
}
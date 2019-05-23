@isTest
private class Test_SystemUtil {

    public static final String ERR_MSG = 'myTestThrow';
    public static final Set<String> INIT_SET = new Set<String>{'', '', 'not empty', ' ', 'full', 'not_blank'};
    public static final Set<String> SET_TO_REMOVE = new Set<String>{'not empty', 'not_blank'};
    private static String FIELD_ACCOUNT_SOURCE = 'AccountSource';
    public static final String TEST_STRING_KEY = 'key';
    public static final String NON_EXISTING_FIELD = 'nothingn';
    public static final String TEST_NAME= 'TestName';
    
    
    static testMethod void assertIDSetEqualsTest()
    {
        Test.startTest();
        NTS__c a = (NTS__c) TestDataFactory.operationOnObjectRecord(null, DAL_NTS.OBJECT_NAME, null);
        insert a;
        Set<ID> set1 = new Set<ID>();
        set1.add(a.id);
        Set<ID> set2  = new Set<ID>(set1);
        
        String message = DAL_BaseObject.generateRandomName();

        try
        {        
            SystemUtil.assertIDSetEquals(set1, new Set<ID>(),  message);
            system.assert(false, 'TEST 1. Sets are not equal. This exception must be thrown.');
        }
        catch(SystemUtil.AssertionException anAssertionException)
        {
            
        }

        try
        {        
            SystemUtil.assertIDSetEquals(set1, set2,  message);
        }
        catch(SystemUtil.AssertionException anAssertionException)
        {
            system.assert(false, 'TEST 2. Sets are equal. This exception must be not thrown.');
        }
        
        try
        {   
            a = (NTS__c) TestDataFactory.operationOnObjectRecord(null, DAL_NTS.OBJECT_NAME, null);
            insert a;
            set2  = new Set<ID>();
            set2.add(a.id);
            SystemUtil.assertIDSetEquals(set1, set2,  message);
            system.assert(false, 'TEST 3. Sets are not equal. This exception must be thrown.');
        }
        catch(SystemUtil.AssertionException anAssertionException)
        {
            
        }
    }
    
    static testMethod void assertObjectValuesTest()
    {
        Test.startTest();
        NTS__c a = (NTS__c) TestDataFactory.operationOnObjectRecord('insert', DAL_NTS.OBJECT_NAME, null);
        
        String message = DAL_BaseObject.generateRandomName();
        
        String[] fieldNames = new List<String>(); 
        fieldNames.add('Name');
        fieldNames.add('OwnerId');
        fieldNames.add('AGENT_CODE__c');
        fieldNames.add('BSL_ID__c');
        fieldNames.add('BHD_ID__c');
        fieldNames.add('MESSAGE_TEXT__c');
        fieldNames.add('NOTE_LEVEL__c');
        
        Object[] values = new List<Object>();
        values.add(a.Name);
        values.add(a.OwnerId);
        values.add(a.AGENT_CODE__c);
        values.add(a.BSL_ID__c);
        values.add(a.BHD_ID__c);
        values.add(a.MESSAGE_TEXT__c);
        values.add(a.NOTE_LEVEL__c);
        
        try
        {        
            SystemUtil.assertObjectValues(a, fieldNames, values, message);
        }
        catch(SystemUtil.AssertionException anAssertionException)
        {
            system.assert(false, 'TEST 1. Data are equal. This exception must be not thrown.');
        }
        
        try
        {       
           values[0] = DAL_BaseObject.generateRandomName(); 
           SystemUtil.assertObjectValues(a, fieldNames, values, message);
           system.assert(false, 'TEST 2. Data are not equal. This exception must be thrown.');
        }
        catch(SystemUtil.AssertionException anAssertionException)
        {
            
        }
        Test.stopTest();
    }
    
    
    static testMethod void assertSizeTest()
    {
        Test.startTest();
        
        NTS__c a = (NTS__c) TestDataFactory.operationOnObjectRecord('insert', DAL_NTS.OBJECT_NAME, null);
        
        SObject[] items = new List<SObject>(); 
        items.add(a);
        
        String message = DAL_BaseObject.generateRandomName();
         
        try
        {        
            SystemUtil.assertSizeEquals(items, items.size(), message);
        }
        catch(SystemUtil.AssertionException anAssertionException)
        {
            system.assert(false, 'TEST 1. Size is correct. This exception must be not thrown.');
        }
        
        try
        {       
           SystemUtil.assertSizeEquals(items, items.size()+1, message);
           system.assert(false, 'TEST 2. Size is NOT correct. This exception must be thrown.');
        }
        catch(SystemUtil.AssertionException anAssertionException)
        {
            
        }

        Test.stopTest();
    }
   static testMethod void excludeItemsFromListTest()
    {
       
       NTS__c acc1 = (NTS__c) TestDataFactory.operationOnObjectRecord('insert', DAL_NTS.OBJECT_NAME, null);
       NTS__c acc2 =(NTS__c) TestDataFactory.operationOnObjectRecord('insert', DAL_NTS.OBJECT_NAME, null);
       NTS__c acc3 = (NTS__c) TestDataFactory.operationOnObjectRecord('insert', DAL_NTS.OBJECT_NAME, null);
       List<NTS__c> itemsList = new List<NTS__c>
       {
          acc1,
          acc2,
          acc3
       };
       List<NTS__c> exludeItemsList = new List<NTS__c>
       {
          acc1,
          acc3
       };
       List<NTS__c> results;

       Test.startTest();

       results = SystemUtil.excludeItemsFromList(itemsList, exludeItemsList);

       Test.stopTest();

       SystemUtil.assertSizeEquals(results , 1, 'Incorect size. Must be left only 1 item');
       System.assertEquals(results.get(0), acc2, 'Wrong item. Only item in list should be "b"');
    }
    static testMethod void testfindWhere()
    {
       List<NTS__c> itemsList = new List<NTS__c>
       {
          (NTS__c) TestDataFactory.operationOnObjectRecord(null, 'NTS__c', null),
          (NTS__c) TestDataFactory.operationOnObjectRecord(null, 'NTS__c', null),
          (NTS__c) TestDataFactory.operationOnObjectRecord(null, 'NTS__c', null)  
       };
      
       NTS__c acc1 = (NTS__c) TestDataFactory.operationOnObjectRecord('insert', 'NTS__c', null);
       acc1.CHANGED_USER_NAME__c = TEST_NAME;
       NTS__c acc2 = (NTS__c) TestDataFactory.operationOnObjectRecord('insert', 'NTS__c', null);
       acc2.CHANGED_USER_NAME__c = TEST_NAME;
       itemsList.add(acc1);
       itemsList.add(acc2);
       List<NTS__c> results = new List<NTS__c>();
       Test.startTest();
       results = SystemUtil.findWhere(itemsList, DAL_BaseObject.ID_FIELD, (Id)acc1.get(DAL_BaseObject.ID_FIELD));
       Test.stopTest();

       System.assertEquals(results.isEmpty(), false, 'List shouldnt be empty ');
       System.assertEquals(results.get(0), acc1, 'Results should match acc1' );

    }

  static testMethod void testHasField()
  {
    NTS__c account = (NTS__c) TestDataFactory.operationOnObjectRecord('insert', DAL_NTS.OBJECT_NAME, null);
    Boolean hasField;

    Test.startTest();

    hasField = SystemUtil.hasSObjectField(account, DAL_BaseObject.NAME_FIELD);
    System.assertEquals(hasField, true, 'Account object always has Name field. Should be true');
    hasField = SystemUtil.hasSObjectField(account, NON_EXISTING_FIELD);
    System.assertEquals(hasField, false, 'Account doesnt have this field. Should be false');

    Test.stopTest();
  }

    static testMethod void testExtractListIds()
  {

    List<NTS__c> itemsList = new List<NTS__c>
    {
     (NTS__c) TestDataFactory.operationOnObjectRecord('insert', DAL_NTS.OBJECT_NAME, null),
     (NTS__c) TestDataFactory.operationOnObjectRecord('insert', DAL_NTS.OBJECT_NAME, null),
     (NTS__c) TestDataFactory.operationOnObjectRecord('insert', DAL_NTS.OBJECT_NAME, null)  
    };
    Set<ID> ids;

    Test.startTest();

    ids = SystemUtil.extractListIds(itemsList);
    System.assertEquals( 3, ids.size(), 'Should be 3 ids in Set' );

    itemsList.add(new NTS__c(
        id = null
    )); 

    ids = SystemUtil.extractListIds(itemsList, DAL_BaseObject.ID_FIELD);
    System.assertEquals( 4, ids.size(), 'Should be 4 ids in Set' );

    ids = SystemUtil.extractListIds(itemsList, DAL_BaseObject.ID_FIELD, true);
    System.assertEquals( 3, ids.size(), 'Should be 3 ids in Set' );

    Test.stopTest();
  }

  static testMethod void testListToMapSet()
  {

    Test.startTest();

    List<NTS__c> itemsList = new List<NTS__c>
    {
        (NTS__c) TestDataFactory.operationOnObjectRecord('insert', DAL_NTS.OBJECT_NAME, null),
        (NTS__c) TestDataFactory.operationOnObjectRecord('insert', DAL_NTS.OBJECT_NAME, null),
        (NTS__c) TestDataFactory.operationOnObjectRecord('insert', DAL_NTS.OBJECT_NAME, null)    
    };

    NTS__c acc1 = (NTS__c) TestDataFactory.operationOnObjectRecord(null, DAL_NTS.OBJECT_NAME, null);
    itemsList.add(acc1);

    Map<ID, Set<Id>> mapSet = new Map<ID, Set<Id>>();
    mapSet = SystemUtil.convertListToMapSet(itemsList, DAL_BaseObject.OWNER_ID_FIELD, DAL_BaseObject.ID_FIELD);
    Set<ID> setId = mapSet.get(UserInfo.getUserId());
    Test.stopTest();
    //System.assertEquals(setId.isEmpty(), false, 'Set should not be empty' );
    //System.assertEquals(setId.contains((Id)acc1.get(DAL_BaseObject.ID_FIELD)), true, 'Set should contain this account ID' );
  }

  static testMethod void testListToMap()
  {
    List<NTS__c> itemsList = new List<NTS__c>
    {
      (NTS__c) TestDataFactory.operationOnObjectRecord('insert', DAL_NTS.OBJECT_NAME, null),
      (NTS__c) TestDataFactory.operationOnObjectRecord('insert', DAL_NTS.OBJECT_NAME, null),
     (NTS__c) TestDataFactory.operationOnObjectRecord('insert', DAL_NTS.OBJECT_NAME, null)  
    };

    Map<ID, List<NTS__c>> mapList = new Map<ID, List<NTS__c>>();
    Test.startTest();
    mapList = SystemUtil.convertListToMap(itemsList, DAL_BaseObject.OWNER_ID_FIELD);
    Test.stopTest();

    List<NTS__c> newList = mapList.get(UserInfo.getUserId());
    //System.assertEquals(newList.isEmpty(), false, 'List shouldnt be empty');
    //System.assertEquals(newList.size(), 3, 'List should have 3 items');
  }

  static testMethod void testListToSingleMap()
  {
    List<NTS__c> itemsList = new List<NTS__c>
    {
      (NTS__c) TestDataFactory.operationOnObjectRecord('insert', DAL_NTS.OBJECT_NAME, null),
      (NTS__c) TestDataFactory.operationOnObjectRecord('insert', DAL_NTS.OBJECT_NAME, null),
      (NTS__c) TestDataFactory.operationOnObjectRecord('insert', DAL_NTS.OBJECT_NAME, null)  
    };

    NTS__c acc1 = (NTS__c) TestDataFactory.operationOnObjectRecord('insert', DAL_NTS.OBJECT_NAME, null);
    itemsList.add(acc1);

    Map<Id, SObject> mapLits = new Map<ID, SObject>();
    Test.startTest();
    mapLits = SystemUtil.convertListToSingleMap(itemsList, DAL_BaseObject.ID_FIELD);
    Test.stopTest();

    System.assertEquals(mapLits.isEmpty(), false, 'List shouldnt be empty');
    System.assertEquals(mapLits.get((Id)acc1.get(DAL_BaseObject.ID_FIELD)), acc1, 'Objects should be equals');
  }

  static testMethod void testListToSingleMapCompoundKey()
  {
    List<NTS__c> itemsList = new List<NTS__c>
    {
      (NTS__c) TestDataFactory.operationOnObjectRecord('insert', DAL_NTS.OBJECT_NAME, null),
      (NTS__c) TestDataFactory.operationOnObjectRecord('insert', DAL_NTS.OBJECT_NAME, null),
      (NTS__c) TestDataFactory.operationOnObjectRecord('insert', DAL_NTS.OBJECT_NAME, null)  
    };

    NTS__c acc1 = (NTS__c) TestDataFactory.operationOnObjectRecord('insert', DAL_NTS.OBJECT_NAME, null);
    itemsList.add(acc1);
    Map<String, SObject> mapLits = new Map<String, SObject>();
    String[] keyList = new String[]{DAL_BaseObject.ID_FIELD, DAL_BaseObject.NAME_FIELD};

    Test.startTest();
    mapLits = SystemUtil.convertListToSingleMap(itemsList, keyList);
    Test.stopTest();

    String key = SystemUtil.getCompoundKey(acc1, keyList);
    //System.assertEquals(mapLits.isEmpty(), false, 'List shouldnt be empty');
    //System.assertEquals(mapLits.get(key), acc1, 'Objects should be equals');
  }

  static testMethod void testExtractListFromMap()
  {
    List<NTS__c> itemsList = new List<NTS__c>
    {
      (NTS__c) TestDataFactory.operationOnObjectRecord('insert', DAL_NTS.OBJECT_NAME, null),
      (NTS__c) TestDataFactory.operationOnObjectRecord('insert', DAL_NTS.OBJECT_NAME, null),
      (NTS__c) TestDataFactory.operationOnObjectRecord('insert', DAL_NTS.OBJECT_NAME, null) 
    };

    Map<String, List<NTS__c>> testMap = new Map<String, List<NTS__c>>();

    testMap.put(TEST_STRING_KEY, itemsList);
    List<NTS__c> extractedList = new List<NTS__c>();
    Test.startTest();
    extractedList = SystemUtil.extractListFromMap(testMap);
    Test.stopTest();
    System.assertEquals(extractedList.isEmpty(), false, 'List shouldnt be empty');
    System.assertEquals(testMap.get(TEST_STRING_KEY).size(), extractedList.size(), 'Objects should be equals');
  }   

    static testMethod void testOmit()
    {
        
        List<NTS__c> accounts = new List<NTS__c>
        {
            (NTS__c) TestDataFactory.operationOnObjectRecord('insert', DAL_NTS.OBJECT_NAME, null),
      (NTS__c) TestDataFactory.operationOnObjectRecord('insert', DAL_NTS.OBJECT_NAME, null),
      (NTS__c) TestDataFactory.operationOnObjectRecord('insert', DAL_NTS.OBJECT_NAME, null) 
        };

        NTS__c a1 = (NTS__c) TestDataFactory.operationOnObjectRecord('insert', DAL_NTS.OBJECT_NAME, null);
        NTS__c a2 = (NTS__c) TestDataFactory.operationOnObjectRecord('insert', DAL_NTS.OBJECT_NAME, null);

        accounts.add(a1);
        accounts.add(a2);

        Set<ID> idList = SystemUtil.extractListIds(accounts);
        Set<ID> idToBeOmited = new Set<ID>{a1.ID, a2.ID};
       
       Test.startTest();
       Set<ID> results = SystemUtil.omit(idList, idToBeOmited);
       List<NTS__c> omitWhereResutls = SystemUtil.omitWhere(accounts, DAL_BaseObject.ID_FIELD, (Id)a1.get(DAL_BaseObject.ID_FIELD));
       Set<ID> concatResults = SystemUtil.concat(results, idToBeOmited);
       Test.stopTest();

       System.assertEquals(3, results.size(), 'Should be left 3 Ids in list');
       System.assertEquals(4, omitWhereResutls.size(), 'Should remove one account from list and be left 4 items in list');
       System.assertEquals(5, concatResults.size(), 'Should add 2 into set and be size of 5');
       
    } 
    static testMethod void testPickListEntriesMap()
    {
        
        Test.startTest();

        Schema.SObjectType token = Schema.getGlobalDescribe().get(DAL_Account.OBJECT_NAME);
        Map<String, String> picklistMap = SystemUtil.getPicklistEntriesMap(token, FIELD_ACCOUNT_SOURCE);

        Test.stopTest();

        System.assertEquals(false, picklistMap.isEmpty());

    }
    
    static testMethod void testPickListEntriesList()
    {
        
        Test.startTest();

       List<Schema.PicklistEntry> pickListEntries = SystemUtil.getPicklistEntries(DAL_Account.OBJECT_NAME, FIELD_ACCOUNT_SOURCE);

        Test.stopTest();

        System.assertEquals(false, pickListEntries.isEmpty());

    }
    static testMethod void testGetRecordType()
    {
      Map<id, String> recordTypeMap;

      Test.startTest();
        
        recordTypeMap = SystemUtil.getRecordTypeMap(DAL_Account.OBJECT_NAME);
        
        List<RecordType> recordTypesList = 
        [
          SELECT Id, DeveloperName
          FROM RecordType 
          WHERE SobjectType = :DAL_Account.OBJECT_NAME
        ];

        System.assertEquals(recordTypeMap.size(), recordTypesList.size(), 'Map and list must be same size');

      Test.stopTest();
    }
   
   
    static testMethod void testRemoveItems()
    {       
        List<String> init_list = new List<String>();
        Test.startTest();
        List<String> resultsList = SystemUtil.removeItems(init_list, SET_TO_REMOVE);
        System.assertEquals( true, resultsList.isEmpty(), 'List should be empty');

        init_list = new List<String>{'a', 'b', 'not empty', 'c', 'full', 'not_blank'};

        resultsList = SystemUtil.removeItems(init_list, SET_TO_REMOVE);
        System.assertEquals(4, resultsList.size(), 'This list should 3 items size');
        Test.stopTest();
    }
    
    static testMethod void doTest1()
    {
        Set<Id> initIdsSet = null;
        Set<String> initStringSet = null;
        
        List<Id> resultIdsList;
        List<String> resultStringList;
        
        Test.startTest();
        
        resultIdsList = SystemUtil.setToList(initIdsSet);
        System.assertEquals(null, resultIdsList, 'Ids should be null now');
        
        resultStringList = SystemUtil.setToList(initStringSet);
        System.assertEquals(null, resultStringList, 'Strings should be null now');  
    
        resultStringList = SystemUtil.setToList(new Set<String>{'a', 'b', 'c', ''});
        System.assertEquals(4, resultStringList.size(), 'String list size does not match');
            
        Test.stopTest();
    }
    
    
    static testMethod void doTest3()
    {
        Test.startTest();
        
        NTS__c a = (NTS__c) TestDataFactory.operationOnObjectRecord('insert', DAL_NTS.OBJECT_NAME, null);
        
        Exception error;
        
        error = new System.NoDataFoundException();
        
        SystemUtil.processException(error, a);
        
        try
        {
            //this triggers DMLException
            insert new NTS__c();
        }
        catch(System.DMLException e)
        {
            error = e;
            SystemUtil.processException(error, a);
        }
            
        Test.stopTest();
    }
    
    static testMethod void doThrowTest()
    {
        Boolean exceptionThrown =  false;
        Test.startTest();
        
        try 
        {
            SystemUtil.justThrow();
        } 
        catch (Exception e) 
        {
            exceptionThrown = true;
        }
    
        System.AssertEquals(exceptionThrown, true, 'justThrow() not thrown');
        exceptionThrown = false;
    
        try 
        {
            SystemUtil.justThrow(ERR_MSG);
        } 
        catch (Exception e)
        {
            Boolean expectedExceptionThrown =  e.getMessage().contains(ERR_MSG);
            System.AssertEquals(expectedExceptionThrown, true);
            exceptionThrown = true;
        }

        System.AssertEquals(exceptionThrown, true, 'justThrow(msg) not thrown');
        exceptionThrown = false;
        
        Test.stopTest();
    }
    
     static testMethod void testMethodsOne()
    {
        DateTime dt=System.now(); 
        NTS__c a = (NTS__c) TestDataFactory.operationOnObjectRecord('insert', DAL_NTS.OBJECT_NAME, null);
        List<SObject> items = new List<SObject>();
        items.add(a);
        Set<Date> set1 = new Set<Date>();
        set1.add(date.today());
        Set<Date> set2 = new Set<Date>();
        set2.add(date.today());
        Test.startTest();
        try{
            SystemUtil.throwDataGenerationException('12321','123213');
            SystemUtil.throwInvalidMethodParametersException('12321','123213');
            SystemUtil.assertEmptyList(items,'asdasd');
            SystemUtil.assertDateSetEquals(set1,set2,'asasd');
           
        } 
        catch (Exception e)
        {
            
        }
        Test.stopTest();
    }
    
      static testMethod void testMethods()
    {
        DateTime dt=System.now(); 
        NTS__c a = (NTS__c) TestDataFactory.operationOnObjectRecord('insert', DAL_NTS.OBJECT_NAME, null);
        List<SObject> items = new List<SObject>();
        items.add(a);
        Set<Date> set1 = new Set<Date>();
        set1.add(date.today());
        Set<Date> set2 = new Set<Date>();
        set2.add(date.today());
        Test.startTest();
        
            SystemUtil.getSObjectTypeByName('Account');
            SystemUtil.isEmpty('123');
            SystemUtil.dateTimeToDate(dt);
            SystemUtil.formatDateStringToString('06-11-2018');
            SystemUtil.convertStringToDate('06/11/2018');
            SystemUtil.convertSToDate('06/11/2018');
            SystemUtil.convertStToDate('06/11/2018');
            SystemUtil.convertStringToDateYYYYDDMM('06-11-2018');
            SystemUtil.convertStringtoBoolean('true');
            SystemUtil.convertStringtoInteger('10');
            SystemUtil.convertStringtoDecimal('1.0');
            SystemUtil.checkEmailAddressRegex('polraparas@gmail.com');
        
        Test.stopTest();
    }
}
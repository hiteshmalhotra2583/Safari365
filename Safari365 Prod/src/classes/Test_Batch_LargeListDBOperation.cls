@isTest
private class Test_Batch_LargeListDBOperation  {
    public static List<WetuLocation__c> lst_WetuLocation;
    public static List<WetuLocation__c> lst_WetuLocation2= new List<WetuLocation__c>();
    static void setupDataOne(){      
        lst_WetuLocation = new List<WetuLocation__c>();
        lst_WetuLocation.add(new WetuLocation__c(Location_Name__c ='City1'));
        lst_WetuLocation.add(new WetuLocation__c(Location_Name__c ='City2'));
        lst_WetuLocation.add(new WetuLocation__c(Location_Name__c ='City3'));
        lst_WetuLocation.add(new WetuLocation__c(Location_Name__c ='City4'));
        lst_WetuLocation.add(new WetuLocation__c(Location_Name__c ='City5'));
        lst_WetuLocation.add(new WetuLocation__c(Location_Name__c ='City6'));
        lst_WetuLocation.add(new WetuLocation__c(Location_Name__c ='City7'));
        lst_WetuLocation.add(new WetuLocation__c(Location_Name__c ='City8'));
        lst_WetuLocation.add(new WetuLocation__c(Location_Name__c ='City9'));
        lst_WetuLocation.add(new WetuLocation__c(Location_Name__c ='City10'));
        lst_WetuLocation.add(new WetuLocation__c(Location_Name__c ='City11'));
    }
    
      static void setupDataTwo(){      
          User us = TestDataFactory.createUser(true, '', true);
          System.runAs(us){
              lst_WetuLocation2.add(new WetuLocation__c(Location_Name__c ='City1'));
              lst_WetuLocation2.add(new WetuLocation__c(Location_Name__c ='City2'));
              lst_WetuLocation2.add(new WetuLocation__c(Location_Name__c ='City3'));
              lst_WetuLocation2.add(new WetuLocation__c(Location_Name__c ='City4'));
              lst_WetuLocation2.add(new WetuLocation__c(Location_Name__c ='City5'));
              lst_WetuLocation2.add(new WetuLocation__c(Location_Name__c ='City6'));
              lst_WetuLocation2.add(new WetuLocation__c(Location_Name__c ='City7'));
              lst_WetuLocation2.add(new WetuLocation__c(Location_Name__c ='City8'));
              lst_WetuLocation2.add(new WetuLocation__c(Location_Name__c ='City9'));
              lst_WetuLocation2.add(new WetuLocation__c(Location_Name__c ='City10'));
              lst_WetuLocation2.add(new WetuLocation__c(Location_Name__c ='City11'));
              insert lst_WetuLocation2;
          }
    }
    
    static testMethod void callmethod_Scheduler_Insert_Test() {                      
        Test.startTest();            
        setupDataOne();            
        
        Batch_LargeListDBOperation batch  = new Batch_LargeListDBOperation(lst_WetuLocation,DAL_BaseObject.DatabaseOperation.DBO_INSERT);            
        Database.executebatch(batch); 
        Test.stopTest();         
    } 
    static testMethod void callmethod_Scheduler_Update_Test() { 
        setupDataTwo();  
        Test.startTest();     
        Batch_LargeListDBOperation batch1  = new Batch_LargeListDBOperation(lst_WetuLocation2,DAL_BaseObject.DatabaseOperation.DBO_UPDATE);            
        Database.executebatch(batch1); 
        Test.stopTest();         
    }
    static testMethod void callmethod_Scheduler_Delete_Test() {       
         setupDataTwo();
        Test.startTest();            
        Batch_LargeListDBOperation batch2  = new Batch_LargeListDBOperation(lst_WetuLocation2,DAL_BaseObject.DatabaseOperation.DBO_DELETE);            
        Database.executebatch(batch2); 
        Test.stopTest();         
    }
}
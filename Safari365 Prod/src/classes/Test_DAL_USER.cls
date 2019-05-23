@isTest
private class Test_DAL_USER {
 
     static User us1;
     static User us2;
     static User us3;
    
    static void setupInsertData(){
       
       us1 = TestDataFactory.createUser(true, '', true);
       us2 = TestDataFactory.createUser(true, '', true);
       us3  = TestDataFactory.createUser(true, '', true);
    }
    
    static testMethod void myUnitTest() {
       
        setupInsertData();
        Set<Id> usersIds = new Set<Id>();
        usersIds.add(us1.Id);
        usersIds.add(us2.Id);
        usersIds.add(us3.Id);
        
        DAL_USER.getUserByIds(usersIds);
        
    }
}
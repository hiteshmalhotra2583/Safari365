@isTest
public class LeadNurturingHandler_Test {
    static Lead_Nurture__c testLeadNurture;
    static Lead testLeadRec;
    static Account testAccountRec;
    static Contact testContactRec;
    public static void setupTestData(){
        testAccountRec = new Account();
        testAccountRec.Name = 'Test Account';
        testAccountRec.Newsletter__c= true;
        insert testAccountRec;
        
        testContactRec = new Contact();
        testContactRec.LastName = 'test';
        testContactRec.Email = 'test@gmail.com';
        insert testContactRec;
        
        testLeadRec = new Lead();
        testLeadRec.Email = 'test@gmail.com';
        testLeadRec.LastName = 'lead test';
        testLeadRec.Company = 'company1';
        //testLeadRec.ConvertedContactId = testContactRec.id;
        //testLeadRec.ConvertedDate = System.today();
        insert testLeadRec;
        
        testLeadNurture = new Lead_Nurture__c();
        testLeadNurture.Email__c = 'test@gmail.com';
        testLeadNurture.First_Name__c = 'test1';
        //testLeadNurture.Countries_of_Interest__c ='South Africa;Zambia';
        insert testLeadNurture;
        
        
    }
    
    public testmethod static void testLeadNurtureUpdate(){
        setupTestData();
        Test.startTest();
        Lead_Nurture__c testLeadNurture1 = new Lead_Nurture__c();
        testLeadNurture1.Email__c = 'test@gmail.com';
        //testLeadNurture1.First_Name__c= 'test2';
        insert testLeadNurture1;
        testLeadNurture1.Beach_relaxation__c = true;
        //testLeadNurture1.Countries_of_Interest__c ='South Africa;Zambia';
        update testLeadNurture1;
        Test.stopTest();
    }
    
    public testmethod static void testLeadUpdate(){
        setupTestData();
        Test.startTest();
        testLeadRec.Country ='SA';
        update testContactRec;
        Test.stopTest();
    }
    
    public testmethod static void testContactUpdate(){
        setupTestData();
        Test.startTest();
        testContactRec.Birthdate = System.today();
        update testContactRec;
        Test.stopTest();
    }
}
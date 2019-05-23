/**
 * This class contains unit tests for validating the behavior of MassUpdateController
 * and triggers.
 */
@isTest
private class MassUpdateSimpleControllerTest {
    static List<Opportunity> opportunitys = new List<Opportunity>();
    static List<Account> accounts = new List<Account>();
    static List<Passenger__c> passengers = new List<Passenger__c>();
    static List<Quotations__c> Quotations = new List<Quotations__c>();
    static List<PassengerQuotationMapping__c> passengerQuotations = new List<PassengerQuotationMapping__c>();
    static List<ServiceLineItem__c> slis = new List<ServiceLineItem__c>();
    static List<ServiceLineItemPassengersMapping__c> sliPassengers = new List<ServiceLineItemPassengersMapping__c>();
    static Integer recordCount = 1;
    static List<QuotationLineItem__c> getQuotationLineItemList = new List<QuotationLineItem__c>();
    static QuotationBuilderDatabaseQueries dbQueries = new QuotationBuilderDatabaseQueries();
    static List<ExchangeRates__c> exchangeRates = new List<ExchangeRates__c>();
    
    static List<CRM__c> crms = new List<CRM__c>(); 
    static List<Opt__c>  opts = new List<Opt__c>();
    static List<NTS__c>  nts = new List<NTS__c>();
    static List<NCT__c>  ncts= new List<NCT__c>();
    static List<NTS__c>  crmsnts = new List<NTS__c>();
    static Integer count =1; 
    
    
    @testSetup static void setupInsertData()
    {
        User us = TestDataFactory.createUser(true, '', true);
        System.runAs(us){
            Account accountRec = new Account();
            accountRec.Name = 'Unit Test Account';
            accountRec.BillingStreet = '123 Unit Test Street';
            accountRec.BillingCity='Dallas';
            accountRec.BillingState = 'TX';
            accountRec.BillingPostalCode = '75006';
            accountRec.BillingCountry='US';
            accountRec.Industry = 'Commerical';
            accountRec.Newsletter__c= true;
            accounts.add(accountRec);
            DAL_BaseObject.InsertDBObjects(accounts);
            
            Map<String,Object>  accountOpportunityMap = new Map<String,Object>();
            for(Account acc:accounts)
            {
                accountOpportunityMap.put('AccountId', acc.ID);
                accountOpportunityMap.put('StageName', 'Prospect');
                accountOpportunityMap.put('Client_Display_Currency__c','USD');
            }
            
            Map<String,Object> exchangeRateMap = new Map<String,Object>();
            exchangeRateMap.put('BaseCurrency__c','USD');
            exchangeRateMap.put('USD__c',10);
            
            for(Integer i = 0 ; i <recordCount; i++)
            {
                exchangeRates.add((ExchangeRates__c) TestDataFactory.operationOnObjectRecord(null, 'ExchangeRates__c', exchangeRateMap));
            }
            DAL_BaseObject.InsertDBObjects(exchangeRates);
            
            for(Integer i = 0 ; i <recordCount; i++)
            {
                opportunitys.add((Opportunity) TestDataFactory.operationOnObjectRecord(null, 'Opportunity', accountOpportunityMap));
            }
            DAL_BaseObject.InsertDBObjects(opportunitys);
            
            Map<String,Object>  opportunityQuotationMap = new Map<String,Object>();
            Map<String,Object>  accountMap = new Map<String,Object>();
            for(Opportunity opp:opportunitys)
            {
                opportunityQuotationMap.put('Opportunity__c', opp.ID);
                opportunityQuotationMap.put('TravelStartDate__c',system.today());
                opportunityQuotationMap.put('TravelEndDate__c',system.today().addDays(3));
                opportunityQuotationMap.put('Iternary_Language__c','En');
                opportunityQuotationMap.put('Itinerary_Summary__c','how are you I am good');
                opportunityQuotationMap.put('Wetu_Identifier__c','abcedeccc');
                accountMap.put('Opportunity__c' ,opp.id );
            }
            
            for(Integer i = 0 ; i <recordCount; i++)
            {
                passengers.add((Passenger__c) TestDataFactory.operationOnObjectRecord(null, DAL_Passenger.OBJECT_NAME, accountMap));
            }
            DAL_BaseObject.InsertDBObjects(passengers);
            
            for(Integer i = 0 ; i <recordCount; i++)
            {
                Quotations.add((Quotations__c) TestDataFactory.operationOnObjectRecord(null, DAL_Quotations.OBJECT_NAME, opportunityQuotationMap));
            }
            DAL_BaseObject.InsertDBObjects(Quotations);
            
            Map<String,Object>  passengerQuotationMapingMap = new Map<String,Object>();
            passengerQuotationMapingMap.put('Passenger__c',passengers[0].Id);
            passengerQuotationMapingMap.put('Quotation__c',Quotations[0].Id);
            for(Integer i = 0 ; i <recordCount; i++)
            {
                passengerQuotations.add((PassengerQuotationMapping__c) TestDataFactory.operationOnObjectRecord(null, 'PassengerQuotationMapping__c', passengerQuotationMapingMap));
            }
            DAL_BaseObject.InsertDBObjects(passengerQuotations);
            
            //Create Quotation Line Item
            Map<String,Object>  QuotationQuotationLinitemMap = new Map<String,Object>();
            for(Integer i = 0 ; i <recordCount; i++)
            {
                QuotationQuotationLinitemMap.put('Name','QLI-'+i);
                QuotationQuotationLinitemMap.put('Quotation__c',Quotations[i].Id);
                QuotationQuotationLinitemMap.put('Line_Item_Date__c',Date.today());
                
                getQuotationLineItemList.add((QuotationLineItem__c) TestDataFactory.operationOnObjectRecord(null, 'QuotationLineItem__c',QuotationQuotationLinitemMap ));
            }
            DAL_BaseObject.InsertDBObjects(getQuotationLineItemList);
            
            Map<String, Object> quoationServiceLineMap =new Map<String, Object>();
            for(QuotationLineItem__c quoli: getQuotationLineItemList)
            {
                quoationServiceLineMap.put('QuotationLine__c',quoli.Id);
            }
            /*=============================================================================================*/   
            
            Map<String,Object> optkeyValueMap1 = new Map<String,Object>();
            optkeyValueMap1.put('Service__c','AC');
            optkeyValueMap1.put('AC__c','Y');
            optkeyValueMap1.put('CHGEX1__c','0');
            optkeyValueMap1.put('CHGEX2__c','G');
            optkeyValueMap1.put('CHGEX3__c','P');
            optkeyValueMap1.put('CHGEX4__c','2');
            optkeyValueMap1.put('CHGEX5__c','G');
            optkeyValueMap1.put('EX1__c','Conservation Levy');
            optkeyValueMap1.put('EX2__c','PG TIM Vehicle Fee');
            optkeyValueMap1.put('EX3__c','Per Person Extra');
            optkeyValueMap1.put('EX4__c','Per Room Extra');
            optkeyValueMap1.put('EX5__c','Per Group Extra');
            optkeyValueMap1.put('ANALYSIS1__c','PF');
            optkeyValueMap1.put('ANALYSIS2__c','PP');
            optkeyValueMap1.put('ANALYSIS3__c','LA');
            optkeyValueMap1.put('ANALYSIS4__c','ZA');
            optkeyValueMap1.put('SupplierMarkup__c',0.00);
            optkeyValueMap1.put('Description__c','Luxury Safari Tent');
            optkeyValueMap1.put('FCU__c','Person');
            optkeyValueMap1.put('MPFCU__c',1);
            
            for(Integer i = 0 ; i <count; i++)
            {
                opts.add((OPT__c) TestDataFactory.operationOnObjectRecord(null, DAL_OPT.OBJECT_NAME, optkeyValueMap1));
            }
            insert opts;  
            
            Map<String,Object> serviceLineItemkeyValueMap1 = new Map<String,Object>();
            serviceLineItemkeyValueMap1.put('Service_Detail__c','Luxury Safari Tent');
            serviceLineItemkeyValueMap1.put('QuotationLine__c',getQuotationLineItemList[0].Id);
            serviceLineItemkeyValueMap1.put('Service_Status__c','Not Booked');
            serviceLineItemkeyValueMap1.put('Provisional_Booking_Expiry_Date__c',system.today());
            serviceLineItemkeyValueMap1.put('Override_details__c',false);
            serviceLineItemkeyValueMap1.put('Room_Configuration__c','TWIN AVAIL');
            serviceLineItemkeyValueMap1.put('Service_Type__c','Accommodation');
            serviceLineItemkeyValueMap1.put('ServiceLocation__c','Timbavati Game Reserve');
            serviceLineItemkeyValueMap1.put('SupplierName__c','Simbavati Hilltop Lodge');
            serviceLineItemkeyValueMap1.put('Selected_OPT_Code__c',opts[0].Code__c);
            serviceLineItemkeyValueMap1.put('Service_Date__c',System.today());
            
            serviceLineItemkeyValueMap1.put('Wetu_Start_Location__c','a');
            serviceLineItemkeyValueMap1.put('Wetu_End_Location__c','b');
            serviceLineItemkeyValueMap1.put('Basis__c','x');
            serviceLineItemkeyValueMap1.put('Reservation_Number__c','a');
            serviceLineItemkeyValueMap1.put('Service_Duration__c',1);
            serviceLineItemkeyValueMap1.put('ClientNotes__c',' ');
            serviceLineItemkeyValueMap1.put('Crm_Code__c','SIM005');
            
            for(Integer i = 0 ; i <count; i++)
            {
                slis.add((ServiceLineItem__c) TestDataFactory.operationOnObjectRecord(null, QuotationBuilderDatabaseQueries.SERVICELINEITEM_OBJECT_NAME, serviceLineItemkeyValueMap1));
            }
            insert slis;   
            
            for(Integer i = 0 ; i <count; i++)
            {
                ncts.add((NCT__c) TestDataFactory.operationOnObjectRecord(null, 'NCT__c', null));
            }
            insert ncts;
            
            Map<String,Object> keyValueMap = new Map<String,Object>();
            for(NCT__c nct:ncts)
            {
                keyValueMap.put('CATEGORY__c', nct.NOTECATEGORY__c);
            }
            
            for(Integer i = 0 ; i <=count; i++)
                nts.add((NTS__c) TestDataFactory.operationOnObjectRecord(null, 'NTS__c', keyValueMap));
            
            Map<String,Object> CrmkeyValueMap1 = new Map<String,Object>();
            CrmkeyValueMap1.put('NAME__c','Simbavati Hilltop Lodge');
            CrmkeyValueMap1.put('MARKUP__c',0.00);
            CrmkeyValueMap1.put('CODE__c','SIM005');
            CrmkeyValueMap1.put('SOD_ID__c',1);
            
            for(Integer i = 0 ; i <1; i++)
            {
                crms.add((CRM__c) TestDataFactory.operationOnObjectRecord(null, 'CRM__c', CrmkeyValueMap1));
            }
            insert crms;
            
            Map<String,Object> keyValueMap2 = new Map<String,Object>();
            for(CRM__c crm:crms)
            {
                keyValueMap2.put('SUPPLIER_CODE__c', crm.CODE__c);
            }
            
            for(Integer i = 0 ; i <=count; i++)
                crmsnts.add((NTS__c) TestDataFactory.operationOnObjectRecord(null, 'NTS__c', keyValueMap2));   
            
            /*=============================================================================================*/   
            
            Map<String,Object>  passengerSLIMapingMap = new Map<String,Object>();
            passengerSLIMapingMap.put('Passenger__c',passengers[0].Id);
            passengerSLIMapingMap.put('Service_Line_Item__c',slis[0].Id);
            for(Integer i = 0 ; i <recordCount; i++)
            {
                sliPassengers.add((ServiceLineItemPassengersMapping__c) TestDataFactory.operationOnObjectRecord(null, 'ServiceLineItemPassengersMapping__c', passengerSLIMapingMap));
            }
            DAL_BaseObject.InsertDBObjects(sliPassengers);
              
        }   
    }

    static testMethod void singleUpdateTest() {
        Opportunity o = new Opportunity();
        List<Opportunity> oppList = [SELECT name FROM Opportunity LIMIT 20];
        
        ApexPages.StandardSetController setCtr = new ApexPages.StandardSetController(oppList);
        setCtr.setSelected(new Opportunity[]{o});
        MassUpdateSimpleController controller = new MassUpdateSimpleController(setCtr);
        System.assertEquals(1, controller.getRecordSize());
        
        System.assert(controller.getFieldTypeOptions().size()>1);
        
        system.assertEquals(1, controller.objsToUpdate.size());
        
        String value = '123test';
        controller.fieldName='name';
        controller.valueToUpdate=value; 
        controller.step4();
        controller.step5();
        
        System.assert(o.name==value);
        
        value ='123';
        controller.step3();
        controller.fieldName='amount';
        controller.valueToUpdate=value; 
        controller.step4();
        controller.step5();
        
        System.assert(o.amount==decimal.valueOf(value));

        // make sure no exception from display tips
        System.assertEquals(controller.getFieldInfoToDisplay()!=null,true);
                
        value ='2009-4-7';
        controller.fieldName='CloseDate';
        controller.valueToUpdate=value;     
        controller.step4();
        controller.step5();
        System.assert(o.CloseDate==Date.valueOf(value));
        
        value ='Closed';
        controller.fieldName='StageName';
        controller.valueToUpdate=value;     
        controller.step4();
        controller.step5();
        System.assert(o.StageName=='Closed');
    }
    
 /*   static testMethod void massUpdateAsStandardUserTest() {
        
        Profile p = [select id from profile where name='Standard User'];
        User u = new User(alias = 'standt', email='standarduser@testorg.com',
          emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
          localesidkey='en_US', profileid = p.Id,
          timezonesidkey='America/Los_Angeles', username='standarduser@test.com');
        
        System.runAs(u) {
          Opportunity o = new Opportunity();
          List<Opportunity> oppList = [SELECT name FROM Opportunity LIMIT 20];
        
          ApexPages.StandardSetController setCtr = new ApexPages.StandardSetController(oppList);
          setCtr.setSelected(new Opportunity[]{o});
          MassUpdateSimpleController controller = new MassUpdateSimpleController(setCtr);
          System.assertEquals(1, controller.getRecordSize());
        
          System.assert(controller.getFieldTypeOptions().size()>1);
        
          system.assertEquals(1, controller.objsToUpdate.size());
        
          String value = '123test';
          controller.fieldName='name';
          controller.valueToUpdate=value;       
          controller.save();
        
          System.assert(o.name==value);
         
        }
    }  */
    
    static testMethod void linkTest() {
        Opportunity o = new Opportunity();
        List<Opportunity> oppList = [SELECT name FROM Opportunity LIMIT 20];
        
        ApexPages.StandardSetController setCtr = new ApexPages.StandardSetController(oppList);
        setCtr.setSelected(new Opportunity[]{o});
        MassUpdateSimpleController controller = new MassUpdateSimpleController(setCtr);
        
        // verify following exceptions will not cause exception
        System.assert(controller.step1()!=null);
        System.assert(controller.step2()!=null);
        controller.getFieldTypeOptions();
        System.assert(controller.step3()!=null);
        System.assert(controller.step4()!=null);
        System.assert(controller.step5()!=null);
        //System.assert(controller.cancel()!=null);
        
        System.assert(controller.getFieldTypeOptions()!=null);
    }
    
    static testMethod void fieldTest() {
        
        List<Opportunity> oppList = new Opportunity[]{};
        
        ApexPages.StandardSetController setCtr = new ApexPages.StandardSetController(oppList);
        MassUpdateSimpleController controller = new MassUpdateSimpleController(setCtr);
        System.assert(controller.cancel()!=null);
        System.assert(controller.getFieldTypeOptions()==null);
    }
    
    static testMethod void miscTest() {
        
        List<Opportunity> oppList = new Opportunity[]{};
        
        ApexPages.StandardSetController setCtr = new ApexPages.StandardSetController(oppList);
        MassUpdateSimpleController controller = new MassUpdateSimpleController(setCtr);
        
        System.assert(controller.getNow(true)!=null);
        System.assert(controller.getNow(false)!=null);
        System.assert(controller.getRecordSize()==0);
        System.assert(controller.getPicklistValues()==null);
    }
    
    
    static testMethod void testOpportunityInRelatedList(){
        List<Opportunity> oppList = [SELECT name, AccountId FROM Opportunity LIMIT 20];
        Test.startTest();
        ApexPages.StandardSetController setCtr = new ApexPages.StandardSetController(oppList);
        PageReference pageRef = Page.MassUpdateOpportunity;
        pageRef.getParameters().put('id', oppList[0].AccountId);
        Test.setCurrentPage(pageRef);
        //apexpages.currentpage().getparameters().put('id' , oppList[0].AccountId);
        MassUpdateSimpleController controller = new MassUpdateSimpleController(setCtr);
       // System.assert(controller.getFieldTypeOptions().size()>1);
        
        String value = '123test';
       // controller.fieldName='name';
        controller.valueToUpdate=value; 
        //controller.convertedFieldData = controller.convertUserInputToFieldData(); 
        controller.lexstep4();
        controller.lexstep5();
        List<Opportunity> selectList = (List<Opportunity>)setCtr.getSelected();
        /*System.assert(selectList[0].name==value);
        System.assert(controller.displayTexField);
        System.assert(!controller.displayCheckBox);
        System.assert(!controller.displayPicklist);
        System.assert(!controller.displayTextArea);*/
        
         value ='Closed';
        controller.lexstep3();
        //controller.fieldName='StageName';
        controller.valueToUpdate=value;     
        controller.lexstep4();
        controller.lexstep5();
        /*System.assert(selectList[0].StageName=='Closed');
        System.assert(!controller.displayTexField);
        System.assert(!controller.displayCheckBox);
        System.assert(controller.displayPicklist);
        System.assert(!controller.displayTextArea);
        Test.stopTest();*/
        
    }
}
public class TH_Passenger extends BaseTriggerHandler{
    
    private static final String CLASS_NAME = TH_Passenger.class.getName();
    private List<Passenger__c> newPassengersList;
    private List<Passenger__c> oldPassengersList;
    private Map<ID, Passenger__c> newPassengerMap;
    private Map<ID, Passenger__c> oldPassengerMap;
    private TriggerUtil triggerUtil = new TriggerUtil();
    public static final String STAGE_NAME_MIB = 'Closed Won Deal';
    
    public TH_Passenger() {
        oldPassengersList = (List<Passenger__c>)Trigger.old;
        newPassengersList = (List<Passenger__c>)Trigger.new;
        newPassengerMap =  (Map<ID, Passenger__c>)Trigger.newMap;
        oldPassengerMap = (Map<ID, Passenger__c>)Trigger.oldMap;
    }
    
    
    protected override void afterUpdate() {
        if(Trigger_PAD.canRun('TH_Passenger')){
            createAccount();
            createSubOpportunity();
            checkNoOfPhotoBookCountChanged();
        }
    }
    
    public void createAccount(){
    
    List<Account> newAccounts = new list<Account>();
    Map<String, Account> passengerNameToAccountMap = new Map<String, Account>();
    Map<String, Passenger__c> passengerNameToPassenger = new Map<String, Passenger__c>();
    for(Passenger__c passsenger: newPassengersList)
    {
        if( null != passsenger.Confirmed__c && passsenger.Confirmed__c)
        {
          Id recordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
          Account acc = new Account();
          if(null != passsenger.New_Account__c)
          {
            acc.Id  = passsenger.New_Account__c;
          }
          if( null !=  passsenger.FirstName__c)
          acc.firstName = passsenger.FirstName__c;
           if( null !=  passsenger.Last_Name__c)
          acc.LastName = passsenger.Last_Name__c;
          acc.Primary_Account__c = passsenger.Account__c;
          acc.RecordTypeId = recordtypeId;
          if( null !=  passsenger.Country_of_Residence__c)
          acc.Country_of_Residence__c=passsenger.Country_of_Residence__c;
          
          acc.Passport_Nationality__c=passsenger.Nationality__c;
          acc.Date_Of_Birth__c=passsenger.Date_of_Birth__c;
          if( null != passsenger.Email__c)
          acc.PersonEmail= passsenger.Email__c;
          if( null != passsenger.Home_Phone__c)
          acc.Phone = passsenger.Home_Phone__c;
          if(null != passsenger.Mobile_Phone__c)
          acc.Mobile_Phone__c= Decimal.valueof(passsenger.Mobile_Phone__c);
          acc.Passport_Expiry_Date__c= passsenger.Passport_Expiry_Date__c;
          acc.Passport_Number__c= passsenger.Passport_Number__c;
          acc.Middle_Name_s__c= passsenger.Middle_Name_s__c;
          acc.Passport_Information_Verified__c= passsenger.Passport_Information_Verified__c;
          acc.Existing_Medical_Condition__c=passsenger.ExistingMedicalCondition__c ;
          acc.Medical_Conditions__c= passsenger.Medical_Conditions__c;
          acc.Medical_Information_Verified__c= passsenger.Medical_Information_Verified__c;
          acc.Mobility_Issues__c= passsenger.Mobility_Issues__c;
          acc.ExistingMobilityIssue__c= passsenger.ExistingMobilityIssue__c;
          acc.DietaryRequirements__c= passsenger.DietaryRequirements__c;
          acc.DietaryRequirements_Text__c= passsenger.DietaryRequirements_Text__c;
          acc.Emergency_First_Name__c=    passsenger.Emergency_First_Name__c;       
          acc.Emergency_Last_Name__c= passsenger.Emergency_Last_Name__c;
          acc.Emergency_Mobile_Phone_Number__c= passsenger.Emergency_Mobile_Phone_Number__c;
          acc.Policy_Emergency_Phone_Number__c=passsenger.Policy_Emergency_Phone_Number__c;
          acc.Celebrating_a_wedding_anniversary__c= passsenger.Celebrating_a_wedding_anniversary__c;
          acc.Celebrating_Birthday__c= passsenger.Celebrating_Birthday__c;
          if( null != passsenger.Require_trip_updates__c)
          acc.Newsletter__c= passsenger.Require_trip_updates__c;
          acc.Other_Occasion__c=passsenger.Other_Occasion__c;
          if( null != passsenger.WebSite_Origin_From_Parent_Account__c)
          acc.Website_Origin_c__c= passsenger.WebSite_Origin_From_Parent_Account__c;
          acc.Newsletter__c = passsenger.Subscribe_me_to_newsletter__c;
          newAccounts.add(acc);
          passengerNameToAccountMap.put(passsenger.Last_Name__c,acc);
          passengerNameToPassenger.put(passsenger.Last_Name__c,passsenger);
        }
    }
    
    system.debug('newAccounts::::'+newAccounts);
    if(! newAccounts.isEmpty())
    {
    	upsert(newAccounts);
    }
    List<Passenger__c> passengerToUpdate = new List<Passenger__c>();
    for(Passenger__c passsenger: newPassengersList)
    {
        if(passsenger.Confirmed__c && null != passengerNameToAccountMap.get(passsenger.Last_Name__c))
        {
          Passenger__c p = new Passenger__c();
          p.Id = passengerNameToPassenger.get(passsenger.Last_Name__c).Id;
          p.New_Account__c = passengerNameToAccountMap.get(passsenger.Last_Name__c).Id;
          passengerToUpdate.add(p);
        }
     }
        system.debug('passengerToUpdate::::'+passengerToUpdate.size());
           
     BaseTriggerHandler.bypass('TH_Passenger');
     DAL_BaseObject.UpdateDBObjects(passengerToUpdate);  
     BaseTriggerHandler.clearBypass('TH_Passenger');
    }
    
    public  void createSubOpportunity()
     {
        UTIL_LogGenerator logger = new UTIL_LogGenerator();
        logger.start(CLASS_NAME,'createSubOpportunity');
        Set<Id> processAccountIds = new Set<Id>();
        Set<Id> opportunityIds = new Set<Id>();
        Map<Id, Id> accountIdMapParentOpportunityIds = new Map<Id, Id>();
        Map<Id, Id> passengerIdSubOpportunityIds = new Map<Id, Id>();
        Map<Id, Passenger__c> accountIdMapPassenger = new Map<Id, Passenger__c>();
        List<String> idStrings = new List<String>();
        Map<String, Opportunity> passengerNameToSubOpportunityMap = new Map<String, Opportunity>();
        for(Passenger__c p: newPassengersList)
        {
            idStrings.add(p.Id);
        }
        
        List<Passenger__c> retreivePassengers = DAL_Passenger.getByIds(idStrings);
        for(Passenger__c passsenger: retreivePassengers)
        {
            if(passsenger.Create_Sub_Opportunity__c)
            {
                processAccountIds.add(passsenger.New_Account__c);
                opportunityIds.add(passsenger.Opportunity__c);
                accountIdMapParentOpportunityIds.put(passsenger.New_Account__c,passsenger.Opportunity__c);
                accountIdMapPassenger.put(passsenger.New_Account__c,passsenger);
                passengerIdSubOpportunityIds.put(passsenger.Id,passsenger.Sub_Opportunity__c);
            }
        }    
        
        List<Opportunity> opportunitys = new List<Opportunity>();     
        Map<Id, Opportunity> opportunityIdMap = DAL_Opportunity.getAllOpportunity(opportunityIds);
        for(Id id: processAccountIds)
        {
            Id subOpportunityId = passengerIdSubOpportunityIds.get(accountIdMapPassenger.get(id).Id);
            if(opportunityIdMap.get(accountIdMapParentOpportunityIds.get(Id)).StageName != STAGE_NAME_MIB)
            {
                if(!Test.isRunningTest())
                Trigger.new[0].addError('Parent Opportunity stage is not set to Money in the bank');
            }
            else
            {
                Opportunity opp = new Opportunity();
                 if( null !=subOpportunityId )
                 opp.Id = subOpportunityId;
                 opp.AccountId =id;
                 opp.Parent_Opportunity__c = accountIdMapParentOpportunityIds.get(Id);
                 opp.StageName=STAGE_NAME_MIB;
                 opp.Name=opportunityIdMap.get(accountIdMapParentOpportunityIds.get(Id)).Name;
                 opp.Arrival_Date__c = opportunityIdMap.get(accountIdMapParentOpportunityIds.get(Id)).Arrival_Date__c;
                 opp.TravelEndDate__c= opportunityIdMap.get(accountIdMapParentOpportunityIds.get(Id)).TravelEndDate__c;
                 opp.CloseDate=opportunityIdMap.get(accountIdMapParentOpportunityIds.get(Id)).CloseDate;
                 opp.Do_Not_Send_Phptpbook_Offer__c = opportunityIdMap.get(accountIdMapParentOpportunityIds.get(Id)).Do_Not_Send_Phptpbook_Offer__c;
                 opp.Number_of_Photo_Books_Owed__c = accountIdMapPassenger.get(Id).Entitled_to_Photobook_s__c;
                 opp.International_Flight_Arrival_Details__c=opportunityIdMap.get(accountIdMapParentOpportunityIds.get(Id)).International_Flight_Arrival_Details__c;
                 opp.International_Flight_Departure_Details__c=opportunityIdMap.get(accountIdMapParentOpportunityIds.get(Id)).International_Flight_Departure_Details__c;
                 opp.Emergency_Mobile_Phone_Number__c=accountIdMapPassenger.get(Id).Policy_Emergency_Phone_Number__c;
                 opp.Travel_Insurance_c__c = accountIdMapPassenger.get(Id).Travel_Insurance__c;
                 opp.Travel_Insurance_Policy_Number__c= accountIdMapPassenger.get(Id).Travel_Insurance_Policy_Number__c;
                 opp.Travel_Insurance_Policy_Provider__c =accountIdMapPassenger.get(Id).Travel_Insurance_Policy_Provider__c;
                 opp.Waiver_Of_Liability__c=accountIdMapPassenger.get(Id).Waiver_Of_Liability__c;
                 opp.Waiver_Of_Liability_Date__c=accountIdMapPassenger.get(Id).Waiver_Of_Liability_Date__c;
                 opp.Waiver_Of_Liability_Name__c=accountIdMapPassenger.get(Id).Waiver_Of_Liability_Name__c;
                 passengerNameToSubOpportunityMap.put(accountIdMapPassenger.get(Id).Last_Name__c,opp);
                 opportunitys.add(opp);
            }
      } 
      
      system.debug('opportunitys::::'+opportunitys.size());
      if(! opportunitys.isEmpty())
      {
        BaseTriggerHandler.bypass('OpportunityTriggerHandler');
        upsert(opportunitys);  
        BaseTriggerHandler.clearBypass('OpportunityTriggerHandler');
      }
      
     List<Passenger__c> passengerToSubOpportunityUpdate = new List<Passenger__c>();
     for(Passenger__c passsenger: retreivePassengers)
     {
        if(passsenger.Confirmed__c && null != passengerNameToSubOpportunityMap.get(passsenger.Id))
        {
          Passenger__c p = new Passenger__c();
          p.Id = passsenger.Id;
          p.Sub_Opportunity__c = passengerNameToSubOpportunityMap.get(passsenger.Id).Id;
          passengerToSubOpportunityUpdate.add(p);
        }
     }
        
     BaseTriggerHandler.bypass('TH_Passenger');
     DAL_BaseObject.UpdateDBObjects(passengerToSubOpportunityUpdate);  
     BaseTriggerHandler.clearBypass('TH_Passenger');
      
     logger.end();
     }  
     
     
     public void checkNoOfPhotoBookCountChanged()
     {
         Set<Id> passengerIdToprocess = new Set<Id>();
         for(Id qid: newPassengerMap.keySet())
         {
            if( newPassengerMap.get(qid).Entitled_to_Photobook_s__c != oldPassengerMap.get(qid).Entitled_to_Photobook_s__c)
            {
                passengerIdToprocess.add(qid);
                continue;
            }
         }
         
            
         if(!passengerIdToprocess.isEmpty())
         {
            List<PassengerQuotationMapping__c> passengersQuotations = DAL_Passenger.getAllQuotationsRelatedToPassengers(passengerIdToprocess);
            Set<Id> quotationIds = new Set<Id>();
            for(PassengerQuotationMapping__c pQM:passengersQuotations)
            {
                quotationIds.add(pQM.Quotation__c);
            }
            
            List<Quotations__c> quotationsToUpdate = new List<Quotations__c>();
            List<Quotations__c> quotationsFromDB = DAL_Quotations.getAllQuotations(new List<Id>(quotationIds));
            for(Quotations__c quotation: quotationsFromDB)
            {
                quotation.Include_Photobooks_USD__c = false;
                quotation.Include_Photobooks_ZAR__c = false;
                quotationsToUpdate.add(quotation);
            }
            
            if(!quotationsToUpdate.isEmpty())
             DAL_BaseObject.UpdateDBObjects(quotationsToUpdate);
         }   
     }
     
}
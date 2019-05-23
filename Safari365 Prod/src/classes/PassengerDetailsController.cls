public class PassengerDetailsController {
    public List<PassengerWrapper> PassengerWs {get;set;}
    public List<Passenger__c> Passengers {get;set;}
    public List<SelectOption> PassengerSelectOptions{get;set;}
    public Passenger__c SelectedPassenger {get;set;}
    public String SelectedOption{get;set;}
    public Boolean SaveDisabled{get; set;}
    public Integer intCounter;
    
    public List<Schema.FieldSetMember> getFields() {
        return SObjectType.Passenger__c.FieldSets.PassengerFrontEnd.getFields();
    }
    
    public List<SelectOption> getPassengerSelectOptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('--Select Passenger--','--Select Passenger--'));
        for(Passenger__c  p:this.Passengers)
        {
            options.add(new SelectOption(p.Id,p.PassengerName__c));
        }
        return options;
    }
    
    public void onPassengerListChange()
    {
        if('--Select Passenger--' == SelectedOption)
        {
            SaveDisabled = true;
            SelectedPassenger= new Passenger__c();
            return;
        }
        else
        {
           SaveDisabled = false; 
        }
        for(PassengerWrapper  p:this.PassengerWs)
        {
            if(p.Passenger.Id==SelectedOption)
            {
                SelectedPassenger = p.Passenger;
            }
        }
    }
    public PassengerDetailsController() {
        SaveDisabled = true;
        SelectedPassenger = new Passenger__c();
        //passenger = new Passenger__c();
        Passengers = getPassengers();
        PassengerSelectOptions = getPassengerSelectOptions();
        PassengerWs = new List<PassengerWrapper>();
        
        intCounter=1;
        for(Passenger__c  p:Passengers)
        {
            PassengerWrapper pw = new PassengerWrapper();
            pw.Passenger=p;
            pw.counter =intCounter;
            PassengerWs.add(pw);
            intCounter = intCounter+1;
        }
        //onPassengerListChange();
    }
    
    private List<Passenger__c> getPassengers() {
        String quotationId = System.currentPagereference().getParameters().get('Id').replace('/','');
        //String quotationId ='a0m0E0000006nkV';
        List<PassengerQuotationMapping__c> passengerQuotationMappings=[SELECT Passenger__c FROM PassengerQuotationMapping__c WHERE Quotation__c =:quotationId] ;
        List<String> confirmedPassengerIds = new List<String>();
        for(PassengerQuotationMapping__c pqm:passengerQuotationMappings)
        {
            confirmedPassengerIds.add(pqm.Passenger__c);
        }

        
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : this.getFields()) {
            query += f.getFieldPath() + ', ';
        }
        query += 'Id, Name,New_Account__c,Account__c FROM Passenger__c WHERE Id IN  (SELECT Passenger__c FROM PassengerQuotationMapping__c WHERE Quotation__c =:quotationId)' ;
        
        return Database.query(query);
    }

    public pageReference Save()
    {   
        upsert SelectedPassenger;
        List<Account> newAccounts = new list<Account>();
        Map<String, Account> passengerNameToAccountMap = new Map<String, Account>();
        Id recordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
        if(SelectedPassenger.New_Account__c == NULL)
        {
            Account acc = new Account();
            acc.firstName =  SelectedPassenger.FirstName__c;
            acc.LastName = SelectedPassenger.Last_Name__c;
            //acc.Name = p.FirstName__c+''+p.PassengerName__c+''+p.Last_Name__c;
            acc.Primary_Account__c = SelectedPassenger.Account__c;
            acc.RecordTypeId = recordtypeId;
            newAccounts.add(acc);
            passengerNameToAccountMap.put(SelectedPassenger.Name,acc);
        }
        
        if(newAccounts.size()>0)
        {
            DAL_BaseObject.InsertDBObjects(newAccounts);
        }
        
        if( null != passengerNameToAccountMap.get(SelectedPassenger.Name))
            SelectedPassenger.New_Account__c = passengerNameToAccountMap.get(SelectedPassenger.Name).Id;
        
        return null;
    }
    
    
       
   public class PassengerWrapper
    {
       public Passenger__c Passenger {get; set;}
       public Integer counter {get; set;}
    }
}
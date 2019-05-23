public with sharing class QuotationPassengerListController {
   public List<PassengerQuotationMapping__c> PassengerQuotationMappings {get;set;}
    public List<Passenger__c> Passengers {get;set;}
    public List<Passenger__c> AllPassengers {get;set;}
    public List<SelectOption> PassengerSelectOptions {get;set;}
    public List<string> SelectedPassengers {get;set;}
    public boolean firstPanel{get;set;}
    public boolean secondPanel{get;set;}
    public String QuotationId{get;set;}
    
    public QuotationPassengerListController(ApexPages.StandardController stdController) {
        PassengerQuotationMappings = new List<PassengerQuotationMapping__c>();
        Passengers = new List<Passenger__c>();
        
        QuotationId = System.currentPagereference().getParameters().get('Id').replace('/','');
        LoadScreen();
    }
    public void LoadScreen()
    {
        PassengerQuotationMappings = [SELECT Passenger__c FROM PassengerQuotationMapping__c WHERE Quotation__c=:QuotationId] ;
        List<String> PassengerIds = new List<String>();
        
        for(PassengerQuotationMapping__c pqm:PassengerQuotationMappings)
        {
            PassengerIds.add(pqm.Passenger__c);
        }
        
        Passengers = DAL_Passenger.getByIds(PassengerIds);
        
        setAllPassengersAvailableForQuotation(QuotationId);
        
        firstPanel = false;
        secondPanel = true;

    }
    public void setAllPassengersAvailableForQuotation(String quotationId)
    {
        Quotations__c quotation =[SELECT Opportunity__c FROM Quotations__c WHERE Id=:quotationId][0];
        
        AllPassengers  = [select Id,PassengerName__c from Passenger__c where Opportunity__c=:quotation.Opportunity__c];
        PassengerSelectOptions = new List<SelectOption>();
        this.SelectedPassengers = new List<String>();
        for(Passenger__c p : AllPassengers)
        {
            String name = p.PassengerName__c;
            if(name==NULL)
            {
                name='';
            }
            PassengerSelectOptions.add(new SelectOption(String.valueOf(p.Id), name));
            
        }
        
        for(Passenger__c p : Passengers)
        {
            SelectedPassengers.add(String.valueOf(p.Id));
        }
    }
    
    public void Cancel()
    {
        firstPanel = false;
        secondPanel = true;
    }
    
    public void ShowModel()
    {
        firstPanel = true;
        secondPanel = false;
    }
    
    public void Save()
    {
        List<PassengerQuotationMapping__c> mappingsToSave = new List<PassengerQuotationMapping__c>();
        for(String sp:SelectedPassengers)
        {
            PassengerQuotationMapping__c passengerQuotationMapping = new PassengerQuotationMapping__c();
            passengerQuotationMapping.Passenger__c = sp;
            passengerQuotationMapping.Quotation__c = QuotationId;
            mappingsToSave.add(passengerQuotationMapping); 
        }
        if(mappingsToSave.size()>0)
        {
            upsert mappingsToSave;  
            //============================================================
            List<Id> ids = new List<Id>();
            ids.add(QuotationId);
            CreateFolderStructureGoogleDrive.createFolderGoogleDrive(ids);
            //=============================================================  
        }
        LoadScreen();
        
    } 
}
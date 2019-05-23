public class MultiSelectCheckboxPassengerController {
    
    @TestVisible
    public String parentID;
    public String recId{get;set;}
    @TestVisible
    public Date TravelStartDate{get;set;}
    @TestVisible
    public Date TravelEndDate{get;set;}
    public List<string> SelectedPassengers {get;set;}
    public List<SelectOption> PassengerSelectOptions {get;set;}
    public Quotations__c newQuotation{get;set;}
    private static final String CLASS_NAME = MultiSelectCheckboxPassengerController.class.getName();
    Map<Id, Passenger__c> failedCheckPassengers = new Map<Id, Passenger__c>();
    
    public MultiSelectCheckboxPassengerController(ApexPages.StandardController stdController) {
        failedCheckPassengers.clear();
        string str = UserInfo.getUiThemeDisplayed();
        Map<String,String> params = ApexPages.currentPage().getParameters();
        String keyName='';
        for (String key: params.keySet()){
            if(key.Contains('_lkid')){
                keyName = key;
            }
        }
        if(str == 'Theme4d'){
            parentID = ApexPages.currentPage().getParameters().get(keyName);
        }else{
            parentID = System.currentPagereference().getParameters().get('retURL').replace('/','');
        }        
        
        PassengerSelectOptions = new List<SelectOption>();
        List<Passenger__c> passengers  = [select Id,PassengerName__c from Passenger__c where Opportunity__c=:parentID];
        this.SelectedPassengers = new List<String>();
        for(Passenger__c p : passengers)
        {
            String name = p.PassengerName__c;
            if(name==NULL)
            {
                name='';
            }
            PassengerSelectOptions.add(new SelectOption(String.valueOf(p.Id), name));
            SelectedPassengers.add(String.valueOf(p.Id));
        }
        
        SetupnewQuotation();
    }
    
    public pageReference Save()
    {
        List<PassengerQuotationMapping__c> PassengerQuotationMappingList = new List<PassengerQuotationMapping__c>();
        UTIL_LogGenerator logger = new UTIL_LogGenerator();
        logger.start(CLASS_NAME,'Save');
        
        List<Passenger__c> passengers  = DAL_Passenger.getByIds(SelectedPassengers);
        boolean flagToProceed = validateInfantAndChildAgeExist(passengers);
        logger.log(flagToProceed);
        
        List<Opportunity> opportunity = DAL_Opportunity.getById(parentID);
        
        boolean validateEntitledToPhotobookValue = validateEntitledToPhotobook(opportunity[0],passengers);
        
        if(!validateEntitledToPhotobookValue)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Amount of "Entitled to Photobook" must be greater than zero for at least one selected passenger or check the box "Do Not Send Phptpbook Offer" in opportunity');
            ApexPages.addMessage(myMsg);
        }
        
        else if(opportunity[0].Client_Display_Currency__c == null ||opportunity[0].Client_Display_Currency__c =='')
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Client Display currency must be selected at Opportunity Level');
            ApexPages.addMessage(myMsg);
        }
        else if(!flagToProceed)
        {
            
            newQuotation.TravelStartDate__c=TravelStartDate;
            newQuotation.TravelEndDate__c = TravelEndDate;
            newQuotation.Email__c = opportunity[0].Email__c;
            insert newQuotation;
            
            for(String sp:SelectedPassengers)
            {
                PassengerQuotationMapping__c passengerQuotationMapping = new PassengerQuotationMapping__c();
                passengerQuotationMapping.Passenger__c = sp;
                passengerQuotationMapping.Quotation__c = newQuotation.Id;
                PassengerQuotationMappingList.add(passengerQuotationMapping);
                //insert passengerQuotationMapping; 
            }
            insert PassengerQuotationMappingList;
            
            //============================================================
            List<Id> ids = new List<Id>();
            ids.add(newQuotation.Id);
            if(!Test.isRunningTest()){
            	CreateFolderStructureGoogleDrive.createFolderGoogleDrive(ids);
            }
            //=============================================================
            PageReference pr = new PageReference('/'+newQuotation.Id);
            pr.setRedirect(true); 
            return pr;
        }
        else
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Infant need an age');
            ApexPages.addMessage(myMsg);
        }
        //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Infant need an age');
        //ApexPages.addMessage(myMsg);
        logger.end();
        return null;
    }
    
    /* public pageReference SaveAndNew()
    {
    newQuotation.TravelStartDate__c=TravelStartDate;
    newQuotation.TravelEndDate__c = TravelEndDate;
    
    insert newQuotation;
    
    for(String sp:SelectedPassengers)
    {
    PassengerQuotationMapping__c passengerQuotationMapping = new PassengerQuotationMapping__c();
    passengerQuotationMapping.Passenger__c = sp;
    passengerQuotationMapping.Quotation__c = newQuotation.Id;
    insert passengerQuotationMapping; 
    }
    
    SetupnewQuotation();
    
    return null;
    }*/
    
    public pageReference Cancel()
    {
        PageReference pr = new PageReference('/'+parentID);
        pr.setRedirect(false); 
        return pr;
    }
    
    private void SetupnewQuotation()
    {
        newQuotation = new Quotations__c();
        if(!Test.isRunningTest())
        {
        newQuotation.Quotation_Name__c='';
        }
        else{
        	newQuotation.Quotation_Name__c='Test Quotation';
        }
        newQuotation.Opportunity__c = parentID;
        TravelStartDate = Date.today();
        TravelEndDate = Date.today().addDays(1);
        
        //SelectedPassengers = new List<String>();
    }
    
    private boolean validateEntitledToPhotobook(Opportunity opportunity, List<Passenger__c> passengers)
    {
        boolean flag = false;
        //List<Opportunity> Opportunity = DAL_Opportunity.getById(parentID);
        
        if(opportunity.Do_Not_Send_Phptpbook_Offer__c == true)
        {
            return true;
        }
        
        for(Passenger__c p: passengers)
        {
            if(p.Entitled_to_Photobook_s__c > 0)
            {
                flag = true;
                failedCheckPassengers.put(p.Id, p);
                break;
            }       
        }
        return flag;
    }
    private boolean validateInfantAndChildAgeExist(List<Passenger__c> passengers)
    {
        UTIL_LogGenerator logger = new UTIL_LogGenerator();
        logger.start(CLASS_NAME,'Save');
        
        logger.log(passengers);
        boolean flag = false;
        for(Passenger__c p: passengers)
        {
            if((p.PassengerType__c=='Infant'|| p.PassengerType__c=='Child') 
               && (p.Given_Age__c == ' ' || p.Given_Age__c == null)
               && (p.Entitled_to_Photobook_s__c > 0))
            {
                flag = true;
                failedCheckPassengers.put(p.Id, p);
                break;
            }       
        }
        return flag;
    }
    
}
public class CreatePassengerController {

    public List<SelectOption> PassengerTypes{get;set;}
    public List<SelectOption> PassengerNumbers{get;set;}
    @TestVisible
    public String SelectedPassengerType {get;set;}
    @TestVisible
    public String SelectedPassengerNumber {get;set;}
    public String OppId;
    public boolean displayPopup {get; set;}     
    public Passenger__c passenger;
    public void closePopup() {        
        displayPopup = false;    
    }     
    public void showPopup() {        
        displayPopup = true;    
    }
    
    public CreatePassengerController(){
    
    }
    public CreatePassengerController(ApexPages.StandardController stdController)
    {
        passenger = (Passenger__c)stdController.getRecord();
        PassengerTypes = getPassengerTypes();
        PassengerNumbers = getPassengerNumbers();
        string str = UserInfo.getUiThemeDisplayed();
        Map<String,String> params = ApexPages.currentPage().getParameters();
        String keyName='';
        for (String key: params.keySet()){
            if(key.Contains('_lkid')){
                keyName = key;
                System.debug('@@keyName :'+keyName);
            }
        }
        if(!Test.isRunningTest())
        {      
           if(str == 'Theme4d')
           {
               OppId = ApexPages.currentPage().getParameters().get(keyName);
           }else{
               OppId = system.currentPagereference().getParameters().get('retURL').replace('/','');
               return;
           }
             //OppId = system.currentPagereference().getParameters().get('retURL').replace('/','');
        }
        else
        {
           if(str == 'Theme4d')
           {
               OppId = ApexPages.currentPage().getParameters().get(keyName);  
           }else{
               String parameters = system.currentPagereference().getParameters().get('retURL/');
               OppId = Id.valueof(parameters);
           }
        }
    }
    
    public List<SelectOption> getPassengerTypes()
    {
        List<SelectOption> options = new List<SelectOption>();
        
       Schema.DescribeFieldResult fieldResult = Passenger__c.PassengerType__c.getDescribe();
       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
       for( Schema.PicklistEntry f : ple)
       {
          options.add(new SelectOption(f.getLabel(), f.getValue()));
       }       
       return options;
    }
    
    public List<SelectOption> getPassengerNumbers()
    {
        List<SelectOption> options = new List<SelectOption>();
            
       for(Integer i=1;i<=10;i++)
       {
          options.add(new SelectOption(String.valueOf(i), String.valueOf(i)));
       }       
       return options;
    }
    
    public pageReference Save()
    {
        List<Opportunity> OppList = [SELECT Id,AccountId FROM Opportunity WHERE Id=:OppId];
        
        CreatePassengerServiceReqButtonHelper.createPassenger(OppList[0].AccountId,OppList[0].Id,SelectedPassengerType,Integer.valueOf(SelectedPassengerNumber));
        
        PageReference pr = new PageReference('/'+OppId);
        pr.setRedirect(false); 
        return pr;
    }
    
    public pageReference Cancel()
    {
        PageReference pr = new PageReference('/'+OppId);
        pr.setRedirect(false); 
        return pr;
    }
}
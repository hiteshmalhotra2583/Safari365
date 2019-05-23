public class UpdatePassengerAgeController {
    public boolean displayPopup {get; set;}     
    public Passenger__c pax{get;set;}
    
    public void closePopup() {        
        displayPopup = false;    
    }     
    public void showPopup() {        
        displayPopup = true;    
    }
     public UpdatePassengerAgeController()
     {
         String pId = system.currentPagereference().getParameters().get('pId');
         
         pax = new Passenger__c();
         pax.Id=Id.ValueOf(pId);
     }
    
    public void Save()
    {
       upsert pax;
       displayPopup = false;     
    }

}
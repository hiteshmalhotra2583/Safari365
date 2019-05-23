public class AccountTriggerHandler extends BaseTriggerHandler {
  
    private List<Account> newAccList;
    private List<Account> oldAccList;
    private Map<ID, Account> newAccMap;
    private Map<ID, Account> oldAccMap;
    private TriggerUtil triggerUtil = new TriggerUtil();

    public AccountTriggerHandler() {
        oldAccList = (List<Account>)Trigger.old;
        newAccList = (List<Account>)Trigger.new;
        newAccMap =  (Map<ID, Account>)Trigger.newMap;
        oldAccMap = (Map<ID, Account>)Trigger.oldMap;
    }
    
    protected override void beforeInsert() { 
        if(Trigger_PAD.canRun('AccountTriggerHandler')){
            updatePersonHasOptedOutOfEmail();
        }
} 

 protected override void beforeUpdate() {
        if(Trigger_PAD.canRun('AccountTriggerHandler')){
            updatePersonHasOptedOutOfEmail();
        }
    }
    
    protected override void afterUpdate() {
        if(Trigger_PAD.canRun('AccountTriggerHandler')){
            changeOpportunityEmail(oldAccList,newAccList);
        }
    }
   
    
   
   public void updatePersonHasOptedOutOfEmail(){
     for(Account a : newAccList){
              if(a.Newsletter__c){
                 a.PersonHasOptedOutOfEmail= false;    
              }else{
                a.PersonHasOptedOutOfEmail= true;    
              }
         }
   }
   
   public void updatePersonHasOptedOutOfEmailUpdate(){
           Map<Id, Account> oldAccountMap=oldAccMap;
            Map<Id, Account> newAccountMap=newAccMap;
            for(Account l : newAccList){
            if(oldAccountMap.get(l.Id).PersonHasOptedOutOfEmail != newAccountMap.get(l.Id).PersonHasOptedOutOfEmail ){
               if(newAccountMap.get(l.Id).PersonHasOptedOutOfEmail){
                l.Newsletter__c= false;
               }else{
               l.Newsletter__c= true;
               }
            }
             if((oldAccountMap.get(l.Id).Newsletter__c != newAccountMap.get(l.Id).Newsletter__c )){
                 if(newAccountMap.get(l.Id).Newsletter__c){
                    l.PersonHasOptedOutOfEmail= false;    
                 }else {
                  l.PersonHasOptedOutOfEmail= true;
                 }
            } 
         }
   }
    
     public static void  changeOpportunityEmail(List<Account> oldlst_Accounts, List<Account> newList_Account){
        
        Set<Id> refineAccIdSet = new Set<Id>();
        Set<Id> accointIdSet = new Set<Id>();
        Set<String> accountOldEmailSet = new Set<String>();
        Map<Id, Account> oldAccountMap = new Map<Id, Account>();
        Map<Id, Account> newAccountMap = new Map<Id, Account>();
        for(Account acc:oldlst_Accounts){
        oldAccountMap.put(acc.Id,acc );
        accointIdSet.add(acc.Id);
        accountOldEmailSet.add(acc.PersonEmail);
        }
        
        for(Account newacc:newList_Account){
        if(newacc.PersonEmail !=oldAccountMap.get(newacc.Id).PersonEmail ){
            refineAccIdSet.add(newacc.Id);
            newAccountMap.put(newacc.Id,newacc);
            }
        }
        
        List<Opportunity> oppList=[Select Email__c,AccountId from Opportunity where AccountId IN:refineAccIdSet];
        List<Opportunity> newoppList = new List<Opportunity> ();
        for(Opportunity opp:oppList){
        opp.Email__c=newAccountMap.get(opp.AccountId).PersonEmail;
        newoppList.add(opp);
        }
        update newoppList;
     }
     
    
}
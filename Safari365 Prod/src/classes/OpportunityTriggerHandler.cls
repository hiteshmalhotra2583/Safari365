public class OpportunityTriggerHandler extends BaseTriggerHandler {
  
    private List<Opportunity> newOptList;
    private List<Opportunity> oldOptList;
    private Map<ID, Opportunity> newOptMap;
    private Map<ID, Opportunity> oldOptMap;
    private TriggerUtil triggerUtil = new TriggerUtil();

    public OpportunityTriggerHandler()
     {
        oldOptList = (List<Opportunity>)Trigger.old;
        newOptList = (List<Opportunity>)Trigger.new;
        newOptMap =  (Map<ID, Opportunity>)Trigger.newMap;
        oldOptMap = (Map<ID, Opportunity>)Trigger.oldMap;
    }
    
    protected override void beforeInsert()
    { 
        if(Trigger_PAD.canRun('OpportunityTriggerHandler'))
        {
            updateCloseDate();
            updateEmailFromAccount();
        }
    } 

    protected override void beforeUpdate()
    {
        if(Trigger_PAD.canRun('OpportunityTriggerHandler'))
        {
           //updateCloseDate(); 
           updateEmailFromAccount(); 
           updateOwnerEmailOnServiceLineItem();              
        }
    }
    
    protected override void afterInsert()
    {
        if(Trigger_PAD.canRun('OpportunityTriggerHandler'))
        {
           createMainAccountAsPassenger();        
        }
    }
    
    
    protected override void afterUpdate()
    {
        if(Trigger_PAD.canRun('OpportunityTriggerHandler'))
        {
           List<Opportunity> updateoppList = updateCloseDateAfterUpdate(); 
           system.debug('updateoppList:::'+updateoppList);  
           UpdateTargetValueOpportunityService.updateTargetMonthlyValues(updateoppList,oldOptMap);
        }
    }
    
    protected override void afterDelete()
    {
        if(Trigger_PAD.canRun('OpportunityTriggerHandler'))
        {
           UpdateTargetValueOpportunityService.deleteTargetMonthlyValues(oldOptList,oldOptMap);
        }
    }
    
    public void updateOwnerEmailOnServiceLineItem()
    {
      Set<String> opportunityToProcess = new Set<String>();
      Set<Id> ownerIdSet = new Set<ID>();
      Map<String,String> opportunityOwnerMap = new Map<String,String>();
        for(Id oppid: newOptMap.keySet())
        {
            if( newOptMap.get(oppid).OwnerId != null
               &&oldOptMap.get(oppid).OwnerId != newOptMap.get(oppid).OwnerId)
            {
                opportunityToProcess.add(newOptMap.get(oppid).Id);
                ownerIdSet.add(newOptMap.get(oppid).OwnerId);
                opportunityOwnerMap.put(newOptMap.get(oppid).Id,newOptMap.get(oppid).OwnerId);
            }
            
       }
       
       if(!ownerIdSet.isEmpty())
       {
           Map<Id,User> userIdMap = DAL_USER.getUserByIds(ownerIdSet);
           List<ServiceLineItem__c> slis = QuotationBuilderDatabaseQueries.allServiceLineItemRelatedToOpportunityIds(opportunityToProcess);
           List<ServiceLineItem__c> slisToUpdate = new List<ServiceLineItem__c>();
           for(ServiceLineItem__c sli:slis)
           {
                User u = userIdMap.get(opportunityOwnerMap.get(Id.valueof(sli.OpportunityId__c)));
                sli.Opportunity_Owner_Email__c =u.Email;
                slisToUpdate.add(sli);
           }
           
           if(!slisToUpdate.isEmpty())
           update slisToUpdate;
       }
    }  
    
    
    public void createMainAccountAsPassenger()
    {
        List<Passenger__c> passengers  = new List<Passenger__c>();
        Set<Id> accountIds = new Set<Id>();
        for(Opportunity opp: newOptList)
        {
            accountIds.add(opp.AccountId);
        }
     
        Map<Id, Account> accountIdMap = DAL_Account.getById(accountIds);
        for(Opportunity opp: newOptList)
        {
            Passenger__c pass = new Passenger__c();
            pass.FirstName__c= accountIdMap.get(opp.AccountId).FirstName;
            pass.Last_Name__c= accountIdMap.get(opp.AccountId).LastName;
            pass.New_Account__c = opp.AccountId;
            pass.Confirmed__c = true;
            pass.Is_Primary__c = true;
            pass.Opportunity__c = opp.id;
            pass.PassengerType__c = 'Adult';
            pass.PassengerName__c = accountIdMap.get(opp.AccountId).FirstName +' '+accountIdMap.get(opp.AccountId).LastName;
            passengers.add(pass);
        }
       
       if(! passengers.isEmpty())
       {
        BaseTriggerHandler.byPass('TH_Passenger');
        DAL_BaseObject.InsertDBObjects(passengers);
        BaseTriggerHandler.clearBypass('TH_Passenger');
       }  
       
    }
     public  void updateEmailFromAccount()
     {
         Set<Id>  accountIDSet= new Set<Id>();
         for(Opportunity OppRec : newOptList)
         {
            accountIDSet.add(OppRec.AccountId);
         }
        
         Map<Id,Account> accountMap = new Map<ID, Account>([Select Id ,PersonEmail from Account where Id IN:accountIDSet]);
         
         for(Opportunity OppRecs : newOptList)
          {
            Account acc = accountMap.get(OppRecs.AccountId);
            if(null!=acc && null!=acc.PersonEmail)
            {
                OppRecs.Email__c=acc.PersonEmail;
            }
          }    
     }
  
     public  void updateCloseDate(){
              
        for(Opportunity OppRec : newOptList)
        {
           if(!(OppRec.StageName == 'Closed Won Deal') || !(OppRec.StageName == 'Money in the Bank'))
           {
                OppRec.closeDate=system.today().addDays(Integer.valueof(system.Label.Opportunity_Close_Day));
           }
           else if(OppRec.StageName == 'Closed Won Deal' || OppRec.StageName == 'Money in the Bank')
           {
                OppRec.closeDate=system.today();
           }
        }
     }    

      public List<Opportunity> updateCloseDateAfterUpdate(){
              
        List<Opportunity> opportunityToUpdate = new List<Opportunity>();
        Boolean flagToUpdate = false;
        for(Opportunity OppRec : newOptList)
        {
           
           Opportunity newOpp = null;
           Opportunity oldOpp = oldOptMap.get(OppRec.Id);
           if(OppRec.StageName != 'Closed Won Deal' 
                && OppRec.StageName != 'Money in the Bank'
                &&  OppRec.StageName != 'Closed Won - Cancelled' )
           {
                newOpp  = new Opportunity(Id =OppRec.Id);
                newOpp.closeDate=system.today().addDays(Integer.valueof(system.Label.Opportunity_Close_Day));
                newOpp.Gross_Profit__c = OppRec.Gross_Profit__c;
                newOpp.StageName = OppRec.StageName;
                //newOpp =OppRec;
           }
           else if( oldOpp.StageName != OppRec.StageName 
                    &&( OppRec.StageName == 'Closed Won Deal' 
                       || OppRec.StageName == 'Closed Won - Cancelled' 
                        || OppRec.StageName == 'Money in the Bank'))
           {
                newOpp  = new Opportunity(Id =OppRec.Id);
                newOpp.closeDate = system.today();
                newOpp.Gross_Profit__c = OppRec.Gross_Profit__c;
                newOpp.StageName = OppRec.StageName;
                newOpp.OwnerId = OppRec.OwnerId;
                //newOpp =OppRec;
           }
           else if( oldOpp.StageName == OppRec.StageName 
                    &&( OppRec.StageName == 'Closed Won Deal' 
                       || OppRec.StageName == 'Closed Won - Cancelled' 
                        || OppRec.StageName == 'Money in the Bank'))
           {
                newOpp  = new Opportunity(Id =OppRec.Id);
                newOpp.closeDate = OppRec.closeDate;
                newOpp.Gross_Profit__c = OppRec.Gross_Profit__c;
                newOpp.StageName = OppRec.StageName;
                newOpp.OwnerId = OppRec.OwnerId;
                newOpp.Consultant_Target_Monthly__c = OppRec.Consultant_Target_Monthly__c;
                flagToUpdate = true;
           }
           
           
            if(null != newOpp )
            opportunityToUpdate.add(newOpp);
         }
           
           if(!opportunityToUpdate.isEmpty() 
                && !flagToUpdate)
           {
                BaseTriggerHandler.byPass('OpportunityTriggerHandler');
                update opportunityToUpdate;
                BaseTriggerHandler.clearBypass('OpportunityTriggerHandler');
           }
           return opportunityToUpdate;
        }

}
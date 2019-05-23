public class TH_Lead extends BaseTriggerHandler{

    private static final String CLASS_NAME = TH_Lead.class.getName();
    private List<Lead> newLeadList;
    private List<Lead> oldLeadList;
    private Map<ID, Lead > newLeadMap;
    private Map<ID, Lead > oldLeadMap;
   

    public TH_Lead() 
    {
        oldLeadList = (List<Lead>)Trigger.old;
        newLeadList = (List<Lead>)Trigger.new;
        newLeadMap =  (Map<ID, Lead>)Trigger.newMap;
        oldLeadMap = (Map<ID, Lead>)Trigger.oldMap;
    }
    
    protected override void beforeInsert()
    {
        if(Trigger_PAD.canRun('TH_Lead'))
        {
            LeadNurturingHandler.validateAndLinkLead(newLeadList,newLeadMap);
            UpdateOwnerImageId.updateImageId(newLeadList); 
        }       
    }
    
    
    protected override void beforeUpdate()
    {
        if(Trigger_PAD.canRun('TH_Lead'))
        {
            for(Lead l : newLeadList)
            {
                if(oldLeadMap.get(l.Id).HasOptedOutOfEmail != newLeadMap.get(l.Id).HasOptedOutOfEmail )
                {
                   if(newLeadMap.get(l.Id).HasOptedOutOfEmail)
                   {
                       l.Newsletter__c= false;
                   }
                   else
                   {
                        l.Newsletter__c= true;
                   }
            }
          
           if((oldLeadMap.get(l.Id).Newsletter__c != newLeadMap.get(l.Id).Newsletter__c ))
           {
                 if(newLeadMap.get(l.Id).Newsletter__c)
                 {
                    l.HasOptedOutOfEmail= false;    
                 }
                 else
                 {
                    l.HasOptedOutOfEmail= true;
                 }
            } 
          
            if(l.ConvertedAccountId != null)
            {
                l.Activate_Workflow__c = true;
            }
         }
       }
    }
    
    
    protected override void afterInsert()
    {
        if(Trigger_PAD.canRun('TH_Lead'))
        {
            system.debug('inside after insert'+SingleExecution.hasAlreadyDone());
            if(SingleExecution.hasAlreadyDone())
             return;
             //Else
            SingleExecution.setAlreadyDone();
            system.debug('inside after insert2222');
            TH_LeadService.processRecordAfterInsert(newLeadList);
        } 
    }
    
    protected override void afterUpdate()
    {
        
        if(Trigger_PAD.canRun('TH_Lead'))
        {
            system.debug('inside after update111'+SingleExecution.hasAlreadyDone());
            if(SingleExecution.hasAlreadyDone())
             return;
             //Else
            SingleExecution.setAlreadyDone();
            system.debug('inside after update222');
            TH_LeadService.procesRecordAfterUpdate(newLeadList,oldLeadMap);
        }       
    }
}
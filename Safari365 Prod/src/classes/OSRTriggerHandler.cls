public class OSRTriggerHandler  extends BaseTriggerHandler {
   
    private List<OSR__c> newOSRList;
    private List<OSR__c> oldOSRList;
    private Map<ID, OSR__c> newOSRMap;
    private Map<ID, OSR__c> oldOSRMap;
    private TriggerUtil triggerUtil = new TriggerUtil();

    public OSRTriggerHandler()
    {
        oldOSRList = (List<OSR__c>)Trigger.old;
        newOSRList = (List<OSR__c>)Trigger.new;
        newOSRMap =  (Map<ID, OSR__c>)Trigger.newMap;
        oldOSRMap = (Map<ID, OSR__c>)Trigger.oldMap;
    }

   protected override void beforeInsert()
   { 
        if(Trigger_PAD.canRun('OSRTriggerHandler'))
        {
            triggerUtil.ProcessTriggerHandler(newOSRList,'OSROPTTriggerHandler');
            triggerUtil.ProcessTriggerHandler(newOSRList,'OSROPCTriggerHandler');
        }
  }   

  protected override void beforeUpdate() 
  {
     if(Trigger_PAD.canRun('OSRTriggerHandler')){
        triggerUtil.ProcessTriggerHandler(newOSRList,'OSROPTTriggerHandler');
        triggerUtil.ProcessTriggerHandler(newOSRList,'OSROPCTriggerHandler');        
    }
  }
}
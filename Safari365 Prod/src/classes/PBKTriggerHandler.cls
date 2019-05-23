public  class PBKTriggerHandler extends BaseTriggerHandler {

    private List<PBK__c> newPBKList;
    private List<PBK__c> oldPBKList;
    private Map<ID, PBK__c> newPBKMap;
    private Map<ID, PBK__c> oldPBKMap;
    private TriggerUtil triggerUtil = new TriggerUtil();

    public PBKTriggerHandler() {
        oldPBKList = (List<PBK__c>)Trigger.old;
        newPBKList = (List<PBK__c>)Trigger.new;
        newPBKMap =  (Map<ID, PBK__c>)Trigger.newMap;
        oldPBKMap = (Map<ID, PBK__c>)Trigger.oldMap;
    }

protected override void beforeInsert() { 
        if(Trigger_PAD.canRun('PBKTriggerHandler')){
            triggerUtil.ProcessTriggerHandler(newPBKList,'PBKCRMTriggerHandler');
            triggerUtil.ProcessTriggerHandler(newPBKList,'PBKCTTTriggerHandler');
            triggerUtil.ProcessTriggerHandler(newPBKList,'PBKOPTTriggerHandler');
        }
} 

protected override void beforeUpdate() {
        if(Trigger_PAD.canRun('PBKTriggerHandler')){
           triggerUtil.ProcessTriggerHandler(newPBKList,'PBKCRMTriggerHandler');
            triggerUtil.ProcessTriggerHandler(newPBKList,'PBKCTTTriggerHandler');
            triggerUtil.ProcessTriggerHandler(newPBKList,'PBKOPTTriggerHandler');
        }
    }
}
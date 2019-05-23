public class OPTTriggerHandler extends BaseTriggerHandler {

    private List<Opt__c> newOptList;
    private List<Opt__c> oldOptList;
    private Map<ID, Opt__c> newOptMap;
    private Map<ID, Opt__c> oldOptMap;
    private TriggerUtil triggerUtil = new TriggerUtil();

    public OPTTriggerHandler() {
        oldOptList = (List<Opt__c>)Trigger.old;
        newOptList = (List<Opt__c>)Trigger.new;
        newOptMap =  (Map<ID, Opt__c>)Trigger.newMap;
        oldOptMap = (Map<ID, Opt__c>)Trigger.oldMap;
    }

protected override void beforeInsert() { 
        if(Trigger_PAD.canRun('OPTTriggerHandler')){
            triggerUtil.ProcessTriggerHandler(newOptList,'OPTCRMTriggerHandler');
            triggerUtil.ProcessTriggerHandler(newOptList,'OPTDB4TriggerHandler');
            triggerUtil.ProcessTriggerHandler(newOptList,'OPTLCLTriggerHandler');
            triggerUtil.ProcessTriggerHandler(newOptList,'OPTSRVTriggerHandler');
            triggerUtil.ProcessTriggerHandler(newOptList,'OPTDB2TriggerHandler');
            triggerUtil.ProcessTriggerHandler(newOptList,'OPTSODTriggerHandler');
        }
} 

protected override void beforeUpdate() {
        if(Trigger_PAD.canRun('OPTTriggerHandler')){
           triggerUtil.ProcessTriggerHandler(newOptList,'OPTCRMTriggerHandler');
            triggerUtil.ProcessTriggerHandler(newOptList,'OPTDB4TriggerHandler');
            triggerUtil.ProcessTriggerHandler(newOptList,'OPTLCLTriggerHandler');
            triggerUtil.ProcessTriggerHandler(newOptList,'OPTSRVTriggerHandler');
            triggerUtil.ProcessTriggerHandler(newOptList,'OPTDB2TriggerHandler');
            triggerUtil.ProcessTriggerHandler(newOptList,'OPTSODTriggerHandler');          
        }
    }
}
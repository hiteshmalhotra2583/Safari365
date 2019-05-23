public class NTSTriggerHandler extends BaseTriggerHandler {

    private List<NTS__c> newNTSList;
    private List<NTS__c> oldNTSList;
    private Map<ID, NTS__c> newNTSMap;
    private Map<ID, NTS__c> oldNTSMap;
    private TriggerUtil triggerUtil = new TriggerUtil();

    public NTSTriggerHandler() {
        oldNTSList = (List<NTS__c>)Trigger.old;
        newNTSList = (List<NTS__c>)Trigger.new;
        newNTSMap =  (Map<ID, NTS__c>)Trigger.newMap;
        oldNTSMap = (Map<ID, NTS__c>)Trigger.oldMap;
    }

protected override void beforeInsert() { 
        if(Trigger_PAD.canRun('NTSTriggerHandler')){
            triggerUtil.ProcessTriggerHandler(newNTSList,'NTSNCTTriggerHandler');
            triggerUtil.ProcessTriggerHandler(newNTSList,'NTSCRMTriggerHandler');
            
        }
} 

protected override void beforeUpdate() {
        if(Trigger_PAD.canRun('NTSTriggerHandler')){
            triggerUtil.ProcessTriggerHandler(newNTSList,'NTSNCTTriggerHandler');
            triggerUtil.ProcessTriggerHandler(newNTSList,'NTSCRMTriggerHandler');
        }
    }
    
}
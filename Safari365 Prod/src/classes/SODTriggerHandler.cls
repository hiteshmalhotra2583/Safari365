public class SODTriggerHandler  extends BaseTriggerHandler {

    private List<SOD__c> newSODList;
    private List<SOD__c> oldSODList;
    private Map<ID, SOD__c> newSODMap;
    private Map<ID, SOD__c> oldSODMap;
    private TriggerUtil triggerUtil = new TriggerUtil();

    public SODTriggerHandler() {
        oldSODList = (List<SOD__c>)Trigger.old;
        newSODList = (List<SOD__c>)Trigger.new;
        newSODMap =  (Map<ID, SOD__c>)Trigger.newMap;
        oldSODMap = (Map<ID, SOD__c>)Trigger.oldMap;
    }

protected override void beforeInsert() { 
        if(Trigger_PAD.canRun('SODTriggerHandler')){
            triggerUtil.ProcessTriggerHandler(newSODList,'SODCRMTriggerHandler');
            
        }
} 

protected override void beforeUpdate() {
        if(Trigger_PAD.canRun('SODTriggerHandler')){
            triggerUtil.ProcessTriggerHandler(newSODList,'SODCRMTriggerHandler');
        }
    }
}
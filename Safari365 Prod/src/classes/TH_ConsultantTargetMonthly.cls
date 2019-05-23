public class TH_ConsultantTargetMonthly extends BaseTriggerHandler{

    private static final String CLASS_NAME = TH_ConsultantTargetMonthly.class.getName();
    private List<Consultant_Target_Monthly__c> newConsultantTargetMonthlyList;
    private List<Consultant_Target_Monthly__c> oldConsultantTargetMonthlyList;
    private Map<Id, Consultant_Target_Monthly__c > newConsultantTargetMonthlyMap;
    private Map<Id, Consultant_Target_Monthly__c > oldConsultantTargetMonthlyMap;

    public TH_ConsultantTargetMonthly() 
    {
        oldConsultantTargetMonthlyList = (List<Consultant_Target_Monthly__c>)Trigger.old;
        newConsultantTargetMonthlyList = (List<Consultant_Target_Monthly__c>)Trigger.new;
        newConsultantTargetMonthlyMap =  (Map<Id, Consultant_Target_Monthly__c>)Trigger.newMap;
        oldConsultantTargetMonthlyMap = (Map<Id, Consultant_Target_Monthly__c>)Trigger.oldMap;
    }
    
    
    protected override void afterupdate()
    {
        if(Trigger_PAD.canRun('TH_ConsultantTargetMonthly'))
        {
             UpdateYearlyTargetService.rollUpFromMonthlyRecords(newConsultantTargetMonthlyMap);
        }       
    }
    
    protected override void afterDelete()
    {
        if(Trigger_PAD.canRun('TH_ConsultantTargetMonthly'))
        {
           UpdateYearlyTargetService.rollUpFromMonthlyRecords(oldConsultantTargetMonthlyMap);
        }       
    }
}
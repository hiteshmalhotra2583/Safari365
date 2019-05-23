public class TH_ConsultantTargetLeadYearly extends BaseTriggerHandler
{

    private static final String CLASS_NAME = TH_ConsultantTargetLeadYearly.class.getName();
    private List<Consultant_Target_Lead_Yearly__c> oldConsultantTargetLeadYearlyList;
    private List<Consultant_Target_Lead_Yearly__c> newConsultantTargetLeadYearlyList;
    private Map<Id, Consultant_Target_Lead_Yearly__c > oldConsultantTargetLeadYearlyMap;
    private Map<Id, Consultant_Target_Lead_Yearly__c > newConsultantTargetLeadYearlyMap;

    public TH_ConsultantTargetLeadYearly() 
    {
        oldConsultantTargetLeadYearlyList = (List<Consultant_Target_Lead_Yearly__c>)Trigger.old;
        newConsultantTargetLeadYearlyList = (List<Consultant_Target_Lead_Yearly__c>)Trigger.new;
        newConsultantTargetLeadYearlyMap =  (Map<Id, Consultant_Target_Lead_Yearly__c>)Trigger.newMap;
        oldConsultantTargetLeadYearlyMap = (Map<Id, Consultant_Target_Lead_Yearly__c>)Trigger.oldMap;
    }
    
    
    protected override void afterupdate()
    {
        if(Trigger_PAD.canRun('TH_ConsultantTargetLeadYearly'))
        {
             UpdateYearlyTargetService.upsertConsultantLeadYearlyTarget(newConsultantTargetLeadYearlyList);
        }       
    }
    
    

}
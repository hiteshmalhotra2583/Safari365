/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
trigger dlrs_Consultant_Target_MonthlyTrigger on Consultant_Target_Monthly__c
    (before delete, before insert, before update, after delete, after insert, after undelete, after update)
{
    dlrs.RollupService.triggerHandler(Consultant_Target_Monthly__c.SObjectType);
}
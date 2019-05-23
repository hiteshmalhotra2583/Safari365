/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
trigger dlrs_Service_Line_Item_ChargeTypeTrigger on Service_Line_Item_ChargeType__c
    (before delete, before insert, before update, after delete, after insert, after undelete, after update)
{
    dlrs.RollupService.triggerHandler(Service_Line_Item_ChargeType__c.SObjectType);
}
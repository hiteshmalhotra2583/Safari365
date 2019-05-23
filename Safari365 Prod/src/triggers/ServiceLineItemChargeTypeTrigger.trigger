trigger ServiceLineItemChargeTypeTrigger on Service_Line_Item_ChargeType__c (before update) {
    new TH_ServiceLineItemChargeType().run();
}
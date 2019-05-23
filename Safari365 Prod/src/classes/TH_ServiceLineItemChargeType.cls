public  class TH_ServiceLineItemChargeType extends BaseTriggerHandler{

    private static final String CLASS_NAME = TH_ServiceLineItemChargeType.class.getName();
    private List<Service_Line_Item_ChargeType__c> newServiceLineItemChargeTypeList;
    private List<Service_Line_Item_ChargeType__c> oldServiceLineItemChargeTypeList;
    private Map<ID, Service_Line_Item_ChargeType__c > newServiceLineItemChargeTypeMap;
    private Map<ID, Service_Line_Item_ChargeType__c > oldServiceLineItemChargeTypeMap;

    public TH_ServiceLineItemChargeType() 
    {
        oldServiceLineItemChargeTypeList = (List<Service_Line_Item_ChargeType__c>)Trigger.old;
        newServiceLineItemChargeTypeList = (List<Service_Line_Item_ChargeType__c>)Trigger.new;
        newServiceLineItemChargeTypeMap =  (Map<ID, Service_Line_Item_ChargeType__c>)Trigger.newMap;
        oldServiceLineItemChargeTypeMap = (Map<ID, Service_Line_Item_ChargeType__c>)Trigger.oldMap;
    }
    
    
    protected override void beforeUpdate()
    {
       if(Trigger_PAD.canRun('TH_ServiceLineItemChargeType'))
       {
         updateNetValues(); 
       }
    }
    
    
    public void updateNetValues()
    {
        for(Service_Line_Item_ChargeType__c sli : newServiceLineItemChargeTypeList)
         {
             Decimal d  =0;
            if(sli.Override_Nett_Cost__c && sli.Total__c >0)
            {
                d =((sli.Total__c-sli.Nett_Cost__c)/sli.Total__c)*100;
                sli.Markup__c = d.setscale(2);
            }
            
            if(sli.Overide_Markup__c && !sli.Override_Nett_Cost__c)
            {
                sli.Total__c = Math.round(sli.Nett_Cost__c+(sli.Nett_Cost__c*sli.Markup__c)/100);
            }
            
         }
    }
    
}
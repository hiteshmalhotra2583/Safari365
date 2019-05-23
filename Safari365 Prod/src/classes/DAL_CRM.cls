public class DAL_CRM {
   public static final String OBJECT_NAME = CRM__c.SObjectType.getDescribe().getLocalName();
    
    public static Map<String,CRM__c> getCrmFromServiceLineItems(List<ServiceLineItem__c> serviceLineItems)
    {
         Set<String> codes = new Set<String>();
         for(ServiceLineItem__c sli: serviceLineItems)    
         {
            codes.add(sli.Crm_Code__c);
         }  
        List<CRM__c> crms=
                  [SELECT
                         Id,
                         Code__c
                    FROM 
                         CRM__c 
                    WHERE 
                         Code__c IN:codes];
       Map<String, CRM__c> codeCrmMap = new Map<String, CRM__c>();
       for(CRM__c op:crms)
       {
        codeCrmMap.put(op.Code__c,op);
       }  
       return  codeCrmMap;  
    }
    
    
    public static List<CRM__c> getById(String id)
    {
        return [SELECT
                         Id,
                         Code__c,
                         DEFAULT_CURRENCY__c
                    FROM 
                         CRM__c 
                    WHERE 
                         Id =:id];
    }
    
     
}
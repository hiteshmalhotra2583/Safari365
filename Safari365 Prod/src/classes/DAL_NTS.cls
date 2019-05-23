public class DAL_NTS {
    
    public static final String OBJECT_NAME = NTS__c.SObjectType.getDescribe().getLocalName();
    
    public static Map<String,NTS__c> GetNtsForServiceLineItems(List<CRM__c> crms)
    {
        Set<Id> crmLookupCodes = new Set<Id>();
        for(CRM__c crm:crms)
        {
            crmLookupCodes.add(crm.Id);
        }
        List<NTS__c> nts = [SELECT
                                    Id,
                                    CATEGORY__c,
                                    MESSAGE_TEXT__c,
                                    CRM_Lookup__c
                              FROM 
                                    NTS__c
                              WHERE
                                   CRM_Lookup__c IN:crmLookupCodes
                                AND 
                                  CATEGORY__c =:'WET'];
       Map<String, NTS__c> codeNtsMap = new Map<String, NTS__c>();
       for(NTS__c nt:nts)
       {
        codeNtsMap.put(nt.CRM_Lookup__c,nt );
       }  
       return  codeNtsMap;         
    }
}
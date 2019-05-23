public class DAL_SOD {
    
  public static final String OBJECT_NAME = SOD__c.SObjectType.getDescribe().getLocalName();
  
  public static Map<Id,SOD__c> getById(Set<Id> ids)
  {
    return new Map<Id,SOD__c >(getSODSbyIds(ids));
  }
  
  
  public static List<SOD__c> getSODSbyIds(Set<Id> ids){
  
   return [SELECT 
	                ADULT_FROM__c,
	                ADULT_TO__c,
	                CHILD_FROM__c,
	                CHILD_TO__c,
	                CRM_Lookup__c,
	                DOUBLE_AD_MAX__c,
	                DOUBLE_MAX__c,
	                DOUBLE_AVAIL__c,
	                Id,
                    INCLUDE_FRI__c,
                    INCLUDE_MON__c,
                    INCLUDE_SAT__c,
                    INCLUDE_SUN__c,
                    INCLUDE_THU__c,
                    INCLUDE_TUE__c,
                    INCLUDE_WED__c,
                    INFANT_FROM__c,
                    INFANT_TO__c,
                    Name,
                    OTHER_AD_MAX__c,
                    OTHER_AVAIL__c,
                    OTHER_MAX__c,
                    POLICY_TYPE__c,
                    QUAD_AD_MAX__c,
                    QUAD_AVAIL__c,
                    QUAD_MAX__c,
                    SINGLE_AD_MAX__c,
                    SINGLE_AVAIL__c,
                    SINGLE_MAX__c,
                    SOD_ID__c,
                    START_FRI__c,
                    START_MON__c,
                    START_SAT__c,
                    START_SUN__c,
                    START_THU__c,
                    START_TUE__c,
                    START_WED__c,
                    TRIPLE_AD_MAX__c,
                    TRIPLE_AVAIL__c,
                    TRIPLE_MAX__c,
                    TWIN_AVAIL__c,
                    TWIN_MAX__c,
                    TWIN_AD_MAX__c 
                FROM 
                    SOD__c
            WHERE 
                    Id IN :ids ORDER BY POLICY_TYPE__c];
  }
    
    
    public static Map<String,SOD__c> getSODSPolicyType(Set<Id> ids)
    {
    	Map<String, SOD__c> policyTypeBySods = new Map<String, SOD__c>();
    	for(SOD__c s:getSODSbyIds(ids))
    	{
    		policyTypeBySods.put(s.POLICY_TYPE__c, s);
    	}
    	
    	return policyTypeBySods;
    }
}
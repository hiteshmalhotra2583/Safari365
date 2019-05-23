public class DAL_OPT {
    
    public static final String OBJECT_NAME = Opt__c.SObjectType.getDescribe().getLocalName();
    
    public static List<Opt__c> getById(Set<Id> ids)
    {
        return [SELECT 
                    ANALYSIS1__c,
                    CHGEX1__c,CHGEX2__c,CHGEX3__c,CHGEX4__c,CHGEX5__c,
                    CLASS__c,Code__c,Comment__c,
                    CRM_Lookup__c,CRM_Name__c,
                    DB2_Description__c,DB2_Lookup__c,
                    DB4_DESCRIPTION__c,DB4_Lookup__c,
                    Description__c,
                    DURATION_HRS__c,
                    EX1__c,EX2__c,EX3__c,EX4__c,EX5__c,
                    FCU__c,FOCEX1__c,FOCEX2__c,FOCEX3__c,FOCEX4__c,FOCEX5__c,
                    Id,
                    INVOICE_TEXT1__c,INVOICE_TEXT2__c,
                    LCL_Lookup__c,LOCALITY__c,Location__c,
                    LOC_Name__c,
                    MPFCU__c,
                    Name,
                    PBX1__c,PBX2__c,PBX3__c,PBX4__c,PBX5__c,PBX6__c,PBX7__c,
                    PCODE__c,PERIODS_BASE__c,PERIODS__c,
                    SCU__c,Service__c,SOD_ID__c,SOD_Lookup__c,SRV_Lookup__c,
                    SRV_Markup_Value__c,SRV_Name__c,SupplierMarkup__c,
                    Supplier__c,CRM_Currency__c,
                    TAX__c,VADD1__c,VADD2__c,VADD3__c,VADD4__c,
                    VADD5__c,
                    VNAME__c
                FROM 
                    Opt__c
               WHERE
                     ID IN:ids];
    
    }
    
    public static OPT__c GetOptIdsForServiceLineItem(String serviceType,String serviceLocation,
                                                     String supplierName, String selectedServiceDetails,
                                                     String supplierComments)
    {
        List<OPT__c> op = [select id,Description__c,CRM_Name__c,SRV_Name__c,LOC_Name__c from opt__c];
        List<OPT__c> optIds = [SELECT
                                     Id,
                                     SOD_Lookup__c ,
                                     Service__c,
                                     AC__c,
                                     FCU__c,
                                     Comment__c,
                                     Description__c,
                                     MPFCU__c,
                                     SupplierMarkup__c,
                                     PBX1__c,PBX2__c,
                                     PBX3__c,PBX4__c,
                                     PBX5__c,PBX6__c,PBX7__c,
                                     EX1__c,EX2__c,
                                     EX3__c,EX4__c,EX5__c,
                                     CHGEX1__c,CHGEX2__c,
                                     CHGEX3__c,CHGEX4__c,CHGEX5__c,
                                     CRM_Lookup__r.Code__c,
                                     CRM_Code__c,
                                     Code__c 
                                     FROM 
                                          OPT__C 
                                     WHERE 
                                          CRM_Name__c=:supplierName
                                      AND 
                                          SRV_Name__c=:serviceType
                                       AND 
                                          LOC_Name__c=:serviceLocation
                                      AND
                                          Description__c=:selectedServiceDetails 
                                     AND 
                                         Comment__c =:supplierComments];
        if(optIds.size() >0)
        {
            return optIds[0];
        }
        return null;
    }
    
    public static OPT__c getOptFromOPTCode(String selectedCode)
    {
        List<OPT__c> optIds = [SELECT
                                     Id,
                                     SOD_Lookup__c ,
                                     Service__c,
                                     AC__c,
                                     FCU__c,
                                     Comment__c,
                                     Description__c,
                                     MPFCU__c,
                                     SupplierMarkup__c,
                                     PBX1__c,PBX2__c,PBX3__c,PBX4__c,PBX5__c,PBX6__c,PBX7__c,
                                     EX1__c,EX2__c,EX3__c,EX4__c,EX5__c,
                                     CHGEX1__c,CHGEX2__c,CHGEX3__c,CHGEX4__c,CHGEX5__c,
                                     CRM_Lookup__r.Code__c,
                                     CRM_Code__c
                                     FROM 
                                          OPT__C 
                                     WHERE 
                                         Code__c =: selectedCode ];
        if(optIds.size() >0)
        {
            return optIds[0];
        }
        return null;
    }
    
}
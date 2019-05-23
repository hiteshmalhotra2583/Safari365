public class DAL_OPD {
    
 public static final String OBJECT_NAME = OPD__c.SObjectType.getDescribe().getLocalName();
 
  public static Map<Id,OPD__c> getById(Set<Id> ids)
  {
    return new Map<Id,OPD__c >([SELECT 
                                    ADD_ADULT1__c,
                                    AGE_CATEGORY__c,
                                    EX1__c,EX2__c,EX3__c,EX4__c,EX5__c,
                                    Id,
                                    Name,
                                    OPD_ID__c,
                                    OSR_ID__c,
                                    OSR_Lookup__c,
                                    OwnerId,
                                    PAX_AGE_MAX__c,PAX_AGE_MIN__c,PRICE_PXB1__c,PRICE_PXB2__c,
                                    PRICE_PXB3__c,PRICE_PXB4__c,PRICE_PXB5__c,PRICE_PXB6__c,
                                    PRICE_PXB7__c,QR__c,RATE_CATEGORY__c,
                                    RATE_TYPE__c,SS__c,STD_EXT__c,
                                    TR__c,
                                    TW__c 
                                FROM 
                                    OPD__c
                            WHERE 
                                Id IN :ids]);
  }   
    
    public static List<OPD__c> GetOpdbyOsrId(OSR__c osr)
    {
        return [SELECT  Id,
                        RATE_TYPE__c,
                        RATE_CATEGORY__c,
                        SS__c,
                        QR__c,
                        TR__c,
                        TW__c,
                        AGE_CATEGORY__c,
                        EX1__c,EX2__c,EX3__c,EX4__c,EX5__c,
                        PAX_AGE_MAX__c,PAX_AGE_MIN__c,PRICE_PXB1__c,PRICE_PXB2__c,
                        PRICE_PXB3__c,PRICE_PXB4__c,PRICE_PXB5__c,PRICE_PXB6__c,
                        PRICE_PXB7__c
                FROM OPD__c 
                    WHERE OSR_Lookup__c=:osr.Id];
    }
}
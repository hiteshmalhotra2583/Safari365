public with sharing class DAL_ExposureRoe {
    
    public static Map<Id, Exposure_ROE__c> getByQuotationId(Set<Id> quotationIds)
    {
        Map<Id, Exposure_ROE__c> quotationIdKeyExposureROEValue = new Map<Id, Exposure_ROE__c>();
        List<Exposure_ROE__c> Exposure_ROEs = [SELECT 
                                                      Id,
                                                      Quotation__c
                                                  FROM 
                                                      Exposure_ROE__c
                                                  WHERE
                                                        Quotation__c IN:quotationIds ];
        for(Exposure_ROE__c eR: Exposure_ROEs)
        {
            quotationIdKeyExposureROEValue.put(er.Quotation__c,eR);
        }
        
        return  quotationIdKeyExposureROEValue;                                             
    }
    
}
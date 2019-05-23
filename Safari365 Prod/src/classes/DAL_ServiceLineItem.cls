public class DAL_ServiceLineItem
{
    
  public static Map<String, Map<String,String>> getCrmCategoryMapByCrmCodes(Set<String> crmCode)
  {
     Map<String,String> uniqueRecord = new  Map<String,String>();
     Map<String, Map<String,String>> uniqueRecords = null;
     List<CRM__c> crms = [SELECT 
                                Id,
                                CODE__c 
                          FROM 
                                CRM__c
                         WHERE 
                                CODE__c IN:crmCode];
     List<Id> crmsIds  = new List<Id>();
     for(CRM__c c:crms)
     {
         crmsIds.add(c.Id);
     }
     
     if(crms != null)
     {
         List<NTS__c> ntsList = [SELECT
                                       Id,
                                       CATEGORY__c,
                                       MESSAGE_TEXT__c,
                                       CRM_Lookup__c,
                                       CRM_Lookup__r.CODE__c
                                  FROM 
                                       NTS__c
                                WHERE
                                      CRM_Lookup__c IN:crmsIds 
                                 AND
                                     (CATEGORY__c = 'OPI' 
                                      OR 
                                      CATEGORY__c = 'OPX')];
         uniqueRecord = new Map<String,String>();
         uniqueRecords = new  Map<String, Map<String,String>>();
         for(NTS__c nts: ntsList)
         {
            if(!uniqueRecord.containsKey(nts.CATEGORY__c) 
                && !(uniqueRecord.get(nts.CATEGORY__c) == nts.CATEGORY__c))
             {
                uniqueRecord.put(nts.CATEGORY__c,nts.MESSAGE_TEXT__c);
                uniqueRecords.put(nts.CRM_Lookup__r.CODE__c,uniqueRecord);
             }
         }
      }
     return uniqueRecords;
  }
    
    
   
  public static String getAddressByCrmCode(String CrmCode){
      String address = '';
      List<CRM__c> crms = [SELECT 
                                    Id,
                                    ADDRESS1__c,
                                    ADDRESS2__c,
                                    ADDRESS3__c,
                                    ADDRESS4__c,
                                    ADDRESS5__c,
                                    CODE__c
                               FROM 
                                    CRM__c 
                               WHERE
                                    CODE__c=:CrmCode];
      
      if(null != crms && crms[0].ADDRESS1__c != null)
      address += crms[0].ADDRESS1__c+',';
      if(null != crms && crms[0].ADDRESS2__c != null)
      address += crms[0].ADDRESS2__c+',';
      if(null != crms && crms[0].ADDRESS3__c != null)
      address += crms[0].ADDRESS3__c+',';
      if(null != crms && crms[0].ADDRESS4__c != null)
      address += crms[0].ADDRESS4__c+',';
      if(null != crms && crms[0].ADDRESS5__c != null)
      address += crms[0].ADDRESS5__c+',';
      
      return address.removeEnd(',');
   }
   
   
   public static Map<String,String> getAddressByCrmCodeMap(Set<String> crmCodes){
      List<CRM__c> crms = [SELECT 
                                    Id,
                                    ADDRESS1__c,
                                    ADDRESS2__c,
                                    ADDRESS3__c,
                                    ADDRESS4__c,
                                    ADDRESS5__c,
                                    CODE__c
                               FROM 
                                    CRM__c 
                               WHERE
                                    CODE__c IN:crmCodes];
      
      Map<String,String> addressByCrmCodeMap = new Map<String,String>();
      for(CRM__c c: crms)
      {
          String address = '';
          if(null != crms && c.ADDRESS1__c != null)
          address += c.ADDRESS1__c+',';
          if(null != crms && c.ADDRESS2__c != null)
          address += c.ADDRESS2__c+',';
          if(null != crms && c.ADDRESS3__c != null)
          address += c.ADDRESS3__c+',';
          if(null != crms && c.ADDRESS4__c != null)
          address +=c.ADDRESS4__c+',';
          if(null != crms && c.ADDRESS5__c != null)
          address += c.ADDRESS5__c+',';
          address.removeEnd(',');
          addressByCrmCodeMap.put(c.CODE__c,address);
      }
      
      return addressByCrmCodeMap;
   }
    
  public static String getPhoneMobileNumberByCrmCode(String CrmCode){
      String phoneMobile = '';
      PBK__c pbkRecord = new PBK__c();
      List<CRM__c> crms = [SELECT Id FROM CRM__c where CODE__c = :CrmCode];
      if(null != crms)
      {
          String id = crms[0].Id;
          List<PBK__c> pbk = [SELECT Id,PHONE__c,MOBILE__c FROM PBK__c WHERE CRM_Lookup__c  = :id AND CONTACTTYPE__c = 'VC'];
          if(pbk.size()>0){
              pbkRecord = pbk[0];
          }
          
          if(pbkRecord != null)
          {
              if(pbkRecord.PHONE__c != null){
                  phoneMobile += 'Phone : '+pbkRecord.PHONE__c+',';
              }
              
              if(pbkRecord.MOBILE__c != null){
                  phoneMobile += ' Mobile : '+pbkRecord.MOBILE__c+',';
              }
          }
      }
      return phoneMobile.removeEnd(',');
   }
   
   
   
   public static Map<String,String> getPhoneMobileNumberByCrmCodes(Set<String> crmCodes){
      
      Map<String,String> codePhoneNumberMap = new Map<String,String>();
      Map<String,String> codeKeyPhoneNumberValueMap = new Map<String,String>();
      List<CRM__c> crms = [SELECT
                                 Id,
                                 CODE__c
                            FROM 
                                CRM__c 
                          WHERE 
                                CODE__c IN :crmCodes];
      if( !crms.isEmpty())
      {
          List<String> crmsIds = new List<String>();
          Map<String,String> idMapCodeMap = new Map<String,String>();
          for(CRM__c c: crms)
          {
              crmsIds.add(c.Id);
              idMapCodeMap.put(c.Id,c.CODE__c);
          }
          //String id = crms[0].Id;
          List<PBK__c> pbks = [SELECT 
                                     Id,
                                     PHONE__c,
                                     MOBILE__c,
                                     CRM_Lookup__c
                                FROM 
                                     PBK__c
                              WHERE 
                                    CRM_Lookup__c  IN :crmsIds 
                                AND 
                                   CONTACTTYPE__c = 'VC'];
          for(PBK__c pbkRecord: pbks)
          {
              String phoneMobile = '';
              if(pbkRecord.PHONE__c != null){
                  phoneMobile += 'Phone : '+pbkRecord.PHONE__c+',';
              }
              
              if(pbkRecord.MOBILE__c != null){
                  phoneMobile += ' Mobile : '+pbkRecord.MOBILE__c+',';
              }
              phoneMobile.removeEnd(',');
              codeKeyPhoneNumberValueMap.put(idMapCodeMap.get(pbkRecord.CRM_Lookup__c),phoneMobile);
          }
       }
       return codeKeyPhoneNumberValueMap;
   }
      
      
      
      public static Map<String,String> getGPSDetailByCrmCodes(Set<String> crmCodes)
      {
        Map<String,String> codePhoneNumberMap = new Map<String,String>();
        Map<String,String> codeKeyPhoneNumberValueMap = new Map<String,String>();
        List<CRM__c> crms = [SELECT
                                     Id,
                                     CODE__c
                                FROM 
                                    CRM__c 
                              WHERE 
                                    CODE__c IN :crmCodes];
       if( !crms.isEmpty())
       {
          List<String> crmsIds = new List<String>();
          Map<String,String> idMapCodeMap = new Map<String,String>();
          for(CRM__c c: crms)
          {
              crmsIds.add(c.Id);
              idMapCodeMap.put(c.Id,c.CODE__c);
          }
          //String id = crms[0].Id;
          List<NTS__c> pbks = [SELECT 
                                     Id,
                                     CATEGORY__c,
                                     MESSAGE_TEXT__c,
                                     CRM_Lookup__c
                                FROM 
                                     NTS__c 
                                WHERE 
                                     (CRM_Lookup__c  IN :crmsIds AND CATEGORY__c='GPS')];
          for(NTS__c ntsRecord: pbks)
          {
              String gpsDetail = '';
              if(ntsRecord.MESSAGE_TEXT__c != null)
              {
                  gpsDetail += 'GPS : '+ntsRecord.MESSAGE_TEXT__c;
                  codeKeyPhoneNumberValueMap.put(idMapCodeMap.get(ntsRecord.CRM_Lookup__c),gpsDetail);
              }
          }
       }
       return codeKeyPhoneNumberValueMap;
   }
      
      
   public static String getGPSDetailByCrmCode(String CrmCode){
      String GPSDetail = '';
      NTS__c ntsRecord = new NTS__c();
      CRM__c crm = [SELECT
                             Id FROM CRM__c where CODE__c = :CrmCode];
      String id = crm.Id;
      List<NTS__c> nts = [SELECT Id,CATEGORY__c,MESSAGE_TEXT__c FROM NTS__c WHERE (CRM_Lookup__c  = :id AND CATEGORY__c='GPS')];
      
      if(nts.size()>0){
          ntsRecord = nts[0];
      }
      
      if(ntsRecord != null){
          if(ntsRecord.MESSAGE_TEXT__c != null){
              GPSDetail += 'GPS : '+ntsRecord.MESSAGE_TEXT__c;
          }
      }
      
      return GPSDetail;
   }

}
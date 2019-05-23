public class DAL_OSR {
   
  public static final String OBJECT_NAME = OSR__c.SObjectType.getDescribe().getLocalName();
 
  public static List<OSR__c> getByIds(Set<Id> ids)
  {
    return [SELECT APPLY_FRI__c,APPLY_MON__c,APPLY_SAT__c,
                   APPLY_SUN__c,APPLY_THU__c,APPLY_TUE__c,APPLY_WED__c,
                   BUY_CURRENCY__c,CANCEL_HOURS__c,CHARGEEXTRA1__c,
                   CHARGEEXTRA2__c,CHARGEEXTRA3__c,CHARGEEXTRA4__c,
                   CHARGEEXTRA5__c,COMMISSIONABLE__c,COMM_ORIDE__c,
                   DATE_FROM__c,DATE_TO__c,EDITVTEXT1__c,
                   EDITVTEXT2__c,EDITVTEXT3__c,EDITVTEXT4__c,
                   EDITVTEXT5__c,EDITVTEXT6__c,EDITVTEXT7__c,
                   EDITVTEXT8__c,EDITVTEXT9__c,EDITVTEXT10__c,
                   EXCHANGE_DIV_RATE__c,EXCHANGE_MUT_RATE__c,
                   FIXED_COUNT__c,FREE1__c,FREE2__c,
                   FREE3__c,FREE4__c,FREE5__c,FREE6__c,
                   FREE7__c,FREE8__c,FREE9__c,FREE10__c,
                   GROSS_NETT__c,
                   Id,
                   MAX_SCU__c,MIN_SCU__c,
                   Name,
                   OPC_Description__c,OPC_Lookup__c,
                   OPT_ID__c,OPT_Lookup__c,OSR_ID__c,
                   PREFER__c,PRICE_CODE__c,
                   PROV__c,RATE_TEXT__c,REPEAT_IND__c,REPEAT_TIMES__c,
                   SALE_FROM__c,SALE_TO__c,SELLBEFORETRAVEL__c,SELLBEFORETYPE__c,
                   SELL_CODE__c,SELL_CURRENCY__c,SPLITRATE__c,
                   STAY1__c,STAY2__c,STAY3__c,STAY4__c,
                   STAY5__c,STAY6__c,STAY7__c,STAY8__c,STAY9__c,
                   STAY10__c,STAYPAY_FROM__c,STAYPAY_TO__c,STAY_TYPE__c,
                   VALIDATE_MIN_MAX__c,VTEXT1__c,VTEXT2__c,VTEXT3__c,
                   VTEXT4__c,VTEXT5__c,VTEXT6__c,VTEXT7__c,
                   VTEXT8__c,VTEXT9__c,VTEXT10__c
             FROM 
                   OSR__c
             WHERE 
                  Id IN :ids];
  }
 
  
  public static Map<Id,OSR__c> getById(Set<Id> ids)
  {
    return new Map<Id,OSR__c >(getByIds(ids));
  } 
  
  public static Map<String,Object> getStayFreeValueMap(Set<Id> ids)
  {
    
    Map<String,String> keyValueMap  = new Map<String, String>();
    List<Field_Mapping_For_Rate_Calculation__mdt> fieldMappings = [
                          SELECT 
                                Source_Object__c, 
                                Target_Object__c, 
                                Source_Field__c,
                                Target_Field__c
                         FROM 
                                Field_Mapping_For_Rate_Calculation__mdt];
     for(Field_Mapping_For_Rate_Calculation__mdt mapping: fieldMappings)
     {
        keyValueMap.put(mapping.Source_Field__c, mapping.Target_Field__c);
     }  
     
     Map<String, Object> fieldsAndValues     = null;
     List<OSR__c> osrs  = DAL_OSR.getByIds(ids); 
     for(OSR__c osr: osrs) 
     { 
      fieldsAndValues = osr.getPopulatedFieldsAsMap(); 
     }
     Map<String , Object> keyValueReturnMap  = new Map<String, Object>();
     for(Field_Mapping_For_Rate_Calculation__mdt mapping: fieldMappings)
     {
        keyValueReturnMap.put(mapping.Source_Field__c, fieldsAndValues.get(keyValueMap.get(mapping.Source_Field__c)));
     }      
     
     return keyValueReturnMap;
  }
  
  
  public static List<OSR__c> getOsrbyOPTId(Set<Id> optIds)
  {
    return [SELECT APPLY_FRI__c,APPLY_MON__c,APPLY_SAT__c,
                   APPLY_SUN__c,APPLY_THU__c,APPLY_TUE__c,APPLY_WED__c,
                   BUY_CURRENCY__c,CANCEL_HOURS__c,CHARGEEXTRA1__c,
                   CHARGEEXTRA2__c,CHARGEEXTRA3__c,CHARGEEXTRA4__c,
                   CHARGEEXTRA5__c,COMMISSIONABLE__c,COMM_ORIDE__c,
                   DATE_FROM__c,DATE_TO__c,EDITVTEXT1__c,
                   EDITVTEXT2__c,EDITVTEXT3__c,EDITVTEXT4__c,
                   EDITVTEXT5__c,EDITVTEXT6__c,EDITVTEXT7__c,
                   EDITVTEXT8__c,EDITVTEXT9__c,EDITVTEXT10__c,
                   EXCHANGE_DIV_RATE__c,EXCHANGE_MUT_RATE__c,
                   FIXED_COUNT__c,FREE1__c,FREE2__c,
                   FREE3__c,FREE4__c,FREE5__c,FREE6__c,
                   FREE7__c,FREE8__c,FREE9__c,FREE10__c,
                   GROSS_NETT__c,
                   Id,
                   MAX_SCU__c,MIN_SCU__c,
                   Name,
                   OPC_Description__c,OPC_Lookup__c,
                   OPT_ID__c,OPT_Lookup__c,OSR_ID__c,
                   PREFER__c,PRICE_CODE__c,
                   PROV__c,RATE_TEXT__c,REPEAT_IND__c,REPEAT_TIMES__c,
                   SALE_FROM__c,SALE_TO__c,SELLBEFORETRAVEL__c,SELLBEFORETYPE__c,
                   SELL_CODE__c,SELL_CURRENCY__c,SPLITRATE__c,
                   STAY1__c,STAY2__c,STAY3__c,STAY4__c,
                   STAY5__c,STAY6__c,STAY7__c,STAY8__c,STAY9__c,
                   STAY10__c,STAYPAY_FROM__c,STAYPAY_TO__c,STAY_TYPE__c,
                   VALIDATE_MIN_MAX__c,VTEXT1__c,VTEXT2__c,VTEXT3__c,
                   VTEXT4__c,VTEXT5__c,VTEXT6__c,VTEXT7__c,
                   VTEXT8__c,VTEXT9__c,VTEXT10__c
             FROM 
                   OSR__c
             WHERE 
                  OPT_Lookup__c IN :optIds];
  }
}
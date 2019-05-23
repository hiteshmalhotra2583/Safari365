public class Lookup {

    /**
     * Returns JSON of list of ResultWrapper to Lex Components
     * @objectName - Name of SObject
     * @fld_API_Text - API name of field to display to user while searching
     * @fld_API_Val - API name of field to be returned by Lookup COmponent
     * @lim   - Total number of record to be returned
     * @fld_API_Search - API name of field to be searched
     * @searchText - text to be searched
     * */
    @AuraEnabled 
    public static String searchDB(String objectName, String fld_API_Text, String fld_API_Val, 
                                  Integer lim,String fld_API_Search,String searchText,Boolean field_preferredSupplier){
        try
        {
        	searchText='\'%' + String.escapeSingleQuotes(searchText.trim()) + '%\'';
			String query ='';
			String  crmIds='';
            if(field_preferredSupplier)
            {    
                AggregateResult[] crmLIds= [select CRM_Lookup__c from OPT__c WHERE ANALYSIS1__c='PF' GROUP BY CRM_Lookup__c];
                
                for(AggregateResult ar:crmLIds)
                {
                    crmIds += (crmIds==''?'':',') + '\''+ String.valueOf(ar.get('CRM_Lookup__c')) + '\'';
                }
              if(String.isEmpty(crmIds))
              {
             		 return JSON.serialize(new List<ResultWrapper>()) ;
              }
                if(String.isNotEmpty(searchText))
                {
                    query = 'SELECT '+fld_API_Text+' ,'+fld_API_Val+
                ' FROM '+objectName+ 
                ' WHERE Id IN( '+crmIds+') AND ' + fld_API_Search+' LIKE '+searchText+
                ' LIMIT '+lim;
                }
                else
                {
                    query = 'SELECT '+fld_API_Text+' ,'+fld_API_Val+
                ' FROM '+objectName+ 
                ' WHERE Id IN( '+crmIds+')';
                }
              
            }
            else
            {
                if(String.isNotEmpty(searchText))
                {
                    query = 'SELECT '+fld_API_Text+' ,'+fld_API_Val+
                    ' FROM '+objectName+
                    ' WHERE '+fld_API_Search+' LIKE '+searchText+
                    ' LIMIT '+lim;
                }
                else
                {
                    query = 'SELECT '+fld_API_Text+' ,'+fld_API_Val+
                    ' FROM '+objectName;
                }
            }
            
        
            
        List<sObject> sobjList = Database.query(query);
        List<ResultWrapper> lstRet = new List<ResultWrapper>();
        
        for(SObject s : sobjList){
            ResultWrapper obj = new ResultWrapper();
            obj.objName = objectName;
            obj.text = String.valueOf(s.get(fld_API_Text)) ;
            obj.val = String.valueOf(s.get(fld_API_Val))  ;
            lstRet.add(obj);
        } 
         return JSON.serialize(lstRet) ;
        }
		catch(Exception e)
        {
            throw e;
        }
    }
    
    @AuraEnabled 
    public static String searchSupplier(String objectName, String fld_API_Text, String fld_API_Val, 
                                  Integer lim,String fld_API_Search,String searchText,String field_selectedServiceType, 
                                  String field_selectedServiceLocation, Boolean field_preferredSupplier){ 
        
        if(String.isBlank(field_selectedServiceType) || String.isBlank(field_selectedServiceLocation))
        {
            return searchDB(objectName, fld_API_Text, fld_API_Val, lim,fld_API_Search, searchText,field_preferredSupplier);
        }
        else
        {
            return searchDbWithParam(objectName,  fld_API_Text,  fld_API_Val,  lim,  fld_API_Search,  searchText,  field_selectedServiceType,  field_selectedServiceLocation,  field_preferredSupplier);
        }
    }
    
    
    @AuraEnabled 
    public static String searchDbWithParam(String objectName, String fld_API_Text, String fld_API_Val, 
                                  Integer lim,String fld_API_Search,String searchText,String field_selectedServiceType, 
                                           String field_selectedServiceLocation, Boolean field_preferredSupplier){//, String dbQuery  ){
        try
        {
        searchText='\'%' + String.escapeSingleQuotes(searchText.trim()) + '%\'';

            String crmIds='';
            
            AggregateResult[]  crmLIds;
            if(field_preferredSupplier)
            {    
                crmLIds= [select CRM_Lookup__c from OPT__c WHERE ANALYSIS1__c='PF' AND LOC_Name__c=:field_selectedServiceLocation  AND SRV_Name__c=:field_selectedServiceType GROUP BY CRM_Lookup__c];
            }
            else
            {
                crmLIds= [select CRM_Lookup__c from OPT__c WHERE LOC_Name__c=:field_selectedServiceLocation  AND SRV_Name__c=:field_selectedServiceType GROUP BY CRM_Lookup__c];
            }
            for(AggregateResult ar:crmLIds)
            {
                crmIds += (crmIds==''?'':',') + '\''+ String.valueOf(ar.get('CRM_Lookup__c')) + '\'';
            }
            if(String.isEmpty(crmIds))
            {
                return JSON.serialize(new List<ResultWrapper>()) ;
            }
            String query = '';
             if(String.isNotEmpty(searchText))
             {
                query = 'SELECT '+fld_API_Text+' ,'+fld_API_Val+
                            ' FROM '+objectName+ 
                            ' WHERE Id IN( '+crmIds+') AND ' + fld_API_Search+' LIKE '+searchText+
                            ' LIMIT '+lim;
             }
            else
            {
                query = 'SELECT '+fld_API_Text+' ,'+fld_API_Val+
                            ' FROM '+objectName+ 
                            ' WHERE Id IN( '+crmIds+')';
            }
        List<sObject> sobjList = Database.query(query);
        List<ResultWrapper> lstRet = new List<ResultWrapper>();
        
        for(SObject s : sobjList){
            ResultWrapper obj = new ResultWrapper();
            obj.objName = objectName;
            obj.text = String.valueOf(s.get(fld_API_Text)) ;
            obj.val = String.valueOf(s.get(fld_API_Val))  ;
            lstRet.add(obj);
        } 
         return JSON.serialize(lstRet) ;
        }
       catch(Exception e)
       {
           throw e;
       }
    }
    
    
    public class ResultWrapper{
        public String objName {get;set;}
        public String text{get;set;}
        public String val{get;set;}
    }
}
public class LookupWetuEndLocation {

    @AuraEnabled 
    public static String searchWetuLocation(String objectName, String fld_API_Text, String fld_API_Val, 
                                  Integer lim,String fld_API_Search,String searchText){
        try
        {
        	searchText='\'%' + String.escapeSingleQuotes(searchText.trim()) + '%\'';
			String query = 'SELECT '+fld_API_Text+' ,'+fld_API_Val+
                ' FROM '+objectName+
                ' WHERE '+fld_API_Search+' LIKE '+searchText+
                ' LIMIT '+lim;
      
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
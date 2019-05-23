public class TriggerUtil {

    public void ProcessTriggerHandler(List<sObject>  sObjs,String label)
    {
        List<TriggerObjectMapping__mdt> triggersToProcess = [select SourceFieldType__c,SourceObject__c, TargetObject__c, SourceField__c,SourceLookupField__c, TargetField__c,Value__c from TriggerObjectMapping__mdt where MasterLabel=:label];
        for(TriggerObjectMapping__mdt triggers :triggersToProcess)
        {
			if(triggers.SourceFieldType__c == 'String'){
        		ProcessStringIds(triggers,sObjs);
            }
            if(triggers.SourceFieldType__c == 'Decimal'){
        		ProcessDecimalIds(triggers,sObjs);
            }            
        }
    }
    
    private void ProcessDecimalIds(TriggerObjectMapping__mdt triggers,List<sObject>  sObjs)
    {
       Set<Decimal> referenceIds = new Set<Decimal>();
			
       for(sObject sObj:sObjs )
       {
       		referenceIds.add((Decimal)sObj.get(triggers.SourceField__c) );
       }
            String query = 'Select Id, '+ triggers.TargetField__c+' from '+triggers.TargetObject__c+' where  '+triggers.TargetField__c+' IN:referenceIds';
  			
            List<sObject> references =Database.query(query);
  			
        	Map<String , sObject> idMap = new Map<String , sObject>();
            for(sObject ref: references)
            {
                
                String targetFieldValue =  String.valueOf((Decimal)ref.get(triggers.TargetField__c)) +'.0';
                
                idMap.put(targetFieldValue,ref);
            }
            for(sObject obj:sObjs)
            {
                
                String codeValue = String.valueOf((Decimal)obj.get(triggers.SourceField__c)) ;
                system.debug('codeValue:::'+codeValue);
                    if(idMap.get(codeValue) <> null)
                    {
                        String idValue = idMap.get(codeValue).Id;
                        system.debug('idValue:::'+idValue);
                        obj.put(triggers.SourceLookupField__c,idValue) ;
                        system.debug('obj:::'+obj);
                    }
            }
    }
    
    private void ProcessStringIds(TriggerObjectMapping__mdt triggers,List<sObject>  sObjs)
    {
        Set<String> referenceIds = new Set<String>();
			for(sObject sObj:sObjs )
        	{
        		referenceIds.add((String)sObj.get(triggers.SourceField__c) );
        	}
            
            String query = 'Select Id, '+ triggers.TargetField__c+' from '+triggers.TargetObject__c+' where  '+triggers.TargetField__c+' IN:referenceIds';
  			
            List<sObject> references =Database.query(query);
  			
            Map<String , sObject> idMap = new Map<String , sObject>();
  			
            for(sObject ref: references)
            {
                String targetFieldValue = (String)ref.get(triggers.TargetField__c) ;
                idMap.put(targetFieldValue,ref);
            }
            for(sObject obj:sObjs)
            {
                String codeValue = (String)obj.get(triggers.SourceField__c) ;
                if(idMap.get(codeValue) <> null)
                {
                    String idValue = idMap.get(codeValue).Id;
                	obj.put(triggers.SourceLookupField__c,idValue) ;
                }
            }
    }
    
}
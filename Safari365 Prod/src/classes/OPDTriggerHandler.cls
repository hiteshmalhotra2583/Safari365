public class OPDTriggerHandler  extends BaseTriggerHandler {

    private List<OPD__c> newOpdList;
    private List<OPD__c> oldOpdList;
    private Map<ID, OPD__c> newOpdMap;
    private Map<ID, OPD__c> oldOpdMap;
    private TriggerUtil triggerUtil = new TriggerUtil();

    public OPDTriggerHandler() {
        oldOpdList = (List<OPD__c>)Trigger.old;
        newOpdList = (List<OPD__c>)Trigger.new;
        newOpdMap =  (Map<ID, OPD__c>)Trigger.newMap;
        oldOpdMap = (Map<ID, OPD__c>)Trigger.oldMap;
    }


    public override void beforeInsert() { 
        if(Trigger_PAD.canRun('OPDTriggerHandler')){
            triggerUtil.ProcessTriggerHandler(newOpdList,'OPDOSRTriggerHandler');
           //processRecords(newOpdList);
        }
	} 

/*protected override void beforeUpdate() {
        if(Trigger_PAD.canRun('OPDTriggerHandler')){
            triggerUtil.ProcessTriggerHandler(newOptList,'OPDOSRTriggerHandler');
        }
    }*/
    
   /* public void processRecords(List<OPD__c> opdList)
    {
        //System.debug('opdList to update the OSR lookup:::::'+opdList);
        //System.debug('opdList to update the OSR lookup count:::::'+opdList.size());
		
        
        Set<String> osrIds = new Set<String>();
		for(OPD__c op:opdList)
		{
            
            if(!osrIds.contains(op.OSR_ID__c))
            {
                osrIds.add(op.OSR_ID__c);
            }
            //else
            //{
            //    System.debug('OPD with duplicate OSR id:::::'+op.OSR_ID__c);
            //}
		}
		System.debug('All Osr Ids:::::'+osrIds);
        //System.debug('All Osr Ids count:::::'+osrIds.size());
        
		Map<String, OSR__c > mapKey = new Map<String, OSR__c>();
		List<OSR__c> osrs = [select Id,OSR_ID__c from OSR__c where OSR_ID__c IN:osrIds];
        
        //System.debug('All Osrs in DB:::::'+osrs);
        System.debug('All Osrs in DB count:::::'+osrs.size());
		for(OSR__c os:osrs)
		{
		  //mapKey.put(String.valueOf(os.OSR_ID__c), os);
            mapKey.put(os.OSR_ID__c, os);
		}
        
        //System.debug('mapKey:::::'+mapKey);
        System.debug('mapKey size:::::'+mapKey.size());
        
		for(OPD__c oop: opdList)
		{
            //String osrId = String.valueOf(oop.OSR_ID__c.stripTrailingZeros());
            //String osrWithoutDecimal = osrId.replace('.0','');
            
            String osrIdInOpd = oop.OSR_ID__c;
            
            System.debug('osrIdInOpd::::'+osrIdInOpd );
            
			if(null != mapKey.get(osrIdInOpd))
            {
                oop.OSR_Lookup__c =mapKey.get(osrIdInOpd).Id; 
            }
            else
            {
                System.debug('OPD records with Id:'+oop.Id +' was not assigned the OSR lookup');
                System.debug('oop.OSR_ID__cValue:'+osrIdInOpd );
                System.debug('mapKey.get(oop.OSR_ID__c) Value:'+mapKey.get(osrIdInOpd) );
                
            }
		}
        //System.debug('Updated Opds:::::::'+opdList); 
    }*/
}
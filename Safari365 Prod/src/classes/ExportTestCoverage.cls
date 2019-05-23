public class ExportTestCoverage{
    public CoverageWrap cw {get;set;}
    public ExportTestCoverage(){
        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.setHeader('Content-Type', 'application/json');
        req.setEndpoint(URL.getSalesforceBaseURL().toExternalForm()+'/services/data/v40.0/tooling/query/?q=Select+id,ApexClassorTriggerId,ApexClassorTrigger.Name,NumLinesCovered,NumLinesUncovered+from+ApexCodeCoverageAggregate');
        req.setMethod('GET');
        Http h = new Http();
        HttpResponse res = h.send(req);
        if(res.getStatusCode() == 200){
            cw  = (CoverageWrap)JSON.deserialize(res.getBody(),CoverageWrap.class); 
            system.debug('Parsed response: ' +cw);
            Set<Id> classIdSet = new Set<Id>();
            Set<Id> triggerIdSet = new Set<Id>();

            for (Records classOrTriggerInfo:cw.records){

                System.debug('classOrTriggerInfo.ApexClassorTriggerId >> ' + classOrTriggerInfo.ApexClassorTriggerId); 
                classOrTriggerInfo.sobjectType = (null != classOrTriggerInfo.ApexClassorTriggerId) ? classOrTriggerInfo.ApexClassorTriggerId.getSobjectType() : null;

                if ( classOrTriggerInfo.sobjectType == ApexClass.SObjectType){
                    classIdSet.add(classOrTriggerInfo.ApexClassorTriggerId);
                }else if(classOrTriggerInfo.sobjectType == ApexTrigger.SObjectType){
                    triggerIdSet.add(classOrTriggerInfo.ApexClassorTriggerId);
                }else{
                    throw new UnknownComponentException('Wow... API version must have changed - I only support class & triggers. classOrTriggerInfo.sobjectType >> ' + classOrTriggerInfo.sobjectType);
                }
            }

            Map<Id,ApexClass>   classMap    =  new Map<Id,ApexClass>    ([SELECT Id,CreatedBy.email,CreatedBy.name,LastModifiedBy.name,LastModifiedBy.email,LastModifiedDate FROM ApexClass WHERE Id in: classIdSet]);
            Map<Id,ApexTrigger> triggerMap  =  new Map<Id,ApexTrigger>  ([SELECT Id,CreatedBy.email,CreatedBy.name,LastModifiedBy.name,LastModifiedBy.email,LastModifiedDate FROM ApexTrigger WHERE Id in: triggerIdSet]);
            
            Sobject tempRecord;
            for (Records classOrTriggerInfo:cw.records){
                // Assigns the temp var a vaule from one of the maps (first one that finds it)
                tempRecord = classMap.get(classOrTriggerInfo.ApexClassorTriggerId);
                tempRecord = tempRecord == null? triggerMap.get(classOrTriggerInfo.ApexClassorTriggerId): tempRecord;
                if (tempRecord == null){
                    throw new UnknownComponentException('Wow... Couldnt fetch class / trigger from DB - permissions?');
                }

                classOrTriggerInfo.createdBy = new UserWrapper(tempRecord.getSobject('CreatedBy'));
                classOrTriggerInfo.lastModifiedBy  = new UserWrapper(tempRecord.getSobject('LastModifiedBy'));
                classOrTriggerInfo.lastModifiedDate = String.valueOf(tempRecord.get('LastModifiedDate'));
            }
        }
    }

    public class UnknownComponentException extends Exception{}

    public class UserWrapper{
        public String name {get;set;}
        public String email {get;set;}
        public String devTeamCreatedBy {get;set;}
        public UserWrapper(Sobject o){
            this.name = String.valueOf(o.get('Name'));
            this.email = String.valueOf(o.get('email'));
            this.devTeamCreatedBy = String.valueOf(o.get('email')).split('@').get(1);
        }
    }

    public class Attributes {
        public String type;
        public String url;
    }

    public class Records {
        public Attributes attributes;
        public String Id;
        public Id ApexClassorTriggerId;
        public UserWrapper createdBy        {get;set;}
        public UserWrapper lastModifiedBy   {get;set;}
        public String lastModifiedDate       {get;set;}
        public ApexClassOrTrigger ApexClassOrTrigger {get;set;}
        public Integer NumLinesCovered {get;set;}
        public Integer NumLinesUncovered {get;set;}
        public Schema.SObjectType sobjectType {get;set;}
    }

    public class ApexClassOrTrigger {
        public Attributes attributes;
        public String Name{get;set;}
    }
    
    public class CoverageWrap{
        public Integer size;
        public Integer totalSize;
        public Boolean done;
        public Object queryLocator;
        public String entityTypeName;
        public List<Records> records{get;set;}
    }
}
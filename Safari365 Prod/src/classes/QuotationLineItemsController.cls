public class QuotationLineItemsController
{
    static QuotationBuilderDatabaseQueries DBQueries = new QuotationBuilderDatabaseQueries();
    
    @AuraEnabled 
    public static String GetQuotationLineItemDate(String quotationLineItemId)
    {
     	List<QuotationLineItem__c> qli = [SELECT 
     	                                       Line_Item_Date__c 
     	                                  FROM
     	                                       QuotationLineItem__c
     	                                 WHERE
     	                                       Id=:quotationLineItemId];
        Date liDate=qli[0].Line_Item_Date__c;
		
		String formattedDate1 =UTIL_Date.formatGivenDateToString(liDate);
		system.debug('formattedDate1:::'+formattedDate1);
        return formattedDate1;
    }   
    
    @AuraEnabled
    public static string getQuotationStage(String quotationId)
    {
        return DBQueries.getQuotationStage(quotationId);
    }
    
    @AuraEnabled 
    public static boolean getPageDefaultOpenSetting() {
        return DBQueries.getPageDefaultOpenSetting();
    }
    
    @AuraEnabled 
    public static List<String> getServiceStatus()  {
        return DBQueries.GetServiceStatus();
    }
	
	@AuraEnabled 
	public static List<String> updateChargeTypes(String chargeTypesToUpdate)
	  {
        Object[] values = (Object [])System.JSON.deserializeUntyped(chargeTypesToUpdate);
       
        Set<ChargeTypeUpdate> newSObjectsList = new Set<ChargeTypeUpdate>();
        for (Object v : values) {
            Map<String, Object> newValueMap= (Map<String, Object>)v;
             
            ChargeTypeUpdate  newValue  = new ChargeTypeUpdate();
            if(newValueMap.get('Status') != null)
            {
                newValue.Status = (String)newValueMap.get('Status');
            }
            if(newValueMap.get('ClientNotes') != null)
            {
                newValue.ClientNotes = (String)newValueMap.get('ClientNotes');
            }
            if(newValueMap.get('ServiceLineItemId') != null)
            {
            	newValue.ServiceLineItemId = (String)newValueMap.get('ServiceLineItemId');    
            }
            if(newValueMap.get('ChargeTypeId') != null)
            {
            	newValue.ChargeTypeId = (String)newValueMap.get('ChargeTypeId');    
            }
            if(newValueMap.get('NettCost') != null)
            {
                try
                {
                    newValue.NettCost = String.valueOf(newValueMap.get('NettCost'));     
                }
                catch(Exception e)
                {
                    newValue.NettCost = (String)newValueMap.get('NettCost');
                }
                
            }
            if(newValueMap.get('Markup') != null)
            {
                try
                {
                  newValue.Markup =  String.valueOf(newValueMap.get('Markup'));      
                }
                catch(Exception e)
                {
                    newValue.Markup =  (String)newValueMap.get('Markup');      
                }
            	
            }
            newSObjectsList.add(newValue);
            
        }
        return DBQueries.updateChargeTypes(newSObjectsList);
    }    
	
    @AuraEnabled 
    public static List<String> deleteSelectedItems(String[] itemsToDelete) {
        return DBQueries.deleteSelectedItems(itemsToDelete);
    }
    
    @AuraEnabled 
    public static List<QuotationLineItem__c> getQuotationLineItems(String quotationId) {
        return DBQueries.GetQuotationLineItems(quotationId);
    }
    
    @AuraEnabled 
    public static String getCrmIdByCode(String crmCode) {
        return DBQueries.getCrmIdByCode(crmCode);
    }
    
    @AuraEnabled public static List<String> deleteServiceLineItem(String servieLineItemId)
     {
        return DBQueries.DeleteServiceLineItem(servieLineItemId);
    }
    
    @AuraEnabled 
    public static void orderServiceLineItem(String[] data) 
    {
       List<ServiceLineItem__c> lstSLI=new List<ServiceLineItem__c>();
        Integer i=0;
        for(String d:data){
            ServiceLineItem__c SL=new ServiceLineItem__c();
            SL.ID=d;
            SL.Day_Order__c=i+1;
            lstSLI.add(SL);
            i++;
        }
        update lstSLI;
    }
    
    @AuraEnabled
    public static List<String> deleteServiceLineChargeType(String chargeTypeId) 
    {
        return DBQueries.DeleteServiceLineChargeType(chargeTypeId);
    }
    
    @AuraEnabled 
    public static String getQuotationLineItemList(String quotationId) {

        Map<Id, wrapper> itemWrapper = new Map<Id, wrapper>();
        system.debug('quotationId:::'+quotationId);
        List<QuotationLineItem__c> items = DBQueries.GetQuotationLineItemList(quotationId);
        system.debug('items:::'+items);
        String QuotationStage = DBQueries.getQuotationStage(quotationId);
        for(QuotationLineItem__c item:items)
        {
            itemWrapper.put(item.Id,new  wrapper(item.Name,item.id ,  'QuotationLineItem__c', true, item, null,null,null,QuotationStage));
        }
        
        return  JSON.serialize(itemWrapper);
    }
    
    @AuraEnabled public static String getRelatedRecords(String quotationLineItemId){
        List<String> serviceStatus = DBQueries.GetServiceStatus();
        String QuotationStage = DBQueries.getQuotationStageByLineItemId(quotationLineItemId);
        Map<Id, wrapper> itemsWrapper = new Map<Id, wrapper>();
        List<ServiceLineItem__c> items= DBQueries.GetServiceLineItemRelatedToQuotations(quotationLineItemId);
        Map<Id,Id> serviceLineItemToCrmMappings = DBQueries.GetCrmCodeToServiceLineItemMapping(quotationLineItemId);
        
        for(ServiceLineItem__c item: items) {
            
            if(item.MarkupUSD__c> 0)
            {
                item.Markup__c = item.MarkupUSD__c;
            }
            if(item.Markup_Eur__c >0 )
            {
                item.Markup__c = item.Markup_Eur__c;
            }
            if(item.MarkUp_Zar__c >0 )
            {
                item.Markup__c = item.MarkUp_Zar__c;
            }
            if(item.Sale_in_USD__c> 0)
            {
                item.Total__c = item.Sale_in_USD__c;
            }
            if(item.Sale_in_Eur__c >0 )
            {
                item.Total__c = item.Sale_in_Eur__c;
            }
            if(item.Nett_Cost_in_EUR__c> 0)
            {
                item.Nett_Cost__c = item.Nett_Cost_in_EUR__c;
            }
            if(item.Nett_Cost_in_USD__c >0 )
            {
                item.Nett_Cost__c = item.Nett_Cost_in_USD__c;
            }
            
            itemsWrapper.put(item.id , new wrapper(item.Name, item.id, 'ServiceLineItem__c', true, null,    item,null,serviceStatus,QuotationStage));
            
        }
        return JSON.serialize(itemsWrapper.values());
    }
    
    @AuraEnabled public static String getGrandChildRecords(String serviceLineItemId){
        
        Map<Id, grandChildWrapper> itemsWrapper = new Map<Id, grandChildWrapper>();
        List<Service_Line_Item_ChargeType__c> items= DBQueries.GetChargeTypeRelatedToServiceLineItem(serviceLineItemId);
        
        for(Service_Line_Item_ChargeType__c item: items) {
            itemsWrapper.put(item.id , new grandChildWrapper(item.Name, item.id, 'Service_Line_Item_ChargeType__c', false,     item));
        }
        return JSON.serialize(itemsWrapper.values());
    }
    
    private static columnWrapper setTreeTableCol(String fieldsetName, Schema.DescribeSObjectResult objTypeDsc){
        fieldsWrapper fw = getFieldApiNameMap(fieldsetName, objTypeDsc);
        
        Map<String, String> fieldAPINamesMap = fw.fieldName;
        
        List<string> fieldApiNames = new List<String>(fieldAPINamesMap.keySet());

        return  new columnWrapper(fieldAPINamesMap, fieldApiNames, fw.fieldFilter);
    }
    @AuraEnabled public static String getTreeTableCol()
    {
        columnWrapper cw = setTreeTableCol('SLI_FieldSet', ServiceLineItem__c.sObjectType.getDescribe());
        columnWrapper cw1 = setTreeTableCol('CT_FieldSet', Service_Line_Item_ChargeType__c.sObjectType.getDescribe());
        cw.columnMap.putAll(cw1.columnMap);
        cw.columnFilter.putAll(cw1.columnFilter);
        for(String item:cw1.columnList)
        {
            if(item == 'Service_Line_Item__r.MarkUp_Zar__c'
               ||item == 'Service_Line_Item__r.Markup_Eur__c' 
               || item == 'Service_Line_Item__r.MarkupUSD__c'
               || item == 'Service_Line_Item__r.Nett_Cost_in_EUR__c'
               || item == 'Service_Line_Item__r.Nett_Cost_in_USD__c'
               || item == 'Service_Line_Item__r.Nett_Cost__c'
               || item == 'Service_Line_Item__r.Sale_in_Eur__c'
               || item == 'Service_Line_Item__r.Sale_in_USD__c'
               || item == 'Service_Line_Item__r.Total__c')
            {
            	//cw.columnList.add('Markup__c');    
            }
           else
            {
            	cw.columnList.add(item);    
            }
            
        }

        return JSON.serialize(cw);
    }
    
    public static fieldsWrapper getFieldApiNameMap(String fieldSetName, Schema.DescribeSObjectResult objTypeDsc){
         
        Map<String, Schema.FieldSet> FsMap = objTypeDsc.fieldSets.getMap();
        
        fieldsWrapper fw = new fieldsWrapper();
         
        for(Schema.FieldSetMember field: FsMap.get(fieldSetName).getFields()){
            fw.fieldName.put(field.getFieldPath(), field.getLabel());
        }
        
        return fw;
    }
    
    public class fieldsWrapper{
        public Map<String, String> fieldName;
        public Map<String, List<String>> fieldFilter;
        public fieldsWrapper(){
            fieldName = new Map<String, String>();
            fieldFilter = new Map<String, List<String>>();
        }
    }
    public class wrapper{
        @AuraEnabled public List<String> ServiceStatus{get; set;}
        @AuraEnabled public String Name{get; set;}
        @AuraEnabled public String QuotationStage{get; set;}
        @AuraEnabled public Id  Id{get;set;}
        @AuraEnabled public String Type{get; set;}
        @AuraEnabled public ServiceLineItem__c ServiceLineItem {get; set;}
        @AuraEnabled public Boolean HasChildren{get; set;}
        @AuraEnabled public QuotationLineItem__c item{get; set;}
        @AuraEnabled public Service_Line_Item_ChargeType__c ChargeType{get; set;}
        

        public wrapper(String Name,Id id,String Type,  
                       Boolean hasChildren,QuotationLineItem__c QuotationLineItem, 
                       ServiceLineItem__c ServiceLineItem, 
                       Service_Line_Item_ChargeType__c chargeType,
                       List<String> serviceStatus, String quotationStage){
            
            this.Name = Name;
            this.Id = Id;
            this.Type = Type;
            this.HasChildren = hasChildren;
            this.ServiceStatus = serviceStatus;
            this.QuotationStage = quotationStage;
                           
            if(ServiceLineItem != null)
            {
                this.item =  ServiceLineItem.QuotationLine__r;
            }
            if(QuotationLineItem!=null)
            {
                this.item =  QuotationLineItem;
            }
            this.ServiceLineItem = ServiceLineItem;
            this.ChargeType =chargeType;
        }
    }
    public class grandChildWrapper{
        @AuraEnabled public String Name{get; set;}
        @AuraEnabled public Id  Id{get;set;}
        @AuraEnabled public String Type{get; set;}
        @AuraEnabled public Boolean HasChildren{get; set;}
        @AuraEnabled public Service_Line_Item_ChargeType__c item{get; set;}
        
         public grandChildWrapper(String Name,Id id,String Type,  Boolean hasChildren, Service_Line_Item_ChargeType__c item){     
            this.Name = Name;
            this.Id = Id;
            this.Type = Type;
            this.HasChildren = hasChildren;
            this.item =  item;
            
        }
    }
    public class columnWrapper{
        @AuraEnabled public Map<String, String> columnMap{get; set;}
        @AuraEnabled public  List<String> columnList{get; set;}
        @AuraEnabled public  Map<String, List<String>> columnFilter{get; set;}

        public columnWrapper(Map<String, String> columnMap, List<String> columnList, Map<String, List<String>> columnFilter){
            this.columnMap = columnMap;
            this.columnList = columnList;
            this.columnFilter =  columnFilter;
        }
    }
}
public class QuotationServiceHelper
{
    public static  QuotationBuilderDatabaseQueries DbQueries= new QuotationBuilderDatabaseQueries();
    public static  UTIL_LogGenerator logger = new UTIL_LogGenerator();
    public static List<ServiceLineItem__c> allServiceLineItems = new List<ServiceLineItem__c>();
    public static Map<String, LegDetail> supplierNameToLegDetailsMap;
    
    public static List<LegDetail> GetLegDetails(Quotations__c quotation)
    {
        logger.start(QuotationServiceHelper.class.getName(),'GetLegDetails');
        
        allServiceLineItems = DbQueries.GetServiceLineItemForWetu(quotation.Id);
      
        List<LegDetail> legDetails = new List<LegDetail>();
        try{
            if(allServiceLineItems.size() == 0)
            {
                return legDetails;
            }
            Integer LegSequenceCounter = 0;
            supplierNameToLegDetailsMap = new Map<String, LegDetail>();
            Integer supplierCounter = 1;
            for(ServiceLineItem__c sli: allServiceLineItems)
            { 
                if(sli.SupplierName__c != null)
                {
                    LegDetail legDetail = null;
                     system.debug('sli.Service_Type__c :>'+sli.Service_Type__c );
                     system.debug('supplierNameToLegDetailsMap :>'+supplierNameToLegDetailsMap );
                     system.debug('sli.Service_Date__c :>'+sli.Service_Date__c);
                    if(sli.Service_Type__c == 'Accommodation' 
                        && supplierNameToLegDetailsMap.get(sli.SupplierName__c) != null
                        //&& supplierNameToLegDetailsMap.get(sli.SupplierName__c).LegStartLocation == sli.SupplierName__c
                        )
                    {
                        system.debug('supplierNameToLegDetailsMap.get(sli.SupplierName__c)::::'+supplierNameToLegDetailsMap.get(sli.SupplierName__c)); 
                        legDetail = supplierNameToLegDetailsMap.get(sli.SupplierName__c);
                        system.debug('legDetail:::::::'+legDetail); 
                        legDetail.LegEndLocation = sli.SupplierName__c;
                        legDetail.LegEndDate = sli.Service_Date__c;
                        continue;
                    }
                    else if(sli.Service_Type__c == 'Accommodation' 
                        && supplierNameToLegDetailsMap.get(sli.SupplierName__c) == null)
                    {
                        
                        legDetail = new legDetail();
                        legDetail.LegStartLocation = sli.SupplierName__c;
                        legDetail.LegEndLocation = sli.SupplierName__c;
                        legDetail.LegStartDate = sli.Service_Date__c;
                        legDetail.LegEndDate = sli.Service_Date__c;
                        legDetail.LegSequence = LegSequenceCounter;
                        LegSequenceCounter++;
                        legDetails.add(legDetail);
                        supplierNameToLegDetailsMap.put(sli.SupplierName__c,legDetail);
                        continue;
                    }
                    else if(sli.Service_Type__c !='Accommodation' 
                        && supplierNameToLegDetailsMap.get(sli.SupplierName__c+sli.Service_Date__c) == null)
                    {
                        system.debug('supplierNameToLegDetailsMap1111:>'+supplierNameToLegDetailsMap);
                        legDetail = new legDetail();
                        legDetail.LegStartLocation = sli.SupplierName__c;
                        legDetail.LegEndLocation = sli.SupplierName__c;
                        legDetail.LegStartDate = sli.Service_Date__c;
                        legDetail.LegEndDate = sli.Service_Date__c;
                        legDetail.LegSequence = LegSequenceCounter;
                        LegSequenceCounter++;
                        legDetails.add(legDetail);
                        
                        supplierNameToLegDetailsMap.put(sli.SupplierName__c+sli.Service_Date__c,legDetail);
                        system.debug('supplierNameToLegDetailsMap2222:>'+supplierNameToLegDetailsMap);
                        continue;
                    }
                    
               }
           }
         logger.end();
        }
        catch(Exception e)
        {
            System.debug('GetLegDetails:>'+e.getMessage());
        }  
        
        return legDetails;
    }
    
    public static List<ServiceLineItem__c> FindServiceItemsForLeg(LegDetail legDetail,List<ServiceLineItem__c> allServiceLineItems)
    {
        List<ServiceLineItem__c> result = new List<ServiceLineItem__c>();
        try{
            for(ServiceLineItem__c sli:allServiceLineItems)
            {
                
                if(sli.Service_Date__c >= legDetail.LegStartDate 
                		&& sli.Service_Date__c <= legDetail.LegEndDate)
                {
                    result.add(sli);
                }
                    
            }
            
        }
        catch(Exception e)
        {
            system.debug('FindServiceItemsForLeg:>'+e.getMessage());
        }    
        return result;
    }
    
    public static String getMonthName(Integer month){
        
        if(month== 1){
            return 'Jan';   
        }else if(month == 2){
            return 'Feb';   
        }else if(month == 3){
            return 'Mar';   
        }else if(month == 4){
            return 'Apr';   
        }else if(month == 5){
            return 'May';       
        }else if(month == 6){            
            return 'Jun';   
        }else if(month == 7){
            return 'Jul';   
        }else if(month == 8){
            return 'Aug';   
        }else if(month == 9){
            return 'Sep';   
        }else if(month == 10){
            return 'Oct';  
        }else if(month == 11){
            return 'Nov';  
        }
         return 'Dec';
        
    }
}
public class UpdateYearlyTargetService{
    
    
    
    public static void rollUpFromMonthlyRecords(Map<Id, Consultant_Target_Monthly__c> mapMonthlyRecords)
    {
        List<Consultant_Target_Yearly__c> lstYearlyRecordsToBeUpdated = new List<Consultant_Target_Yearly__c>();
        Map<String,List<Consultant_Target_Monthly__c>> yearlyMonthlyMap = new Map<String,List<Consultant_Target_Monthly__c>>();
        for( Consultant_Target_Monthly__c monthlyRecord : mapMonthlyRecords.values()) {
            if(monthlyRecord.Consultant_Target_Yearly__c!=null) {
                if(yearlyMonthlyMap.containsKey(monthlyRecord.Consultant_Target_Yearly__c)) {
                    yearlyMonthlyMap.get(monthlyRecord.Consultant_Target_Yearly__c).add(monthlyRecord);
                } else {
                    yearlyMonthlyMap.put(monthlyRecord.Consultant_Target_Yearly__c, new List<Consultant_Target_Monthly__c>{monthlyRecord});
                }
            }
            
        }
        
        if(yearlyMonthlyMap!=null && !yearlyMonthlyMap.isEmpty()) {
            //query all monthlyMap records to setup fields at yearly level
            List<Consultant_Target_Yearly__c> lstYearlyRecordWithMonthlyChild = [Select Id, Total_Target__c, Total_Target_Achieved__c,
                                                                    (Select Id,Consultant_Target_Yearly__c, Gross_Profit_Target__c,Consultant_Gross_Profit_Target_Achieved__c 
                                                                    from Consultant_Target_Monthly__r) from Consultant_Target_Yearly__c where ID IN:yearlyMonthlyMap.keyset() ];
            if(lstYearlyRecordWithMonthlyChild!=null && !lstYearlyRecordWithMonthlyChild.isEmpty())
             {
                for(Consultant_Target_Yearly__c yearlyRecord : lstYearlyRecordWithMonthlyChild) 
                {
                    Consultant_Target_Yearly__c updateYearly = new Consultant_Target_Yearly__c(Id = yearlyRecord.Id);
                    //reset the target and target achieved
                    updateYearly.Total_Target__c = 0;
                    updateYearly.Total_Target_Achieved__c = 0;
                    //process through child records and rollup the values
                    for(Consultant_Target_Monthly__c monthlyRecord : yearlyRecord.Consultant_Target_Monthly__r)
                     {
                        updateYearly.Total_Target__c += (monthlyRecord.Gross_Profit_Target__c==null?0: monthlyRecord.Gross_Profit_Target__c);
                        updateYearly.Total_Target_Achieved__c += (monthlyRecord.Consultant_Gross_Profit_Target_Achieved__c==null?0:monthlyRecord.Consultant_Gross_Profit_Target_Achieved__c);
                    }
                    //add to the updated list
                    lstYearlyRecordsToBeUpdated.add(updateYearly);
                }
                //check and update the parent records
                if(lstYearlyRecordsToBeUpdated != null
                 && !lstYearlyRecordsToBeUpdated.isEmpty()) 
                {
                    update lstYearlyRecordsToBeUpdated;
                }
            }
        }
    }
   
   public static void upsertConsultantLeadYearlyTarget(List<Consultant_Target_Lead_Yearly__c> ctlys)
   {
       Set<Id> consultantIds = new Set<Id>();
       Set<String> years = new Set<String>();
       Map<String, Consultant_Target_Lead_Yearly__c> keyCTMValueMap = new  Map<String, Consultant_Target_Lead_Yearly__c>();
       for(Consultant_Target_Lead_Yearly__c ctm: ctlys)
       {
           consultantIds.add(ctm.Consultant__c);
           years.add(ctm.Year__c);
           String k = ctm.Consultant__c+ctm.Year__c;
           keyCTMValueMap.put(k,ctm);
       }
       
       List<Consultant_Target_Yearly__c>  consultantTargetYearlys = DAL_ConsultantTargetYearly.getByConsultantIdandYear(consultantIds,years);
        
        Set<Consultant_Target_Yearly__c> toUpdateCTYSet = new Set<Consultant_Target_Yearly__c>();
        for(Consultant_Target_Yearly__c consultantTargetYearly: consultantTargetYearlys)
        {
            String key  =  consultantTargetYearly.ConsultantIdKeyYear__c;
            if( null != keyCTMValueMap.get(key) )
            {
                Consultant_Target_Yearly__c c  = new Consultant_Target_Yearly__c(); 
                //c.Total_Lead__c =keyCTMValueMap.get(key).Consultant_Target_Lead_Achieved__c;
                c.Id =consultantTargetYearly.Id;
                c.Lead_Rollup_Annual__c = keyCTMValueMap.get(key).Id;
                toUpdateCTYSet.add(c);
            }
        }
        
        if(!toUpdateCTYSet.isEmpty())
        {
          update new List<Consultant_Target_Yearly__c>(toUpdateCTYSet);
        }
  }
   
}
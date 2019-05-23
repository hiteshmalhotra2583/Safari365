public class HLPR_RollupTargetYearly {
    
    public static void rollUpFromMonthlyRecords(Map<Id, Consultant_Target_Monthly__c> mapMonthlyRecords) {
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
            if(lstYearlyRecordWithMonthlyChild!=null && !lstYearlyRecordWithMonthlyChild.isEmpty()) {
                for(Consultant_Target_Yearly__c yearlyRecord : lstYearlyRecordWithMonthlyChild) {
                    Consultant_Target_Yearly__c updateYearly = new Consultant_Target_Yearly__c(Id = yearlyRecord.Id);
                    //reset the target and target achieved
                    updateYearly.Total_Target__c = 0;
                    updateYearly.Total_Target_Achieved__c = 0;
                    //process through child records and rollup the values
                    for(Consultant_Target_Monthly__c monthlyRecord : yearlyRecord.Consultant_Target_Monthly__r) {
                        updateYearly.Total_Target__c += (monthlyRecord.Gross_Profit_Target__c==null?0: monthlyRecord.Gross_Profit_Target__c);
                        updateYearly.Total_Target_Achieved__c += (monthlyRecord.Consultant_Gross_Profit_Target_Achieved__c==null?0:monthlyRecord.Consultant_Gross_Profit_Target_Achieved__c);
                    }
                    //add to the updated list
                    lstYearlyRecordsToBeUpdated.add(updateYearly);
                }
                //check and update the parent records
                if(lstYearlyRecordsToBeUpdated!=null && !lstYearlyRecordsToBeUpdated.isEmpty()) {
                    update lstYearlyRecordsToBeUpdated;
                }
            }
        }
    }

}
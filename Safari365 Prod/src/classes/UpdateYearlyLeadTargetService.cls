public class UpdateYearlyLeadTargetService
{
    public static void updateYearlyTarget(List<Consultant_Target_Lead_Monthly__c> ctlms)
    {
        Set<Id> consultantIds = new Set<Id>();
        Set<String> years  = new Set<String>();
        Map<String,List<Consultant_Target_Lead_Monthly__c>> monthlyTargetMap  =new Map<String,List<Consultant_Target_Lead_Monthly__c>>();
        for(Consultant_Target_Lead_Monthly__c ctlm: ctlms)
        {
            consultantIds.add(ctlm.Consultant__c);
            years.add(ctlm.Year__c);
            String k2 = ctlm.Consultant__c+ctlm.Year__c;
        }
        
        List<Consultant_Target_Lead_Yearly__c> existingRecords = 
        DAL_ConsultantTargetYearly.getLeadTargetByConsultantIdsAndYear(consultantIds,years);
        Map<String, Consultant_Target_Lead_Yearly__c> keyConsultantTargetLeadYearlys = 
        new Map<String, Consultant_Target_Lead_Yearly__c>();
        for(Consultant_Target_Lead_Yearly__c rec:existingRecords)
        {
            String k = rec.Consultant__c+rec.year__c;
            keyConsultantTargetLeadYearlys.put(k,rec);
        }
        
        Map<String,Object> keyTargetObjectMap = DAL_ConsultantTargetMonthly.getSumOfLeadMonthyTarget(years,consultantIds);
        Map<String,Object> keyTargetAchievedObjectMap = DAL_ConsultantTargetMonthly.getSumOfLeadMonthyTargetAchieved(years,consultantIds);
        
        Set<Consultant_Target_Lead_Yearly__c> toUpsertCTLY  = new  Set<Consultant_Target_Lead_Yearly__c>();
        for(Consultant_Target_Lead_Monthly__c nctlm: ctlms)
        {
            String key = nctlm.Consultant__c+nctlm.Year__c;
            Consultant_Target_Lead_Yearly__c ctlyToUpdate = null;
            if(null !=keyConsultantTargetLeadYearlys && null != keyConsultantTargetLeadYearlys.get(key))
            {
              ctlyToUpdate = keyConsultantTargetLeadYearlys.get(key);
              ctlyToUpdate.Consultant_Target_Lead_Achieved__c = (Decimal)keyTargetAchievedObjectMap.get(key);
              ctlyToUpdate.Consultant_Total_Lead_Target__c = (Decimal)keyTargetObjectMap.get(key);
            }
            else
            {
               ctlyToUpdate = new Consultant_Target_Lead_Yearly__c();
               ctlyToUpdate.Consultant_Target_Lead_Achieved__c = (Decimal)keyTargetAchievedObjectMap.get(key);
               ctlyToUpdate.Consultant_Total_Lead_Target__c = (Decimal)keyTargetObjectMap.get(key);
               ctlyToUpdate.CounsltantIdAndYearKey__c = key;
               ctlyToUpdate.Consultant__c = nctlm.Consultant__c;
               ctlyToUpdate.Year__c = nctlm.Year__c;
               keyConsultantTargetLeadYearlys.put(key,ctlyToUpdate);
            }   
           
           
          // ctlyToUpdate.Consultant_Total_Lead_Target__c=
            system.debug(ctlyToUpdate); 
           toUpsertCTLY.add(ctlyToUpdate);
        }
        
        if(! toUpsertCTLY.isEmpty())
        {
           Schema.SObjectField ftoken = Consultant_Target_Lead_Yearly__c.Fields.CounsltantIdAndYearKey__c;
           Database.UpsertResult[] srList = Database.upsert(new List<Consultant_Target_Lead_Yearly__c>(toUpsertCTLY),ftoken,false);
           Set<Id> ctlySuccessIds  = new Set<Id>();
           for (Database.UpsertResult sr : srList)
           {
                if (sr.isSuccess())
                {
                    // Operation was successful
                    ctlySuccessIds.add(sr.getId());
                }
                else
                {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors())
                     {
                        System.debug('error has occurred.' + err.getStatusCode() + ': ' + err.getMessage());                    
                        System.debug('fields that affected this error: ' + err.getFields());
                        
                    }
                }
           }
        }
    }
}
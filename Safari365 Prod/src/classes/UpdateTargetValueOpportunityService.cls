public class UpdateTargetValueOpportunityService{
    
    public static final string STAGENAMECLOSEDWON = 'Closed Won Deal';
    public static final string STAGENAMECLOSEDWONCANCELLED = 'Closed Won - Cancelled';
    
    public static void updateTargetMonthlyValues(List<Opportunity> opportunitys,
                                                 Map<Id,Opportunity> oldOpportunityMap)
    {
        system.debug('opportunitys::'+opportunitys);
        Set<Id> opportunityOwnerIds = new Set<Id>();
        Set<String> years = new Set<String>();
        Set<String> months = new Set<String>();
        Map<String, Opportunity> keyOpportuntiyMap = new Map<String, Opportunity>();
        Map<String, Opportunity> keyOldOpportuntiyMap = new Map<String, Opportunity>();
        for(Opportunity o: opportunitys)
        {
            if(o.StageName == STAGENAMECLOSEDWON 
              || o.StageName == STAGENAMECLOSEDWONCANCELLED)
            {
                 opportunityOwnerIds.add(o.OwnerId);
                 years.add(String.valueof(o.closeDate.year()));
                 months.add(String.valueof(o.closeDate.month()));
                 String oppKey = o.OwnerId+String.valueof(o.closeDate.month())+String.valueof(o.closeDate.year());
                 system.debug('oppKey::'+oppKey);
                 keyOpportuntiyMap.put(oppKey,o);
                 Opportunity oldOpp = oldOpportunityMap.get(o.Id);
                 if((oldOpp.StageName == STAGENAMECLOSEDWON 
                  ||  oldOpp.StageName == STAGENAMECLOSEDWONCANCELLED)
                  && oldOpp.closeDate.month() != o.closeDate.month())
                {
                   if(! opportunityOwnerIds.contains(oldOpp.OwnerId))
                    opportunityOwnerIds.add(oldOpp.OwnerId);
                   
                   years.add(String.valueof(oldOpp.closeDate.year()));
                   months.add(String.valueof(oldOpp.closeDate.month()));
                   String OldOppKey = oldOpp.OwnerId+String.valueof(oldOpp.closeDate.month())+String.valueof(oldOpp.closeDate.year());
                   keyOldOpportuntiyMap.put(OldOppKey,oldOpp);
                }
                 
            }
              
        }
        
        List<Consultant_Target_Monthly__c> toUpdateTargetAchievedValues = new List<Consultant_Target_Monthly__c>();
        List<Opportunity> toUpdateOpportunity = new List<Opportunity>();
        
        if(!opportunityOwnerIds.isEmpty() 
            && ! keyOpportuntiyMap.values().isEmpty())
        {
            List<Consultant_Target_Monthly__c> consultantTargetMonthlys =
            DAL_ConsultantTargetMonthly.getByConsultantIdAndYear(opportunityOwnerIds,months,years);
           system.debug('consultantTargetMonthlys::'+consultantTargetMonthlys);
            Map<String, Consultant_Target_Monthly__c> keyConsultantTargetMonthlyMap = new Map<String, Consultant_Target_Monthly__c>();
            for(Consultant_Target_Monthly__c ctm: consultantTargetMonthlys)
            {
               String key =  ctm.Consultant__c+ctm.Month__c+ctm.Year__c;
               keyConsultantTargetMonthlyMap.put(key,ctm);
            }
            
            for(String oldKey : keyOldOpportuntiyMap.keySet())
            {
               if(keyConsultantTargetMonthlyMap.get(oldKey) != null)
               {
                  system.debug('isnside the if consultantTargetMonthlys::'+consultantTargetMonthlys);
                   Consultant_Target_Monthly__c ctmToUpdate = keyConsultantTargetMonthlyMap.get(oldKey);
                   ctmToUpdate.Consultant_Gross_Profit_Target_Achieved__c = ctmToUpdate.Consultant_Gross_Profit_Target_Achieved__c - keyOldOpportuntiyMap.get(oldKey).Gross_Profit__c;
                   toUpdateTargetAchievedValues.add(ctmToUpdate);
               }
            }
           
            for(String k: keyOpportuntiyMap.keySet())
            {
               system.debug('current key::'+k);
               if(keyConsultantTargetMonthlyMap.get(k) != null)
               {
                   
                   Consultant_Target_Monthly__c ctmToUpdate = keyConsultantTargetMonthlyMap.get(k);
                    system.debug('ctmToUpdate::'+ctmToUpdate);
                   Decimal currentValue =0;
                   
                   if(ctmToUpdate.Consultant_Gross_Profit_Target_Achieved__c > 0
                         && keyOpportuntiyMap.get(k).Consultant_Target_Monthly__c != null)
                   {
                       system.debug('inside the ctmToUpdate::'+ctmToUpdate);
                       system.debug('oldOpportunityMap.get(keyOpportuntiyMap.get(k).Id).Gross_Profit__c'+oldOpportunityMap.get(keyOpportuntiyMap.get(k).Id).Gross_Profit__c);
                       currentValue = ctmToUpdate.Consultant_Gross_Profit_Target_Achieved__c - oldOpportunityMap.get(keyOpportuntiyMap.get(k).Id).Gross_Profit__c;
                        //currentValue = ctmToUpdate.Consultant_Gross_Profit_Target_Achieved__c;
                       system.debug(' the ctmToUpdate2222::'+ctmToUpdate);
                   }
                   else if(ctmToUpdate.Consultant_Gross_Profit_Target_Achieved__c > 0
                            && keyOpportuntiyMap.get(k).Consultant_Target_Monthly__c == null)
                   {
                      currentValue = ctmToUpdate.Consultant_Gross_Profit_Target_Achieved__c;
                   }
                   system.debug('currentValue::'+currentValue);
                   ctmToUpdate.Consultant_Gross_Profit_Target_Achieved__c = currentValue+keyOpportuntiyMap.get(k).Gross_Profit__c;
                   toUpdateTargetAchievedValues.add(ctmToUpdate); 
                   
                   Opportunity toUpdateOpp = new Opportunity();
                   toUpdateOpp.Id =keyOpportuntiyMap.get(k).Id;
                   toUpdateOpp.Consultant_Target_Monthly__c = keyConsultantTargetMonthlyMap.get(k).Id;
                   toUpdateOpportunity.add(toUpdateOpp);
               }
             }
           } 
           
            if(!toUpdateTargetAchievedValues.isEmpty())
            update toUpdateTargetAchievedValues;
            
            if( ! toUpdateOpportunity.isEmpty())
            {
                BaseTriggerHandler.byPass('OpportunityTriggerHandler');
                update toUpdateOpportunity;
                BaseTriggerHandler.clearBypass('OpportunityTriggerHandler');
            }
      
       
    }
    
    
    public static void deleteTargetMonthlyValues(List<Opportunity> opportunitys,
                                                 Map<Id,Opportunity> oldOpportunityMap)
    {
        Set<Id> opportunityOwnerIds = new Set<Id>();
        Set<String> years = new Set<String>();
        Set<String> months = new Set<String>();
        Map<String, Opportunity> keyOpportuntiyMap = new Map<String, Opportunity>();
        for(Opportunity o: opportunitys)
        {
            // if old amoiunt is same as the new one
            if(o.StageName == STAGENAMECLOSEDWON || o.StageName == STAGENAMECLOSEDWONCANCELLED)
            {
                 opportunityOwnerIds.add(o.OwnerId);
                 years.add(o.Close_Date_Year__c);
                 months.add(o.Close_Date_Month__c);
                 String oppKey = o.OwnerId+o.Close_Date_Month__c+o.Close_Date_Year__c;
                 keyOpportuntiyMap.put(oppKey,o);
            }
        }
        
        if(!opportunityOwnerIds.isEmpty() 
            && ! keyOpportuntiyMap.values().isEmpty())
        {
            List<Consultant_Target_Monthly__c> consultantTargetMonthlys =
            DAL_ConsultantTargetMonthly.getByConsultantIdAndYear(opportunityOwnerIds,months,years);
        
            Map<String, Consultant_Target_Monthly__c> keyConsultantTargetMonthlyMap = new Map<String, Consultant_Target_Monthly__c>();
            for(Consultant_Target_Monthly__c ctm: consultantTargetMonthlys)
            {
               String key =  ctm.Consultant__c+ctm.Month__c+ctm.Year__c;
               keyConsultantTargetMonthlyMap.put(key,ctm);
            }
            
            List<Consultant_Target_Monthly__c> toUpdateTargetAchievedValues = new List<Consultant_Target_Monthly__c>();
            for(String k: keyOpportuntiyMap.keySet())
            {
               if(keyConsultantTargetMonthlyMap.get(k) != null)
               {
                   Consultant_Target_Monthly__c ctmToUpdate = keyConsultantTargetMonthlyMap.get(k);
                   Decimal currentValue =  ctmToUpdate.Consultant_Gross_Profit_Target_Achieved__c - oldOpportunityMap.get(keyOpportuntiyMap.get(k).Id).Gross_Profit__c;
                   ctmToUpdate.Consultant_Gross_Profit_Target_Achieved__c = currentValue;
                   toUpdateTargetAchievedValues.add(ctmToUpdate); 
               }
            }
            
            if(!toUpdateTargetAchievedValues.isEmpty())
            update toUpdateTargetAchievedValues;
       }
       
    }


}
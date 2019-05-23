public class DAL_ConsultantTargetMonthly{
    
    
    public static List<Consultant_Target_Monthly__c> getByConsultantIdAndYear(Set<Id> consultantId,
                                                                              Set<String> months,
                                                                              Set<String> years)
    {
    
      return [SELECT 
                    Id,
                    Consultant_Gross_Profit_Target_Achieved__c,
                    Consultant_Gross_Profit_Target__c,
                    Consultant_Role__c,
                    Consultant__c,
                    Month__c,
                    Year__c
               FROM 
                    Consultant_Target_Monthly__c
               WHERE
                    Consultant__c IN:consultantId
                AND 
                    Month__c IN: months
               AND 
                   Year__c IN:years];
    }
    
    
    public static List<Consultant_Target_Lead_Monthly__c> getLeadTargetByConsultantIdAndYear(Set<Id> consultantId,
                                                                              Set<String> months,
                                                                              Set<String> years)
    {
    
      return [SELECT 
                    Id,
                    Consultant_Leads_Target__c,
                    Consultant_Target_Lead_Achieved__c,
                    Consultant_Role__c,
                    Consultant__c,
                    Month__c,
                    Year__c
               FROM 
                    Consultant_Target_Lead_Monthly__c
               WHERE
                    Consultant__c IN:consultantId
                AND 
                    Month__c IN: months
               AND 
                   Year__c IN:years];
    }
    
    
    
    public static Map<String,Object> getCountConsultantTargetMonthly(Set<String> years, 
                                                               Set<Id> consultantIds)
    {
     
      AggregateResult[] groupedResults = [SELECT 
                                                Consultant__c,
                                                Count(Id)aver,
                                                Year__c
                                               FROM 
                                                     Consultant_Target_Monthly__c
                                              WHERE
                                                     Year__c IN: years
                                               AND 
                                                    Consultant__c IN: consultantIds
                                              group by Consultant__c,Year__c];
                              
         Map<String,Integer>  countOfActiveMonthTargetMap = new Map<String,Integer>();
         for(AggregateResult result:groupedResults )
        {
          String key = (String)result.get('Consultant__c')+(String)result.get('Year__c');
          countOfActiveMonthTargetMap.put(key,(result.get('aver')==null?0:(Integer)result.get('aver')));
        }  
    
    return countOfActiveMonthTargetMap;             
    }
    
    
    public static Map<String,Object> getSumOfAverageConsultantTargetMonthly(Set<String> years, 
                                                               Set<Id> consultantIds)
    {
     
      AggregateResult[] groupedResults = [SELECT 
                                                Consultant__c,
                                                Sum(Consultant_Gross_Profit_Target__c)aver,
                                                Year__c
                                               FROM 
                                                     Consultant_Target_Monthly__c
                                              WHERE
                                                     Year__c IN: years
                                               AND 
                                                    Consultant__c IN: consultantIds
                                              group by Consultant__c,Year__c];
                              
         Map<String,Decimal>  sumOfGPTargetMap = new Map<String,Decimal>();
         for(AggregateResult result:groupedResults )
        {
          String key = (String)result.get('Consultant__c')+(String)result.get('Year__c');
          sumOfGPTargetMap.put(key,(result.get('aver')==null?0:(Decimal)result.get('aver')));
        }  
    
    return sumOfGPTargetMap;             
    }
    
    
    public static Map<String,Object> getSumOfLeadMonthyTarget(Set<String> years, 
                                                               Set<Id> consultantIds)
    {
     
      AggregateResult[] groupedResults = [SELECT 
                                                Consultant__c,
                                                SUM(Consultant_Leads_Target__c)aver,
                                                Year__c
                                               FROM 
                                                     Consultant_Target_Lead_Monthly__c
                                              WHERE
                                                     Year__c IN: years
                                               AND 
                                                    Consultant__c IN: consultantIds
                                              group by Consultant__c,Year__c];
                              
         Map<String,Decimal>  monthlyTargetMap = new Map<String,Decimal>();
         for(AggregateResult opp:groupedResults )
        {
          String key = (String)opp.get('Consultant__c')+(String)opp.get('Year__c');
          monthlyTargetMap.put(key,(opp.get('aver')==null?0:(Decimal)opp.get('aver')));
        }  
    
    return monthlyTargetMap;             
    }
    
    
    public static Map<String,Object> getSumOfLeadMonthyTargetAchieved(Set<String> years, 
                                                               Set<Id> consultantIds)
    {
     
      AggregateResult[] groupedResults = [SELECT 
                                                Consultant__c,
                                                SUM(Consultant_Target_Lead_Achieved__c)aver,
                                                Year__c
                                               FROM 
                                                     Consultant_Target_Lead_Monthly__c
                                              WHERE
                                                     Year__c IN: years
                                               AND 
                                                    Consultant__c IN: consultantIds
                                              group by Consultant__c,Year__c];
                              
         Map<String,Decimal>  monthlyTargetMap = new Map<String,Decimal>();
         for(AggregateResult opp:groupedResults )
        {
          String key = (String)opp.get('Consultant__c')+(String)opp.get('Year__c');
          monthlyTargetMap.put(key,(opp.get('aver')==null?0:(Decimal)opp.get('aver')));
        }  
    
    return monthlyTargetMap;             
    }

}
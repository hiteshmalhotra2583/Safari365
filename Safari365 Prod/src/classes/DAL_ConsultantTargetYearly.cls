public class DAL_ConsultantTargetYearly
{
    
    public static List<Consultant_Target_Yearly__c> getByConsultantIdandYear(Set<Id> consultantId,
                                                                              Set<String> years)
    {
      return [SELECT
                     Id,
                     Consultant__c,
                     Name,
                     Year__c,
                     Total_Target__c,
                     Total_Target_Achieved__c,
                     Average_of_Conversion_Ratio__c ,
                     ConsultantIdKeyYear__c
               FROM
                     Consultant_Target_Yearly__c
               WHERE
                     Consultant__c IN: consultantId
               AND 
                      Year__c IN:years];   
    }

  
    public static List<Consultant_Target_Lead_Yearly__c> getLeadTargetByConsultantIdsAndYear(Set<Id> consultantId,
                                                                              Set<String> years)
    {
      return [SELECT
                     Id,
                     Consultant__c,
                     Name,
                     Year__c,
                     Consultant_Total_Lead_Target__c,
                     Consultant_Target_Lead_Achieved__c,
                    
                     CounsltantIdAndYearKey__c
               FROM
                     Consultant_Target_Lead_Yearly__c
               WHERE
                     Consultant__c IN: consultantId
               AND 
                     Year__c IN:years];   
    }


   public static List<Consultant_Target_Yearly__c> getByIds(Set<Id> ids)
   {
      return [SELECT
                     Id,
                     Consultant__c,
                     Name,
                     Year__c,
                     Total_Target__c,
                     Total_Target_Achieved__c,
                     Average_of_Conversion_Ratio__c,
                     ConsultantIdKeyYear__c
               FROM
                     Consultant_Target_Yearly__c
               WHERE
                     Id IN: ids];   
    }
    
    
   public static List<Consultant_Target_Yearly__c> getByYearSet(Set<Id> ids)
   {
      return [Select Id, 
                     Total_Target__c,
                     Total_Target_Achieved__c,
                     (SELECT 
                             Id,
                             Consultant_Target_Yearly__c,
                             Gross_Profit_Target__c,
                             Consultant_Gross_Profit_Target_Achieved__c 
                     FROM
                             Consultant_Target_Monthly__r) 
               FROM
                     Consultant_Target_Yearly__c
              WHERE 
                    ID IN:ids];   
    }
    
    
    public static List<Consultant_Target_Lead_Yearly__c> getLeadTargetByIds(Set<Id> ids)
   {
      return [SELECT
                     Id,
                     Consultant__c,
                     Name,
                     Year__c,
                     Consultant_Total_Lead_Target__c,
                     Consultant_Target_Lead_Achieved__c,
                     CounsltantIdAndYearKey__c
               FROM
                     Consultant_Target_Lead_Yearly__c
               WHERE
                     Id IN: ids];   
    }
    
    
    
}
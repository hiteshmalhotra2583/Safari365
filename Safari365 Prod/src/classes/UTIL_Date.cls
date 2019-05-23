public class UTIL_Date 
{
    private static final String SATURDAY = 'Sat';
    private static final String SUNDAY = 'Sun';
    private static final String DAY_FMT = 'E';
    private static final String FULL_TIME_FORMATTER = 'yyyy-MM-dd hh:mm:ss';
    private static final String DATE_FORMATTER = 'yyyy-MM-dd';
    
    public static String giveWeekDayName(Datetime aDateTime)
    {
    	return aDateTime.format(DAY_FMT);
    }
    
     public static String giveWeekDayName(Date aDate)
    {
    	return giveWeekDayName((Datetime)aDate);
    }
    
    public static Boolean isWeekend(Datetime aDateTime)
    {
        return (aDateTime.format(DAY_FMT) == SATURDAY || aDateTime.format(DAY_FMT) == SUNDAY);
    }

    public static Boolean isWeekend(Date aDate)
    {
        return isWeekend((Datetime)aDate);
    }
    
    public static Boolean isWeekDay(Datetime day)
    {
        return !isWeekend(day);
    }
    
    public static Boolean isWeekDay(Date day)
    {
        return isWeekDay((Datetime)day);
    }

        
    public static Date addBusinessDays(Date startDate, integer businessDaysToAdd)
    {
        Date finalDate = startDate;
        Integer direction = businessDaysToAdd < 0 ? -1 : 1;
        while(businessDaysToAdd != 0)
        {
            finalDate = finalDate.AddDays(direction);
            if (!isWeekend(finalDate))
            {
                businessDaysToAdd -= direction;
            }
        }
        return finalDate;
    }
    
    
     public static String formatGivenDate(Datetime aDateTime)
    {
    	String day = aDateTime.format(DAY_FMT);
    	
    	return day +'-'+String.valueof(aDateTime.day())+'/'+String.valueof(aDateTime.month())+'/'+String.valueof(aDateTime.year());
    }
    
    public static String formatGivenDateToString(Datetime aDateTime)
    {
    	String day = aDateTime.format(DAY_FMT);
    	
    	return String.valueof(aDateTime.day())+'/'+String.valueof(aDateTime.month())+'/'+String.valueof(aDateTime.year());
    }
    
     public static String formatGivenDateToString(Date aDate)
    {
    	return String.valueof(aDate.day())+'/'+String.valueof(aDate.month())+'/'+String.valueof(aDate.year());
    }
    
    /*
    * @descriptions returns the most recent weekday before today
    */
    public static Date lastWeekDay()
    {
        Date result;
        for (result = Date.today().addDays(-1); isWeekend(result); result = result.addDays(-1));
        return result;
    }
    

    public static Date testWeekDay()
    {
        // This is a wednesday
        return Date.newInstance(2014, 7, 30);
    }

    public static Date testWeekedDay()
    {
        // This is a saturday
        return Date.newInstance(2014, 8, 2);
    }
}
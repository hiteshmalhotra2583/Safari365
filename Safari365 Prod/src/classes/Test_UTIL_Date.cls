@isTest
private class Test_UTIL_Date
{
    static testMethod void testDateMethods()
    {
        Date weekDay = UTIL_Date.testWeekDay();
        Date weekendDay = UTIL_Date.testWeekedDay();
        Date lastWeekDay = UTIL_Date.lastWeekDay();
        Date dateBeforeAddingWorkDays = Date.newInstance(2015, 1, 1); // 1 jan 2015 is a thursday
        Integer businessDaysToAdd = 5; // when added to 2015/1/1 
        Date dateAfterAddingWorkDays = Date.newInstance(2015,1,8); // 5 days after the 1st excl weekends

        Test.startTest();
        Boolean checker = UTIL_Date.isWeekend(weekendDay);
        System.assertEquals(checker, true, 'This date should be weekend day. Value must be True');

        checker = UTIL_Date.isWeekDay(weekDay);
        System.assertEquals(checker, true, 'This date should be week day. Value must be True');

        checker = UTIL_Date.isWeekDay(lastWeekDay);
        System.assertEquals(checker, true, 'This date should be week day. Value must be True');
        
        
        Date dateCheck = UTIL_Date.addBusinessDays(dateBeforeAddingWorkDays, businessDaysToAdd);
        checker = (dateCheck == dateAfterAddingWorkDays);
        System.assertEquals(checker, true, 'This date should exclude weekends, Value must be true');
        
        String day= UTIL_Date.giveWeekDayName(dateBeforeAddingWorkDays);
        System.assertEquals(day,'Thu');
        
        UTIL_Date.formatGivenDate(System.Now());
        UTIL_Date.formatGivenDateToString(System.Now());
        
        Test.stopTest();

    }
}
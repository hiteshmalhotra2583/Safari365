global class SingleExecution {

private static boolean blnAlreadyDone = false;

public static boolean hasAlreadyDone(){ 
    return blnAlreadyDone;
}

public static void setAlreadyDone() {
    blnAlreadyDone = true;  
}

public static void forceResetAlreadyDone() {
    blnAlreadyDone = false; 
}

/*static testMethod void testSingleExecution() {
    //Hasn't already run
    System.assertEquals(false,SingleExecution.hasAlreadyDone());

    SingleExecution.setAlreadyDone();
    //Has just been run
    System.assertEquals(true,SingleExecution.hasAlreadyDone());

    SingleExecution.forceResetAlreadyDone();
    //Has just been reset
    System.assertEquals(false,SingleExecution.hasAlreadyDone());
} */  
}
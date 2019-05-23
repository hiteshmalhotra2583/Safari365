global class LoadWetuLocationService implements Schedulable  {
    
    
    @future(callout=true)
    public static void loadWetuLocation()
    {
        
        string url ='https://wetu.com/API/Pins/'+Label.WetuAPI+'/List?All=include&modifiedsince='+getLastMonthDate();
         // Instantiate a new http object
        Http h = new Http();

        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('GET');
        // Send the request, and return a response
        HttpResponse res = h.send(req);        
        List<WetuLocation__c> wetuLocations = JSON2Apex.parseWetuLocationJson(System.JSON.createParser(res.getBody()));
        DAL_BaseObject.InsertDBObjectsAsync(wetuLocations);
        insertIntegrationLog(wetuLocations.size());
       
    }
    
    public static void insertIntegrationLog(Integer wetuLocations)
    {
        SyncforceServiceLog__c  log =  new SyncforceServiceLog__c();
        log.NumberOfRecordsProcessed__c =wetuLocations;
        log.SalesforceObjectName__c='WetuLocation__c';
        log.QueryId__c='1';
        log.NumberOfRecordsUnProcessed__c =0;
        log.ProcessDate__c = UTIL_Date.formatGivenDateToString(system.today());
        log.SqlTableName__c='WetuLocation__c';
        if(!Test.isRunningTest())
        insert log;
    }
    
    public static  String getLastMonthDate()
    {   
        Integer year = null;
        if(system.today().month() == 1)
        {
            year  = system.today().addYears(-1).year();
        }
        else
        {
            year  = system.today().year();
        }
        Integer month = system.today().toStartOfMonth().addMonths(-1).month();
        Integer day  = system.today().day();
        String returnDate =String.valueOf(year)+'-'+String.valueOf(month)+'-'+String.valueOf(day)+'T00:00:00';
        return returnDate;
    }
    
    
     global void execute(SchedulableContext bc){
       LoadWetuLocationService.loadWetuLocation();

   }     
}
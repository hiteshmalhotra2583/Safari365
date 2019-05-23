/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class DaddyAnalyticsRetrieveData {
    global DaddyAnalyticsRetrieveData() {

    }
    global static System.HttpRequest buildRequest(Datetime visitDate, String DA_Token, String url, String siteId, String siteKey) {
        return null;
    }
    global static System.HttpRequest buildRequest(Datetime visitDate, String DA_Token, String url, String siteId, String siteKey, Boolean isRequestForFirstVisit, String firstVisitSessionId) {
        return null;
    }
    global static String getFirstVisitSessionIdFromResponse(System.HttpResponse response, Integer numberOfDaysToTrackForFirstVisit) {
        return null;
    }
    global static String getLeadSourceValue(String referrerDomain, String referrerType) {
        return null;
    }
    webService static String onButtonRetrieveData(String DA_Token) {
        return null;
    }
    webService static String onButtonRetrieveDataBatch() {
        return null;
    }
    global static String retrieveData(String DA_Token) {
        return null;
    }
    @Future(callout=true)
    global static void retrieveDataAfterInsert(String DA_Token) {

    }
    global static System.HttpResponse sendRequest(System.Http h, System.HttpRequest request) {
        return null;
    }
    global static String setFields(System.JSONParser parser, Lead matchLead) {
        return null;
    }
}

@RestResource(urlMapping='/Safari365/MembersClub/UpdatePassenger/*')
global with sharing class WS_UpdatePassenger
{
    private static final String SUCCESS = 'Success';
    private static final String ERROR = 'Error';
    private static final String BLANK_STRING = '';
    
    @Httppost
    global static ResponseWrapper doPost(RequestWrapper requestWrapper)
    {
        ResponseWrapper returnResponse = new ResponseWrapper();
        returnResponse.requestWrapper = requestWrapper;
        if(requestWrapper.Passenger != null){
            try{
                Passenger__c passengerObj = new Passenger__c(Id=requestWrapper.Passenger.PassengerId);
                if(requestWrapper.Passenger.FirstName != null && requestWrapper.Passenger.FirstName != ''){
                    passengerObj.FirstName__c = requestWrapper.Passenger.FirstName;
                }
                if(requestWrapper.Passenger.MiddleName != null && requestWrapper.Passenger.MiddleName != ''){
                    passengerObj.Middle_Name_s__c = requestWrapper.Passenger.MiddleName;
                }
                if(requestWrapper.Passenger.LastName != null && requestWrapper.Passenger.LastName != ''){
                    passengerObj.Last_Name__c = requestWrapper.Passenger.LastName;
                }
                if(requestWrapper.Passenger.PassportNumber != null && requestWrapper.Passenger.PassportNumber != ''){
                    passengerObj.Passport_Number__c = requestWrapper.Passenger.PassportNumber;
                }
                if(requestWrapper.Passenger.PassportExpiry != null){
                    passengerObj.Passport_Expiry_Date__c = requestWrapper.Passenger.PassportExpiry;
                }
                if(requestWrapper.Passenger.DOB != null ){
                    passengerObj.Date_of_Birth__c = requestWrapper.Passenger.DOB;
                }
                if(requestWrapper.Passenger.PassportNationality != null && requestWrapper.Passenger.PassportNationality != ''){
                    passengerObj.Nationality__c = requestWrapper.Passenger.PassportNationality;
                }
                if(requestWrapper.Passenger.EmailAddress != null && requestWrapper.Passenger.EmailAddress != ''){
                    passengerObj.Email__c = requestWrapper.Passenger.EmailAddress;
                }
                if(requestWrapper.Passenger.MobilePhone != null && requestWrapper.Passenger.MobilePhone != ''){
                    passengerObj.Mobile_Phone__c = requestWrapper.Passenger.MobilePhone;
                }
                if(requestWrapper.Passenger.HomePhone != null && requestWrapper.Passenger.HomePhone != ''){
                    passengerObj.Home_Phone__c = requestWrapper.Passenger.HomePhone;
                }
                if(requestWrapper.Passenger.CountryofResidence != null && requestWrapper.Passenger.CountryofResidence != ''){
                    passengerObj.Country_of_Residence__c = requestWrapper.Passenger.CountryofResidence;
                }
                if(requestWrapper.Passenger.EmergencyFirstName != null && requestWrapper.Passenger.EmergencyFirstName != ''){
                    passengerObj.Emergency_First_Name__c = requestWrapper.Passenger.EmergencyFirstName;
                }
                if(requestWrapper.Passenger.EmergencyLastName != null && requestWrapper.Passenger.EmergencyLastName != ''){
                    passengerObj.Emergency_Last_Name__c = requestWrapper.Passenger.EmergencyLastName;
                }
                if(requestWrapper.Passenger.EmergencyPhoneNumber != null && requestWrapper.Passenger.EmergencyPhoneNumber != ''){
                    passengerObj.Emergency_Mobile_Phone_Number__c = requestWrapper.Passenger.EmergencyPhoneNumber;
                }
                if(requestWrapper.Passenger.SpecialDietaryRequirements != null){
                    passengerObj.DietaryRequirements__c = requestWrapper.Passenger.SpecialDietaryRequirements;
                }
                if(requestWrapper.Passenger.SpecialDietaryRequirementsDetails != null && requestWrapper.Passenger.SpecialDietaryRequirementsDetails != ''){
                    passengerObj.DietaryRequirements_Text__c = requestWrapper.Passenger.SpecialDietaryRequirementsDetails;
                }
                if(requestWrapper.Passenger.MedicalInformation != null){
                    passengerObj.Medical_Information_Verified__c = requestWrapper.Passenger.MedicalInformation;
                }
                if(requestWrapper.Passenger.existingMedicalInformation != null){
                    passengerObj.ExistingMedicalCondition__c = requestWrapper.Passenger.existingMedicalInformation;
                }
                if(requestWrapper.Passenger.MedicalInformationDetails != null && requestWrapper.Passenger.MedicalInformationDetails != ''){
                    passengerObj.Medical_Conditions__c = requestWrapper.Passenger.MedicalInformationDetails;
                }
                if(requestWrapper.Passenger.ExistingMobilityIssues != null){
                    passengerObj.ExistingMobilityIssue__c = requestWrapper.Passenger.ExistingMobilityIssues;
                }
                if(requestWrapper.Passenger.ExistingMobilityIssuesDetails != null && requestWrapper.Passenger.ExistingMobilityIssuesDetails != ''){
                    passengerObj.Mobility_Issues__c = requestWrapper.Passenger.ExistingMobilityIssuesDetails;
                }
                if(requestWrapper.Passenger.Anniversary != null){
                    passengerObj.Celebrating_a_wedding_anniversary__c = requestWrapper.Passenger.Anniversary;
                }
                if(requestWrapper.Passenger.OtherOccasion != null && requestWrapper.Passenger.OtherOccasion != ''){
                    passengerObj.Other_Occasion__c = requestWrapper.Passenger.OtherOccasion;
                }
                if(requestWrapper.Passenger.TravelInsurance != null && requestWrapper.Passenger.TravelInsurance != ''){
                    passengerObj.Travel_Insurance__c = requestWrapper.Passenger.TravelInsurance;
                }
                if(requestWrapper.Passenger.TravelInsurancePolicyNumber != null && requestWrapper.Passenger.TravelInsurancePolicyNumber != ''){
                    passengerObj.Travel_Insurance_Policy_Number__c = requestWrapper.Passenger.TravelInsurancePolicyNumber;
                }
                if(requestWrapper.Passenger.TravelInsuranceProvider != null && requestWrapper.Passenger.TravelInsuranceProvider != ''){
                    passengerObj.Travel_Insurance_Policy_Provider__c = requestWrapper.Passenger.TravelInsuranceProvider;
                }
                if(requestWrapper.Passenger.TravelInsuranceEmergencyNumber != null && requestWrapper.Passenger.TravelInsuranceEmergencyNumber != ''){
                    passengerObj.Policy_Emergency_Phone_Number__c = requestWrapper.Passenger.TravelInsuranceEmergencyNumber;
                }
                if(requestWrapper.Passenger.ArrivalFlightDetails != null && requestWrapper.Passenger.ArrivalFlightDetails != ''){
                    passengerObj.International_Flight_Arrival_Details__c = requestWrapper.Passenger.ArrivalFlightDetails;
                }
                if(requestWrapper.Passenger.DepartureFlightDetails != null && requestWrapper.Passenger.DepartureFlightDetails != ''){
                    passengerObj.International_Flight_Departure_Details__c = requestWrapper.Passenger.DepartureFlightDetails;
                }
                if(requestWrapper.Passenger.WaiverOfLiabilityName!= null){
                    passengerObj.Waiver_Of_Liability_Name__c = requestWrapper.Passenger.WaiverOfLiabilityName;
                }
                if(requestWrapper.Passenger.WaiverofLiabilityDate != null){
                    passengerObj.Waiver_Of_Liability_Date__c = requestWrapper.Passenger.WaiverofLiabilityDate;
                }
                if(requestWrapper.Passenger.WaiverofLiabilityConfirmation != null){
                    passengerObj.Waiver_Of_Liability__c = requestWrapper.Passenger.WaiverofLiabilityConfirmation;
                }
                if(requestWrapper.Passenger.PrivacyPolicyAgreed != null){
                    passengerObj.Privacy_Policy_Agreed__c = requestWrapper.Passenger.PrivacyPolicyAgreed;
                }
                if(requestWrapper.Passenger.SubscribeMeToNewsletter != null){
                    passengerObj.Subscribe_me_to_newsletter__c = requestWrapper.Passenger.SubscribeMeToNewsletter;
                }
                update passengerObj;            
                returnResponse.status  = SUCCESS;
            }catch(Exception ex){
                System.debug('-----EX----- '+ ex);
                returnResponse.status  = Error;
                returnResponse.errorMessage = ex.getMessage();
            }
        }
        else {
            returnResponse.status  = Error;
            returnResponse.errorMessage ='Passenger details not found in request message';
        }
     
       return returnResponse;
    }
    
    global class ResponseWrapper {
    
        webservice String status;
        webservice String errorMessage;
        webservice RequestWrapper requestWrapper;
        
    }
        
    global class RequestWrapper {
        
        webservice Passenger Passenger;
        
    }  
    
    global class Passenger {
    
        webservice String PassengerId;
        webservice String FirstName;
        webservice String MiddleName;
        webservice String LastName;
        webservice String PassportNumber;
        webservice Date PassportExpiry;
        webservice Date DOB;
        webservice String PassportNationality;
        webservice String EmailAddress;
        webservice String MobilePhone;
        webservice String HomePhone;
        webservice String CountryofResidence;
        webservice String EmergencyFirstName;
        webservice String EmergencyLastName;
        webservice String EmergencyPhoneNumber;
        webservice boolean SpecialDietaryRequirements;
        webservice String SpecialDietaryRequirementsDetails;
        webservice boolean MedicalInformation;
        webservice boolean existingMedicalInformation;
        webservice String MedicalInformationDetails;
        webservice boolean ExistingMobilityIssues;
        webservice String ExistingMobilityIssuesDetails;
        webservice Date Anniversary;
        webservice String OtherOccasion;
        webservice String TravelInsurance;
        webservice String TravelInsurancePolicyNumber;
        webservice String TravelInsuranceProvider;
        webservice String TravelInsuranceEmergencyNumber;
        webservice String ArrivalFlightDetails;
        webservice String DepartureFlightDetails;
        webservice Date WaiverofLiabilityDate;
        webservice boolean WaiverofLiabilityConfirmation;
        webservice String WaiverOfLiabilityName;
        webservice boolean PrivacyPolicyAgreed;
        webservice boolean SubscribeMeToNewsletter;
    } 
            
}


/*********************

{
    "requestWrapper":{
        "Passenger":{
            "PassengerId":"a0q0E000000lM1A",
            "FirstName":"MYName",
            "LastName":"YourName"
        }       
    }
}


***********************/
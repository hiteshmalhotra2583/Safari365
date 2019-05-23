@isTest
private class Test_FetchCalculatedValues {

   static testMethod void myUnitTest() 
   {
        String sText ='ABX9043092058';
        FetchCalculatedValues calcuValue= new FetchCalculatedValues();
       /* calcuValue.SelectedOPDForAdult =sText;
        calcuValue.SelectedOPDForChild =sText;
        calcuValue.SelectedOPDForInfant =sText;
        calcuValue.SelectedOSR =sText;
        calcuValue.TotalAdultRate =sText;
        calcuValue.TotalAdultRate=sText;
        calcuValue.TotalChildRate=sText;
        calcuValue.TotalInfantRate=sText;
        calcuValue.PerAdultRate=sText;
        calcuValue.PerChildRate=sText;
        calcuValue.PerInfantRate=sText;
        calcuValue.Discount=sText;
        calcuValue.IsDiscountAvailable=sText;
        calcuValue.TargetObjectName=sText;
        calcuValue.ErrorMessages=sText;
        calcuValue.ChargeTypeExtraRatesForAdult=sText;
        calcuValue.ChargeTypeExtraRatesForChild=sText;
        calcuValue.ChargeTypeExtraRatesForInfant=sText;*/
     }
     
     
    static testMethod void PaymentSummaryWrapperTest() 
    {
        String sText ='100';
        PaymentSummaryWrapper calcuValue= new PaymentSummaryWrapper();
        calcuValue.DepositeDueAmount =sText;
        calcuValue.DepositeDueDate =sText;
        calcuValue.BalanceDueAmount =sText;
        calcuValue.BalanceDueDate =sText;
       
     }
     
     
     static testMethod void ProfileAnalysisWrapperTest() 
     {
        String sText ='100';
        ProfileAnalysisWrapper calcuValue= new ProfileAnalysisWrapper();
        calcuValue.QuotationSale =sText;
        calcuValue.QuotationCost =sText;
        calcuValue.QuotationProfit =sText;
        calcuValue.QuotationGross =sText;
        calcuValue.GrandTotal =sText;
       
     }
     
     static testMethod void PricePerPersonSummaryWrapperTest() 
     {
        String sText ='100';
        PricePerPersonSummaryWrapper calcuValue= new PricePerPersonSummaryWrapper();
        calcuValue.PassengerId =sText;
        calcuValue.PassengerName =sText;
        calcuValue.Amount =sText;
       
     }
     
     
     static testMethod void LegDayDetailTest() 
     {
        String sText ='100';
        LegDayDetail calcuValue= new LegDayDetail();
        //calcuValue.LegDate =sText;
        //calcuValue.LegDayServiceLineItem =sText;
        //calcuValue.LegServiceLineItems =sText;
       
     }
     
     static testMethod void PicklistEntryWrapperTest() 
     {
        String sText ='100';
        PicklistEntryWrapper calcuValue= new PicklistEntryWrapper();
        calcuValue.active =sText;
        calcuValue.defaultValue=sText;
	    calcuValue.label=sText;
	    calcuValue.value =sText;
	    calcuValue.validFor=sText;
       
     }
     
     static testMethod void ServiceLinePassengerWrapperTest() 
     {
        ServiceLinePassengerWrapper calcuValue= new ServiceLinePassengerWrapper();
       // insert a new passenger and assign here 
        //calcuValue.Passenger =sText;
        calcuValue.IsSelected=false;
       
     }
     
}
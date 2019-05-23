public class QuotationPricingHelper
{
    public static QuotationBuilderDatabaseQueries dao = new QuotationBuilderDatabaseQueries();
    public static Map<String,Decimal> CCROEForUSDZAREURMapping = new Map<String,Decimal>();
    
    public static QuotationPricingSummaryWrapper getQuotationPricingDetails(String quotationId,Map<String,Decimal> CCROEForUSDZAREURMap)
    {
        CCROEForUSDZAREURMapping = CCROEForUSDZAREURMap;
        Quotations__c quotation = dao.getQuotationForPricingSummary(quotationId);
        QuotationPricingSummaryWrapper summary = new QuotationPricingSummaryWrapper();
        SetPerPersonSummary(summary,quotation);
        SetPaymentSummary(summary,quotation);
        SetPaymentClientCurrency(summary,quotation);
        return summary;
    } 

    public static void SetPerPersonSummary(QuotationPricingSummaryWrapper summary,Quotations__c quotation)
    {
      
      //FetchAll QuotationLineItems 
      List<QuotationLineItem__c> allQuotationLineItems = dao.GetQuotationLineItems(quotation.Id);
      List<Id> allQuotationLineItemsIds = new List<Id>();
      for(QuotationLineItem__c qli: allQuotationLineItems)
      {
        allQuotationLineItemsIds.add(qli.Id);
      }
      
      //FetchAll Related ServiceLineItems 
       List<ServiceLineItem__c> allServiceLineItems = dao.getRelatedQuotationServiceLineItems(allQuotationLineItemsIds);
      
       //FetchAll Related Charge Types
       Set<String> serviceLineitemIds = new Set<String>();
       for(ServiceLineItem__c sli:allServiceLineItems) 
       {
           serviceLineitemIds.add(sli.Id);
       }
       
       //Fetch All selected Passengers from the QuotationId
       List<Passenger__c> selectedPassengers = dao.GetServiceLineItemsPassengers(serviceLineitemIds);
       Set<String> selectedPassengerIds = new Set<String>();
       for(Passenger__c p:selectedPassengers)
       {
           selectedPassengerIds.add(p.Id);
       }
       
       List<Passenger__c>  Passengers = DAL_Passenger.getByIds(new List<String>(selectedPassengerIds));
       Map<Id,Passenger__c> passengerIdToPassangerMap =new Map<Id, Passenger__c>();
       for(Passenger__c p: Passengers)
       {
         passengerIdToPassangerMap.put(p.Id,p);
       }
       
       AggregateResult[] zarTotals =dao.getTotalPricePerPassengers(serviceLineitemIds,selectedPassengerIds,'ZAR');
       AggregateResult[] usdTotals =dao.getTotalPricePerPassengers(serviceLineitemIds,selectedPassengerIds,'USD');
       AggregateResult[] eurTotals =dao.getTotalPricePerPassengers(serviceLineitemIds,selectedPassengerIds,'EUR');
       
       summary.PricePerPersonSummaryZAR = new List<PricePerPersonSummaryWrapper>();
       summary.PricePerPersonSummaryUSD = new List<PricePerPersonSummaryWrapper>();
       summary.PricePerPersonSummaryEUR = new List<PricePerPersonSummaryWrapper>();
       summary.TotalPricePerPersonSummaryClientCurrency = new List<TotalPricePerPersonSummaryWrapper>();
       
       PopulatePassengerTotal(zarTotals,summary.PricePerPersonSummaryZAR,quotation,passengerIdToPassangerMap,'ZAR');
       PopulatePassengerTotal(usdTotals,summary.PricePerPersonSummaryUSD,quotation,passengerIdToPassangerMap,'USD');
       PopulatePassengerTotal(eurTotals,summary.PricePerPersonSummaryEUR,quotation,passengerIdToPassangerMap,'EUR');
       
       populatePassengerTotalInClientCurrent(selectedPassengerIds,summary.PricePerPersonSummaryZAR,summary.PricePerPersonSummaryUSD,
                                             summary.PricePerPersonSummaryEUR,passengerIdToPassangerMap,
                                             summary.TotalPricePerPersonSummaryClientCurrency);
   }
   
   public static void populatePassengerTotalInClientCurrent(Set<String> selectedPassengerIds,List<PricePerPersonSummaryWrapper> ppsWrapperZAR,
                                                             List<PricePerPersonSummaryWrapper> ppsWrapperUSD,List<PricePerPersonSummaryWrapper> ppsWrapperEUR,
                                                             Map<Id,Passenger__c>  passengerIdToPassangerMap,List<TotalPricePerPersonSummaryWrapper> totalPrice)
    {
       Map<String, Integer> totalValueInUSDMap = new Map<String, Integer>();
       Map<String, Integer> totalValueInAUDMap = new Map<String, Integer>();
       Map<String, Integer> totalValueInEURMap = new Map<String, Integer>();
       Map<String, Integer> totalValueInGBPMap = new Map<String, Integer>();
       
       for(String passengerId: selectedPassengerIds)
       {
           for(PricePerPersonSummaryWrapper wrapperZAR: ppsWrapperZAR)
           {
             if(passengerId == wrapperZAR.PassengerId)
             {
               String passsengerAmountInUSD = wrapperZAR.AmountINUSD;
               String passsengerAmountInAUD = wrapperZAR.AmountINAUD;
               String passsengerAmountInEUR = wrapperZAR.AmountINEUR;
               String passsengerAmountInGBP = wrapperZAR.AmountInGBP;
               if(null != totalValueInUSDMap.get(passengerId))
               {
                 Integer passsengerAmountInUSD1 = totalValueInUSDMap.get(passengerId)+ Integer.valueof(passsengerAmountInUSD);
                 totalValueInUSDMap.put(passengerId,passsengerAmountInUSD1);
               }
               else{
                 totalValueInUSDMap.put(passengerId,Integer.valueof(passsengerAmountInUSD));
               }
               
               if(null != totalValueInAUDMap.get(passengerId))
               {
                 Integer passsengerAmountInAUD1 = totalValueInAUDMap.get(passengerId)+ Integer.valueof(passsengerAmountInAUD);
                 totalValueInAUDMap.put(passengerId,passsengerAmountInAUD1);
               }
               else
               {
                 totalValueInAUDMap.put(passengerId,Integer.valueof(passsengerAmountInAUD));
               }
               
               if(null != totalValueInEURMap.get(passengerId))
               {
                 Integer passsengerAmountInEUR1 = totalValueInEURMap.get(passengerId)+ Integer.valueof(passsengerAmountInEUR);
                 totalValueInEURMap.put(passengerId,passsengerAmountInEUR1);
               }
               else{
                 totalValueInEURMap.put(passengerId,Integer.valueof(passsengerAmountInEUR));
               }
               
               if(null != totalValueInGBPMap.get(passengerId))
               {
                 Integer passsengerAmountInGBP1 = totalValueInGBPMap.get(passengerId)+ Integer.valueof(passsengerAmountInGBP);
                 totalValueInGBPMap.put(passengerId,passsengerAmountInGBP1);
               }
               else{
                 totalValueInGBPMap.put(passengerId,Integer.valueof(passsengerAmountInGBP));
               }
             }
           }
           
           for(PricePerPersonSummaryWrapper wrapperUSD: ppsWrapperUSD)
           {
             if(passengerId == wrapperUSD.PassengerId)
             {
               String passsengerAmountInUSD = wrapperUSD.AmountINUSD;
               String passsengerAmountInAUD = wrapperUSD.AmountINAUD;
               String passsengerAmountInEUR = wrapperUSD.AmountINEUR;
               String passsengerAmountInGBP = wrapperUSD.AmountInGBP;
               if(null != totalValueInUSDMap.get(passengerId))
               {
                 Integer passsengerAmountInUSD1 = totalValueInUSDMap.get(passengerId)+ Integer.valueof(passsengerAmountInUSD);
                 totalValueInUSDMap.put(passengerId,passsengerAmountInUSD1);
               }
               else{
                 totalValueInUSDMap.put(passengerId,Integer.valueof(passsengerAmountInUSD));
               }
               
               if(null != totalValueInAUDMap.get(passengerId))
               {
                 Integer passsengerAmountInAUD1 = totalValueInAUDMap.get(passengerId)+ Integer.valueof(passsengerAmountInAUD);
                 totalValueInAUDMap.put(passengerId,passsengerAmountInAUD1);
               }
               else{
                 totalValueInAUDMap.put(passengerId,Integer.valueof(passsengerAmountInAUD));
               }
               
               if(null != totalValueInEURMap.get(passengerId))
               {
                 Integer passsengerAmountInEUR1 = totalValueInEURMap.get(passengerId)+ Integer.valueof(passsengerAmountInEUR);
                 totalValueInEURMap.put(passengerId,passsengerAmountInEUR1);
               }
               else{
                 totalValueInEURMap.put(passengerId,Integer.valueof(passsengerAmountInEUR));
               }
               
               if(null != totalValueInGBPMap.get(passengerId))
               {
                 Integer passsengerAmountInGBP1 = totalValueInGBPMap.get(passengerId)+ Integer.valueof(passsengerAmountInGBP);
                 totalValueInGBPMap.put(passengerId,passsengerAmountInGBP1);
               }
               else{
                 totalValueInGBPMap.put(passengerId,Integer.valueof(passsengerAmountInGBP));
               }
             }
           }
           
           for(PricePerPersonSummaryWrapper wrapperEUR: ppsWrapperEUR)
           {
             if(passengerId == wrapperEUR.PassengerId)
             {
               String passsengerAmountInUSD = wrapperEUR.AmountINUSD;
               String passsengerAmountInAUD = wrapperEUR.AmountINAUD;
               String passsengerAmountInEUR = wrapperEUR.AmountINEUR;
               String passsengerAmountInGBP = wrapperEUR.AmountInGBP;
               if(null != totalValueInUSDMap.get(passengerId))
               {
                 Integer passsengerAmountInUSD1 = totalValueInUSDMap.get(passengerId)+ Integer.valueof(passsengerAmountInUSD);
                 totalValueInUSDMap.put(passengerId,passsengerAmountInUSD1);
               }
               else{
                 totalValueInUSDMap.put(passengerId,Integer.valueof(passsengerAmountInUSD));
               }
               
               if(null != totalValueInAUDMap.get(passengerId))
               {
                 Integer passsengerAmountInAUD1 = totalValueInAUDMap.get(passengerId)+ Integer.valueof(passsengerAmountInAUD);
                 totalValueInAUDMap.put(passengerId,passsengerAmountInAUD1);
               }
               else{
                 totalValueInAUDMap.put(passengerId,Integer.valueof(passsengerAmountInAUD));
               }
               
               if(null != totalValueInEURMap.get(passengerId))
               {
                 Integer passsengerAmountInEUR1 = totalValueInEURMap.get(passengerId)+ Integer.valueof(passsengerAmountInEUR);
                 totalValueInEURMap.put(passengerId,passsengerAmountInEUR1);
               }
               else{
                 totalValueInEURMap.put(passengerId,Integer.valueof(passsengerAmountInEUR));
               }
               
               if(null != totalValueInGBPMap.get(passengerId))
               {
                 Integer passsengerAmountInGBP1 = totalValueInGBPMap.get(passengerId)+ Integer.valueof(passsengerAmountInGBP);
                 totalValueInGBPMap.put(passengerId,passsengerAmountInGBP1);
               }
               else{
                 totalValueInGBPMap.put(passengerId,Integer.valueof(passsengerAmountInGBP));
               }
             }
           }
       }
     for(String passengerId: selectedPassengerIds)
     {
       TotalPricePerPersonSummaryWrapper totalPriceWrapper = new TotalPricePerPersonSummaryWrapper();
       totalPriceWrapper.PassengerId=passengerId;
       totalPriceWrapper.PassengerName = passengerIdToPassangerMap.get(passengerId).PassengerName__c;
       totalPriceWrapper.TotalAmountINUSD = String.valueof(totalValueInUSDMap.get(PassengerId));
       totalPriceWrapper.TotalAmountINEUR = String.valueof(totalValueInEURMap.get(PassengerId));
       totalPriceWrapper.TotalAmountINAUD= String.valueof(totalValueInAUDMap.get(PassengerId));
       totalPriceWrapper.TotalAmountInGBP= String.valueof(totalValueInGBPMap.get(PassengerId));
       totalPrice.add(totalPriceWrapper);
     }
    }
    
    public static void PopulatePassengerTotal(AggregateResult[] allTotals,List<PricePerPersonSummaryWrapper> ppsWrapper,
                          Quotations__c quotation, Map<Id,Passenger__c> passengerIdToPassangerMap, String currencyType)
    {
        
        List<String> PassengerIds = new List<String>();
        for(AggregateResult ct:allTotals)
        {
            PricePerPersonSummaryWrapper pps = new PricePerPersonSummaryWrapper();
            pps.PassengerId = String.valueOf(ct.get('Selected_Passenger__c'));
            Decimal decimalAmount=Decimal.valueof(String.valueOf(ct.get('total'))).round(System.RoundingMode.CEILING);
            pps.Amount = String.valueOf(decimalAmount);
            if(currencyType =='ZAR')
            {
                if(null!=quotation.CC_ROE_for_ZAR_in_USD__c && null!=quotation.CC_ROE_for_ZAR_in_AUD__c && null!=quotation.CC_ROE_for_ZAR_in_EUR__c && null!=quotation.CC_ROE_for_ZAR_in_GPB__c){
                      pps.AmountINUSD = String.valueOf(((decimalAmount*quotation.CC_ROE_for_ZAR_in_USD__c).round(System.RoundingMode.CEILING)));
                      pps.AmountINAUD = String.valueOf((decimalAmount*quotation.CC_ROE_for_ZAR_in_AUD__c).round(System.RoundingMode.CEILING));
                      pps.AmountINEUR= String.valueOf((decimalAmount*quotation.CC_ROE_for_ZAR_in_EUR__c).round(System.RoundingMode.CEILING));
                      pps.AmountInGBP = String.valueOf((decimalAmount*quotation.CC_ROE_for_ZAR_in_GPB__c).round(System.RoundingMode.CEILING));
                }else{
                      Decimal CC_ROE_for_ZAR_in_USD = null!=CCROEForUSDZAREURMapping.get('CC_ROE_for_ZAR_in_USD__c')?CCROEForUSDZAREURMapping.get('CC_ROE_for_ZAR_in_USD__c'):0.0;
                      Decimal CC_ROE_for_ZAR_in_AUD = null!=CCROEForUSDZAREURMapping.get('CC_ROE_for_ZAR_in_AUD__c')?CCROEForUSDZAREURMapping.get('CC_ROE_for_ZAR_in_AUD__c'):0.0;
                      Decimal CC_ROE_for_ZAR_in_EUR = null!=CCROEForUSDZAREURMapping.get('CC_ROE_for_ZAR_in_EUR__c')?CCROEForUSDZAREURMapping.get('CC_ROE_for_ZAR_in_EUR__c'):0.0;
                      Decimal CC_ROE_for_ZAR_in_GPB = null!=CCROEForUSDZAREURMapping.get('CC_ROE_for_ZAR_in_GPB__c')?CCROEForUSDZAREURMapping.get('CC_ROE_for_ZAR_in_GPB__c'):0.0;
                      
                      pps.AmountINUSD = String.valueOf(((decimalAmount*CC_ROE_for_ZAR_in_USD).round(System.RoundingMode.CEILING)));
                      pps.AmountINAUD = String.valueOf((decimalAmount*CC_ROE_for_ZAR_in_USD).round(System.RoundingMode.CEILING));
                      pps.AmountINEUR= String.valueOf((decimalAmount*CC_ROE_for_ZAR_in_EUR).round(System.RoundingMode.CEILING));
                      pps.AmountInGBP = String.valueOf((decimalAmount*CC_ROE_for_ZAR_in_GPB).round(System.RoundingMode.CEILING));
                    
                }
            }
            if(currencyType =='USD')
            {
                 if(null!=quotation.CC_ROE_for_USD_in_USD__c && null!=quotation.CC_ROE_for_USD_in_AUD__c && null!=quotation.CC_ROE_for_USD_in_EUR__c && null!=quotation.CC_ROE_for_USD_in_GPB__c){
                     pps.AmountINUSD = String.valueOf(((decimalAmount*quotation.CC_ROE_for_USD_in_USD__c).round(System.RoundingMode.CEILING)));
                     pps.AmountINAUD = String.valueOf((decimalAmount*quotation.CC_ROE_for_USD_in_AUD__c).round(System.RoundingMode.CEILING));
                     pps.AmountINEUR= String.valueOf((decimalAmount*quotation.CC_ROE_for_USD_in_EUR__c).round(System.RoundingMode.CEILING));
                     pps.AmountInGBP = String.valueOf((decimalAmount*quotation.CC_ROE_for_USD_in_GPB__c).round(System.RoundingMode.CEILING));
                 }else{
                    Decimal CC_ROE_for_USD_in_USD = null!=quotation.CC_ROE_for_USD_in_USD__c?quotation.CC_ROE_for_USD_in_USD__c:0.0;
                    Decimal CC_ROE_for_USD_in_AUD = null!=quotation.CC_ROE_for_USD_in_AUD__c?quotation.CC_ROE_for_USD_in_AUD__c:0.0;
                    Decimal CC_ROE_for_USD_in_EUR = null!=quotation.CC_ROE_for_USD_in_EUR__c?quotation.CC_ROE_for_USD_in_EUR__c:0.0;
                    Decimal CC_ROE_for_USD_in_GPB = null!=quotation.CC_ROE_for_USD_in_GPB__c?quotation.CC_ROE_for_USD_in_GPB__c:0.0;
                 
                    pps.AmountINUSD = String.valueOf(((decimalAmount*CC_ROE_for_USD_in_USD).round(System.RoundingMode.CEILING)));
                    pps.AmountINAUD = String.valueOf((decimalAmount*CC_ROE_for_USD_in_AUD).round(System.RoundingMode.CEILING));
                    pps.AmountINEUR= String.valueOf((decimalAmount*CC_ROE_for_USD_in_EUR).round(System.RoundingMode.CEILING));
                    pps.AmountInGBP = String.valueOf((decimalAmount*CC_ROE_for_USD_in_GPB).round(System.RoundingMode.CEILING));
                 
                 }
              
            }
            if(currencyType =='EUR')
            {
              if(null!=quotation.CC_ROE_for_EUR_in_USD__c && null!=quotation.CC_ROE_for_EUR_in_AUD__c && null!=quotation.CC_ROE_for_EUR_in_EUR__c && null!=quotation.CC_ROE_for_EUR_in_GPB__c){
                  pps.AmountINUSD = String.valueOf(((decimalAmount*quotation.CC_ROE_for_EUR_in_USD__c).round(System.RoundingMode.CEILING)));
                  pps.AmountINAUD = String.valueOf((decimalAmount*quotation.CC_ROE_for_EUR_in_AUD__c).round(System.RoundingMode.CEILING));
                  pps.AmountINEUR= String.valueOf((decimalAmount*quotation.CC_ROE_for_EUR_in_EUR__c).round(System.RoundingMode.CEILING));
                  pps.AmountInGBP = String.valueOf((decimalAmount*quotation.CC_ROE_for_EUR_in_GPB__c).round(System.RoundingMode.CEILING));
              }else{
                  Decimal CC_ROE_for_EUR_in_USD = null!=quotation.CC_ROE_for_EUR_in_USD__c?quotation.CC_ROE_for_EUR_in_USD__c:0.0;
                  Decimal CC_ROE_for_EUR_in_AUD = null!=quotation.CC_ROE_for_EUR_in_AUD__c?quotation.CC_ROE_for_EUR_in_AUD__c:0.0;
                  Decimal CC_ROE_for_EUR_in_EUR = null!=quotation.CC_ROE_for_EUR_in_EUR__c?quotation.CC_ROE_for_EUR_in_EUR__c:0.0;
                  Decimal CC_ROE_for_EUR_in_GPB = null!=quotation.CC_ROE_for_EUR_in_GPB__c?quotation.CC_ROE_for_EUR_in_GPB__c:0.0;
                    
                  pps.AmountINUSD = String.valueOf(((decimalAmount*CC_ROE_for_EUR_in_USD).round(System.RoundingMode.CEILING)));
                  pps.AmountINAUD = String.valueOf((decimalAmount*CC_ROE_for_EUR_in_AUD).round(System.RoundingMode.CEILING));
                  pps.AmountINEUR= String.valueOf((decimalAmount*CC_ROE_for_EUR_in_EUR).round(System.RoundingMode.CEILING));
                  pps.AmountInGBP = String.valueOf((decimalAmount*CC_ROE_for_EUR_in_GPB).round(System.RoundingMode.CEILING));
              }
            }
            
            
            ppsWrapper.add(pps);
            PassengerIds.add(pps.PassengerId);
        }
        
        for(Passenger__c p:passengerIdToPassangerMap.values())
        {
            for(PricePerPersonSummaryWrapper pps :ppsWrapper)
            {
                if(pps.PassengerId == p.Id)
                {
                    pps.PassengerName = p.PassengerName__c;
                }
            }
        }
    }
    
    public static void SetPaymentSummary(QuotationPricingSummaryWrapper summary,Quotations__c quotation)
    {
       
        Map<String,Decimal> mapCurrencyToDiscountValue  =dao.getPaymentDiscountsForQuotation();
        Map<String,Decimal> mapCurrencyToDayDifference  =dao.getDueDateDifferenceForQuotation();
        
        Decimal discountPercentageZAR = mapCurrencyToDiscountValue.get('ZAR').round(System.RoundingMode.CEILING);//dao.GetPaymentDiscountsForQuotation('ZAR');
        Decimal discountPercentageUSD = mapCurrencyToDiscountValue.get('USD').round(System.RoundingMode.CEILING);//dao.GetPaymentDiscountsForQuotation('USD');
        Decimal discountPercentageEUR = mapCurrencyToDiscountValue.get('EUR').round(System.RoundingMode.CEILING);//dao.GetPaymentDiscountsForQuotation('EUR');
        Decimal discountPercentageOther = mapCurrencyToDiscountValue.get('Other').setscale(2);
        
        Decimal dueDateDifferenceZAR = mapCurrencyToDayDifference.get('ZAR').round(System.RoundingMode.CEILING);//dao.GetDueDateDifferenceForQuotation('ZAR');
        Decimal dueDateDifferenceUSD = mapCurrencyToDayDifference.get('USD').round(System.RoundingMode.CEILING);//dao.GetDueDateDifferenceForQuotation('USD');
        Decimal dueDateDifferenceEUR = mapCurrencyToDayDifference.get('EUR').round(System.RoundingMode.CEILING);//dao.GetDueDateDifferenceForQuotation('EUR');
        Decimal dueDateDifferenceOther = mapCurrencyToDayDifference.get('Other').round(System.RoundingMode.CEILING);
        
        if(quotation.Total_Sale_In_Zar__c != null && quotation.Total_Sale_In_Zar__c > 0)
        {
            summary.PaymentSummaryZAR = new PaymentSummaryWrapper();
            if(quotation.Opportunity__r.closedate.daysBetween(quotation.Opportunity__r.Arrival_Date__c ) > 60 
               && !quotation.Deposit_Value_Override_By_Consultant__c)
            {
                summary.PaymentSummaryZAR.DepositeDueAmount = String.valueOf((((quotation.Total_Sale_In_Zar__c * discountPercentageZAR)/100).round(System.RoundingMode.CEILING)));
            }
            else
            {
                if(quotation.Deposite_Due_Amount_ZAR__c !=null && quotation.Deposite_Due_Amount_ZAR__c > 0){
                    summary.PaymentSummaryZAR.DepositeDueAmount = String.valueOf((quotation.Deposite_Due_Amount_ZAR__c).round(System.RoundingMode.CEILING));
                }else{
                    summary.PaymentSummaryZAR.DepositeDueAmount = String.valueOf((quotation.Total_Sale_In_Zar__c).round(System.RoundingMode.CEILING));
                }
            }
            summary.PaymentSummaryZAR.DepositeDueDate = String.valueOf(quotation.Deposit_Due_Date__c);
            summary.PaymentSummaryZAR.BalanceDueAmount = String.valueOf(((quotation.Total_Sale_In_Zar__c).round(System.RoundingMode.CEILING))- Decimal.valueof(summary.PaymentSummaryZAR.DepositeDueAmount).round(System.RoundingMode.CEILING));
            summary.PaymentSummaryZAR.BalanceDueDate = String.valueOf(quotation.Opportunity__r.Arrival_Date__c.addDays(Integer.valueOf(dueDateDifferenceZAR)));
        }
        if(quotation.Total_Sale_In_USD__c != null && quotation.Total_Sale_In_USD__c > 0)
        {
            summary.PaymentSummaryUSD = new PaymentSummaryWrapper();
             if(quotation.Opportunity__r.closedate.daysBetween( quotation.Opportunity__r.Arrival_Date__c) >60 
               && !quotation.Deposit_Value_Override_By_Consultant__c)
            {
                summary.PaymentSummaryUSD.DepositeDueAmount = String.valueOf(((quotation.Total_Sale_In_USD__c * discountPercentageUSD)/100).round(System.RoundingMode.CEILING));
            }
            else
            {
                if(quotation.Deposite_Due_Amount_USD__c!=null && quotation.Deposite_Due_Amount_USD__c > 0){
                    summary.PaymentSummaryUSD.DepositeDueAmount = String.valueOf((quotation.Deposite_Due_Amount_USD__c).round(System.RoundingMode.CEILING));
                }else{
                    summary.PaymentSummaryUSD.DepositeDueAmount = String.valueOf((quotation.Total_Sale_In_USD__c).round(System.RoundingMode.CEILING));
                }
              
            }
            summary.PaymentSummaryUSD.DepositeDueDate = String.valueOf(quotation.Deposit_Due_Date__c);
            summary.PaymentSummaryUSD.BalanceDueAmount =String.valueOf(((quotation.Total_Sale_In_USD__c).round(System.RoundingMode.CEILING)) - Decimal.valueof(summary.PaymentSummaryUSD.DepositeDueAmount).round(System.RoundingMode.CEILING));
            summary.PaymentSummaryUSD.BalanceDueDate = String.valueOf(quotation.Opportunity__r.Arrival_Date__c.addDays(Integer.valueOf(dueDateDifferenceUSD)));
        }
       
        if(quotation.Sale_in_EUR__c != null && Integer.valueof(quotation.Sale_in_EUR__c) >= 0)
        {
             summary.PaymentSummaryEUR = new PaymentSummaryWrapper();
             if(quotation.Opportunity__r.closedate.daysBetween(quotation.Opportunity__r.Arrival_Date__c) >60
               && !quotation.Deposit_Value_Override_By_Consultant__c)
            {
                summary.PaymentSummaryEUR.DepositeDueAmount = String.valueOf(((quotation.Sale_in_EUR__c * discountPercentageEUR)/100).round(System.RoundingMode.CEILING));
            }
            else
            {
                if(quotation.Deposite_Due_Amount_EUR__c !=null && quotation.Deposite_Due_Amount_EUR__c > 0)
                {
                    summary.PaymentSummaryEUR.DepositeDueAmount = String.valueOf((quotation.Deposite_Due_Amount_EUR__c).round(System.RoundingMode.CEILING));
                }
                else
                {
                    summary.PaymentSummaryEUR.DepositeDueAmount = String.valueOf((quotation.Sale_in_EUR__c).round(System.RoundingMode.CEILING));
                } 
            }
            summary.PaymentSummaryEUR.DepositeDueDate = String.valueOf(quotation.Deposit_Due_Date__c);      
            summary.PaymentSummaryEUR.BalanceDueAmount =String.valueOf(((quotation.Sale_in_EUR__c).round(System.RoundingMode.CEILING)) - Decimal.valueof(summary.PaymentSummaryEUR.DepositeDueAmount).round(System.RoundingMode.CEILING));
            summary.PaymentSummaryEUR.BalanceDueDate = String.valueOf(quotation.Opportunity__r.Arrival_Date__c.addDays(Integer.valueOf(dueDateDifferenceEUR)));
        }
        
        if(quotation.Quotation_Sale_Total_in_CC__c != null && quotation.Quotation_Sale_Total_in_CC__c > 0)
        {
            summary.PaymentSummaryClientCurrency = new PaymentSummaryWrapper();
             if(quotation.Opportunity__r.closedate.daysBetween(quotation.Opportunity__r.Arrival_Date__c) >60)
            {
                summary.PaymentSummaryClientCurrency.DepositeDueAmount = String.valueOf(((quotation.Quotation_Sale_Total_in_CC__c * discountPercentageOther)/100).round(System.RoundingMode.CEILING));
            }
            else
            {
              summary.PaymentSummaryClientCurrency.DepositeDueAmount = String.valueOf((quotation.Quotation_Sale_Total_in_CC__c).round(System.RoundingMode.CEILING));
            }
            
            summary.PaymentSummaryClientCurrency.DepositeDueDate = String.valueOf(quotation.Opportunity__r.CloseDate);
            summary.PaymentSummaryClientCurrency.BalanceDueAmount =String.valueOf(((quotation.Quotation_Sale_Total_in_CC__c).round(System.RoundingMode.CEILING)) - Decimal.valueof(summary.PaymentSummaryClientCurrency.DepositeDueAmount).round(System.RoundingMode.CEILING));
            summary.PaymentSummaryClientCurrency.BalanceDueDate = String.valueOf(quotation.Opportunity__r.Arrival_Date__c.addDays(Integer.valueOf(dueDateDifferenceOther)));
            summary.PaymentSummaryClientCurrency.clientCurrency = quotation.Currency__c;
        }
        
    }
    
     public static void SetPaymentClientCurrency(QuotationPricingSummaryWrapper summary,Quotations__c quotation){
        
        summary.ClientSelectedCurrency =quotation.Currency__c;
        summary.PaymentClientCurrency = new ProfileAnalysisWrapper();
        if(quotation.Currency__c=='USD')
        {
         summary.PaymentClientCurrency.QuotationSales = String.valueOf((quotation.Quotation_Sale_Total_in_CC_USD__c).round(System.RoundingMode.CEILING));
        }
        else if(quotation.Currency__c=='AUD')
        {
            summary.PaymentClientCurrency.QuotationSales = String.valueOf((quotation.Quotation_Sale_Total_in_CC_AUD__c).round(System.RoundingMode.CEILING));
        }
        else if(quotation.Currency__c=='EUR')
        {
            summary.PaymentClientCurrency.QuotationSales = String.valueOf((quotation.Quotation_Sale_Total_in_CC_EUR__c).round(System.RoundingMode.CEILING));
        }
        else if(quotation.Currency__c=='GBP')
        {
            summary.PaymentClientCurrency.QuotationSales = String.valueOf((quotation.Quotation_Sale_Total_in_CC_GBP__c).round(System.RoundingMode.CEILING));
        }
                
        if(quotation.Deposit_Due_Date__c != null){
            summary.PaymentClientCurrency.DepositDueDate = String.valueOf(quotation.Deposit_Due_Date__c);
        } 
        /*========================================================= AUD Currency ==============================================================*/
        if(quotation.Currency__c=='AUD' && null != quotation.Deposite_Due_Amount_USD__c  && null !=quotation.Deposite_Due_Amount_EUR__c && null != quotation.Deposite_Due_Amount_ZAR__c)
        {
            if(null!=quotation.CC_ROE_for_USD_in_AUD__c && null!=quotation.CC_ROE_for_ZAR_in_AUD__c && null!=quotation.CC_ROE_for_EUR_in_AUD__c){
                summary.PaymentClientCurrency.DepositDueAmount =  String.valueof(((quotation.Deposite_Due_Amount_USD__c * quotation.CC_ROE_for_USD_in_AUD__c) + ( quotation.Deposite_Due_Amount_ZAR__c*quotation.CC_ROE_for_ZAR_in_AUD__c)
                + (quotation.Deposite_Due_Amount_EUR__c*quotation.CC_ROE_for_EUR_in_AUD__c)).round(System.RoundingMode.CEILING));
            
            }else{
                 Decimal CC_ROE_for_USD_in_AUD =  null!=CCROEForUSDZAREURMapping.get('CC_ROE_for_USD_in_AUD__c')?CCROEForUSDZAREURMapping.get('CC_ROE_for_USD_in_AUD__c'):0.0;
                 Decimal CC_ROE_for_ZAR_in_AUD =  null!=CCROEForUSDZAREURMapping.get('CC_ROE_for_ZAR_in_AUD__c')?CCROEForUSDZAREURMapping.get('CC_ROE_for_ZAR_in_AUD__c'):0.0;
                 Decimal CC_ROE_for_EUR_in_AUD =  null!=CCROEForUSDZAREURMapping.get('CC_ROE_for_EUR_in_AUD__c')?CCROEForUSDZAREURMapping.get('CC_ROE_for_EUR_in_AUD__c'):0.0;
                
                summary.PaymentClientCurrency.DepositDueAmount =  String.valueof(((quotation.Deposite_Due_Amount_USD__c * CC_ROE_for_USD_in_AUD) + ( quotation.Deposite_Due_Amount_ZAR__c*CC_ROE_for_ZAR_in_AUD)
                + (quotation.Deposite_Due_Amount_EUR__c*CC_ROE_for_EUR_in_AUD)).round(System.RoundingMode.CEILING));
            
            } 
         }
        else if (quotation.Currency__c=='AUD'){
            if(null!=quotation.CC_ROE_for_USD_in_AUD__c && null!=quotation.CC_ROE_for_ZAR_in_AUD__c && null!=quotation.CC_ROE_for_EUR_in_AUD__c){
            	
            	 Decimal paymentSummaryUSd =0;
                     if(null != summary.PaymentSummaryUSD &&  null != summary.PaymentSummaryUSD.DepositeDueAmount)
                     paymentSummaryUSd = (Decimal.valueof(summary.PaymentSummaryUSD.DepositeDueAmount) * quotation.CC_ROE_for_USD_in_AUD__c).round(System.RoundingMode.CEILING);
                  
                     Decimal PaymentSummaryEUR =0;
                     if(null != summary.PaymentSummaryEUR && null != summary.PaymentSummaryEUR.DepositeDueAmount)
                     PaymentSummaryEUR = (Decimal.valueof(summary.PaymentSummaryEUR.DepositeDueAmount)* quotation.CC_ROE_for_EUR_in_AUD__c).round(System.RoundingMode.CEILING);
                     
                     Decimal PaymentSummaryZAR =0;
                     if( null != summary.PaymentSummaryZAR && null != summary.PaymentSummaryZAR.DepositeDueAmount)
                     PaymentSummaryZAR = (Decimal.valueof(summary.PaymentSummaryZAR.DepositeDueAmount)* quotation.CC_ROE_for_ZAR_in_AUD__c).round(System.RoundingMode.CEILING);
                    
                    summary.PaymentClientCurrency.DepositDueAmount = String.valueof(paymentSummaryUSd+PaymentSummaryEUR+PaymentSummaryZAR);
            	
                /*summary.PaymentClientCurrency.DepositDueAmount = String.valueof((Decimal.valueof(summary.PaymentSummaryUSD.DepositeDueAmount)* quotation.CC_ROE_for_USD_in_AUD__c).round(System.RoundingMode.CEILING)
                +(Decimal.valueof(summary.PaymentSummaryZAR.DepositeDueAmount)* quotation.CC_ROE_for_ZAR_in_AUD__c).round(System.RoundingMode.CEILING)
                +(Decimal.valueof(summary.PaymentSummaryEUR.DepositeDueAmount)* quotation.CC_ROE_for_EUR_in_AUD__c).round(System.RoundingMode.CEILING));*/
            }else{
                Decimal CC_ROE_for_USD_in_AUD =  null!=CCROEForUSDZAREURMapping.get('CC_ROE_for_USD_in_AUD__c')?CCROEForUSDZAREURMapping.get('CC_ROE_for_USD_in_AUD__c'):0.0;
                Decimal CC_ROE_for_ZAR_in_AUD =  null!=CCROEForUSDZAREURMapping.get('CC_ROE_for_ZAR_in_AUD__c')?CCROEForUSDZAREURMapping.get('CC_ROE_for_ZAR_in_AUD__c'):0.0;
                Decimal CC_ROE_for_EUR_in_AUD =  null!=CCROEForUSDZAREURMapping.get('CC_ROE_for_EUR_in_AUD__c')?CCROEForUSDZAREURMapping.get('CC_ROE_for_EUR_in_AUD__c'):0.0;
                 
                summary.PaymentClientCurrency.DepositDueAmount = String.valueof((Decimal.valueof(summary.PaymentSummaryUSD.DepositeDueAmount)*CC_ROE_for_USD_in_AUD).round(System.RoundingMode.CEILING)
                +(Decimal.valueof(summary.PaymentSummaryZAR.DepositeDueAmount)*CC_ROE_for_ZAR_in_AUD).round(System.RoundingMode.CEILING)
                +(Decimal.valueof(summary.PaymentSummaryEUR.DepositeDueAmount)*CC_ROE_for_EUR_in_AUD).round(System.RoundingMode.CEILING));
            }
        }
            /*========================================================= AUD Currency ==============================================================*/
            /*========================================================= USD Currency ==============================================================*/
            if(quotation.Currency__c=='USD' && null != quotation.Deposite_Due_Amount_USD__c  && null !=quotation.Deposite_Due_Amount_EUR__c && null != quotation.Deposite_Due_Amount_ZAR__c)
            {
                if(null!=quotation.CC_ROE_for_USD_in_USD__c && null!=quotation.CC_ROE_for_ZAR_in_USD__c && null!=quotation.CC_ROE_for_EUR_in_USD__c){
                    summary.PaymentClientCurrency.DepositDueAmount =   string.valueof(((quotation.Deposite_Due_Amount_USD__c * quotation.CC_ROE_for_USD_in_USD__c) + ( quotation.Deposite_Due_Amount_ZAR__c*quotation.CC_ROE_for_ZAR_in_USD__c)
                    + (quotation.Deposite_Due_Amount_EUR__c*quotation.CC_ROE_for_EUR_in_USD__c)).round(System.RoundingMode.CEILING));
                }
                else
                {
                    Decimal CC_ROE_for_USD_in_USD =  null!=CCROEForUSDZAREURMapping.get('CC_ROE_for_USD_in_USD__c')?CCROEForUSDZAREURMapping.get('CC_ROE_for_USD_in_USD__c'):0.0;
                    Decimal CC_ROE_for_ZAR_in_USD =  null!=CCROEForUSDZAREURMapping.get('CC_ROE_for_ZAR_in_USD__c')?CCROEForUSDZAREURMapping.get('CC_ROE_for_ZAR_in_USD__c'):0.0; 
                    Decimal CC_ROE_for_EUR_in_USD =  null!=CCROEForUSDZAREURMapping.get('CC_ROE_for_EUR_in_USD__c')?CCROEForUSDZAREURMapping.get('CC_ROE_for_EUR_in_USD__c'):0.0;
                    
                    summary.PaymentClientCurrency.DepositDueAmount =   string.valueof(((quotation.Deposite_Due_Amount_USD__c * CC_ROE_for_USD_in_USD) + ( quotation.Deposite_Due_Amount_ZAR__c*CC_ROE_for_ZAR_in_USD)
                    + (quotation.Deposite_Due_Amount_EUR__c*CC_ROE_for_EUR_in_USD)).round(System.RoundingMode.CEILING));
                }
                
            }
            else if (quotation.Currency__c=='USD')
            {
                if(null!=quotation.CC_ROE_for_USD_in_USD__c && null!=quotation.CC_ROE_for_ZAR_in_USD__c && null!=quotation.CC_ROE_for_EUR_in_USD__c)
                {
                    
                     
                     Decimal paymentSummaryUSd =0;
                     if(null != summary.PaymentSummaryUSD &&  null != summary.PaymentSummaryUSD.DepositeDueAmount)
                     paymentSummaryUSd = (Decimal.valueof(summary.PaymentSummaryUSD.DepositeDueAmount) * quotation.CC_ROE_for_USD_in_USD__c).round(System.RoundingMode.CEILING);
                  
                     Decimal PaymentSummaryEUR =0;
                     if(null != summary.PaymentSummaryEUR && null != summary.PaymentSummaryEUR.DepositeDueAmount)
                     PaymentSummaryEUR = (Decimal.valueof(summary.PaymentSummaryEUR.DepositeDueAmount)* quotation.CC_ROE_for_EUR_in_USD__c).round(System.RoundingMode.CEILING);
                     
                     Decimal PaymentSummaryZAR =0;
                     if( null != summary.PaymentSummaryZAR && null != summary.PaymentSummaryZAR.DepositeDueAmount)
                     PaymentSummaryZAR = (Decimal.valueof(summary.PaymentSummaryZAR.DepositeDueAmount)* quotation.CC_ROE_for_ZAR_in_USD__c).round(System.RoundingMode.CEILING);
                    
                    summary.PaymentClientCurrency.DepositDueAmount = String.valueof(paymentSummaryUSd+PaymentSummaryEUR+PaymentSummaryZAR);
                     
                     
                     /*summary.PaymentClientCurrency.DepositDueAmount = 
                     String.valueof((Decimal.valueof(summary.PaymentSummaryUSD.DepositeDueAmount)* quotation.CC_ROE_for_USD_in_USD__c).round(System.RoundingMode.CEILING)
                    +(Decimal.valueof(summary.PaymentSummaryZAR.DepositeDueAmount)* quotation.CC_ROE_for_ZAR_in_USD__c).round(System.RoundingMode.CEILING)
                    +(Decimal.valueof(summary.PaymentSummaryEUR.DepositeDueAmount)* quotation.CC_ROE_for_EUR_in_USD__c).round(System.RoundingMode.CEILING));*/
                }
                else
                {
                    Decimal CC_ROE_for_USD_in_USD =  null!=CCROEForUSDZAREURMapping.get('CC_ROE_for_USD_in_USD__c')?CCROEForUSDZAREURMapping.get('CC_ROE_for_USD_in_USD__c'):0.0;
                    Decimal CC_ROE_for_ZAR_in_USD =  null!=CCROEForUSDZAREURMapping.get('CC_ROE_for_ZAR_in_USD__c')?CCROEForUSDZAREURMapping.get('CC_ROE_for_ZAR_in_USD__c'):0.0; 
                    Decimal CC_ROE_for_EUR_in_USD =  null!=CCROEForUSDZAREURMapping.get('CC_ROE_for_EUR_in_USD__c')?CCROEForUSDZAREURMapping.get('CC_ROE_for_EUR_in_USD__c'):0.0;
                    
                    
                     Decimal paymentSummaryUSd =0;
                    if(null != summary.PaymentSummaryUSD &&  null != summary.PaymentSummaryUSD.DepositeDueAmount)
                     paymentSummaryUSd = (Decimal.valueof(summary.PaymentSummaryUSD.DepositeDueAmount)*CC_ROE_for_USD_in_USD).round(System.RoundingMode.CEILING);
                  
                     Decimal PaymentSummaryEUR =0;
                     if(null != summary.PaymentSummaryEUR && null != summary.PaymentSummaryEUR.DepositeDueAmount)
                     PaymentSummaryEUR = (Decimal.valueof(summary.PaymentSummaryEUR.DepositeDueAmount)*CC_ROE_for_EUR_in_USD).round(System.RoundingMode.CEILING);
                     
                     Decimal PaymentSummaryZAR =0;
                     if( null != summary.PaymentSummaryZAR && null != summary.PaymentSummaryZAR.DepositeDueAmount)
                     PaymentSummaryZAR = (Decimal.valueof(summary.PaymentSummaryZAR.DepositeDueAmount)*CC_ROE_for_ZAR_in_USD).round(System.RoundingMode.CEILING);
                    
                    summary.PaymentClientCurrency.DepositDueAmount = String.valueof(paymentSummaryUSd+PaymentSummaryEUR+PaymentSummaryZAR);
                    
                    //summary.PaymentClientCurrency.DepositDueAmount = String.valueof((Decimal.valueof(summary.PaymentSummaryUSD.DepositeDueAmount)* CC_ROE_for_USD_in_USD).round(System.RoundingMode.CEILING)+(Decimal.valueof(summary.PaymentSummaryZAR.DepositeDueAmount)* CC_ROE_for_ZAR_in_USD).round(System.RoundingMode.CEILING)+(Decimal.valueof(summary.PaymentSummaryEUR.DepositeDueAmount)* CC_ROE_for_EUR_in_USD).round(System.RoundingMode.CEILING));
                }
            }
            /*========================================================= USD Currency ==============================================================*/
            /*========================================================= EUR Currency ==============================================================*/
            if(quotation.Currency__c=='EUR' 
                 && null != quotation.Deposite_Due_Amount_USD__c 
            	 && null !=quotation.Deposite_Due_Amount_EUR__c
            	 && null != quotation.Deposite_Due_Amount_ZAR__c)
            {
                if(null!=quotation.CC_ROE_for_USD_in_EUR__c && null!= quotation.CC_ROE_for_ZAR_in_EUR__c && null!=quotation.CC_ROE_for_EUR_in_EUR__c){
                    summary.PaymentClientCurrency.DepositDueAmount =  string.valueof(((quotation.Deposite_Due_Amount_USD__c * quotation.CC_ROE_for_USD_in_EUR__c) + ( quotation.Deposite_Due_Amount_ZAR__c*quotation.CC_ROE_for_ZAR_in_EUR__c)
                    + (quotation.Deposite_Due_Amount_EUR__c*quotation.CC_ROE_for_EUR_in_EUR__c)).round(System.RoundingMode.CEILING));
                }else{
                    Decimal CC_ROE_for_USD_in_EUR =  null!=CCROEForUSDZAREURMapping.get('CC_ROE_for_USD_in_EUR__c')?CCROEForUSDZAREURMapping.get('CC_ROE_for_USD_in_EUR__c'):0.0;
                    Decimal CC_ROE_for_ZAR_in_EUR =  null!=CCROEForUSDZAREURMapping.get('CC_ROE_for_ZAR_in_EUR__c')?CCROEForUSDZAREURMapping.get('CC_ROE_for_ZAR_in_EUR__c'):0.0;
                    Decimal CC_ROE_for_EUR_in_EUR =  null!=CCROEForUSDZAREURMapping.get('CC_ROE_for_EUR_in_EUR__c')?CCROEForUSDZAREURMapping.get('CC_ROE_for_EUR_in_EUR__c'):0.0;
                    summary.PaymentClientCurrency.DepositDueAmount =  string.valueof(((quotation.Deposite_Due_Amount_USD__c * CC_ROE_for_USD_in_EUR) + ( quotation.Deposite_Due_Amount_ZAR__c*CC_ROE_for_ZAR_in_EUR)
                    + (quotation.Deposite_Due_Amount_EUR__c*CC_ROE_for_EUR_in_EUR)).round(System.RoundingMode.CEILING));
                }
            }
            else if (quotation.Currency__c=='EUR')
            {
                if(null!=quotation.CC_ROE_for_USD_in_EUR__c && null!= quotation.CC_ROE_for_ZAR_in_EUR__c && null!=quotation.CC_ROE_for_EUR_in_EUR__c)
                {
                    Decimal paymentSummaryUSd =0;
                   if(null != summary.PaymentSummaryUSD &&  null != summary.PaymentSummaryUSD.DepositeDueAmount)
                   paymentSummaryUSd = (Decimal.valueof(summary.PaymentSummaryUSD.DepositeDueAmount)* quotation.CC_ROE_for_USD_in_EUR__c).round(System.RoundingMode.CEILING);
              
                 Decimal PaymentSummaryEUR =0;
                 if(null != summary.PaymentSummaryEUR && null != summary.PaymentSummaryEUR.DepositeDueAmount)
                 PaymentSummaryEUR = (Decimal.valueof(summary.PaymentSummaryEUR.DepositeDueAmount)* quotation.CC_ROE_for_ZAR_in_EUR__c).round(System.RoundingMode.CEILING);
                 
                 Decimal PaymentSummaryZAR =0;
                 if( null != summary.PaymentSummaryZAR && null != summary.PaymentSummaryZAR.DepositeDueAmount)
                 PaymentSummaryZAR = (Decimal.valueof(summary.PaymentSummaryZAR.DepositeDueAmount)* quotation.CC_ROE_for_ZAR_in_EUR__c).round(System.RoundingMode.CEILING);
                    summary.PaymentClientCurrency.DepositDueAmount = String.valueof(paymentSummaryUSd+PaymentSummaryEUR+PaymentSummaryZAR);
                }
                else
                {
                    Decimal CC_ROE_for_USD_in_EUR =  null!=CCROEForUSDZAREURMapping.get('CC_ROE_for_USD_in_EUR__c')?CCROEForUSDZAREURMapping.get('CC_ROE_for_USD_in_EUR__c'):0.0;
                    Decimal CC_ROE_for_ZAR_in_EUR =  null!=CCROEForUSDZAREURMapping.get('CC_ROE_for_ZAR_in_EUR__c')?CCROEForUSDZAREURMapping.get('CC_ROE_for_ZAR_in_EUR__c'):0.0;
                    Decimal CC_ROE_for_EUR_in_EUR =  null!=CCROEForUSDZAREURMapping.get('CC_ROE_for_EUR_in_EUR__c')?CCROEForUSDZAREURMapping.get('CC_ROE_for_EUR_in_EUR__c'):0.0;
                
                    Decimal paymentSummaryUSd =0;
                    if(null != summary.PaymentSummaryUSD &&  null != summary.PaymentSummaryUSD.DepositeDueAmount)
                     paymentSummaryUSd = (Decimal.valueof(summary.PaymentSummaryUSD.DepositeDueAmount)*CC_ROE_for_USD_in_EUR).round(System.RoundingMode.CEILING);
                  
                     Decimal PaymentSummaryEUR =0;
                     if(null != summary.PaymentSummaryEUR && null != summary.PaymentSummaryEUR.DepositeDueAmount)
                     PaymentSummaryEUR = (Decimal.valueof(summary.PaymentSummaryEUR.DepositeDueAmount)*CC_ROE_for_EUR_in_EUR).round(System.RoundingMode.CEILING);
                     
                     Decimal PaymentSummaryZAR =0;
                     if( null != summary.PaymentSummaryZAR && null != summary.PaymentSummaryZAR.DepositeDueAmount)
                     PaymentSummaryZAR = (Decimal.valueof(summary.PaymentSummaryZAR.DepositeDueAmount)*CC_ROE_for_ZAR_in_EUR).round(System.RoundingMode.CEILING);
                    
                    summary.PaymentClientCurrency.DepositDueAmount = String.valueof(paymentSummaryUSd+PaymentSummaryEUR+PaymentSummaryZAR);
                    
                }
            }
            /*========================================================= EUR Currency ==============================================================*/
            /*========================================================= GBP Currency ==============================================================*/
            if(quotation.Currency__c=='GBP' && null != quotation.Deposite_Due_Amount_USD__c  && null !=quotation.Deposite_Due_Amount_EUR__c && null != quotation.Deposite_Due_Amount_ZAR__c)
            {
                if(null!=quotation.CC_ROE_for_USD_in_GPB__c && null!=quotation.CC_ROE_for_ZAR_in_GPB__c && null!=quotation.CC_ROE_for_EUR_in_GPB__c){
                    summary.PaymentClientCurrency.DepositDueAmount =  String.valueof(((quotation.Deposite_Due_Amount_USD__c * quotation.CC_ROE_for_USD_in_GPB__c) + ( quotation.Deposite_Due_Amount_ZAR__c*quotation.CC_ROE_for_ZAR_in_GPB__c)
                    + (quotation.Deposite_Due_Amount_EUR__c*quotation.CC_ROE_for_EUR_in_GPB__c)).round(System.RoundingMode.CEILING));
                }else{
                    Decimal CC_ROE_for_USD_in_GPB =  null!=CCROEForUSDZAREURMapping.get('CC_ROE_for_USD_in_GPB__c')?CCROEForUSDZAREURMapping.get('CC_ROE_for_USD_in_GPB__c'):0.0;
                    Decimal CC_ROE_for_ZAR_in_GPB =  null!=CCROEForUSDZAREURMapping.get('CC_ROE_for_ZAR_in_GPB__c')?CCROEForUSDZAREURMapping.get('CC_ROE_for_ZAR_in_GPB__c'):0.0;
                    Decimal CC_ROE_for_EUR_in_GPB =  null!=CCROEForUSDZAREURMapping.get('CC_ROE_for_EUR_in_GPB__c')?CCROEForUSDZAREURMapping.get('CC_ROE_for_EUR_in_GPB__c'):0.0;
                    
                    summary.PaymentClientCurrency.DepositDueAmount =  String.valueof(((quotation.Deposite_Due_Amount_USD__c *CC_ROE_for_USD_in_GPB) + ( quotation.Deposite_Due_Amount_ZAR__c*CC_ROE_for_ZAR_in_GPB)
                    + (quotation.Deposite_Due_Amount_EUR__c*CC_ROE_for_EUR_in_GPB)).round(System.RoundingMode.CEILING));
                }
            }
            else if (quotation.Currency__c=='GBP')
            {
                if(null!=quotation.CC_ROE_for_USD_in_GPB__c 
                	&& null!=quotation.CC_ROE_for_ZAR_in_GPB__c 
                	&& null!=quotation.CC_ROE_for_EUR_in_GPB__c)
                {
                   Decimal paymentSummaryUSd =0;
                   if(null != summary.PaymentSummaryUSD &&  null != summary.PaymentSummaryUSD.DepositeDueAmount)
                   paymentSummaryUSd = (Decimal.valueof(summary.PaymentSummaryUSD.DepositeDueAmount)* quotation.CC_ROE_for_USD_in_GPB__c).round(System.RoundingMode.CEILING);
              
                   Decimal PaymentSummaryEUR =0;
                   if(null != summary.PaymentSummaryEUR && null != summary.PaymentSummaryEUR.DepositeDueAmount)
                   PaymentSummaryEUR = (Decimal.valueof(summary.PaymentSummaryEUR.DepositeDueAmount)* quotation.CC_ROE_for_EUR_in_GPB__c).round(System.RoundingMode.CEILING);
                 
                   Decimal PaymentSummaryZAR =0;
                   if( null != summary.PaymentSummaryZAR && null != summary.PaymentSummaryZAR.DepositeDueAmount)
                    PaymentSummaryZAR = (Decimal.valueof(summary.PaymentSummaryZAR.DepositeDueAmount)* quotation.CC_ROE_for_ZAR_in_GPB__c).round(System.RoundingMode.CEILING);
                    summary.PaymentClientCurrency.DepositDueAmount = String.valueof(paymentSummaryUSd+PaymentSummaryEUR+PaymentSummaryZAR);
                	
                }
                else
                {
                    Decimal CC_ROE_for_USD_in_GPB =  null!=CCROEForUSDZAREURMapping.get('CC_ROE_for_USD_in_GPB__c')?CCROEForUSDZAREURMapping.get('CC_ROE_for_USD_in_GPB__c'):0.0;
                    Decimal CC_ROE_for_ZAR_in_GPB =  null!=CCROEForUSDZAREURMapping.get('CC_ROE_for_ZAR_in_GPB__c')?CCROEForUSDZAREURMapping.get('CC_ROE_for_ZAR_in_GPB__c'):0.0;
                    Decimal CC_ROE_for_EUR_in_GPB =  null!=CCROEForUSDZAREURMapping.get('CC_ROE_for_EUR_in_GPB__c')?CCROEForUSDZAREURMapping.get('CC_ROE_for_EUR_in_GPB__c'):0.0;
                    Decimal paymentSummaryUSd =0;
                    if(null != summary.PaymentSummaryUSD &&  null != summary.PaymentSummaryUSD.DepositeDueAmount)
                     paymentSummaryUSd = (Decimal.valueof(summary.PaymentSummaryUSD.DepositeDueAmount)*CC_ROE_for_USD_in_GPB).round(System.RoundingMode.CEILING);
                  
                     Decimal PaymentSummaryEUR =0;
                     if(null != summary.PaymentSummaryEUR && null != summary.PaymentSummaryEUR.DepositeDueAmount)
                     PaymentSummaryEUR = (Decimal.valueof(summary.PaymentSummaryEUR.DepositeDueAmount)*CC_ROE_for_EUR_in_GPB).round(System.RoundingMode.CEILING);
                     
                     Decimal PaymentSummaryZAR =0;
                     if( null != summary.PaymentSummaryZAR && null != summary.PaymentSummaryZAR.DepositeDueAmount)
                     PaymentSummaryZAR = (Decimal.valueof(summary.PaymentSummaryZAR.DepositeDueAmount)*CC_ROE_for_ZAR_in_GPB).round(System.RoundingMode.CEILING);
                    
                    summary.PaymentClientCurrency.DepositDueAmount = String.valueof(paymentSummaryUSd+PaymentSummaryEUR+PaymentSummaryZAR);
                }
            }
            /*========================================================= GBP Currency ==============================================================*/
            
            summary.PaymentClientCurrency.BalanceDueDate = String.valueOf((quotation.Opportunity__r.Arrival_Date__c).adddays(Integer.valueof(Label.Client_Balance_Due_Date)));
        
            if( null != summary.PaymentClientCurrency.DepositDueAmount)
            {
            summary.PaymentClientCurrency.BalanceDueAmount = String.valueOf(Decimal.valueof(summary.PaymentClientCurrency.QuotationSales) - Decimal.valueof(summary.PaymentClientCurrency.DepositDueAmount));
            }
            
    }

}
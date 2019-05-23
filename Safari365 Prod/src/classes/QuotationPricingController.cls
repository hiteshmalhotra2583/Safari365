public class QuotationPricingController {

    static QuotationBuilderDatabaseQueries dao = new QuotationBuilderDatabaseQueries();

    @AuraEnabled public static QuotationPricingSummaryWrapper getQuotationPricingDetails(String quotationId)
    {
        Quotations__c quotation = dao.getQuotationForPricingSummary(quotationId);
        QuotationPricingSummaryWrapper summary = new QuotationPricingSummaryWrapper();
        
        boolean toDisplayPaymentSummmary = validateClientFundRecieved(summary,quotation);
        SetProfileSummary(summary,quotation);
        SetPaymentSummary(summary,quotation);
        SetPerPersonSummary(summary,quotation);
        if(toDisplayPaymentSummmary)
        SetPaymentClientCurrency(summary,quotation);
        return summary;
    } 
    
    
    
    @AuraEnabled public static QuotationPricingSummaryWrapper calculatedDepositValues(String quotationId,Double depositeDueAmountZAR,
                                                                                      Double depositeDueAmountUSD,Double depositeDueAmountEUR,
                                                                                      Double depositDueAmount,
                                                                                      Double balanceDueAmount,String depositDueDate,String balanceDueDate)
    {
        system.debug('calculateDepositValues'+quotationId);
        updateQuotataionSalesValue(quotationId,depositeDueAmountZAR,depositeDueAmountUSD,depositeDueAmountEUR,depositDueAmount,balanceDueAmount,depositDueDate,balanceDueDate);
        Quotations__c quotation = dao.getQuotationForPricingSummary(quotationId);
        QuotationPricingSummaryWrapper summary = new QuotationPricingSummaryWrapper();
        validateClientFundRecieved(summary,quotation);
        SetProfileSummary(summary,quotation);
        SetPaymentSummary(summary,quotation);
        SetPerPersonSummary(summary,quotation);
        setPaymentClientCurrency(summary,quotation);
        return summary;
    } 
    
    
    private static boolean validateClientFundRecieved(QuotationPricingSummaryWrapper summary,Quotations__c quotation)
    {
        boolean flag = false;
        if(quotation.Client_Fund_Recieved__c)
        {
            summary.ClientFundRecieved = 'true';
            flag= true;
        }else
        {
            summary.ClientFundRecieved = 'false';
            flag= false;
        }
        
        return flag;
    }
    
    private static void SetProfileSummary(QuotationPricingSummaryWrapper summary,Quotations__c quotation)
    {
        
        if(quotation.Total_Sale_In_Zar__c != null && quotation.Total_Sale_In_Zar__c > 0)
        {
            summary.ProfileAnalysisZAR = new ProfileAnalysisWrapper();
            summary.ProfileAnalysisZAR.QuotationSale = String.valueOf((quotation.Total_Sale_In_Zar__c).round(System.RoundingMode.CEILING));
            summary.ProfileAnalysisZAR.QuotationCost = String.valueOf((quotation.Total_Cos_in_ZAR__c).round(System.RoundingMode.CEILING));
            summary.ProfileAnalysisZAR.QuotationProfit = String.valueOf(quotation.Profit_IN_ZAR__c);
            summary.ProfileAnalysisZAR.QuotationGross = String.valueOf((quotation.Quotation_Gross_Profit_ZAR__c).round(System.RoundingMode.CEILING));
        }
        
        if(quotation.Total_Sale_In_USD__c != null && quotation.Total_Sale_In_USD__c > 0)
        {
            summary.ProfileAnalysisUSD = new ProfileAnalysisWrapper();
            summary.ProfileAnalysisUSD.QuotationSale = String.valueOf((quotation.Total_Sale_In_USD__c).round(System.RoundingMode.CEILING));
            summary.ProfileAnalysisUSD.QuotationCost = String.valueOf((quotation.Total_Cos_in_USD__c).round(System.RoundingMode.CEILING));
            summary.ProfileAnalysisUSD.QuotationProfit = String.valueOf(quotation.Profit_USD__c);
            summary.ProfileAnalysisUSD.QuotationGross = String.valueOf((quotation.Quotation_Gross_Profit_USD__c).round(System.RoundingMode.CEILING));
        }
        
        if(quotation.Sale_in_EUR__c != null && quotation.Sale_in_EUR__c > 0)
        {
            summary.ProfileAnalysisEUR = new ProfileAnalysisWrapper();
            summary.ProfileAnalysisEUR.QuotationSale = String.valueOf((quotation.Sale_in_EUR__c).round(System.RoundingMode.CEILING));
            summary.ProfileAnalysisEUR.QuotationCost = String.valueOf((quotation.COS_in_EUR__c).round(System.RoundingMode.CEILING));
            summary.ProfileAnalysisEUR.QuotationProfit = String.valueOf(quotation.Profit_Eur__c);
            summary.ProfileAnalysisEUR.QuotationGross = String.valueOf((quotation.Quotation_Gross_Profit_EUR__c).round(System.RoundingMode.CEILING));
        }
        
        if(quotation.Sale_in_EUR__c != null && quotation.Sale_in_EUR__c > 0)
        {
            summary.ProfileAnalysisClientCurrency = new ProfileAnalysisWrapper();
            summary.ProfileAnalysisClientCurrency.QuotationSale = String.valueOf((quotation.Quotation_Sale_Total_in_CC__c).round(System.RoundingMode.CEILING));
        }
    }
    
    private static void SetPaymentSummary(QuotationPricingSummaryWrapper summary,Quotations__c quotation)
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
            if(system.Today().daysBetween(quotation.Opportunity__r.Arrival_Date__c ) > 60 
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
        
        if(quotation.Total_Sale_In_USD__c != null && quotation.Total_Sale_In_USD__c >= 0)
        {
            summary.PaymentSummaryUSD = new PaymentSummaryWrapper();
             if(system.Today().daysBetween( quotation.Opportunity__r.Arrival_Date__c) >60 
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
        
        if(quotation.Sale_in_EUR__c != null && quotation.Sale_in_EUR__c >= 0)
        {
            summary.PaymentSummaryEUR = new PaymentSummaryWrapper();
             if(system.Today().daysBetween(quotation.Opportunity__r.Arrival_Date__c) >60
               && !quotation.Deposit_Value_Override_By_Consultant__c)
            {
                summary.PaymentSummaryEUR.DepositeDueAmount = String.valueOf(((quotation.Sale_in_EUR__c * discountPercentageEUR)/100).round(System.RoundingMode.CEILING));
            }
            else
            {
                if(quotation.Deposite_Due_Amount_EUR__c!=null && quotation.Deposite_Due_Amount_EUR__c > 0){
                    summary.PaymentSummaryEUR.DepositeDueAmount = String.valueOf((quotation.Deposite_Due_Amount_EUR__c).round(System.RoundingMode.CEILING));
                }else{
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
             if(system.Today().daysBetween(quotation.Opportunity__r.Arrival_Date__c) >60)
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
    
    private static void SetPerPersonSummary(QuotationPricingSummaryWrapper summary,Quotations__c quotation)
    {
        //FetchAll QuotationLineItems 
      List<QuotationLineItem__c> allQuotationLineItems =dao.GetQuotationLineItems(quotation.Id);
      List<Id> allQuotationLineItemsIds = new List<Id>();
      for(QuotationLineItem__c qli: allQuotationLineItems)
      {
        allQuotationLineItemsIds.add(qli.Id);
      }
      
      //FetchAll Related ServiceLineItems 
      List<ServiceLineItem__c> allServiceLineItems =dao.getRelatedQuotationServiceLineItems(allQuotationLineItemsIds);
      
       //FetchAll Related Charge Types
       Set<String> serviceLineitemIds = new Set<String>();
       for(ServiceLineItem__c sli:allServiceLineItems) 
       {
           serviceLineitemIds.add(sli.Id);
       }
        //Fetch All selected Passengers from the QuotationId
       List<Passenger__c> selectedPassengers =dao.GetServiceLineItemsPassengers(serviceLineitemIds);
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
       populatePassengerTotalInClientCurreny(selectedPassengerIds,summary.PricePerPersonSummaryZAR,summary.PricePerPersonSummaryUSD,
                                            summary.PricePerPersonSummaryEUR,passengerIdToPassangerMap,summary.TotalPricePerPersonSummaryClientCurrency);
                         
    }
    
    
    
    private static void populatePassengerTotalInClientCurreny(Set<String> selectedPassengerIds,List<PricePerPersonSummaryWrapper> ppsWrapperZAR,
                                                             List<PricePerPersonSummaryWrapper> ppsWrapperUSD,List<PricePerPersonSummaryWrapper> ppsWrapperEUR,
                                                             Map<Id,Passenger__c>  passengerIdToPassangerMap,List<TotalPricePerPersonSummaryWrapper> totalPrice)
    {
        
       Map<String, Decimal> totalValueInUSDMap = new Map<String, Decimal>();
       Map<String, Decimal> totalValueInAUDMap = new Map<String, Decimal>();
       Map<String, Decimal> totalValueInEURMap = new Map<String, Decimal>();
       Map<String, Decimal> totalValueInGBPMap = new Map<String, Decimal>();
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
                    Decimal passsengerAmountInUSD1 = totalValueInUSDMap.get(passengerId)+ Decimal.valueof(passsengerAmountInUSD);
                    totalValueInUSDMap.put(passengerId,passsengerAmountInUSD1);
                }
                else{
                    totalValueInUSDMap.put(passengerId,Decimal.valueof(passsengerAmountInUSD));
                }
                
                if(null != totalValueInAUDMap.get(passengerId))
                {
                    Decimal passsengerAmountInAUD1 = totalValueInAUDMap.get(passengerId)+ Decimal.valueof(passsengerAmountInAUD);
                    totalValueInAUDMap.put(passengerId,passsengerAmountInAUD1);
                }
                else{
                    totalValueInAUDMap.put(passengerId,Decimal.valueof(passsengerAmountInAUD));
                }
                
                if(null != totalValueInEURMap.get(passengerId))
                {
                    Decimal passsengerAmountInEUR1 = totalValueInEURMap.get(passengerId)+ Decimal.valueof(passsengerAmountInEUR);
                    totalValueInEURMap.put(passengerId,passsengerAmountInEUR1);
                }
                else{
                    totalValueInEURMap.put(passengerId,Decimal.valueof(passsengerAmountInEUR));
                }
                
                if(null != totalValueInGBPMap.get(passengerId))
                {
                    Decimal passsengerAmountInGBP1 = totalValueInGBPMap.get(passengerId)+ Decimal.valueof(passsengerAmountInGBP);
                    totalValueInGBPMap.put(passengerId,passsengerAmountInGBP1);
                }
                else{
                    totalValueInGBPMap.put(passengerId,Decimal.valueof(passsengerAmountInGBP));
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
                    Decimal passsengerAmountInUSD1 = totalValueInUSDMap.get(passengerId)+ Decimal.valueof(passsengerAmountInUSD);
                    totalValueInUSDMap.put(passengerId,passsengerAmountInUSD1);
                }
                else{
                    totalValueInUSDMap.put(passengerId,Decimal.valueof(passsengerAmountInUSD));
                }
                
                if(null != totalValueInAUDMap.get(passengerId))
                {
                    Decimal passsengerAmountInAUD1 = totalValueInAUDMap.get(passengerId)+ Decimal.valueof(passsengerAmountInAUD);
                    totalValueInAUDMap.put(passengerId,passsengerAmountInAUD1);
                }
                else{
                    totalValueInAUDMap.put(passengerId,Decimal.valueof(passsengerAmountInAUD));
                }
                
                if(null != totalValueInEURMap.get(passengerId))
                {
                    Decimal passsengerAmountInEUR1 = totalValueInEURMap.get(passengerId)+ Decimal.valueof(passsengerAmountInEUR);
                    totalValueInEURMap.put(passengerId,passsengerAmountInEUR1);
                }
                else{
                    totalValueInEURMap.put(passengerId,Decimal.valueof(passsengerAmountInEUR));
                }
                
                if(null != totalValueInGBPMap.get(passengerId))
                {
                    Decimal passsengerAmountInGBP1 = totalValueInGBPMap.get(passengerId)+ Decimal.valueof(passsengerAmountInGBP);
                    totalValueInGBPMap.put(passengerId,passsengerAmountInGBP1);
                }
                else{
                    totalValueInGBPMap.put(passengerId,Decimal.valueof(passsengerAmountInGBP));
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
                    Decimal passsengerAmountInUSD1 = totalValueInUSDMap.get(passengerId)+ Decimal.valueof(passsengerAmountInUSD);
                    totalValueInUSDMap.put(passengerId,passsengerAmountInUSD1);
                }
                else{
                    totalValueInUSDMap.put(passengerId,Integer.valueof(passsengerAmountInUSD));
                }
                
                if(null != totalValueInAUDMap.get(passengerId))
                {
                    Decimal passsengerAmountInAUD1 = totalValueInAUDMap.get(passengerId)+ Decimal.valueof(passsengerAmountInAUD);
                    totalValueInAUDMap.put(passengerId,passsengerAmountInAUD1);
                }
                else{
                    totalValueInAUDMap.put(passengerId,Integer.valueof(passsengerAmountInAUD));
                }
                
                if(null != totalValueInEURMap.get(passengerId))
                {
                    Decimal passsengerAmountInEUR1 = totalValueInEURMap.get(passengerId)+ Decimal.valueof(passsengerAmountInEUR);
                    totalValueInEURMap.put(passengerId,passsengerAmountInEUR1);
                }
                else{
                    totalValueInEURMap.put(passengerId,Decimal.valueof(passsengerAmountInEUR));
                }
                
                if(null != totalValueInGBPMap.get(passengerId))
                {
                    Decimal passsengerAmountInGBP1 = totalValueInGBPMap.get(passengerId)+ Decimal.valueof(passsengerAmountInGBP);
                    totalValueInGBPMap.put(passengerId,passsengerAmountInGBP1);
                }
                else{
                    totalValueInGBPMap.put(passengerId,Decimal.valueof(passsengerAmountInGBP));
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
    
    private static void PopulatePassengerTotal(AggregateResult[] allTotals,List<PricePerPersonSummaryWrapper> ppsWrapper,
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
                pps.AmountINUSD ='0';
                pps.AmountINAUD = '0';
                pps.AmountINEUR = '0';
                pps.AmountInGBP = '0';
                if(null != quotation.CC_ROE_for_ZAR_in_USD__c)
                {
                     //pps.AmountINUSD = String.valueOf(((decimalAmount*quotation.CC_ROE_for_ZAR_in_USD__c).round(System.RoundingMode.CEILING)));
                     pps.AmountINUSD = String.valueOf(((decimalAmount*quotation.CC_ROE_for_ZAR_in_USD__c).setscale(2)));
                }
                if(null != quotation.CC_ROE_for_ZAR_in_AUD__c)
                {
                    // pps.AmountINAUD = String.valueOf(((decimalAmount*quotation.CC_ROE_for_ZAR_in_AUD__c).round(System.RoundingMode.CEILING)));
                      pps.AmountINAUD = String.valueOf(((decimalAmount*quotation.CC_ROE_for_ZAR_in_AUD__c).setscale(2)));
                }
                if(null != quotation.CC_ROE_for_ZAR_in_EUR__c)
                {
                     //pps.AmountINEUR = String.valueOf(((decimalAmount*quotation.CC_ROE_for_ZAR_in_EUR__c).round(System.RoundingMode.CEILING)));
                     pps.AmountINEUR = String.valueOf(((decimalAmount*quotation.CC_ROE_for_ZAR_in_EUR__c).setscale(2)));
                }
                if(null != quotation.CC_ROE_for_ZAR_in_GPB__c)
                {
                     //pps.AmountInGBP = String.valueOf(((decimalAmount*quotation.CC_ROE_for_ZAR_in_GPB__c).round(System.RoundingMode.CEILING)));
                     pps.AmountInGBP = String.valueOf(((decimalAmount*quotation.CC_ROE_for_ZAR_in_GPB__c).setscale(2)));
                }
            }
            if(currencyType =='USD')
            {
                pps.AmountINUSD ='0';
                pps.AmountINAUD = '0';
                pps.AmountINEUR = '0';
                pps.AmountInGBP = '0';
                if(null != quotation.CC_ROE_for_USD_in_USD__c)
                {
                    // pps.AmountINUSD = String.valueOf(((decimalAmount*quotation.CC_ROE_for_USD_in_USD__c).round(System.RoundingMode.CEILING)));
                    pps.AmountINUSD = String.valueOf(((decimalAmount*quotation.CC_ROE_for_USD_in_USD__c).setscale(2)));
                }
                if(null != quotation.CC_ROE_for_USD_in_AUD__c)
                {
                     //pps.AmountINAUD = String.valueOf(((decimalAmount*quotation.CC_ROE_for_USD_in_AUD__c).round(System.RoundingMode.CEILING)));
                     pps.AmountINAUD = String.valueOf(((decimalAmount*quotation.CC_ROE_for_USD_in_AUD__c).setscale(2)));
                }
                if(null != quotation.CC_ROE_for_USD_in_EUR__c)
                {
                     //pps.AmountINEUR = String.valueOf(((decimalAmount*quotation.CC_ROE_for_USD_in_EUR__c).round(System.RoundingMode.CEILING)));
                      pps.AmountINEUR = String.valueOf(((decimalAmount*quotation.CC_ROE_for_USD_in_EUR__c).setscale(2)));
                }
                if(null != quotation.CC_ROE_for_USD_in_GPB__c)
                {
                    // pps.AmountInGBP = String.valueOf(((decimalAmount*quotation.CC_ROE_for_USD_in_GPB__c).round(System.RoundingMode.CEILING)));
                    pps.AmountInGBP = String.valueOf(((decimalAmount*quotation.CC_ROE_for_USD_in_GPB__c).setscale(2)));
                }
            }
            if(currencyType =='EUR')
            {
                pps.AmountINUSD ='0';
                pps.AmountINAUD = '0';
                pps.AmountINEUR = '0';
                pps.AmountInGBP = '0';
                if(null != quotation.CC_ROE_for_EUR_in_USD__c)
                {
                     //pps.AmountINUSD = String.valueOf(((decimalAmount*quotation.CC_ROE_for_EUR_in_USD__c).round(System.RoundingMode.CEILING)));
                     pps.AmountINUSD = String.valueOf(((decimalAmount*quotation.CC_ROE_for_EUR_in_USD__c).setscale(2)));
                }
                if(null != quotation.CC_ROE_for_EUR_in_AUD__c)
                {
                     //pps.AmountINAUD = String.valueOf(((decimalAmount*quotation.CC_ROE_for_EUR_in_AUD__c).round(System.RoundingMode.CEILING)));
                      pps.AmountINAUD = String.valueOf(((decimalAmount*quotation.CC_ROE_for_EUR_in_AUD__c).setscale(2)));
                }
                if(null != quotation.CC_ROE_for_EUR_in_EUR__c)
                {
                     //pps.AmountINEUR = String.valueOf(((decimalAmount*quotation.CC_ROE_for_EUR_in_EUR__c).round(System.RoundingMode.CEILING)));
                     pps.AmountINEUR = String.valueOf(((decimalAmount*quotation.CC_ROE_for_EUR_in_EUR__c).setscale(2)));
                }
                if(null != quotation.CC_ROE_for_EUR_in_GPB__c)
                {
                    // pps.AmountInGBP = String.valueOf(((decimalAmount*quotation.CC_ROE_for_EUR_in_GPB__c).round(System.RoundingMode.CEILING)));
                     pps.AmountInGBP = String.valueOf(((decimalAmount*quotation.CC_ROE_for_EUR_in_GPB__c).setscale(2)));
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
    
    //====================
    private static void setPaymentClientCurrency(QuotationPricingSummaryWrapper summary,Quotations__c quotation)
    {
        
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
        
        if(quotation.Currency__c=='AUD'
            && null != quotation.Deposite_Due_Amount_USD__c
            && null !=quotation.Deposite_Due_Amount_EUR__c 
            && null != quotation.Deposite_Due_Amount_ZAR__c)
        {
            summary.PaymentClientCurrency.DepositDueAmount =  String.valueof(((quotation.Deposite_Due_Amount_USD__c * quotation.CC_ROE_for_USD_in_AUD__c) + ( quotation.Deposite_Due_Amount_ZAR__c*quotation.CC_ROE_for_ZAR_in_AUD__c)
            + (quotation.Deposite_Due_Amount_EUR__c*quotation.CC_ROE_for_EUR_in_AUD__c)).round(System.RoundingMode.CEILING));
        }
        else if (quotation.Currency__c=='AUD')
        {
            
            Decimal paymentSummaryUSd =0;
            if(null != summary.PaymentSummaryUSD &&  null != summary.PaymentSummaryUSD.DepositeDueAmount && null != quotation.CC_ROE_for_USD_in_AUD__c)
            paymentSummaryUSd = (Decimal.valueof(summary.PaymentSummaryUSD.DepositeDueAmount)* quotation.CC_ROE_for_USD_in_AUD__c).round(System.RoundingMode.CEILING);
          
            Decimal PaymentSummaryEUR =0;
            if(null != summary.PaymentSummaryEUR && null != summary.PaymentSummaryEUR.DepositeDueAmount &&  null != quotation.CC_ROE_for_EUR_in_AUD__c)
            PaymentSummaryEUR = (Decimal.valueof(summary.PaymentSummaryEUR.DepositeDueAmount)* quotation.CC_ROE_for_EUR_in_AUD__c).round(System.RoundingMode.CEILING);
             
            Decimal PaymentSummaryZAR =0;
            if( null != summary.PaymentSummaryZAR && null != summary.PaymentSummaryZAR.DepositeDueAmount && null != quotation.CC_ROE_for_ZAR_in_AUD__c)
            PaymentSummaryZAR = (Decimal.valueof(summary.PaymentSummaryZAR.DepositeDueAmount)* quotation.CC_ROE_for_ZAR_in_AUD__c).round(System.RoundingMode.CEILING);
            
            summary.PaymentClientCurrency.DepositDueAmount = String.valueof(paymentSummaryUSd+PaymentSummaryEUR+PaymentSummaryZAR);
            
            /*summary.PaymentClientCurrency.DepositDueAmount = String.valueof((Decimal.valueof(summary.PaymentSummaryUSD.DepositeDueAmount)* quotation.CC_ROE_for_USD_in_AUD__c).round(System.RoundingMode.CEILING)
            +(Decimal.valueof(summary.PaymentSummaryZAR.DepositeDueAmount)* quotation.CC_ROE_for_ZAR_in_AUD__c).round(System.RoundingMode.CEILING)
            +(Decimal.valueof(summary.PaymentSummaryEUR.DepositeDueAmount)* quotation.CC_ROE_for_EUR_in_AUD__c).round(System.RoundingMode.CEILING));*/
        }
        
        if(quotation.Currency__c=='USD' 
            && null != quotation.Deposite_Due_Amount_USD__c  
            && null !=quotation.Deposite_Due_Amount_EUR__c 
            && null != quotation.Deposite_Due_Amount_ZAR__c)
        {
            summary.PaymentClientCurrency.DepositDueAmount =   string.valueof(((quotation.Deposite_Due_Amount_USD__c * quotation.CC_ROE_for_USD_in_USD__c) + ( quotation.Deposite_Due_Amount_ZAR__c*quotation.CC_ROE_for_ZAR_in_USD__c)
            + (quotation.Deposite_Due_Amount_EUR__c*quotation.CC_ROE_for_EUR_in_USD__c)).round(System.RoundingMode.CEILING));
        }
        else if (quotation.Currency__c=='USD')
        {
            Decimal paymentSummaryUSd =0;
            if(null != summary.PaymentSummaryUSD &&  null != summary.PaymentSummaryUSD.DepositeDueAmount && null != quotation.CC_ROE_for_USD_in_USD__c)
            paymentSummaryUSd = (Decimal.valueof(summary.PaymentSummaryUSD.DepositeDueAmount)* quotation.CC_ROE_for_USD_in_USD__c).round(System.RoundingMode.CEILING);
          
            Decimal PaymentSummaryEUR =0;
            if(null != summary.PaymentSummaryEUR && null != summary.PaymentSummaryEUR.DepositeDueAmount &&  null != quotation.CC_ROE_for_EUR_in_USD__c)
            PaymentSummaryEUR = (Decimal.valueof(summary.PaymentSummaryEUR.DepositeDueAmount)* quotation.CC_ROE_for_EUR_in_USD__c).round(System.RoundingMode.CEILING);
             
            Decimal PaymentSummaryZAR =0;
            if( null != summary.PaymentSummaryZAR && null != summary.PaymentSummaryZAR.DepositeDueAmount && null != quotation.CC_ROE_for_ZAR_in_USD__c)
            PaymentSummaryZAR = (Decimal.valueof(summary.PaymentSummaryZAR.DepositeDueAmount)* quotation.CC_ROE_for_ZAR_in_USD__c).round(System.RoundingMode.CEILING);
            
            summary.PaymentClientCurrency.DepositDueAmount = String.valueof(paymentSummaryUSd+PaymentSummaryEUR+PaymentSummaryZAR);
        }
        
        if(quotation.Currency__c=='EUR'
            && null != quotation.Deposite_Due_Amount_USD__c
            && null !=quotation.Deposite_Due_Amount_EUR__c 
            && null != quotation.Deposite_Due_Amount_ZAR__c)
        {
            summary.PaymentClientCurrency.DepositDueAmount =  string.valueof(((quotation.Deposite_Due_Amount_USD__c * quotation.CC_ROE_for_USD_in_EUR__c) + ( quotation.Deposite_Due_Amount_ZAR__c*quotation.CC_ROE_for_ZAR_in_EUR__c)
            + (quotation.Deposite_Due_Amount_EUR__c*quotation.CC_ROE_for_EUR_in_EUR__c)).round(System.RoundingMode.CEILING));
        }
        else if (quotation.Currency__c=='EUR')
        {
               
            Decimal paymentSummaryUSd =0;
            
            if(null != summary.PaymentSummaryUSD &&  null != summary.PaymentSummaryUSD.DepositeDueAmount && null != quotation.CC_ROE_for_USD_in_EUR__c)
            paymentSummaryUSd = (Decimal.valueof(summary.PaymentSummaryUSD.DepositeDueAmount)* quotation.CC_ROE_for_USD_in_EUR__c).round(System.RoundingMode.CEILING);
          
            Decimal PaymentSummaryEUR =0;
            if(null != summary.PaymentSummaryEUR && null != summary.PaymentSummaryEUR.DepositeDueAmount && null != quotation.CC_ROE_for_EUR_in_EUR__c)
            PaymentSummaryEUR = (Decimal.valueof(summary.PaymentSummaryEUR.DepositeDueAmount)* quotation.CC_ROE_for_EUR_in_EUR__c).round(System.RoundingMode.CEILING);
             
            Decimal PaymentSummaryZAR =0;
            if( null != summary.PaymentSummaryZAR && null != summary.PaymentSummaryZAR.DepositeDueAmount && null != quotation.CC_ROE_for_ZAR_in_EUR__c)
            PaymentSummaryZAR = (Decimal.valueof(summary.PaymentSummaryZAR.DepositeDueAmount)* quotation.CC_ROE_for_ZAR_in_EUR__c).round(System.RoundingMode.CEILING);
           
            summary.PaymentClientCurrency.DepositDueAmount = String.valueof(paymentSummaryUSd+PaymentSummaryEUR+PaymentSummaryZAR);
        }
        
        if(quotation.Currency__c=='GBP'
            && null != quotation.Deposite_Due_Amount_USD__c
            && null !=quotation.Deposite_Due_Amount_EUR__c 
            && null != quotation.Deposite_Due_Amount_ZAR__c)
        {
            summary.PaymentClientCurrency.DepositDueAmount =  String.valueof(((quotation.Deposite_Due_Amount_USD__c * quotation.CC_ROE_for_USD_in_GPB__c) + ( quotation.Deposite_Due_Amount_ZAR__c*quotation.CC_ROE_for_ZAR_in_GPB__c)
            + (quotation.Deposite_Due_Amount_EUR__c*quotation.CC_ROE_for_EUR_in_GPB__c)).round(System.RoundingMode.CEILING));
        }
        else if (quotation.Currency__c=='GBP')
        {
            Decimal paymentSummaryUSd =0;
            if(null != summary.PaymentSummaryUSD &&  null != summary.PaymentSummaryUSD.DepositeDueAmount && null != quotation.CC_ROE_for_USD_in_GPB__c)
            paymentSummaryUSd = (Decimal.valueof(summary.PaymentSummaryUSD.DepositeDueAmount)* quotation.CC_ROE_for_USD_in_GPB__c).round(System.RoundingMode.CEILING);
              
           Decimal PaymentSummaryEUR =0;
           if(null != summary.PaymentSummaryEUR && null != summary.PaymentSummaryEUR.DepositeDueAmount && null != quotation.CC_ROE_for_EUR_in_GPB__c)
           PaymentSummaryEUR = (Decimal.valueof(summary.PaymentSummaryEUR.DepositeDueAmount)* quotation.CC_ROE_for_EUR_in_GPB__c).round(System.RoundingMode.CEILING);
                 
           Decimal PaymentSummaryZAR =0;
           if( null != summary.PaymentSummaryZAR && null != summary.PaymentSummaryZAR.DepositeDueAmount && null != quotation.CC_ROE_for_ZAR_in_GPB__c)
            PaymentSummaryZAR = (Decimal.valueof(summary.PaymentSummaryZAR.DepositeDueAmount)* quotation.CC_ROE_for_ZAR_in_GPB__c).round(System.RoundingMode.CEILING);
            
            summary.PaymentClientCurrency.DepositDueAmount = String.valueof(paymentSummaryUSd+PaymentSummaryEUR+PaymentSummaryZAR);
            
        }
        
        summary.PaymentClientCurrency.BalanceDueDate = String.valueOf((quotation.Opportunity__r.Arrival_Date__c).adddays(Integer.valueof(Label.Client_Balance_Due_Date)));
        if( null != summary.PaymentClientCurrency.DepositDueAmount)
        {
        summary.PaymentClientCurrency.BalanceDueAmount = String.valueOf(Decimal.valueof(summary.PaymentClientCurrency.QuotationSales) - Decimal.valueof(summary.PaymentClientCurrency.DepositDueAmount));
        }
       
        quotation.Sales_Values_Verified_By_Consultant__c = true;
        quotation.Deposit_Due_Amount__c =Decimal.valueof(summary.PaymentClientCurrency.DepositDueAmount);
        quotation.Balance_Due_Amount__c =Decimal.valueof(summary.PaymentClientCurrency.QuotationSales) - Decimal.valueof(summary.PaymentClientCurrency.DepositDueAmount);
        quotation.Deposit_Due_Date__c=quotation.Deposit_Due_Date__c;
        quotation.Balance_Due_Date__c=quotation.Opportunity__r.Arrival_Date__c.adddays(Integer.valueof(Label.Client_Balance_Due_Date));
        BaseTriggerHandler.bypass('TH_Quotations');
        update quotation;
        BaseTriggerHandler.clearBypass('TH_Quotations');
          
    }
    
    
    @AuraEnabled
    public static void updateQuotataionSalesValue(String quotationId,Double depositeDueAmountZAR,
                                                  Double depositeDueAmountUSD,Double depositeDueAmountEUR,
                                                  Double depositDueAmount,
                                                  Double balanceDueAmount,String depositDueDate,String balanceDueDate)
    {
      
      if(quotationId != null && quotationId !='')
      {
        Quotations__c quotation =DAL_Quotations.getAllQuotationsById(quotationId).get(0);
        if(depositeDueAmountUSD !=null && depositeDueAmountUSD > 0)
        {
            quotation.Deposite_Due_Amount_USD__c = depositeDueAmountUSD;
            quotation.Deposit_Value_Override_By_Consultant__c = true;
        }
        
        if(depositeDueAmountZAR!=null && depositeDueAmountZAR > 0)
        {
            quotation.Deposite_Due_Amount_ZAR__c = depositeDueAmountZAR;
            quotation.Deposit_Value_Override_By_Consultant__c = true;
        }
        if(depositeDueAmountEUR!=null && depositeDueAmountEUR > 0)
        {
            quotation.Deposite_Due_Amount_EUR__c = depositeDueAmountEUR;
            quotation.Deposit_Value_Override_By_Consultant__c = true;
        }
        
        if(depositDueAmount!=null && depositDueAmount > 0)
        {
            quotation.Deposit_Due_Amount__c = depositDueAmount;
            quotation.Deposit_Value_Override_By_Consultant__c = true;
        }
        if(balanceDueAmount!=null && balanceDueAmount > 0)
        {
            quotation.Balance_Due_Amount__c = balanceDueAmount;
            quotation.Deposit_Value_Override_By_Consultant__c = true;
        }
        
        if(depositDueDate!=null)
        {
            quotation.Deposit_Due_Date__c =SystemUtil.convertStringToDateYYYYDDMM(depositDueDate);
            quotation.Deposit_Value_Override_By_Consultant__c = true;
        }
        
        if(balanceDueDate!=null)
        {
            quotation.Balance_Due_Date__c = SystemUtil.convertStringToDateYYYYDDMM(balanceDueDate);
            quotation.Deposit_Value_Override_By_Consultant__c = true;
        }
        
        BaseTriggerHandler.bypass('TH_Quotations');
        update quotation;
        BaseTriggerHandler.clearBypass('TH_Quotations');
    }
    }
    //====================
}
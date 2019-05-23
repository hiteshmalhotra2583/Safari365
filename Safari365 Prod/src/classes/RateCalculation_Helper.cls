public class RateCalculation_Helper {
    
    private static final String CLASS_NAME = RateCalculation_Helper.class.getName();
    private static final UTIL_LogGenerator logger = new UTIL_LogGenerator();
    private static final String VALID_CHECK_MESSGAE='';
    private OPT__c opt;
    
    public RateCalculation_Helper(OPT__c opt)
    {
        logger.log('opt',opt);
        this.opt=opt;
    }
    
    public FetchCalculatedValues CalculateServiceChargeType(ServiceLineItem__c serviceLineItem,
    												List<Passenger__c> allPassengers,OPT__c opt)
    {
        FetchCalculatedValues calculatedValues = FetchSelectedOPDs(serviceLineItem, allPassengers);
        if(calculatedValues.SelectedOPDForAdult == null
           && calculatedValues.SelectedOPDForChild == null
           && calculatedValues.SelectedOPDForInfant == null)
        {
            calculatedValues.ErrorMessages.add('OPD is not available');
            return calculatedValues;
        }
        List<String> exWithValueForAdultOPD = CheckIfOPDExForValues(calculatedValues.SelectedOPDForAdult);
        List<String> exWithValueForChildOPD = CheckIfOPDExForValues(calculatedValues.SelectedOPDForChild);
        List<String> exWithValueForInfantOPD = CheckIfOPDExForValues(calculatedValues.SelectedOPDForInfant);
        
        ChargeTypeExtraRate chargeTypeExtraRateForAdult = new ChargeTypeExtraRate();
        chargeTypeExtraRateForAdult.OPD = calculatedValues.SelectedOPDForAdult;
        chargeTypeExtraRateForAdult.ChgExs = CreateChargeTypeItems(exWithValueForAdultOPD,opt);
        chargeTypeExtraRateForAdult.ExtraRateDescription = GetChargeTypeItemsExtraRate(exWithValueForAdultOPD, opt);
        
        ChargeTypeExtraRate chargeTypeExtraRateForChild = new ChargeTypeExtraRate();
        chargeTypeExtraRateForChild.OPD = calculatedValues.SelectedOPDForChild;
        chargeTypeExtraRateForChild.ChgExs = CreateChargeTypeItems(exWithValueForChildOPD,opt);
        chargeTypeExtraRateForChild.ExtraRateDescription = GetChargeTypeItemsExtraRate(exWithValueForChildOPD, opt);
            
        ChargeTypeExtraRate chargeTypeExtraRateForInfant = new ChargeTypeExtraRate();
        chargeTypeExtraRateForInfant.OPD = calculatedValues.SelectedOPDForInfant;
        chargeTypeExtraRateForInfant.ChgExs = CreateChargeTypeItems(exWithValueForInfantOPD,opt);
        chargeTypeExtraRateForInfant.ExtraRateDescription = GetChargeTypeItemsExtraRate(exWithValueForInfantOPD, opt);

        calculatedValues.ChargeTypeExtraRatesForAdult = chargeTypeExtraRateForAdult;
        calculatedValues.ChargeTypeExtraRatesForChild = chargeTypeExtraRateForChild;
        calculatedValues.ChargeTypeExtraRatesForInfant = chargeTypeExtraRateForInfant;
        
        return calculatedValues;
    }
    
    public Map<String,String> CreateChargeTypeItems(List<String> exWithValueForOPD, OPT__c targetOpt)
    {
        String sourceObject='OPD__c';
        Map<String,String> targetFieldName = new Map<String,String>();
        try{
            List<Field_Mapping_For_Rate_Calculation__mdt>
	        				 stayMappings = [SELECT 
	        										Target_Object__c, 
	        										Target_Field__c,
                                             		Source_Field__c
										    FROM
										    		 Field_Mapping_For_Rate_Calculation__mdt 
										   WHERE 
										   			Source_Field__c IN :exWithValueForOPD
										   	   AND 
										   	        Source_Object__c=:sourceObject];
        
        for(Field_Mapping_For_Rate_Calculation__mdt mapping:stayMappings)
        {
            targetFieldName.put(mapping.Source_Field__c, (String)targetOpt.Get( mapping.Target_Field__c));
        }
        }
        catch(Exception e)
        {
            throw new CustomException('CreateChargeTypeItems:>>' + e.getMessage() );
        }
        return targetFieldName;
    }
    
    public Map<String,String> GetChargeTypeItemsExtraRate(List<String> chExWithValueForOPT, OPT__c opt)
    {
        String sourceObject='OPT__c';
        Map<String,String> extraRates = new Map<String,String>();
        try
        {
	        for(String mapping:chExWithValueForOPT)
	        {
	            extraRates.put(mapping, (String)opt.Get(mapping));
	        }
	        logger.log('GetChargeTypeItemsExtraRate.chExWithValueForOPT>>',chExWithValueForOPT);
	        logger.log('GetChargeTypeItemsExtraRate.extraRates>>',extraRates);
        }
        catch(Exception e)
        {
            throw new CustomException('GetChargeTypeItemsExtraRate:>>' + e.getMessage() );
        }
        return extraRates;
    }
    
    public List<String> CheckIfOPDExForValues(OPD__c opd)
    {
        List<String> exWithValue  =new List<String>();
        try{
        if(opd == null)
        {
            return exWithValue;
        }
        if(opd.EX1__c> 0)
        {
            exWithValue.add('EX1__c');
        }
        if(opd.EX2__c> 0)
        {
            exWithValue.add('EX2__c');
        }
        if(opd.EX3__c> 0)
        {
            exWithValue.add('EX3__c');
        }
        if(opd.EX4__c> 0)
        {
            exWithValue.add('EX4__c');
        }
        if(opd.EX5__c> 0)
        {
            exWithValue.add('EX5__c');
        }
        }
        catch(Exception e)
        {
            throw new CustomException('OPD.EX values:>>' + e.getMessage() );
        }
        return exWithValue;
    }
    
    public FetchCalculatedValues FetchSelectedOPDs(ServiceLineItem__c serviceLineItem,List<Passenger__c> allPassengers)
    {
        logger.start(CLASS_NAME,'RateCalculation_Helper.calculateServiceChargeType');
        
        FetchCalculatedValues calculationResult = new FetchCalculatedValues();
        try{    
        //Set<String> ErrorMessages = '';
        Boolean qualifyForDiscount=false;
        Decimal discountValue=null;
            
        Set<Id> optIds = new Set<Id>();
        logger.log('FetchSelectedOPDs',opt.Id);
        optIds.add(opt.Id);
        String OSR_PRICE_CODE_EB='EB';
        String OSR_PRICE_CODE_ST='ST';
        String OSR_PRICE_CODE_S1='S1';
        String OPD_RATETYPE_FC='FC';
        String OPD_RATETYPE_GC='GC';
        String opt_AC_A = 'A';
        String opt_AC_Y = 'Y';
        String opt_AC_N = 'N';
        String opd_AGECATEGORY_AD = 'AD';
        String opd_AGECATEGORY_IN = 'IN';
        String opd_AGECATEGORY_CH = 'CH';
        
        Decimal TotalAdultRate = null;
        Decimal PerAdultRate = null;
        Decimal TotalChildRate = null;
        Decimal PerChildRate = null;
        Decimal TotalInfantRate = null;
        Decimal PerInfantRate = null;
        
        OSR__c SelectedOSR=null;
        OPD__c SelectedOPDForAdult = null;
        OPD__c SelectedOPDForChild = null;
        OPD__c SelectedOPDForInfant = null;
        
        List<OPD__c> opds  = new List<OPD__c>();
        List<OPD__c> opd_FC_Ids = new List<OPD__c>();
        List<OPD__c> opd_GC_Ids = new List<OPD__c>();
        
        List<OSR__c> osr_EB_Ids = new List<OSR__c>();
        List<OSR__c> osr_ST_Ids = new List<OSR__c>();
        List<OSR__c> osr_S1_Ids = new List<OSR__c>();
        
        List<Passenger__c> adultPassengers = new List<Passenger__c>();
        List<Passenger__c> childPassengers= new List<Passenger__c>();
        List<Passenger__c> infantPassengers= new List<Passenger__c>();
        
        logger.log('allPassengers',allPassengers);
        for(Passenger__c p :allPassengers)
        {
            if(p.PassengerType__c=='Adult')
            {
                adultPassengers.add(p);
            }
            if(p.PassengerType__c=='Child')
            {
                childPassengers.add(p);
            }
            if(p.PassengerType__c=='Infant')
            {
                infantPassengers.add(p);
            }
        }
            
        List<OSR__c> osrIds = DAL_OSR.getOsrbyOPTId(optIds);
        logger.Log('Select OSR list based on given OPT Id',osrIds.size());
        logger.Log('Select OSR list',osrIds);
        
        for(OSR__c osr:osrIds)
        {
            logger.Log('If OSR list is available, Select OSR Price Code Prefer EB, if no match use ST then S1');
            if(osr.PRICE_CODE__c == OSR_PRICE_CODE_EB)
            {
                logger.Log('Populate the OSR list with Price Code EB');    
                osr_EB_Ids.add(osr);
            }
            
            if(osr.PRICE_CODE__c == OSR_PRICE_CODE_ST)
            {
                logger.Log('Populate the OSR list with Price Code ST');    
                osr_ST_Ids.add(osr);
            }
           
            if(osr.PRICE_CODE__c == OSR_PRICE_CODE_S1)
            {
                logger.Log('Populate the OSR list with Price Code S1');    
                osr_S1_Ids.add(osr);
            }
        }
        Set<String> OSRErrors = new Set<String>();
        FindOSRResult result = FindSelectedOSR(osr_EB_Ids,serviceLineItem);
        logger.Log('Check If OSR is available for Price Code EB',result);
        SelectedOSR = result.SelectedOSR;
        logger.Log('SelectedOSR',SelectedOSR);
        if(result.ErrorMessages.Size()>0)
        {
  			OSRErrors.addAll(result.ErrorMessages);          
        }
        //errorMessage = result.ErrorMessage;
        
        if(SelectedOSR == null)
        {
            logger.Log('If OSR was not available for Price Code EB, then Check If OSR is available for Price Code ST');
        
            FindOSRResult result1 = FindSelectedOSR(osr_ST_Ids,serviceLineItem);
            SelectedOSR = result1.SelectedOSR;
            if(result1.ErrorMessages.Size()>0)
            {
                OSRErrors.addAll(result1.ErrorMessages);          
            }
        }
        if(SelectedOSR == null)
        {
            logger.Log('If OSR was not available for Price Code ST, then Check If OSR is available for Price Code S1');
            FindOSRResult result2 = FindSelectedOSR(osr_S1_Ids,serviceLineItem);
            SelectedOSR = result2.SelectedOSR;
            if(result2.ErrorMessages.size()>0)
            {
                OSRErrors.addAll(result2.ErrorMessages);          
            }
        }
        if(SelectedOSR == null)
        {
            logger.Log('If OSR was not available for any Price code, through error message that OSR is not available');
            calculationResult.ErrorMessages.add(system.label.No_OSR_available);
            calculationResult.ErrorMessages.addAll(OSRErrors) ;
            return calculationResult;
        }
        
        logger.Log('Now we have OSR selected, so we get the OPD based on Selected OSR');
        logger.log('SelectedOSR>>'+SelectedOSR);
        opds  = DAL_OPD.GetOpdbyOsrId(SelectedOSR);
        for(OPD__c opd:opds)
        {
            if(opd.RATE_TYPE__c  == OPD_RATETYPE_FC)
            {
                logger.Log('Populate the OPD list with Rate Type FC');
                opd_FC_Ids.add(opd);
            }
            if(opd.RATE_TYPE__c == OPD_RATETYPE_GC)
            {
                logger.Log('Populate the OPD list with Rate Type GC');
                opd_GC_Ids.add(opd);
            }
        }
        if(opd_FC_Ids.isEmpty() && opd_GC_Ids.isEmpty())
        {
            logger.Log('If OPD was not available for any rate type, the throw message, No OPD available');
            calculationResult.ErrorMessages.add('system.label.No_OPD_available_for_selected_OSR'+SelectedOSR.Id);
            return calculationResult;
        }
        logger.Log('Section Start to find if discount is available');
        
        String errorMessage = ValidateStayPay(SelectedOSR, serviceLineItem.Service_Date__c);
        if(String.isEmpty(errorMessage))
        {
            logger.Log('check if Service Duration matches with OPD Stay ');
            errorMessage = MatchServiceDuration(SelectedOSR, Integer.valueOf(serviceLineItem.Service_Duration__c));
            if(String.isEmpty(errorMessage))
            {
                logger.Log('check if Service Duration matches with OSR FREE');
                discountValue =GetDiscountValue(SelectedOSR,  Integer.valueOf(serviceLineItem.Service_Duration__c));
                if(discountValue != null)
                {
                    logger.Log('Discount value is available');
                    
                    qualifyForDiscount = true;    
                }
            }
              // comment below else block for Bug no B-00000032
            /*else
            {
                calculationResult.ErrorMessages.add(errorMessage);
            }*/
        }
        //else
        //{
        //    calculationResult.ErrorMessages.add(errorMessage);
        //}
        logger.Log('Section End to find if discount is available');

        logger.Log('Check OPD for available passengers');
        
        //We need to find OPD for all three possible scenario
        //Scenario1:If Service Date is not between OSR>Stay_From to OSR>Stay_To
        //Scenario2:If Service Duration is not valid
        //Scenario3:If discount is available
        //  
        logger.Log('Section Start to find OPD for Passenger');
        if(adultPassengers.size() >0)
        {
            logger.Log('Find Selected OPD for Adult Passengers');
            FindOPDResult adResult = SetSelectedOPD(opd_FC_Ids, opd_GC_Ids, opd_AGECATEGORY_AD);
            if(adResult.SelectedOPD==null)
            {
                logger.Log('Error finding Selected OPD for Adult Passengers:' +adResult.ErrorMessages);
                calculationResult.ErrorMessages.addAll(adResult.ErrorMessages);
            }
            else
            {
                logger.Log('OPD for Adult Passengers found');
                SelectedOPDForAdult =adResult.SelectedOPD; 
            }
        }
        if(childPassengers.size() > 0)
        {
            logger.Log('Find Selected OPD for Child Passengers');
            FindOPDResult chResult = SetSelectedOPD(opd_FC_Ids, opd_GC_Ids, opd_AGECATEGORY_CH);
            if(chResult.SelectedOPD==null)
            {
                logger.Log('Error finding Selected OPD for Child Passengers:' +chResult.ErrorMessages);
                calculationResult.ErrorMessages.addAll(chResult.ErrorMessages);
                return calculationResult;
            }
            else
            {
                logger.Log('OPD for Child Passengers found');
                SelectedOPDForChild =chResult.SelectedOPD; 
            }
        }
        if(infantPassengers.size() > 0)
        {
            logger.Log('Find Selected OPD for Infant Passengers');
            FindOPDResult inResult = SetSelectedOPD(opd_FC_Ids, opd_GC_Ids, opd_AGECATEGORY_IN);
            if(inResult.SelectedOPD==null)
            {
                logger.Log('Error finding Selected OPD for Infant Passengers:' +inResult.ErrorMessages);
                calculationResult.ErrorMessages.addAll(inResult.ErrorMessages);
                return calculationResult;
            }
            else
            {
                logger.Log('OPD for Infant Passengers found');
                SelectedOPDForInfant =inResult.SelectedOPD; 
            }
        }
        logger.Log('Section End to find OPD for Passenger');
        
        logger.Log('Check if OPT>Service = AC');
        if(opt.Service__c=='AC')
        {
            logger.Log('OPT>Service = AC, now check if OPT>AC value is Y');
            //Proceed to AC Type Y
            if(opt.AC__c == opt_AC_Y)
            {
                logger.Log('OPT>AC value is Y, now check if Adult Passengers are available');
                //Get Adult rate
                if(adultPassengers.size()>0)
                {
                    logger.Log('Adult Passengers are available for OPT>AC = Y, now get Total rate for all Adult Passengers and Rate per Passenger');
                    TotalAdultRate =GetTotalAdultRate(SelectedOPDForAdult,serviceLineItem, adultPassengers);
                    PerAdultRate = TotalAdultRate/ adultPassengers.size();
                }
            }
            logger.Log('OPT>Service = AC, now check if OPT>AC value is A');
            if(opt.AC__c == opt_AC_A)
            {
                //Proceed to AC Type A
                //Get Adult Rate
                logger.Log('OPT>AC value is A, now check if Adult Passengers are available');
                if(adultPassengers.size() >0)
                {
                    logger.Log('Adult Passengers are available for OPT>AC = A, now get Total rate for all Adult Passengers and Rate per Passenger');
                    TotalAdultRate =GetTotalAdultRateForAC_A(opt,SelectedOPDForAdult,serviceLineItem, adultPassengers);
                    PerAdultRate = TotalAdultRate/ adultPassengers.size();
                }
            }
            
            if(opt.AC__c == opt_AC_N)
            {
                logger.Log('OPT>Service = AC, now check if OPT>AC value is N');
                //Proceed to AC Type N
                logger.Log('OPT>AC value is N, now check if all Passengers size is greater than opt.MPFCU__c');
                if((adultPassengers.size() + childPassengers.size() + infantPassengers.size()) > opt.MPFCU__c)
                {
                    logger.Log('OPT>AC value is N, and all Passengers size is greater than opt.MPFCU__c, so throw no OPD available');
                    calculationResult.ErrorMessages.add('OPD is not avaialble');
                }
                else
                {
                    //NO
                    //Get Adult rate
                    logger.Log('OPT>AC value is N, and all Passengers size is not greater than opt.MPFCU__c, now check if Adult Passengers are available');
                    if(adultPassengers.size()>0)
                    {
                        logger.Log('Adult Passengers are available for OPT>AC = N, now get Total rate for all Adult Passengers and Rate per Passenger');
                        TotalAdultRate =FindPricePBXBaseOnAdultPassengerCount(opt,SelectedOPDForAdult,adultPassengers);
                        PerAdultRate = TotalAdultRate/ adultPassengers.size();
                    }
                }
            }
        }
        else
        {
            logger.Log('OPT>Service is not equal AC');
            logger.Log('Checkif OPT.MPFCU__c > 1');
            if(opt.MPFCU__c > 1 )
            {
                logger.Log('OPT.MPFCU__c > 1 is true');
                
                logger.Log('Check if Total pax is > OPT.MPFCU__c  ');
               	logger.Log('adultPassengers.size()',adultPassengers.size());
                logger.Log('childPassengers.size()',childPassengers.size());
                logger.Log('infantPassengers.size()',infantPassengers.size());
                if((adultPassengers.size() + childPassengers.size() + infantPassengers.size()) > opt.MPFCU__c)
                {
                    logger.Log('Total pax is > OPT.MPFCU__c is true ');
                    calculationResult.ErrorMessages.add('OPD is not avaialble,OPT Id is: '+ opt.Id);
                }
                else
                {
                    logger.Log('Total pax is > OPT.MPFCU__c is false');
                    if(adultPassengers.size()>0)
                    {
                        TotalAdultRate =FindPricePBXBaseOnAdultPassengerCount(opt,SelectedOPDForAdult,adultPassengers);
                        PerAdultRate = TotalAdultRate/ adultPassengers.size();
                    }
                }
            }
            else
            {
                logger.Log('OPT.MPFCU__c > 1 is false');
                if(adultPassengers.size()>0)
                {
                    logger.Log('OPT>Service is not equal to AC, and all Passengers size is not greater than opt.MPFCU__c, now check if Adult Passengers are available');
                    logger.Log('Adult Passengers are available for OPT>Service <> AC, now get Total rate for all Adult Passengers and Rate per Passenger');
                    PerAdultRate =FindPricePBXBaseOnAdultPassengerCount(opt,SelectedOPDForAdult,adultPassengers);
                    TotalAdultRate = PerAdultRate * adultPassengers.size();
                     
                }
            }
            //Proceed to Any Other Service Type
            logger.Log('OPT>Service is not equal to AC, now check if all Passengers size is greater than opt.MPFCU__c');
            /*if(opt.MPFCU__c > 1 && (adultPassengers.size() + childPassengers.size() + infantPassengers.size()) > opt.MPFCU__c)
            {
                calculationResult.ErrorMessages.add('OPD is not avaialble');
                //TotalAdultRate =FindPricePBXBaseOnAdultPassengerCount(opt,SelectedOPDForAdult,adultPassengers);
            }
            //Get Adult rate
            else if(adultPassengers.size()>0)
            {
                logger.Log('OPT>Service is not equal to AC, and all Passengers size is not greater than opt.MPFCU__c, now check if Adult Passengers are available');
                logger.Log('Adult Passengers are available for OPT>Service <> AC, now get Total rate for all Adult Passengers and Rate per Passenger');
                TotalAdultRate =FindPricePBXBaseOnAdultPassengerCount(opt,SelectedOPDForAdult,adultPassengers);
                logger.log('Line 445:TotalAdultRate', TotalAdultRate);
                logger.log('Line 445:adultPassengers.size()', adultPassengers.size());
                PerAdultRate = TotalAdultRate/ adultPassengers.size();
                logger.log('Line 445:PerAdultRate', PerAdultRate);
            }*/
        }
        
        //Rates for child and infant are being calculated in same way for all possible scenario, hence putting this code here. 
        //The scenarios are as follow
        //OPT>Service= AC and OPT>AC = Y
        //OPT>Service= AC and OPT>AC = A
        //OPT>Service= AC and OPT>AC = N and all Passengers less than OPT>MPFCU
        //OPT>Service<> AC and all Passengers less than OPT>MPFCU
        logger.Log('Check if Child Passenger are available');
        if(childPassengers.size() >0)
        {
            //Use  Field OPD> PRICE_PXB1 for Rate per CH or IN included
            logger.Log('get Total Child rate for all Child Passenger are available'); 
            TotalChildRate = SelectedOPDForChild.PRICE_PXB1__c;
            //PerAdultRate = TotalAdultRate/ childPassengers.size();
        }
        logger.Log('Check if Infant Passenger are available');
        if(infantPassengers.size() >0)
        {
            //Use  Field OPD> PRICE_PXB1 for Rate per CH or IN included 
            logger.Log('get Total infant rate for all infant Passenger are available'); 
            TotalInfantRate = SelectedOPDForInfant.PRICE_PXB1__c;
            //PerAdultRate = TotalAdultRate/ infantPassengers.size();
        }
        
        //FetchCalculatedValues calculatedValues = new FetchCalculatedValues();
        calculationResult.SelectedOSR  = SelectedOSR;
        calculationResult.SelectedOPDForAdult = SelectedOPDForAdult ;
        calculationResult.SelectedOPDForChild = SelectedOPDForChild ;
        calculationResult.SelectedOPDForInfant = SelectedOPDForInfant ;
        calculationResult.TotalAdultRate = TotalAdultRate ;
        calculationResult.TotalChildRate = TotalChildRate ;
        calculationResult.TotalInfantRate = TotalInfantRate ;
        calculationResult.PerAdultRate = PerAdultRate ;
        calculationResult.PerChildRate = PerChildRate ;
        calculationResult.PerInfantRate = PerInfantRate ;
        calculationResult.IsDiscountAvailable = qualifyForDiscount ;
        calculationResult.Discount  = discountValue;
        
       logger.log('calculationResult',calculationResult);
       logger.end();
        }
        catch(Exception e)
        {
            throw new CustomException('FetchCalculatedValues:>>' + e.getMessage() );
        }
        return calculationResult;
    }
    
    public FindOPDResult SetSelectedOPD(List<OPD__c> opd_FC_Ids, List<OPD__c> opd_GC_Ids, String opd_AGECATEGORY)
    {
        logger.log('opd_FC_Ids',opd_FC_Ids);
        logger.log('opd_GC_Ids',opd_GC_Ids);
        logger.log('opd_AGECATEGORY',opd_AGECATEGORY);
        FindOPDResult result =FindSelectedOPD(opd_FC_Ids,opd_AGECATEGORY);
        if(result.SelectedOPD==null)
        {
            result =FindSelectedOPD(opd_GC_Ids,opd_AGECATEGORY);
        }
        
        return result;
    }
    
    public FindOPDResult FindSelectedOPD(List<OPD__c> opds, String PaxCategory)
    {
        FindOPDResult result = new FindOPDResult();
        try
        {
        for(OPD__c opd:opds)
        {
            if(opd.AGE_CATEGORY__c == PaxCategory)
            {
                result.SelectedOPD = opd;
            }
        }
        if(result.SelectedOPD == null)
        {
            result.ErrorMessages.add('OPD not available for Pax Category');
        }
        }
        catch(Exception e)
        {
            throw new CustomException('FindOPDResult:>>' + e.getMessage() );
        }
        return result;
    }
    
    public FindOSRResult FindSelectedOSR(List<OSR__c> osrs, ServiceLineItem__c serviceLineItem)
    {
        Set<String> ErrorMessages = new Set<String>();
        
        FindOSRResult result=new FindOSRResult();
        try
        {
        OSR__c SelectedOSR=null;
        for(OSR__c osr:osrs)
        {
            String errorMessage = ValidateServiceDate(osr ,serviceLineItem.Service_Date__c);
            logger.log('ValidateServiceDate.ErrorMessage',errorMessage);
            if(String.isBlank(errorMessage))
            {
               // errorMessage = ValidateServiceDuration(osr,Integer.valueOf(serviceLineItem.Service_Duration__c)); change made on 6sep2018 night 11 pm
               errorMessage = ValidateServiceDuration(osr,Integer.valueOf(serviceLineItem.TotalServiceDuration__c));
                logger.log('ValidateServiceDuration.ErrorMessage',errorMessage);
                if(String.isBlank(errorMessage))
                {
                    errorMessage =ValidateServiceDay(osr,serviceLineItem.Service_Date__c);
                    logger.log('ValidateServiceDay.ErrorMessage',errorMessage);
                    if(String.isBlank(errorMessage))
                    {
                        errorMessage = ValidateSellBeforeTravel(osr, serviceLineItem.Service_Date__c);
                        logger.log('ValidateSellBeforeTravel.ErrorMessage',errorMessage);
                        if(String.isBlank(errorMessage))
                        {
                            logger.log('inside the selection',errorMessage);
                            logger.log('iselected osr',osr);
                            SelectedOSR = osr;
                            break;
                        }
                        else
                        {
                            ErrorMessages.add(errorMessage);
                            continue;
                        }
                    }
                    else
                    {
                        ErrorMessages.add(errorMessage);
                        continue;
                    }
                }
                else{
                    ErrorMessages.add(errorMessage);
                    continue;
                }
            }
            else
            {
                ErrorMessages.add(errorMessage);
                continue;
            }
        }
        
        result.SelectedOSR = SelectedOSR;
        result.ErrorMessages.addAll(ErrorMessages);
        }
        catch(Exception e)
        {
            throw new CustomException('FindOSRResult:' + e.getMessage() );
        }
        return result;
    }
        
    public String ValidateServiceDate( OSR__c osr ,DateTime serviceLineItemdate)
    {
        try
        {
        if(osr.DATE_FROM__c <= serviceLineItemdate 
           && osr.DATE_TO__c >= serviceLineItemdate)
        {
            return VALID_CHECK_MESSGAE;   
        }
        else
        {
            return system.label.Service_Date_Range;           
        }
        }
        catch(Exception e)
        {
            throw new CustomException('ValidateServiceDate:>>' + e.getMessage() );
        }
    }
    
    public String ValidateServiceDuration(OSR__c  osr, Integer serviceDuration)
    {
        try
        {
          logger.log('ValidateSellBeforeTravel.osr',osr);
          logger.log('ValidateSellBeforeTravel.serviceDuration',serviceDuration);
            logger.log('osr.MIN_SCU__c',osr.MIN_SCU__c);
            logger.log('osr.MAX_SCU__c',osr.MAX_SCU__c);
        if(serviceDuration >= osr.MIN_SCU__c && serviceDuration <= osr.MAX_SCU__c)
        {
            return VALID_CHECK_MESSGAE;  
        }
        else
        {
            return  system.label.SCU_Range_Check;
        }
        }
        catch(Exception e)
        {
            throw new CustomException('ValidateServiceDuration:>>' + e.getMessage() );
        }
    }
    
    public String ValidateServiceDay(OSR__c osr, DateTime serviceDate)
    {
        try
        {
        String serviceDayName = UTIL_Date.giveWeekDayName(serviceDate);
        
        if(osr.APPLY_MON__c &&  serviceDayName== 'Mon'
           || osr.APPLY_TUE__c &&  serviceDayName== 'Tue'
           || osr.APPLY_WED__c &&  serviceDayName== 'Wed'
           || osr.APPLY_THU__c &&  serviceDayName== 'Thu'
           || osr.APPLY_FRI__c &&  serviceDayName== 'Fri'
           || osr.APPLY_SAT__c &&  serviceDayName== 'Sat'
           || osr.APPLY_SUN__c &&  serviceDayName== 'Sun')
        {
            return VALID_CHECK_MESSGAE;
        }
        else
        {
            return system.label.Service_Day_Check;
        }
        }
        catch(Exception e)
        {
            throw new CustomException('ValidateServiceDuration:OSR.APPLY_MON__c|TUES|WED|THUR|FRI|SAT|SUN >>' + e.getMessage() );
        }
    }
    
    public String ValidateSellBeforeTravel(OSR__c osr, DateTime serviceDate)
    {
        try
        {
        Date TodaysDate=Date.today();
        Integer dateToCompare =  TodaysDate.daysBetween(date.newinstance(serviceDate.year(), serviceDate.month(), serviceDate.day()));
        logger.log('dateToCompare',dateToCompare);
        logger.log('osr.SELLBEFORETRAVEL__c',osr.SELLBEFORETRAVEL__c);
        if(dateToCompare >= osr.SELLBEFORETRAVEL__c)
        {
            return VALID_CHECK_MESSGAE;
        }
        else
        {
            return system.label.Service_Date_Check;
        }
        }
        catch(Exception e)
        {
            throw new CustomException('ValidateSellBeforeTravel: SELLBEFORETRAVEL__c>>' + e.getMessage() );
        }
    }
    
    public String ValidateStayPay(OSR__c osr, DateTime serviceDate)
    {
        try
        {
	        logger.Log('Validate Stay Pay');
	        if(serviceDate >= osr.STAYPAY_FROM__c 
	        	&& serviceDate <= osr.STAYPAY_TO__c)
		        {
		            return VALID_CHECK_MESSGAE;
		        }
		        else
		        {
		            return system.label.Stay_Pay_Not_Valid;
		        }
        }
        catch(Exception e)
        {
            throw new CustomException('ValidateServiceDay-> OSR.STAYPAY_FROM__c OR OSR.STAYPAY_TO__c:>>' + e.getMessage() );
        }
    }
    
    public Decimal GetDiscountValue(OSR__c  osr,  Integer serviceDuration)
    {
        try
        {
	        String STAY  ='';
	        
	        if(osr.STAY1__c == serviceDuration)
	        {
	            STAY='STAY1__c';
	        }
	        if(osr.STAY2__c == serviceDuration)
	        {
	            STAY='STAY2__c';
	        }
	        if(osr.STAY3__c == serviceDuration)
	        {
	            STAY='STAY3__c';
	        }
	        if(osr.STAY4__c == serviceDuration)
	        {
	            STAY='STAY4__c';
	        }
	        if(osr.STAY5__c == serviceDuration)
	        {
	            STAY='STAY5__c';
	        }
	        if(osr.STAY6__c == serviceDuration)
	        {
	            STAY='STAY6__c';
	        }
	        if(osr.STAY7__c == serviceDuration)
	        {
	            STAY='STAY7__c';
	        }
	        if(osr.STAY8__c == serviceDuration)
	        {
	            STAY='STAY8__c';
	        }
	        if(osr.STAY9__c == serviceDuration)
	        {
	            STAY='STAY9__c';
	        }
	        if(osr.STAY10__c == serviceDuration)
	        {
	            STAY='STAY10__c';
	        }
	        
	        String sourceObject='OSR__c';
	        String targetObjectName='';
	        String targetFieldName ='';
	        Logger.log('STAY',STAY);
	        List<Field_Mapping_For_Rate_Calculation__mdt>
	        				 stayMappings = [SELECT 
	        										Target_Object__c, 
	        										Target_Field__c
										    FROM
										    		 Field_Mapping_For_Rate_Calculation__mdt 
										   WHERE 
										   			Source_Field__c=:STAY
										   	   AND 
										   	        Source_Object__c=:sourceObject];
	        for(Field_Mapping_For_Rate_Calculation__mdt mapping:stayMappings)
	        {
	            targetObjectName=mapping.Target_Object__c;
	            targetFieldName =mapping.Target_Field__c;
                
	        }
	        Logger.log('targetFieldName>>',(Decimal)osr.get(targetFieldName));
	        return (Decimal)osr.get(targetFieldName);
	    }
        catch(Exception e)
        {
            throw new CustomException('GetDiscountValue: OSR.STAY:>>' + e.getMessage() );
        }
    }
    
    public String MatchServiceDuration(OSR__c osr,  Integer serviceDuration)
    {
        try
        {
	        if(osr.STAY1__c == serviceDuration
	           ||osr.STAY2__c == serviceDuration
	           ||osr.STAY3__c == serviceDuration
	           ||osr.STAY4__c == serviceDuration
	           ||osr.STAY5__c == serviceDuration
	           ||osr.STAY6__c == serviceDuration
	           ||osr.STAY7__c == serviceDuration
	           ||osr.STAY8__c == serviceDuration
	           ||osr.STAY9__c == serviceDuration
	           ||osr.STAY10__c == serviceDuration
	          )
	        {
	            return VALID_CHECK_MESSGAE;
	        }
	        else
	        {
	            return system.label.Service_Duration_Check+osr.Id;
	        }
        }
        catch(Exception e)
        {
            throw new CustomException('MatchServiceDuration: OSR.STAY:>>' + e.getMessage() );
        }
    }
    
    public Decimal MapRoomConfigToTotalAdultRate(OPD__c opd, String roomConfiguration)
    {
        try
        {
	        Decimal AdultRate =null;
	        
	        if('SINGLE AVAIL'  == roomConfiguration)
	        {
	             AdultRate = opd.SS__c;
	        }
	        if('TWIN AVAIL'  == roomConfiguration)
	        {
	             AdultRate = opd.TW__c;
	        }
	        if('DOUBLE AVAIL'  == roomConfiguration)
	        {
	             AdultRate = opd.TW__c;
	        }
	        if('QUAD AVAIL'  == roomConfiguration)
	        {
	             AdultRate = opd.QR__c;
	        }
	        if('TRIPLE AVAIL'  == roomConfiguration)
	        {
	             AdultRate = opd.TR__c;
	        }
	        
	        return AdultRate;
        }
        catch(Exception e)
        {
            throw new CustomException('MapRoomConfigToTotalAdultRate: OPD.SS__c:>>' + e.getMessage() );
        }
    }
    
    public static Decimal MapRoomConfigToOPT_PBX(OPD__c opd, String roomConfiguration)
    {
        try
        {
	        Decimal AdultRate =null;
	        
	        if('SINGLE AVAIL'  == roomConfiguration)
	        {
	             AdultRate = opd.SS__c;
	        }
	        if('TWIN AVAIL'  == roomConfiguration)
	        {
	             AdultRate = opd.TW__c;
	        }
	        if('DOUBLE AVAIL'  == roomConfiguration)
	        {
	             AdultRate = opd.TW__c;
	        }
	        if('QUAD AVAIL'  == roomConfiguration)
	        {
	             AdultRate = opd.QR__c;
	        }
	        if('TRIPLE AVAIL'  == roomConfiguration)
	        {
	             AdultRate = opd.TR__c;
	        }
	        
        return AdultRate;
        }
        catch(Exception e)
        {
            throw new CustomException('MapRoomConfigToOPT_PBX: OPD.SS__c:>>' + e.getMessage() );
        }
    }

    public Decimal FindPricePBXBaseOnAdultPassengerCount(OPT__c opt,OPD__c opd, List<Passenger__c> adultPassengers)
    {
        try
        {
	        String matchedPbX = '';
	        if(opt.PBX1__c > = adultPassengers.size())
	        {
	            matchedPbX = 'PBX1__c'; 
	        }
	        if(opt.PBX2__c > = adultPassengers.size() && String.isBlank(matchedPbX))
	        {
	            matchedPbX = 'PBX2__c'; 
	        }
	        
	        if(opt.PBX3__c > = adultPassengers.size() && String.isBlank(matchedPbX))
	        {
	            matchedPbX = 'PBX3__c'; 
	        }
	        if(opt.PBX4__c > = adultPassengers.size() && String.isBlank(matchedPbX))
	        {
	            matchedPbX = 'PBX4__c'; 
	        }
	        if(opt.PBX5__c > = adultPassengers.size() && String.isBlank(matchedPbX))
	        {
	            matchedPbX = 'PBX5__c'; 
	        }
	        if(opt.PBX6__c > = adultPassengers.size() && String.isBlank(matchedPbX))
	        {
	            matchedPbX = 'PBX6__c'; 
	        }
	        if(opt.PBX7__c > = adultPassengers.size() && String.isBlank(matchedPbX))
	        {
	            matchedPbX = 'PBX7__c'; 
	        }
	            
	        String sourceObject='Opt__c';
	        String targetObjectName='';
	        String targetFieldName ='';
	        
	        List<Field_Mapping_For_Rate_Calculation__mdt>
	        								 stayMappings = [SELECT 
																	Target_Object__c,
																    Target_Field__c 
													           FROM 
													                Field_Mapping_For_Rate_Calculation__mdt
													            WHERE 
													                Source_Field__c=:matchedPbX 
													            AND 
													                Source_Object__c=:sourceObject];
	        for(Field_Mapping_For_Rate_Calculation__mdt mapping:stayMappings)
	        {
	            targetObjectName=mapping.Target_Object__c;
	            targetFieldName =mapping.Target_Field__c;
	        }
	        return (Decimal)opd.get(targetFieldName);
        }
        catch(Exception e)
        {
            throw new CustomException('FindPricePBXBaseOnAdultPassengerCount: OPT.PBX:>>' + e.getMessage() );
        }
    }
    
    
    public Decimal GetTotalAdultRate(OPD__c opd, ServiceLineItem__c serviceLineItem,List<Passenger__c> adultPassengers)
    {
        try
        {
        String ServiceLineItem_Room_Configuration_SS = 'SINGLE AVAIL';
        String ServiceLineItem_Room_Configuration_DA = 'DOUBLE AVAIL';
        String ServiceLineItem_Room_Configuration_TW = 'TWIN AVAIL';
        String ServiceLineItem_Room_Configuration_TR = 'TRIPLE AVAIL';
        String ServiceLineItem_Room_Configuration_QD = 'QUAD AVAIL';
        String ServiceLineItem_Room_Configuration_OT = 'OTHER AVAIL';

        logger.log('serviceLineItem.Room_Configuration__c',serviceLineItem.Room_Configuration__c);
        Decimal TotalAdultRate = null;
        if( serviceLineItem.Room_Configuration__c == Servicelineitem_Room_Configuration_SS
          ||serviceLineItem.Room_Configuration__c == Servicelineitem_Room_Configuration_TW
          ||serviceLineItem.Room_Configuration__c == Servicelineitem_Room_Configuration_TR
          ||serviceLineItem.Room_Configuration__c == Servicelineitem_Room_Configuration_QD
		  ||serviceLineItem.Room_Configuration__c == ServiceLineItem_Room_Configuration_DA)
        {
            TotalAdultRate = MapRoomConfigToTotalAdultRate(opd, serviceLineItem.Room_Configuration__c);
            logger.log('opd',opd);
            logger.log('TotalAdultRate',TotalAdultRate);
        }
        if(serviceLineItem.Room_Configuration__c == Servicelineitem_Room_Configuration_OT)
        {
            //Proceed to Use Field OPD>QR for rate for first 4 adults
            TotalAdultRate =opd.QR__c;
            
            //Any Additional Adults > 4 at QR rate, Use ADD Adult1  rate per extra adult, e.g. 6 Adults would be QR + ADD Adult1 + ADD Adult 1. 
            //This gives total Adult for OT room  
            if(adultPassengers.size() > 4)
            {
                TotalAdultRate = TotalAdultRate + ((adultPassengers.size()-4)*opd.ADD_ADULT1__c); 
            }
        }
        return TotalAdultRate;
        }
        catch(Exception e)
        {
            throw new CustomException('GetTotalAdultRate:>>' + e.getMessage() );
        }
    }
    
    public Decimal GetTotalAdultRateForAC_A(OPT__c opt,OPD__c opd, ServiceLineItem__c serviceLineItem,List<Passenger__c> adultPassengers)
    {
        try
        {
        String ServiceLineItem_Room_Configuration_SS = 'SINGLE AVAIL';
        String ServiceLineItem_Room_Configuration_TW = 'TWIN AVAIL';
        String ServiceLineItem_Room_Configuration_DA = 'DOUBLE AVAIL';
        String ServiceLineItem_Room_Configuration_TR = 'TRIPLE AVAIL';
        String ServiceLineItem_Room_Configuration_QD = 'QUAD AVAIL';
        String ServiceLineItem_Room_Configuration_OT = 'OTHER AVAIL';

        
        Decimal TotalAdultRate = null;
        if(serviceLineItem.Room_Configuration__c == Servicelineitem_Room_Configuration_SS
                      ||serviceLineItem.Room_Configuration__c == Servicelineitem_Room_Configuration_TW
                      ||serviceLineItem.Room_Configuration__c == Servicelineitem_Room_Configuration_TR
                      ||serviceLineItem.Room_Configuration__c == Servicelineitem_Room_Configuration_QD
                      ||serviceLineItem.Room_Configuration__c == ServiceLineItem_Room_Configuration_DA)
        {   
            TotalAdultRate = MapRoomConfigToTotalAdultRate(opd, serviceLineItem.Room_Configuration__c);
        }
        if(serviceLineItem.Room_Configuration__c == Servicelineitem_Room_Configuration_OT)
        {
            //Proceed to Use Field OPD>QR for rate for first 4 adults
            TotalAdultRate =opd.QR__c;
            
            //Any Additional Adults > 4 at QR rate, Use ADD Adult1  rate per extra adult, e.g. 6 Adults would be QR + ADD Adult1 + ADD Adult 1. 
            //This gives total Adult for OT room  
            if(adultPassengers.size() > 4)
            {
                TotalAdultRate = TotalAdultRate + ((adultPassengers.size()-4)*FindPricePBXBaseOnAdultPassengerCount(opt,opd,adultPassengers)); 
            }
        }
        return TotalAdultRate;
        }
        catch(Exception e)
        {
            throw new CustomException('GetTotalAdultRateForAC_A:>>' + e.getMessage() );
        }
    }
    
    public class FindOSRResult
    {
        public FindOSRResult()
        {
            ErrorMessages = new Set<String>();
        }
        Set<String> ErrorMessages{get;set;}
        OSR__c SelectedOSR{get;set;}
    }
    
    public class FindOPDResult
    {
        public FindOPDResult()
        {
            ErrorMessages = new Set<String>();
        }
        Set<String> ErrorMessages{get;set;}
        OPD__c SelectedOPD{get;set;}
    }
 }
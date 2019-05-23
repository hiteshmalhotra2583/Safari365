public class TH_ExposureRoe extends BaseTriggerHandler{
    
    private static final String CLASS_NAME = TH_Passenger.class.getName();
    private List<Exposure_ROE__c> newExposureROEList;
    private List<Exposure_ROE__c> oldExposureROEList;
    private Map<ID, Exposure_ROE__c> newExposureROEMap;
    private Map<ID, Exposure_ROE__c> oldExposureROEMap;
    
    public TH_ExposureRoe() {
        oldExposureROEList = (List<Exposure_ROE__c>)Trigger.old;
        newExposureROEList = (List<Exposure_ROE__c>)Trigger.new;
        newExposureROEMap =  (Map<ID, Exposure_ROE__c>)Trigger.newMap;
        oldExposureROEMap = (Map<ID, Exposure_ROE__c>)Trigger.oldMap;
    }
    
    
    protected override void afterInsert() {
        if(Trigger_PAD.canRun('TH_ExposureRoe'))
        {
            populateQuoteExposure();
        }
    }
    
    
     protected override void afterUpdate() {
        if(Trigger_PAD.canRun('TH_ExposureRoe'))
        {
            populateQuoteExposure();
        }
    }
    
    
    public void populateQuoteExposure()
    {
        List<Id> exposureIds = new List<Id>();
        for(Exposure_ROE__c eRoe: newExposureROEList)
        {
            exposureIds.add(eRoe.Id);
        }
        List<Exposure_ROE__c> toProcessRecords =[SELECT 
                                                        Id,
                                                        Quote_Exposure__c,
                                                        EXP_Quotation_Sale_Total_in_Selected_CC__c,
                                                        Quotation_Sale_Total_in_Selected_CC__c ,
                                                        Quotation__c
                                                FROM 
                                                        Exposure_ROE__c
                                                   WHERE
                                                         ID IN:exposureIds  ];
        
        List<Exposure_ROE__c> toUpdateExposureROE = new List<Exposure_ROE__c>();
        Set<Id> quotationIds = new Set<Id>();
       
        for(Exposure_ROE__c e: toProcessRecords)
        {
            if(e.Quotation_Sale_Total_in_Selected_CC__c > 0)
            {
                e.Quote_Exposure__c = ((e.Quotation_Sale_Total_in_Selected_CC__c/e.EXP_Quotation_Sale_Total_in_Selected_CC__c) - 1)*100;
                if(Integer.valueof(e.Quote_Exposure__c) < Integer.valueof(Label.Exposure_Threshold))
                {
                    quotationIds.add(e.Quotation__c);
                }
                toUpdateExposureROE.add(e);
            }
        }
      
      Set<Quotations__c> toUpdateQuotation = new Set<Quotations__c>();
      if(!quotationIds.isEmpty())
      {
        List<Quotations__c> allQuotations = DAL_Quotations.getAllQuotations(new List<Id>(quotationIds));
        for(Quotations__c q: allQuotations)
        {
            q.Approval_from_FX_Treasury_Required__c = true;
            toUpdateQuotation.add(q);
        }
      }
      
      if(!toUpdateQuotation.isEmpty())
      {
        BaseTriggerHandler.bypass('TH_Quotations');
        update new List<Quotations__c>(toUpdateQuotation);
       BaseTriggerHandler.clearBypass('TH_Quotations');
      }
      
      if(!toUpdateExposureROE.isEmpty())
     {
       BaseTriggerHandler.clearAllBypasses();
       BaseTriggerHandler.bypass('TH_ExposureRoe');
       BaseTriggerHandler.bypass('TH_Quotations');
        update toUpdateExposureROE;
       BaseTriggerHandler.clearBypass('TH_ExposureRoe');
       BaseTriggerHandler.clearBypass('TH_Quotations');
     }
    
    }   
     
}
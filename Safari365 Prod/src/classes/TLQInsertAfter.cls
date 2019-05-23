public class TLQInsertAfter {
    
    //create your variables and data structures

    //constructor
    public TLQInsertAfter(){
        
    }
    
    //constructor accepting a list of TLQs
    public TLQInsertAfter(TL_Quotation__c[] myTLQs){
     
     Set<Id> OppIds  = new Set<Id>();
      Set<Id> TLQIds  = new Set<Id>();
      
      List<TL_Quotation__c> NonPrimTLQ = new List<TL_Quotation__c>();
      
       for (TL_Quotation__c t : myTLQs){
       OppIds.add(t.Opportunity__c);  //add the TLQ's Opp id into the Opp Set
       TLQIds.add(t.id);
       }
                         
     Map<Id, Double> OppISPEMap = new Map<Id, Double>();
    Map<Id, Double> OppSalesMap = new Map<Id, Double>();
    Map<Id, Double> OppCoSMap = new Map<Id, Double>();
    Map<Id, Double> OppGrossProfitMap = new Map<Id, Double>();
    
    //get a list of all tlq records that are primary for this opp
    List<AggregateResult> TLQAgg = [select Opportunity__c, sum(Invoice_Selling_Price_Excl__c), sum(Sales__c), sum(CoS__c), sum(Gross_Profit__c)
    from TL_Quotation__c where Primary_Quotation__c = true AND Opportunity__c IN :OppIds group by Opportunity__c];
    
    // sum the amounts
    for(AggregateResult q : TLQAgg ){

      OppISPEMap.put((Id)q.get('Opportunity__c'),(Double)q.get('expr0'));
      OppSalesMap.put((Id)q.get('Opportunity__c'),(Double)q.get('expr1'));
      OppCoSMap.put((Id)q.get('Opportunity__c'),(Double)q.get('expr2'));
      OppGrossProfitMap.put((Id)q.get('Opportunity__c'),(Double)q.get('expr3'));
      }
    
   List<TL_Quotation__c> TLQQuery = new List<TL_Quotation__c>();
  
     //get all the primary quotations for this opp     
   TLQQuery =  [Select Id, Travel_Date__c, Invoice_Selling_Price_Incl__c, Invoice_Selling_Price_Excl__c, Proforma_Date__c, 
               Receipt_Date__c, CoS__c, Gross_Profit_Perc__c, Gross_Profit__c, ROE__c, Opportunity__c, Sales__c, 
               CreatedDate from TL_Quotation__c WHERE Opportunity__c = :OppIds AND Primary_Quotation__c = true ];
    system.debug('TLQQuery = '+TLQQuery);
    
     Map<Id, Double> OppROEMap =   new Map<Id, Double>();
     Map<Id, Id> OppTLQMap =   new Map<Id, Id>(); 
     Map<Id, Date> OppTravelDateMap =   new Map<Id, Date>();  
     
    for(TL_Quotation__c RelatedTLQ : TLQQuery){
      if(TLQQuery.size() > 0){
      
      OppROEMap.put((Id)RelatedTLQ.get('Opportunity__c'),(Double)RelatedTLQ.get('ROE__c'));
      OppTLQMap.put((Id)RelatedTLQ.get('Opportunity__c'),(Id)RelatedTLQ.get('Id'));
      OppTravelDateMap.put((Id)RelatedTLQ.get('Opportunity__c'),(Date)RelatedTLQ.get('Travel_Date__c'));
     }
    }
//------------ UPDATE THE OPP(s) WITH ALL THE SUMS AND AGGREGATES--------------------------------//    
    List<Opportunity> OppAmounttoUpdate = new List<Opportunity>();
     
    List<Opportunity> OppQueryList = new List<Opportunity>();
     OppQueryList = [Select Id, Amount, StageName,Arrival_Date__c,Invoice_Date__c from Opportunity where Id IN : OppIds];
     
     for(Opportunity o : OppQueryList ){
         o.Amount = OppsalesMap.get(o.Id);
         o.CoS__c = OppCoSMap.get(o.Id);
         o.Gross_Profit__c = OppGrossProfitMap.get(o.Id);
         o.ROE__c = OppROEMap.get(o.Id);
         o.Arrival_Date__c=OppTravelDateMap.get(o.Id);
         //o.Invoice_Date__c=OppTravelDateMap.get(o.Id);
        
     OppAmountToUpdate.add(o);
      }
     
    update OppAmountToUpdate;     
           
    }
}
public class TLQInsertBefore {
    
    //create your variables and data structures

    //constructor
    public TLQInsertBefore(){
        
    }
    
    //constructor accepting a list of TLQs
    public TLQInsertBefore(TL_Quotation__c[] myTLQs){
                             
        Set<Id> OppSet = new Set<Id>();
       
            for (TL_Quotation__c tlq : myTLQs) {                         // if an item is marked as primary, add the purchased country to the map where the sales order id is the key 
                if (tlq.Primary_by_Consultant__c == FALSE){
                OppSet.add(tlq.Opportunity__c);
                }
                 
            }
              
               
            // query for the tlqs in the context to update
            List<TL_Quotation__c> tlqlist = [select id, Newest_TLQ__c, Primary_by_Consultant__c, Opportunity__c from TL_Quotation__c
                                            where id NOT IN :myTLQs AND Opportunity__c IN :OppSet and Primary_by_Consultant__c =false];
                for (TL_Quotation__c tl : tlqlist){
                    tl.Primary_Quotation__c = FALSE;
                    tl.Newest_TLQ__c = FALSE;
                }
            
            // commit the records 
            update tlqlist; 
           
    }
}
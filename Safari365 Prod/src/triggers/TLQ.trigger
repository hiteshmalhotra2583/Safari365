trigger TLQ on TL_Quotation__c (before insert, before update, after insert, after update) {

    if(trigger.isBefore){
        if(trigger.isInsert){
            TLQInsertBefore myInsertBefore = new TLQInsertBefore(Trigger.new);
        }
        if(trigger.isUpdate){
            TLQUpdateBefore myUpdateBefore = new TLQUpdateBefore(Trigger.new,Trigger.old);
        }
    }
    
    if(trigger.isAfter){
        if(trigger.isInsert || Trigger.isUpdate){
            TLQInsertAfter myInsertAfter = new TLQInsertAfter(Trigger.new);
        }
  /*      if(Trigger.isUpdate){
            TLQUpdateAfter myUpdateAfter = new TLQUpdateAfter(Trigger.new, Trigger.old);
        } */
    } 
}
global class CreatePassengerServiceReqButtonHelper{


    webservice static Passenger__c createPassengerAccount(Id AccountId, Id OppId ,String Type, String name){
      
     Passenger__c acc  = new Passenger__c();
     acc.Opportunity__c =OppId;
     acc.Account__c = AccountId;
     acc.PassengerName__c = Name;
     acc.PassengerType__c = Type;
     return acc;
    }

    webservice static void createPassenger(Id AccountId, Id OppId, String Type, Integer counts)
    {
     	Integer lastCount = DAL_Passenger.getExisitingCouunt(Type,OppId);
        if(lastCount==NULL)
        {
            lastCount =0;
        }
     	String name ='';
        List<Passenger__c> Passengers = new List<Passenger__c>();
        
        for(Integer i = 1;i<=counts;i++)
        {
            lastCount = ++lastCount;
            String lastValue = String.valueof(lastCount);
            name = Type+ ' '+lastValue;
            Passengers.add(createPassengerAccount(AccountId,OppId,Type, name));
         }
        DAL_BaseObject.InsertDBObjects(Passengers);
    }


}
public class DAL_Passenger {
    
 public static final String OBJECT_NAME = Passenger__c.SObjectType.getDescribe().getLocalName();

 public static Integer getExisitingCouunt(String passengerType , Id oppId)
 {
   String query ='SELECT count() from Passenger__c WHERE PassengerType__c =\''+passengerType + '\' AND Opportunity__c ='+'\''+oppId  +'\'';
   Integer  count= database.countQuery(query);
   return count;

 }
 
 
public static List<Passenger__c> getByIds(List<String> ids)
{
  return [Select 
                Id,
                Name,
                PassengerType__c,
                Given_Age__c,
                PassengerName__c,
                Is_Primary__c,
                Entitled_to_Photobook_s__c,
                New_Account__c,
                Account__c,
                Opportunity__c,
                Create_Sub_Opportunity__c,
                Travel_Insurance_Policy_Provider__c,
                Travel_Insurance_Policy_Number__c,
                Travel_Insurance__c,
                Policy_Emergency_Phone_Number__c,
                International_Flight_Departure_Details__c,
                International_Flight_Arrival_Details__c,
                Waiver_Of_Liability__c,
                Waiver_Of_Liability_Date__c,
                Waiver_Of_Liability_Name__c,
                Sub_Opportunity__c,
                Last_Name__c,
                Confirmed__c,
                WebSite_Origin_From_Parent_Account__c,
                Privacy_Policy_Agreed__c,
                Subscribe_me_to_newsletter__c
            FROM 
                Passenger__c
           WHERE 
                Id IN:ids
        ORDER BY
                PassengerName__c ];
}

public static List<Passenger__c> getPrimaryByIds(List<String> ids)
{
  return [Select 
                Id ,
                PassengerType__c,
                Given_Age__c,
                PassengerName__c
            FROM 
                Passenger__c
           WHERE 
                Id IN:ids AND Is_Primary__c=:true];
}    
public static List<Passenger__c> getById(String id)
{
  List<String> s = new List<String>();
  s.add(id);
  return getByIds(s);
}
 
public static List<String> GetPassengerAgeList()
{
    List<String> options = new List<String>();
    options.add('--Select Age--');    
        Schema.DescribeFieldResult fieldResult = Passenger__c.Given_Age__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

        for (Schema.PicklistEntry f: ple) {
            options.add(f.getLabel());
        }       
        return options;
}    


public static List<PassengerQuotationMapping__c> getAllQuotationsRelatedToPassengers(Set<Id> passengerIds)
{
    return [Select 
                Id ,
                Passenger__c,
                Quotation__c
            FROM 
                PassengerQuotationMapping__c
           WHERE 
                Passenger__c IN:passengerIds];
}

public static List<PassengerQuotationMapping__c> getAllPassengerQuotation(List<Id> quotationIds)
{
    return [Select 
                    Id,
                    Passenger__r.Name,
                    Passenger__c,
                    Quotation__c,
                    Quotation__r.Quotation_Stage__c,
                    Passenger__r.Waiver_Of_Liability__c
                FROM 
                    PassengerQuotationMapping__c
               WHERE 
                    Quotation__c IN:quotationIds];
}

    public static Passenger__c getPasenger_DynamiCSOQL(String PassengerId) {
        try
        {
            String query = 'SELECT ';
            for(Schema.FieldSetMember f : SObjectType.Passenger__c.FieldSets.WS_GetPassenger.getFields()) {
                query += f.getFieldPath() + ',';
            }
            query = query.substring(0, query.length()-1);
            query += ' FROM Passenger__c WHERE Id = \''+PassengerId+'\'';
            return Database.query(query);
        }
        catch(Exception e){
            return null;
        }
       
    }
    
    public static List<Passenger__c> getPasengers_DynamiCSOQL(List<String> PassengerIds) {
        try
        {
            String query = 'SELECT ';
            for(Schema.FieldSetMember f : SObjectType.Passenger__c.FieldSets.WS_GetPassenger.getFields()) {
                query += f.getFieldPath() + ',';
            }
            query = query.substring(0, query.length()-1);
            query += ' FROM Passenger__c WHERE Id IN (';
            for(String str  : PassengerIds){
                query += '\'' + str + '\',';    
            }
            query = query.substring(0, query.length()-1) + ')';
            return Database.query(query);
        }
        catch(Exception e){
            return null;
        }
        
    }

 public static List<WS_GetPassengers.PassengerInfoWrapper> getPassengersDetailsByQuotationId(List<Id> quotationIds)
 {
    List<PassengerQuotationMapping__c> mappingRecords = getAllPassengerQuotation(quotationIds);
    List<String> passengerIds = new List<String>();
    Map<String, String> QuationStatusMap =new Map<String, String>(); 
    for(PassengerQuotationMapping__c pqm: mappingRecords)
    {
        passengerIds.add(pqm.Passenger__c);
        QuationStatusMap.put(pqm.Passenger__c,pqm.Quotation__r.Quotation_Stage__c);
    }
    
    List<Passenger__c> passengers =getByIds(passengerIds);
    List<WS_GetPassengers.PassengerInfoWrapper> passengerInfoWrappers =new List<WS_GetPassengers.PassengerInfoWrapper>();
    for(Passenger__c p:passengers )
    {
        passengerInfoWrappers.add( new WS_GetPassengers.PassengerInfoWrapper(p.PassengerType__c,p.Is_Primary__c,
                          p.PassengerName__c,String.valueof(p.Id),QuationStatusMap.get(p.Id),p.Waiver_Of_Liability__c));
    }
    
    return passengerInfoWrappers;
 }
}
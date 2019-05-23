public class DAL_Account {
    
    public static final String OBJECT_NAME = Account.SObjectType.getDescribe().getLocalName();
    public static Map<Id, Account> getById(Set<Id> ids)
    {
      return new Map<Id,Account >([SELECT
                  Id,
                  Name,
                  FirstName,
                  LastName
             FROM 
                  Account
            WHERE 
                Id IN :ids]);
    }
        
    public static Account getAccount_DynamiCSOQL(String oppId) {
        try
        {
            String query = 'SELECT ';
            for(Schema.FieldSetMember f : SObjectType.Account.FieldSets.WS_GetAccount.getFields()) {
                query += f.getFieldPath() + ',';
            }
            query = query.substring(0, query.length()-1);
            query += ' FROM Account WHERE ID IN (SELECT AccountId from Opportunity where Id = \''+oppId+'\')';
        
            return Database.query(query);
        }
        catch(Exception e){
            return null;
        }
       
    }
    
    public static Account getAccountById(String accId)
    {
      return [SELECT
                  Id,
                  Name,
                  FirstName,
                  LastName,
                  GoogleAccFolderId__c,
                  ShippingCity,
                  ShippingCountry,
                  ShippingPostalCode,
                  ShippingState,
                  ShippingStreet,
                  ShippingLatitude,
                  ShippingLongitude
             FROM 
                  Account
            WHERE 
                Id = :accId];
    }
     
    public static Account getPersonAccountById(String accId)
    {
      return [SELECT
                  Id,
                  FirstName,
                  LastName,
                  GoogleAccFolderId__c,
                  ShippingCity,
                  ShippingCountry,
                  ShippingPostalCode,
                  ShippingState,
                  ShippingStreet,
                  ShippingLatitude,
                  ShippingLongitude
             FROM 
                  Account
            WHERE 
                Id = :accId];
    }
    
    public static Account getAccountByEmailId(String EmailId)
    {
      return [SELECT
                  Id,
                  Initiate_Forget_Id_Workflow__c
             FROM 
                  Account
             WHERE 
                PersonEmail = :EmailId];
    }

    
}
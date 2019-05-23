public class DAL_USER {
	
      private static final String CLASS_NAME = DAL_USER.class.getName();
      
      public static Map<Id,User> getUserByIds(Set<Id> userIds)
      {
      	return new MAP<Id,USER>([SELECT
      									Id,
      									EMAIL
      								FROM
      									 User
      								WHERE
      								     ID IN:userIds]);
      }
      
      
      public static User getbyOwnerId(Id userid)
      {
      	return [ SELECT
  			            Id,
  						EMAIL,
  						ProfileImageUrl__c,
  						User_Profile_Intro__c,
  						ProfileUrl__c,
  						MobilePhone,
  						Extension,
  						Phone,
  						Name
  				    FROM
  						 User
  					WHERE
  						 ID =:userid limit 1];
  }
}
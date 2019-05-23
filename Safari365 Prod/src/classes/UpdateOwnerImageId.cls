public class UpdateOwnerImageId{

    public static void updateImageId(List<Lead> lst_Lead){

        Set<String> set_OwnerIds = new Set<String>();
        for(Lead l : lst_Lead){
            if(l.ownerid != null){
                set_OwnerIds.add(l.OwnerId);
            }
        }
        Map<Id, User> map_Users = new Map<Id, User>([ Select Id, ProfileImageUrl__c, ProfileUrl__c from User Where ID IN:set_OwnerIds] );

        for(Lead l : lst_Lead){
            if( l.OwnerId != null && map_Users.containsKey(l.OwnerId)){
                l.OwnerImageId__c = map_Users.get(l.ownerId).ProfileImageUrl__c;
                l.Consultant_Profile__c = map_Users.get(l.ownerId).ProfileUrl__c;
            }
        }
        
    }
    
}
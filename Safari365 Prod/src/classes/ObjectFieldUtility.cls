public class ObjectFieldUtility {

    public static List<FieldInfo> getAllfieldsDescription(String ObjectAPIName){
        List<FieldInfo> lst_Fields = new List<FieldInfo>();
        SObjectType ObjectType = Schema.getGlobalDescribe().get(ObjectAPIName);
        Map<String,Schema.SObjectField> mfields = ObjectType.getDescribe().fields.getMap();
        for(String fieldKey : mfields.keyset()){
            Schema.SObjectField FieldAPIName = mfields.get(fieldKey);
            Schema.DescribeFieldResult fieldResult = FieldAPIName.getDescribe(); 
            String fieldType =  String.valueof(fieldResult.getType());
            String fieldLabel =  String.valueof(fieldResult.getLabel());
            FieldInfo fieldObj = new FieldInfo(fieldLabel, fieldKey , fieldType);
            if(fieldType.equalsignoreCase('Picklist')){
                for(Schema.PicklistEntry  pickVal : fieldResult.getPicklistValues()){
                    if(pickVal.isActive()){
                        fieldObj.PicklistValues.add(pickVal.getValue());  
                    }           
                }
            }
            lst_Fields.add(fieldObj);
        }
        return lst_Fields;
    }
    
    public class FieldInfo{
        public string FieldName;
        public string FieldAPIName;
        public string FieldType;
        public List<string> PicklistValues;
        public FieldInfo(String f_Name, String f_APIName, String f_Type){
            this.FieldName = f_Name;
            this.FieldAPIName = f_APIName;
            this.FieldType = f_Type;
            PicklistValues = new List<String>();
        }
    }
}
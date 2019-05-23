public with sharing class Util_LabelTranslate {
	
     
    public  String translate(String labelName, String language){
            Pagereference r = Page.CustomLabelTranslator_VF;
            r.getParameters().put('label_lang', language);
            r.getParameters().put('label', labelName);  
            String labelValue = r.getContent().toString();
            return labelValue;
    }
     
    
}
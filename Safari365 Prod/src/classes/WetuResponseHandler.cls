public class WetuResponseHandler
 {
	
	public static void ProcessResponse(String responseXml,String requestXml, Quotations__c quotation)
    {
       
        CreateContentDocumentLink(requestXml,'Wetu Request','Request.xml', quotation);
        CreateContentDocumentLink(responseXml,'Wetu Response','Response.xml', quotation);
        
        if(responseXml != null)
        {
	        XPath xp = new XPath(responseXml);
			
	        Dom.XmlNode[] actualNodes = xp.find(xp.root, '/soap:Envelope/soap:Body/AuthenticateAndSaveItineraryResponse/AuthenticateAndSaveItineraryResult');
	        Dom.XmlNode[] IdentifierNodes = xp.find(actualNodes[0], './Identifier');
	        Dom.XmlNode[] IdentifierKeyNodes = xp.find(actualNodes[0], './IdentifierKey');
	        
	        quotation.Wetu_Identifier__c = IdentifierNodes[0].getText().trim();
	        quotation.Wetu_Identifier_Key__c = IdentifierKeyNodes[0].getText().trim();
	        
	        upsert quotation;
        }
        
    }
    
    private static void CreateContentDocumentLink(String xmlStr,String title, String pathOnClient, Quotations__c quotation)
    {
        String versonData = 'Error Occured!!!!!!';
        system.debug('xmlStr>>>>'+xmlStr);
        if(xmlStr != null &&  xmlStr !='')
        {
       	 system.debug('inside the if block >>>>'+xmlStr);
       	 versonData = xmlStr;
        }
        system.debug('versonData>>>>'+versonData);
        ContentVersion conVer = new ContentVersion();
        conVer.ContentLocation = 'S';    
        conVer.PathOnClient = pathOnClient;  
        conVer.Title = title;  
        conVer.VersionData = Blob.valueOf(versonData);
        insert conVer;
         
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
         
        //System.debug('Content document>>'+[SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id]);
        
        //Create ContentDocumentLink
        ContentDocumentLink cDe = new ContentDocumentLink();
        cDe.ContentDocumentId = conDoc;
        cDe.LinkedEntityId = quotation.Id;  
        cDe.ShareType = 'V';  
        cDe.Visibility = 'AllUsers';
        insert cDe;
    }
}
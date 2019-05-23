({
	doInitHelper : function(component, event, helper) {
		var action = component.get("c.createOrNotQuotationItineraryDocOnGDLtng");
        var quotationId = component.get("v.recordId");       
        action.setParams({
            "quotationId": quotationId,
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resultStatus = response.getReturnValue();
                if(resultStatus == "true"){
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Success!",
                            "type":"success",
                            "message": "Quotation Itinerary Doc Created In Google Drive Successfully."
                        });
                        toastEvent.fire();
                    	var urlEvent = $A.get("e.force:navigateToSObject");
                        urlEvent.setParams({
                          "recordId": quotationId
                        });
                        urlEvent.fire();
                    	$A.get("e.force:closeQuickAction").fire();
                    
                }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "type":"error",
                        "message": resultStatus
                    });
                    toastEvent.fire();
                    //$A.get('e.force:refreshView').fire();
                    $A.get("e.force:closeQuickAction").fire();
                }
            }
            else {
                var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "type":"error",
                        "message": "There is some error while processing."
                    });
                toastEvent.fire();
               // $A.get('e.force:refreshView').fire();
                $A.get("e.force:closeQuickAction").fire();  
            }
        });
        $A.enqueueAction(action);
	}
})
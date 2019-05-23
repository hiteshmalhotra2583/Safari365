({
	doInitHelper : function(component, event, helper) {
		var action = component.get("c.processRequestLtng");
        var quotationId = component.get("v.recordId");       
        action.setParams({
            "quotationId": quotationId,
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resultStatus = response.getReturnValue();
                if(resultStatus == "successMsg"){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "type":"success",
                        "message": "WETU Itinerary Updated Successfully."
                    });
                    toastEvent.fire();
                    $A.get("e.force:closeQuickAction").fire();
                }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "type":"error",
                        "message": resultStatus
                    });
                    toastEvent.fire();
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
                $A.get("e.force:closeQuickAction").fire();
            }
        });
        $A.enqueueAction(action);
	}
})
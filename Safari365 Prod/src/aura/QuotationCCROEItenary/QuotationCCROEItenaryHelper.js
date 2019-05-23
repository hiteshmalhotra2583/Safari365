({
	doInitHelper: function(component, event) {
		var quotationId = component.get("v.recordId");
        var action = component.get("c.updateAllCCROIFields");
        action.setParams({
            quotationId: quotationId
        });
        var self = this;
        // set call back 
        action.setCallback(this, function(response) {
            var resultStatus = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS") {
                if(resultStatus == "success")
                {                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "type":"success"
                    });
                    toastEvent.fire();
                    self.doIteneraryHelper(component,event);
                    //$A.get("e.force:closeQuickAction").fire();
                    //$A.get('e.force:refreshView').fire(); 
                }
                else if(resultStatus == "FailureFXRateLocked")
                {
                    $A.get("e.force:closeQuickAction").fire();
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "type":"error",
                        "message": "Itinerary Document not created as FX Rate Refresh has been disabled. If needed, please contact FX manager to create"
                    });
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire(); 
                }
                else
                {
                    $A.get("e.force:closeQuickAction").fire();
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "type":"error",
                        "message":resultStatus
                    });
                    toastEvent.fire(); 
                    $A.get('e.force:refreshView').fire();
               }
            // handel the response errors        
            } else if (state === "INCOMPLETE") {
                alert("From server: " + response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error!");
                }
            }
        });
        // enqueue the action
        $A.enqueueAction(action);
	},
    doIteneraryHelper : function(component, event) {
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
                    	$A.get('e.force:refreshView').fire();                    
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
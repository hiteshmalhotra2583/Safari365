({
	doInitHelper: function(component, event) {
		var quotationId = component.get("v.recordId");
        var action = component.get("c.updateManuallyCCROIFields");
        action.setParams({
            quotationId: quotationId
        });
        
        // set call back 
        action.setCallback(this, function(response) {
            var resultStatus = response.getReturnValue();
            var state = response.getState();
            debugger;
            if (state === "SUCCESS") {
                if(resultStatus == "success")
                {
                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "type":"success",
                        "message": "Quotation CC ROE Fields Updated Successfully!"
                    });
                    toastEvent.fire();
                    $A.get("e.force:closeQuickAction").fire();
                    $A.get('e.force:refreshView').fire(); 
                }
                else
                {
                    $A.get("e.force:closeQuickAction").fire();
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "type":"error",
                        "message": resultStatus
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
	}
})
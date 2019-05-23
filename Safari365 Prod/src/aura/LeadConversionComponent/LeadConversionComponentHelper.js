({
	doInitHelper : function(component, event, helper) {
       var leadId = component.get("v.recordId");
       var action = component.get("c.leadConversion");
       action.setParams({
            "leadId": leadId,
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                window.location = '/lead/leadconvert.jsp?retURL='+leadId+'&id='+leadId;
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
({
	doInit : function(component, event, helper) {
        helper.doInitHelper(component, event, helper);
        $A.get('e.force:refreshView').fire();
	}
})
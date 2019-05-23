({
	 doInit : function(component, event, helper) {
        helper.loadChargeType(component, event);
        helper.loadCurrency(component, event);
        helper.loadNettCost(component, event);
        helper.loadMarkup (component, event);
    },
    
    doCancel: function(component, event,helper) {
  		helper.doCancel(component, event);
  	},
  
    saveChargeType : function(component, event,helper) {
		helper.save(component, event);
        helper.doCancel(component, event);
  	},
  
    saveAndNewChargeType : function(component, event,helper) {
		helper.saveAndNewChargeType(component, event);
     }
})
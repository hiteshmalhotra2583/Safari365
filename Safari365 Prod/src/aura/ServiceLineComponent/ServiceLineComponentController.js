({
    doInit : function(component, event, helper) {
		helper.doInit(component, event); 
        helper.loadServiceStatus(component, event);
        
    },
    dateChange: function(component, event, helper) {
        helper.dateChange(component);
        
    },
    serviceDateChange: function(component, event, helper) {
        helper.serviceDateChange(component);
        
    },
    onServiceTypeChange : function(component, event, helper) {
	  helper.onServiceTypeChange(component, event);
    },
    
    onLocationChange : function(component, event, helper) {
      helper.onLocationChange(component, event);	
    },
    
    onPreferredSupplierChange : function(component, event, helper) {
      helper.onPreferredSupplierChange(component, event);	
    },
    
    onSupplierNameChange : function(component, event, helper) {
        helper.onSupplierNameChange(component, event);
    },
  
    onUpdateCheckboxes : function(component, event, helper) {
    	helper.onUpdateCheckboxes(component, event);  
	},
    
    doCancel: function(component, event,helper) {
  		helper.doCancel(component, event);
  	},
  
    saveServiceLine : function(component, event,helper) {
		helper.save(component, event);
        //helper.doCancel(component, event);
  	},
  
    saveAndNewServiceLine : function(component, event,helper) {
		helper.saveAndNewServiceLine(component, event);
	 },
    
    handleSelectLookupItemEvent  : function(component, event,helper) {
       helper.handleSelectLookupItemEvent(component, event);
	},
    handleCancelLookupSelectionEvent  : function(component, event,helper) {
       helper.handleCancelLookupSelectionEvent(component, event);
	},
    handleSelectLookupWetuStartLocationEvent  : function(component, event,helper) {
       helper.handleSelectLookupWetuStartLocationEvent(component, event);
	},
    handleCancelLookupWetuStartLocationEvent  : function(component, event,helper) {
       helper.handleCancelLookupWetuStartLocationEvent(component, event);
	},
    handleSelectLookupWetuEndLocationEvent  : function(component, event,helper) {
       helper.handleSelectLookupWetuEndLocationEvent(component, event);
	},
    handleCancelLookupWetuEndLocationEvent  : function(component, event,helper) {
       helper.handleCancelLookupWetuEndLocationEvent(component, event);
	},
    openModel: function(component, event, helper) {
        helper.OpenPassengerAgeModel(component, event);
        var ctarget = event.currentTarget;
    	var selectedPassenger  = ctarget.dataset.value;
        
        component.set("v.SelectedPassenger", selectedPassenger);
      	component.set("v.ShowPopup", true);
   },
 
   closeModel: function(component, event, helper) {
       helper.closeModel(component, event);
      	//component.set("v.ShowPopup", false);
   },
 
   updatePassengerAge: function(component, event, helper) {
       helper.updatePassengerAge(component, event);
          //var selectedPassenger = component.get("v.SelectedPassenger");
     
      	//component.set("v.ShowPopup", false);
   },
    setSelectedLineItemDate : function(component, event, helper) {
        helper.setSelectedLineItemDate(component, event);
	}   ,
	
	    loadOptions: function (component, event, helper) {
	        var options = [
	            { value: "new", label: "New" },
	            { value: "in-progress", label: "In Progress" },
	            { value: "finished", label: "Finished" }
	        ];
	        component.set("v.statusOptions", options);
	    },
	    handleChange: function (cmp, event) {
	        // Get the string of the "value" attribute on the selected option
	        var selectedOptionValue = event.getParam("value");
	        alert("Option selected with value: '" + selectedOptionValue + "'");
	    }
})
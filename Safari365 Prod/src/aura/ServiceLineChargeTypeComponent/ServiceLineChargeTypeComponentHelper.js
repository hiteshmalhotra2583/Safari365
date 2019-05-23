({
	loadChargeType : function(component, event) {
        var action = component.get("c.getChargeTypes");
        var inputsel = component.find("InputChargeType");
        var opts=[];
        action.setCallback(this, function(a) {
            for(var i=0;i< a.getReturnValue().length;i++){
                opts.push({"class": "optionClass", label: a.getReturnValue()[i], value: a.getReturnValue()[i]});
            }
            inputsel.set("v.options", opts);
			
        });
        $A.enqueueAction(action); 
    },
    loadCurrency : function(component, event) {
        var action = component.get("c.getCurrencyTypes");
        var inputsel = component.find("InputCurrency");
        var opts=[];
        action.setCallback(this, function(a) {
            for(var i=0;i< a.getReturnValue().length;i++){
                opts.push({"class": "optionClass", label: a.getReturnValue()[i], value: a.getReturnValue()[i]});
            }
            inputsel.set("v.options", opts);
			
        });
        $A.enqueueAction(action); 
    },
    loadNettCost : function(component, event) {
        var action = component.get("c.getNettCostTypes");
        var inputsel = component.find("InputNettCost");
        var opts=[];
        action.setCallback(this, function(a) {
            for(var i=0;i< a.getReturnValue().length;i++){
                opts.push({"class": "optionClass", label: a.getReturnValue()[i], value: a.getReturnValue()[i]});
            }
            inputsel.set("v.options", opts);
			
        });
        $A.enqueueAction(action); 
    },
    loadMarkup : function(component, event) {
        var action = component.get("c.getMarkupTypes");
        var inputsel = component.find("InputMarkup");
        var opts=[];
        action.setCallback(this, function(a) {
            for(var i=0;i< a.getReturnValue().length;i++){
                opts.push({"class": "optionClass", label: a.getReturnValue()[i], value: a.getReturnValue()[i]});
            }
            inputsel.set("v.options", opts);
			
        });
        $A.enqueueAction(action); 
    },
    save : function(component, event) 
    {
        var name = component.find("InputName").get("v.value");
    	var chargeType = component.find("InputChargeType").get("v.value");
    	var currency = component.find("InputCurrency").get("v.value");
    	var nettCost = component.find("InputNettCost").get("v.value");
    	var markup = component.find("InputMarkup").get("v.value");
    	var total = component.find("InputTotal").get("v.value");  
    	
        var serviceLineItemId = component.get("v.serviceLineItemId");   
        
        if(chargeType=='--Select Charge Types--')
        {
			chargeType = '';
        }
        
        if(currency=='--Select Currency--')
        {
            currency = '';
        }
        
        
    	var action = component.get("c.saveServiceLineChargeType");
    	action.setParams({ 
        	"name":name,
        	"chargeType": chargeType,
        	"currency_c": currency,
        	"nettCost": nettCost,
        	"markup": markup,
        	"total":total,
        	"serviceLineItemId":serviceLineItemId
    	});
    	action.setCallback(this, function(a) {
           var state = a.getState();
            if (state === "SUCCESS") {
                var name = a.getReturnValue();
                alert("Saved successfully!");
            	}
            else if (state === "ERROR") {
                var errors = a.getError();
                
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                                 errors[0].message);
                        alert(errors[0].message);
                    }
                } else { alert("Unknown error");
                    console.log("Unknown error");
                }
            }
        	});
    	$A.enqueueAction(action);
    },
    saveAndNewChargeType : function(component, event) {
        this.save(component, event);
        this.setNewChargeType(component, event);
    },
    doCancel : function(component, event) {
        var quotationId = component.get("v.quotationId");   
        window.open((location.origin+"/"+quotationId),'_parent');
    },
    setNewChargeType: function(component, event) {
        var opts=[];
        component.find("InputName").set("v.value",'');
        component.find("InputChargeType").set("v.value",null);
    	component.find("InputCurrency").set("v.options", opts);
    	component.find("InputNettCost").set("v.options", opts);
    	component.find("InputMarkup").set("v.options", opts);
    	component.find("InputTotal").set("v.value",'');;  
	},
})
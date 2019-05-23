({
    doInit : function(component, event) {
        var quotationId = component.get("v.quotationId"); 
        //alert(quotationId);
        var action = component.get("c.getQuotationPricingDetails");
        
        var hasConfirmed = false;
       
        action.setParams({ 
            "quotationId":quotationId,
        });
        
        action.setCallback(this, function(a) { 
            var state = a.getState();
            if (state === "INCOMPLETE") {
                alert('No server response. The server might be down or the client might be offline.');
            }
            if (state === "SUCCESS") {
                //alert(JSON.stringify(a.getReturnValue()));
                component.set("v.QuotationPricingSummary", a.getReturnValue());
            }
            if (state === "ERROR") {
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
   calculateDepositValues: function(component, event) {
       var quotationId = component.get("v.quotationId");
       var depositeDueAmountUSD,depositeDueAmountZAR,depositeDueAmountEUR;
        if(component.find("depositeDueAmountUSD")){
            
            depositeDueAmountUSD = component.find("depositeDueAmountUSD").get("v.value");
        
        }
        if(component.find("depositeDueAmountZAR")){
            depositeDueAmountZAR = component.find("depositeDueAmountZAR").get("v.value");
        }
        if(component.find("depositeDueAmountEUR")){
            depositeDueAmountEUR = component.find("depositeDueAmountEUR").get("v.value");
        }
        if(depositeDueAmountZAR==''){
            alert('Please Enter Deposit Due Amount ZAR');
            return;
        }
        if(depositeDueAmountUSD==''){
            alert('Please Enter Deposit Due Amount USD');
            return;
        }
        if(depositeDueAmountEUR==''){
            alert('Please Enter Deposit Due Amount EUR');
            return;
        }
       var action = component.get("c.calculatedDepositValues");
        action.setParams({ 
            "quotationId":quotationId,
            "depositeDueAmountZAR":depositeDueAmountZAR,
            "depositeDueAmountUSD":depositeDueAmountUSD,
            "depositeDueAmountEUR":depositeDueAmountEUR
           });
        
        action.setCallback(this, function(a) { 
            var state = a.getState();
           // alert('state'+state);
            if (state === "INCOMPLETE") {
                alert('No server response. The server might be down or the client might be offline.');
            }
            if (state === "SUCCESS") {
            	component.set("v.QuotationPricingSummary", a.getReturnValue());
            	// $A.get('e.force:refreshView').fire();
            }
            if (state === "ERROR") {
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
        
    }
    
})
({ 
    loadQuotationLineItems: function (component, event) {
        var loadingCmp = component.find('loading');
        //console.log(loadingCmp);

        $A.util.toggleClass(loadingCmp, 'slds-hide');
        	component.set('v.showError', false);
		
        var action1 = component.get("c.getTreeTableCol");
        action1.setCallback(this, function(response){
            var state = response.getState();
			
            if (component.isValid() && state === "SUCCESS") {
            
                var returnData = JSON.parse(response.getReturnValue());
                
                var config = component.get('v.treeConfig');
                config.columns = returnData;
                config.columns.filterTable = {};
                component.set('v.treeConfig', config);
                component.set('v.hasConfig', true);
                component.set('v.tableFilter', {});
            }
            else{
                component.set('v.showError', true);
                console.log(response);
                component.set('v.errorMessage', 'Please Contact your system administrator' );
          }
        });
        $A.enqueueAction(action1);

        var action = component.get("c.getQuotationLineItemList");
        var quotationId = component.get("v.quotationId");   
        action.setParams({ 
        	"quotationId":quotationId,
        });
        action.setCallback(this, function(response){
            var state = response.getState();
			
            if (component.isValid() && state === "SUCCESS") {
                var returnData = JSON.parse(response.getReturnValue());
                var temp =[];
                for(var key in returnData){
                    console.log(key);
                    if(returnData[key].HasChildren){
                        console.log('this has children');
                        console.log(returnData[key]);
                    }
                    temp.push(returnData[key]);
                }
                console.log(temp.length);
                component.set("v.treeItems", temp);
                $A.util.toggleClass(loadingCmp, 'slds-hide');
               this.defaultExpandCollapse(component, event);
            }
            else{
                component.set('v.showError', true);
                console.log(response);
                component.set('v.errorMessage', 'Please Contact your system administrator' );
                $A.util.toggleClass(loadingCmp, 'slds-hide');
            }
        });
        $A.enqueueAction(action);
        
        var action2 = component.get("c.getQuotationStage");
        //alert(quotationId);
        action2.setParams({ 
        	"quotationId":quotationId,
        });
        action2.setCallback(this, function(response){
            var state = response.getState();
			
            if (component.isValid() && state === "SUCCESS") {
                var quotationStage = response.getReturnValue();
                
                if(quotationStage == 'Confirmed')
                {
                    component.set("v.disableButton", true);
                }
                else
                {
                     component.set("v.disableButton", false);
                }

            }
            else{
                component.set('v.showError', true);
                console.log(response);
                component.set('v.errorMessage', 'Please Contact your system administrator' );
                $A.util.toggleClass(loadingCmp, 'slds-hide');
            }
        });
        $A.enqueueAction(action2);
        
    },
    
    loadListItems : function(component, event, helper){
        var action = component.get("c.getQuotationLineItems");
        var quotationId = component.get("v.quotationId");   
        action.setParams({ 
        	"quotationId":quotationId,
        });
        action.setCallback(this, function(a) {
		        component.set("v.listItems", a.getReturnValue() );	
        });
        $A.enqueueAction(action); 

    },
    defaultExpandCollapse:function(component,event)
    {
        var action = component.get("c.getPageDefaultOpenSetting");

        action.setCallback(this, function(response){
            if(component.isValid() && response !== null && response.getState() == 'SUCCESS'){
                var returnData = JSON.parse(response.getReturnValue());
                
                if(returnData == true)
                {
                	this.handleExpendAll(component,event);    
                }
            }
        });

    $A.enqueueAction(action);
    },
    handleCollapseAll:function(component,event)
    { 
        var allItems = component.get("v.treeItems");
       //alert(allItems.length);
      
        for(var i=0;i<allItems.length; i++)
        {
            var currentItem = allItems[i];
            var nodPosition= 'tree-'+ i.toString();
            
            if(currentItem.childRecords != null && currentItem.childRecords.length != 0)
            {
                //alert(nodPosition);
            	this.collapseItem(component,nodPosition);
            }
        }
        var cae = $A.get("e.c:CollapseAllEvent");
        //cae.setParams({"childClass": nodPosition});
        //cae.setParams({"allItems": allItems});
        cae.fire();
    },
    collapseItem : function(component, childClass) {
       
        var elements = document.getElementsByClassName ( childClass );
		
        console.log(elements);
       
            for(var i=0; i<elements.length; i++){
                elements[i].className += ' slds-hide';
            }

    },
    handleTreeExpansion: function (component, event) { 
        var selection = event.getParam("selection");
        var nodePos = event.getParam("nodeposition");
        var temp = component.get("v.treeItems");
        this.expandItem(component,event,selection,nodePos,temp);
        event.stopPropagation();
    },
    
    handleExpendAll:function(component,event)
    { 
        var allItems = component.get("v.treeItems");
        
     	//alert(JSON.stringify(allItems));
     	var parentPositionsMapping = [];
        for(var i=0;i<allItems.length; i++)
        { 
            var currentItem = allItems[i];
            var nodPosition= i.toString();
            parentPositionsMapping[i]=currentItem.Id;
            this.expandItem(component,event,currentItem,nodPosition,allItems);
        }
        for(var i=0;i<allItems.length; i++)
        { 
            var action = component.get("c.getRelatedRecords");
            action.setParams({ 
        	"quotationLineItemId":allItems[i].Id,
    	    });
            
            action.setCallback(this, function(response){
            var state = response.getState();
            
            console.log(response);
            if (component.isValid() && state === "SUCCESS") {
                var childRecords = JSON.parse(response.getReturnValue());
                //alert(JSON.stringify(childRecords));
                for(var j=0; j<childRecords.length; j++){
                    childRecords[j].ServiceLineItem.Day_Order__c=j+1;
                    var currentChildItem = childRecords[j];
                    var parentId = currentChildItem['ServiceLineItem']['QuotationLine__r']['Id'];
                    var parentIndex = parentPositionsMapping.indexOf(parentId);
                    
                    var childNodPosition= parentIndex.toString()  + '-' + j.toString();
                    this.expandItem(component,event,currentChildItem,childNodPosition,allItems);  
                }
            }
         });
        $A.enqueueAction(action);      
        }
    },
    expandItem:function(component,event,selectedItem,nodPosition,treeItems)
    { 
        //var serviceStatus = component.get("v.serviceLineStatus");
        
        var selection = selectedItem;
        //var temp = component.get("v.treeItems");
        var temp = treeItems;
        var nodePos = nodPosition;
        var pos = nodePos.split('-');
        //alert('nodePos: '+ nodePos);
        //alert('pos: '+ pos);
        var temp1;
		
        var loadingCmp = component.find('loading');
        //console.log(loadingCmp);
        $A.util.toggleClass(loadingCmp, 'slds-hide');
        component.set('v.showError', false);
        var action ;
        
        if( selection.Type == 'ServiceLineItem__c')
        {
            action = component.get("c.getGrandChildRecords");
            action.setParams({ 
        	"serviceLineItemId":selection.Id,
	        });
        }
        else
        {
            action = component.get("c.getRelatedRecords");
            action.setParams({ 
        	"quotationLineItemId":selection.Id,
    	    });
        }
        
        action.setCallback(this, function(response){
            var state = response.getState();
            
            console.log(response);
            if (component.isValid() && state === "SUCCESS") {
                var returnData = JSON.parse(response.getReturnValue());
                //console.log(returnData);
                //console.log(returnData);
                var nopos=0;
                for(var i=0; i<pos.length; i++){
                    if(temp1 == undefined)
                    {
                           temp1 = temp[pos[i]];
                        	nopos=pos[i];
                        //alert('inside if temp1 value is: '+ JSON.stringify(temp1));
                    }
                     
                    else
                    {
                        temp1 = temp1.childRecords[pos[i]];
                        nopos=pos[i];
                        //alert('inside else temp1 value is: '+ JSON.stringify(temp1));
                    }
                        
                    // console.log(temp1);
                }
                if(!(selection.Type == 'ServiceLineItem__c')){
                    for(var i=0;i<returnData.length;i++){
                        returnData[i].ServiceLineItem.Day_Order__c=i+1;
                        returnData[i].nopos=nopos; 
                    }
                }
                temp1.childRecords = returnData;
                //alert(JSON.stringify(temp1.childRecords));
                console.log(temp);
                
                component.set("v.treeItems", temp);
                
                component.set("v.refreshItem", nodePos);
                
                //component.set("v.serviceLineStatus", serviceStatus);
                
                $A.util.toggleClass(loadingCmp, 'slds-hide');
                
                // console.log(loadingCmp);
            }
            else{
                component.set('v.showError', true);
                console.log(response);
                component.set('v.errorMessage', 'Please Contact your system administrator' );
                $A.util.toggleClass(loadingCmp, 'slds-hide');
            }

        });
        $A.enqueueAction(action);
    },
    getPillsData: function (component, event, itemsMap, selectedItems) {

        var pills = [];
        for(var key in itemsMap){
            if(itemsMap[key] != null){
                var pillItem ={};
                pillItem['key'] = key;
                pillItem['value'] = itemsMap[key].Name;
                pills.push(pillItem);
            }

        }
        component.set('v.selectedItems', selectedItems);
        component.set('v.selectedItemMap', itemsMap);
        component.set('v.pillItems', pills);


        if(selectedItems.length>0){
            component.set('v.hasQuotationLineItems', true);
        }
        else{
            component.set('v.hasQuotationLineItems', false);
        }

    },
    handleShowModelEvent: function (component, event, helper) {
        
        var selection = event.getParam("selection");
        var mode = event.getParam("mode");
		component.set("v.Mode",mode);
        
        if(mode=='Add')
        {
            component.set("v.showServiceLine",true); 
            component.set("v.selectedQuotationLineItem",selection.Id);
        	component.set("v.selectedQuotationLineItemName",selection.Name);
        	this.setDate(component,selection.Id);
        }
		if(mode=='Edit' && selection['Type']== 'ServiceLineItem__c')
        {
            component.set("v.showServiceLine",true); 
            component.set("v.selectedQuotationLineItem",selection['ServiceLineItem']['QuotationLine__r']['Id']);
            component.set("v.selectedQuotationLineItemName",selection['ServiceLineItem']['QuotationLine__r']['Name']);
            component.set("v.currentServiceLineItem",selection);
            this.setDate(component,selection['ServiceLineItem']['QuotationLine__r']['Id']);    
        }
        if(mode=='Edit' && selection['Type']== 'Service_Line_Item_ChargeType__c')
        {
            var chargeTypeId = selection['Id'];   
        	window.open((location.origin+"/"+chargeTypeId),'_blank');
        }
        if(mode=='Delete' && selection['Type']== 'ServiceLineItem__c')
        {
            if (confirm('Are you sure you want to delete this service line item?')) {
                this.DeleteServiceLineItem(component,event,selection['ServiceLineItem']['Id']);
            } else {
                // Do nothing!
            }
        }
        if(mode=='Delete' && selection['Type']== 'Service_Line_Item_ChargeType__c')
        {
            if (confirm('Are you sure you want to delete this service line charge type item?')) {
                this.DeleteServiceLineChargeType(component,event,selection['Id']);
            } else {
                // Do nothing!
            }
        }
        if((mode=='Up' || mode=='Down' )&& selection['Type']== 'ServiceLineItem__c'){
            var allItems = component.get("v.treeItems");
       		
            var SLItem = allItems[selection.nopos].childRecords;
            var currOrder=1;
            var orderUpdate=[];
            
            for(var i=0; i<SLItem.length; i++){
                if(SLItem[i].Id==selection.Id){
                    currOrder=i+1;
                }
                orderUpdate.push(SLItem[i].Id);
            }
            if(mode=='Up' && currOrder==1){
                return;
            }
            else if(mode=='Down' && currOrder==SLItem.length){
                return;
            }
            if(mode=='Up'){
                var val=orderUpdate.splice(currOrder-1, 1);
                orderUpdate.splice(currOrder-2, 0,val[0] );
                var sl=SLItem.splice(currOrder-1, 1);
                SLItem.splice(currOrder-2, 0,sl[0] );
                
            }
            if(mode=='Down'){
                var val=orderUpdate.splice(currOrder-1, 1);
            	orderUpdate.splice(currOrder, 0,val[0] );
                var sl=SLItem.splice(currOrder-1, 1);
                SLItem.splice(currOrder, 0,sl[0] );
            }
                
            console.log(orderUpdate);
            
			this.OrderServiceLineItem(component,event,orderUpdate,SLItem,selection.nopos);                                                               
            
        }
        
        event.stopPropagation();
    },
    handleDeleteItemCheckboxEvent: function (component, event, helper) {
        
        var selection = event.getParam("selection");
        var isChecked = event.getParam("isChecked");
		
        if (isChecked)
        {
            // Checkbox is checked - add id to checkedContacts
            if (component.get("v.itemsToDelete").indexOf(selection.Id) < 0)
            {
                component.get("v.itemsToDelete").push(selection.Id);
            }
        } 
        else
        {
            // Checkbox is unchecked - remove id from checkedContacts
            var index = component.get("v.itemsToDelete").indexOf(selection.Id);
            if (index > -1)
            {
                component.get("v.itemsToDelete").splice(index, 1);
            }
        }
        
        event.stopPropagation();
    },
    handleDeleteItems: function (component, event, helper) {
        var itemsToDelete = component.get("v.itemsToDelete");
        if(itemsToDelete.length == 0)
        {
            alert('No item is selected to delete');
        }
        else
        {
            var loadingCmp = component.find('loading');
        	$A.util.toggleClass(loadingCmp, 'slds-hide');
            
            var action = component.get("c.deleteSelectedItems");
  
        action.setParams({ 
        	"itemsToDelete":itemsToDelete
        });
        action.setCallback(this, function(a) {
            $A.util.toggleClass(loadingCmp, 'slds-hide');
             var state = a.getState();
            if (state === "INCOMPLETE") {
            	alert('No server response. The server might be down or the client might be offline.');
            }
            if (state === "SUCCESS") {
                var errorMessages = '';
                for(var i=0;i< a.getReturnValue().length;i++){
                 errorMessages = errorMessages + a.getReturnValue()[i] + '\n';
            	}
                if(errorMessages.length > 0)
                {
                   alert(errorMessages);
                }
                else
                {
                    alert("Deleted successfully!");
                    this.Refresh(component, event);
                }
            }
            else if (state === "ERROR") {
                var btn = event.getSource();
                var errors = a.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                                 errors[0].message);
                        alert(errors[0].message);
                    }
                } else { 
                    console.log("Unknown error");
                }
            }
        });
        
        $A.enqueueAction(action); 
        }
    },
    handleShowCrmEvent: function (component, event, helper) {
        
        var selection = event.getParam("selection");
       
		if( selection['Type']== 'ServiceLineItem__c')
        {
            var crmCode =  selection['ServiceLineItem']['Crm_Code__c'];
            this.showCrmRecord(component,event,crmCode);
        }
        
        event.stopPropagation();
    },
    showCrmRecord:function(component,event,crmCode)
    {
        var action = component.get("c.getCrmIdByCode");
  
        action.setParams({ 
        	"crmCode":crmCode
        });
        action.setCallback(this, function(a) {
             var state = a.getState();
            if (state === "INCOMPLETE") {
            	alert('No server response. The server might be down or the client might be offline.');
            }
            if (state === "SUCCESS") { 
                 var crmId =  a.getReturnValue();
                window.open((location.origin+"/"+crmId),'_blank');  
            }
            else if (state === "ERROR") {
                 
                var errors = a.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                                 errors[0].message);
                        alert(errors[0].message);
                    }
                } else { 
                    console.log("Unknown error");
                }
            }
        });
        
        $A.enqueueAction(action); 
    },
    DeleteServiceLineChargeType:function(component,event,Id)
    {
        var loadingCmp = component.find('loading');
        $A.util.toggleClass(loadingCmp, 'slds-hide');
        var action = component.get("c.deleteServiceLineChargeType");
  
        action.setParams({ 
        	"chargeTypeId":Id
        });
        action.setCallback(this, function(a) {
            $A.util.toggleClass(loadingCmp, 'slds-hide');
             var state = a.getState();
            if (state === "INCOMPLETE") {
            	alert('No server response. The server might be down or the client might be offline.');
            }
            if (state === "SUCCESS") {
                var errorMessages = '';
                for(var i=0;i< a.getReturnValue().length;i++){
                 errorMessages = errorMessages + a.getReturnValue()[i] + '\n';
            	}
                if(errorMessages.length > 0)
                {
                   alert(errorMessages);
                }
                else
                {
                    alert("Deleted successfully!");
                    this.Refresh(component, event);
                }
            }
            else if (state === "ERROR") {
                var btn = event.getSource();
                var errors = a.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                                 errors[0].message);
                        alert(errors[0].message);
                    }
                } else { 
                    console.log("Unknown error");
                }
            }
        });
        
        $A.enqueueAction(action); 
    },
    DeleteServiceLineItem:function(component,event,Id)
    {
        var loadingCmp = component.find('loading');
        $A.util.toggleClass(loadingCmp, 'slds-hide');
        var action = component.get("c.deleteServiceLineItem");
  
        action.setParams({ 
        	"servieLineItemId":Id
        });
        action.setCallback(this, function(a) {
        	$A.util.toggleClass(loadingCmp, 'slds-hide');
             var state = a.getState();
            if (state === "INCOMPLETE") {
            	alert('No server response. The server might be down or the client might be offline.');
            }
            if (state === "SUCCESS") {
                var errorMessages = '';
                for(var i=0;i< a.getReturnValue().length;i++){
                 errorMessages = errorMessages + a.getReturnValue()[i] + '\n';
            	}
                if(errorMessages.length > 0)
                {
                   alert(errorMessages);
                }
                else
                {
                    alert("Deleted successfully!");
                    this.Refresh(component, event);
                }
            }
            else if (state === "ERROR") {
                var btn = event.getSource();
                var errors = a.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                                 errors[0].message);
                        alert(errors[0].message);
                    }
                } else { 
                    console.log("Unknown error");
                }
            }
        });
        
        $A.enqueueAction(action); 

    },
    OrderServiceLineItem:function(component,event,orderData,SLItem,pos)
    {
        var loadingCmp = component.find('loading');
        $A.util.toggleClass(loadingCmp, 'slds-hide');
        var action = component.get("c.orderServiceLineItem");
  
        action.setParams({ 
        	"data":orderData
        });
        action.setCallback(this, function(a) {
        	$A.util.toggleClass(loadingCmp, 'slds-hide');
             var state = a.getState();
            if (state === "INCOMPLETE") {
            	alert('No server response. The server might be down or the client might be offline.');
            }
            if (state === "SUCCESS") {
               // this.Refresh(component, event);
                
                var treeData=component.get("v.treeItems");
                var removeData=treeData.splice(pos, 1);
                component.set("v.treeItems",treeData);
                
                removeData[0].childRecords=SLItem;
                treeData.splice(pos, 0,removeData[0] );
                component.set("v.treeItems",treeData);
            }
            else if (state === "ERROR") {
                var btn = event.getSource();
                var errors = a.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                                 errors[0].message);
                        alert(errors[0].message);
                    }
                } else { 
                    console.log("Unknown error");
                }
            }
        });
        
        $A.enqueueAction(action); 

    },
    setDate:function(component,Id)
    {
        var action = component.get("c.GetQuotationLineItemDate");
  
        action.setParams({ 
        	"quotationLineItemId":Id
        });
        action.setCallback(this, function(a) {
            component.set("v.selectedLineItemDate",a.getReturnValue());
			
      	var itemDateChangeEvent = $A.get("e.c:ItemDateChangeEvent");
        itemDateChangeEvent.setParams({"itemDate": a.getReturnValue()});
                                
        itemDateChangeEvent.fire();   
        });
        
        $A.enqueueAction(action); 
    },
    Refresh : function(component, event) {
        var quotationId = component.get("v.quotationId");   
        window.open((location.origin+"/"+quotationId),'_parent');
	},
    /*
    handleUpdateMarkupEvent: function (component, event, helper) {
        var selection = event.getParam("selection");
        var markupValue = event.getParam("markupValue");
        
        if(markupValue == undefined || markupValue.length == 0)
        {
            alert('Markup value is empty');
        }
        else
        {
            var loadingCmp = component.find('loading');
        	$A.util.toggleClass(loadingCmp, 'slds-hide');
            
            var action = component.get("c.updateMarkupValue");
  
        action.setParams({ 
        	"chargeTypeId":selection.Id,
            "markupValue":markupValue
        });
        action.setCallback(this, function(a) {
            $A.util.toggleClass(loadingCmp, 'slds-hide');
             var state = a.getState();
            if (state === "INCOMPLETE") {
            	alert('No server response. The server might be down or the client might be offline.');
            }
            if (state === "SUCCESS") {
                var errorMessages = '';
                for(var i=0;i< a.getReturnValue().length;i++){
                 errorMessages = errorMessages + a.getReturnValue()[i] + '\n';
            	}
                if(errorMessages.length > 0)
                {
                   alert(errorMessages);
                }
                else
                {
                    alert("Updated successfully!");
                    //this.loadQuotationLineItems(component, event);
                    this.handleExpendAll(component,event);  
                    //$A.get('e.force:refreshView').fire();
                    //this.Refresh(component, event);
                }
            }
            else if (state === "ERROR") {
                var btn = event.getSource();
                var errors = a.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                                 errors[0].message);
                        alert(errors[0].message);
                    }
                } else { 
                    console.log("Unknown error");
                }
            }
        });
        
        $A.enqueueAction(action); 
        }
        
        event.stopPropagation();
    },
    */
    handleUpdateItemsEvent: function (component, event, helper) {
        var updatedItem = event.getParam("updatedItem");
        
        var chargeObjId  = updatedItem.ChargeTypeId;
        var serviceObjId   = updatedItem.ServiceLineItemId;
        
        var allItems = component.get("v.itemsToUpdate");
        
        if(allItems != undefined)
        {
            for(var i=0;i< allItems.length;i++)
            {
                if(allItems[i].ServiceLineItemId == serviceObjId && allItems[i].ChargeTypeId == null)
                {
                    allItems.splice(i, 1);
                    //component.get("v.itemsToUpdate").splice(i, 1);
                }
                else if(allItems[i].ChargeTypeId == chargeObjId && allItems[i].ServiceLineItemId == null)
                {
                    allItems.splice(i, 1);
                    //component.get("v.itemsToUpdate").splice(i, 1);
                }
            }
        }
         
        allItems.push(updatedItem);
        //alert(JSON.stringify(component.get("v.itemsToUpdate")));
        event.stopPropagation();
    },
    
    handleUpdateItems: function (component, event, helper) {
        var allItems = component.get("v.itemsToUpdate");
        if(allItems.length == 0)
        {
            alert('No item to update');
            return;
        }
        var loadingCmp = component.find('loading');
        $A.util.toggleClass(loadingCmp, 'slds-hide');
        
        var action = component.get("c.updateChargeTypes");
  
        action.setParams({ 
        	"chargeTypesToUpdate":JSON.stringify(component.get("v.itemsToUpdate"))
        });
        action.setCallback(this, function(a) {
            $A.util.toggleClass(loadingCmp, 'slds-hide');
             var state = a.getState();
            if (state === "INCOMPLETE") {
            	alert('No server response. The server might be down or the client might be offline.');
            }
            if (state === "SUCCESS") {
                var errorMessages = '';
                for(var i=0;i< a.getReturnValue().length;i++){
                 errorMessages = errorMessages + a.getReturnValue()[i] + '\n';
            	}
                if(errorMessages.length > 0)
                {
                   alert(errorMessages);
                }
                else
                {
                    alert("Updated successfully!");
                    //this.loadQuotationLineItems(component, event);
                    this.handleExpendAll(component,event);  
                }
            }
            else if (state === "ERROR") {
                var btn = event.getSource();
                var errors = a.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                                 errors[0].message);
                        alert(errors[0].message);
                    }
                } else { 
                    console.log("Unknown error");
                }
            }
        });
        
        $A.enqueueAction(action); 
    },
})
({
    parseItem : function(component) {
        var config = component.get("v.config");
        var item = component.get("v.item");
        item = item.records != undefined ? item.records : item;
        
        var label;
        var hasChildren;
        var children = [];
        var id;
        var data =[];

        if (typeof item === 'string'){
            label = item;
        }
        else if (Array.isArray(item) && item.length > 0) {
            label = this.getLabelFromArray(item);
            children = item;
        }
        else if (typeof item === 'object') {
            label = this.getLabelFromObject(item, config.labelProperties);
            id = item.Id;
            //alert(config.columns.columnList);
            data = this.getGridColumnsFromObject(item, config.columnProperties, config.columns.columnList,component);
			            
            children = this.getChildrenFromObject(item, config.expandProperties);
        }
        else
            throw "Unknown node type: "+ typeof item;

        hasChildren = item.HasChildren != undefined ? item.HasChildren : children.length>0 ? true : false;
        
        component.set("v.label", label);
        
        component.set("v.hasChildren",hasChildren);
        component.set("v.hasButton",true);
        
        if(item.ServiceStatus != undefined)
        {
            var opts=[];
            
            for(var i=0;i< item.ServiceStatus.length;i++){
                opts.push({"class": "optionClass", label: item.ServiceStatus[i], value: item.ServiceStatus[i]});
            }
                
            component.set("v.serviceLineStatus", opts);
            
        }
       
        //serviceStatus
        component.set("v.children", children);
		        //alert(JSON.stringify(item.QuotationStage));
        if(item['Type']=='ServiceLineItem__c')
        {
            if(item.QuotationStage != 'Confirmed')
            {
               component.set("v.buttonName",'Edit'); 
            }
            
            var serviceStatusComponent = component.find("ServiceLineStatus");
            
            if(serviceStatusComponent != undefined)
            {
                serviceStatusComponent.set("v.value", item['ServiceLineItem']['Service_Status__c']);
            }
        }
        if( item['Type']=='QuotationLineItem__c')
        {
            if(item.QuotationStage != 'Confirmed')
            {
            	component.set("v.buttonName",'Add');
            }
        }
        component.set("v.id", id);
        component.set("v.data", data);
        component.set("v.columns", config.columns.columnList);
        return children;
    },

    getGridColumnsFromObject: function (item, columnProperties, columns,component) {
        var data=[];
        
        for(var i=0; i<columns.length; i++){
            var value ='';
            
            if( columns[i]=='Name' && item['Type']=='ServiceLineItem__c')
            {
                value = item['ServiceLineItem']['Name'] ;
            }
            
            if( columns[i]=='Name' && item['Type']=='QuotationLineItem__c')
            {
                value =item['item']['Format_Date__c'] ;
            }
            
            if( columns[i]=='Name' && item['Type']=='Service_Line_Item_ChargeType__c')
            {
                value = item['item']['Service_Line_Item__r']['Name'] ;
            }
            if( columns[i]=='Service_Line_Item__r.Service_Status__c' && item['Type']=='ServiceLineItem__c')
            {
                value = item['ServiceLineItem']['Service_Status__c'] ;
            }
            if( columns[i]=='Service_Line_Item__r.ClientNotes__c' && item['Type']=='ServiceLineItem__c')
            {
                value = item['ServiceLineItem']['ClientNotes__c'] ;
            }
            if( columns[i]=='Service_Line_Item__r.ClientNotes__c' && item['Type']=='Service_Line_Item_ChargeType__c')
            {
            }
            if( columns[i]=='Service_Line_Item__r.Basis__c' && item['Type']=='Service_Line_Item_ChargeType__c')
            {
                value = item['item']['Service_Line_Item__r']['Basis__c'] ;
            }
            if( columns[i]=='Service_Line_Item__r.Service_Status__c' && item['Type']=='Service_Line_Item_ChargeType__c')
            {
            }
            if( columns[i]=='Service_Line_Item__r.Service_Detail__c' && item['Type']=='Service_Line_Item_ChargeType__c')
            {
                if(('Include Passenger Insurance ZAR' == item['item']['Extra__c'])
                   || ('Include Passenger Insurance USD' == item['item']['Extra__c'])
                   || ('Include Photobooks USD' == item['item']['Extra__c'])
                   || ('Include Photobooks ZAR' == item['item']['Extra__c']))
                {
                    value = item['item']['Extra__c'];
                }
                else
                {
                    value = item['item']['Service_Line_Item__r']['Service_Detail__c'] ;
                }
                
            }
            if( columns[i]=='Selected_Passenger__r.PassengerName__c' && item['Type']=='Service_Line_Item_ChargeType__c')
            {
                value = item['item']['Selected_Passenger__r']['PassengerName__c'] ;
            }
            if( columns[i]=='Total__c' && item['Type']=='ServiceLineItem__c')
            {
                if(item['ServiceLineItem']['Total__c'] == undefined)
                {
                    value = '0';
                }
                else
                {
                    var n= Number(item['ServiceLineItem']['Total__c']);
                	value = n.toLocaleString();
                }
            }
            if( columns[i]=='Markup__c' && item['Type']=='ServiceLineItem__c')
            {
                 
                if(item['ServiceLineItem']['Markup__c'] == undefined)
                {
                    value = '0%';
                }
                else
                {
                    var n= Number(item['ServiceLineItem']['Markup__c']);
                    value = n.toLocaleString() + '%';    
                }
            }
                        
            if( columns[i]=='Nett_Cost__c' && item['Type']=='ServiceLineItem__c')
            {
                if(item['ServiceLineItem']['Nett_Cost__c'] == undefined)
                {
                    value = '0';
                }
                else
                {
                    var n= Number(item['ServiceLineItem']['Nett_Cost__c']);
					value = n.toLocaleString();
                }
            }
             
            if( columns[i]=='Service_Line_Item__r.Crm_Code__c' && item['Type']=='ServiceLineItem__c')
            {
                value = item['ServiceLineItem']['Crm_Code__c'] ;
            }
            if( columns[i]=='Total__c' && item['Type']=='Service_Line_Item_ChargeType__c')
            {
                value = item['item']['Total__c'] ;
            }
            if( columns[i]=='Markup__c' && item['Type']=='Service_Line_Item_ChargeType__c')
            {
                //value = item['item']['Markup__c'] + '%';
                value = item['item']['Markup__c'] ;
            }
            
            if( columns[i]=='Nett_Cost__c' && item['Type']=='Service_Line_Item_ChargeType__c')
            {
                value = item['item']['Nett_Cost__c'] ;
            }
            if( columns[i]=='Category__c' && item['Type']=='Service_Line_Item_ChargeType__c')
            {
                value = item['item']['Category__c'] ;
            }
            if( columns[i]=='Extra__c' && item['Type']=='Service_Line_Item_ChargeType__c')
            {
                if(('Include Passenger Insurance ZAR' != item['item']['Extra__c'])
                   &&('Include Passenger Insurance USD' != item['item']['Extra__c'])
                   &&('Include Photobooks USD' != item['item']['Extra__c'])
                   &&('Include Photobooks ZAR' != item['item']['Extra__c']))
                {
                    value = item['item']['Extra__c'] ;
                }
                
            }
            if( columns[i]=='Currency__c' && item['Type']=='Service_Line_Item_ChargeType__c')
            {
                value = item['item']['Currency__c'] ;
            }
            
            if( columns[i]=='Charge_Type__c' && item['Type']=='Service_Line_Item_ChargeType__c')
            {
                value = item['item']['Charge_Type__c'] ;
            }
            
            data.push(value);
            
        }
        return data;
    },

    getLabelFromArray : function(item) {
        if (item.length == 1)
            return "List of one item";
        return "List of "+ item.length +" items";
    },

    getLabelFromObject : function(item, labelProperties) {
        var label = null;
        for (var i=0; label == null && i<labelProperties.length; i++) {
            var value = item[labelProperties[i]];
            if (value !== undefined && typeof value === 'string')
            {
                label = value;
             }
        }
        return (label == null) ? 'Undefined label' : label;
    },

    getChildrenFromObject : function(item, expandProperties) {
      var children = null;
        for (var i=0; children == null && i<expandProperties.length; i++) {
            
            var value = item[expandProperties[i]];
            
            if (value !== undefined)
                children = value;
        }
        return (children == null) ? [] : children;
    },

    toggleNodeExpand : function(component, childClass) {
        var toggleExpandIcon = component.get("v.toggleExpandIcon");
        var subTree = component.find('subTree');
        var elements = document.getElementsByClassName ( childClass );
		
        console.log(elements);
        if (toggleExpandIcon == "utility:chevrondown") { 
            for(var i=0; i<elements.length; i++){
                elements[i].className += ' slds-hide';
            }

            this.changeIcon(component, "utility:chevronright");
        }
        else {
            for(var i=0; i<elements.length; i++){
                var cn = elements[i].className;
				var re = new RegExp('slds-hide', 'g');
				var newcn = cn.replace(re, '');
                
                elements[i].className = newcn;
            }
            //alert(toggleExpandIcon);
            this.changeIcon(component, "utility:chevrondown");
            
        }
    },

    changeIcon : function(component, svgIcon) {
        component.set("v.toggleExpandIcon", svgIcon);
    },

    fireExpansionEvent: function (component, event, childClass) {
        
        //var inputsel = component.get("v.serviceLineStatus");
        //alert(JSON.stringify(inputsel));
        
        var expansionEvent = component.getEvent("treeExpansionEvent");
        expansionEvent.setParams({"selection": component.get('v.item')});
        expansionEvent.setParams({"nodeposition": childClass.replace('tree-','')});
        expansionEvent.fire();
    },

    onShowModelEvent: function (component, event, helper) {

        var showModelEvent = component.getEvent("showModelEvent");
        var mode = '';
        
        var actionSelector = component.find("ActionSelector");
        if(actionSelector != null && actionSelector != undefined)
        {
            mode = actionSelector.get("v.value");
        }
        else
        {
            mode = component.get('v.buttonName');
        }
        showModelEvent.setParams({
            "selection": component.get('v.item'),
            "isSelected": component.get('v.isSelected'),
            "mode":mode
        });
        
        showModelEvent.fire();
        
    },

    fireSelectionEvent: function (component, event) {
        var selectionEvent = component.getEvent("treeSelectionEvent");
        selectionEvent.setParams({
            "selection": component.get('v.item'),
            "isSelected": component.get('v.isSelected')
        });
        selectionEvent.fire();
    },

    navigateToRecord : function(component, event) {
        var item = component.get('v.item');

        if(this.isLightningExperienceOrSalesforce1()){
            //Open lightning record view
            window.open('/one/one.app#/sObject/'+item.Id+'/view');
        }
        else{
            window.open('/'+item.Id);
        }
    },
	onShowCrmEvent : function(component, event) {
        var showCrmEvent = component.getEvent("showCrmEvent");
       
        showCrmEvent.setParams({
            "selection": component.get('v.item')
        });
        
        showCrmEvent.fire();
    },
    isLightningExperienceOrSalesforce1: function() {
        return((typeof sforce != 'undefined') && sforce && (!!sforce.one));
    },
    handleCollapseAllEvent : function(component, event) {
		this.changeIcon(component, "utility:chevronright");
        event.stopPropagation();
    },
    deleteCheckboxClicked : function(component, event) {
    	var deleteItemCheckboxEvent = component.getEvent("deleteItemCheckboxEvent");
       
        deleteItemCheckboxEvent.setParams({
            "selection": component.get('v.item'),
            "isChecked": component.find("deleteItemCheckbox").get("v.value")
        });
        
        deleteItemCheckboxEvent.fire();
    },
	
    onUpdateItemsEvent: function (component, event, helper) {
        
        var updateItemsEvent = component.getEvent("updateItemsEvent");
        var selectedItem=component.get('v.item');
        
         var sObject;
        if(selectedItem['Type']=='ServiceLineItem__c')
        {
            var serviceStatus = component.find("ServiceLineStatus").get("v.value");
            var clientNotes = component.find("InputClientNotes").get("v.value");
            
            sObject = {
                       sobjectType:"ChargeTypeUpdate", 
                       Status:serviceStatus,
                       ClientNotes:clientNotes,
                       ServiceLineItemId:selectedItem.Id,
                       ChargeTypeId:null,
                       NettCost:null,
                       Markup:null
                      };     
        }
        else
        {
            var markup = component.find("InputMarkup").get("v.value");
            var nett = component.find("InputNett").get("v.value");
            
            sObject = {sobjectType:"ChargeTypeUpdate", 
                       NettCost:nett,
                       Markup:markup,
                       ChargeTypeId:component.get('v.item').Id,
                       Status:null,
                       ClientNotes:null,
                       ServiceLineItemId:null,
                      }; 
        }
        updateItemsEvent.setParams({
            "updatedItem": sObject
        });
        
        updateItemsEvent.fire();
    },
})
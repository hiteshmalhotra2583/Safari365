({
    doInit : function(component, event, helper) {
        //console.log(component.get("v.itemPosition"));
        // Parse item
        
        var children = helper.parseItem(component);
        // Check if this is a node
       
        if (children.length > 0) {
            // Set default expand icon
            helper.changeIcon(component, "utility:chevrondown");
            // Check if we should collapse based on config and current level
            var config = component.get("v.config");
            var level = component.get("v.level");

        }
    },
    
    onToggleExpand : function(component, event, helper) {
        var childClass = event.currentTarget.id;
        var item = component.get('v.item');
        
        if(item.childRecords != null && item.childRecords.length != 0){
            helper.toggleNodeExpand(component, childClass);
        }
        else{
            helper.fireExpansionEvent(component, event, childClass);
        }
        // Prevent accidental node selection
        event.stopPropagation();
    },

    onSelectNode : function(component, event, helper) {
        var config = component.get("v.config");
        // Check if selection is allowed
        if (!config.isSelectable)
            return;
        // Check if node selection is allowed
        var children = component.get("v.children");
        if (children.length > 0 && !config.isNodeSelectionEnabled)
            return;

        var isSelected = component.get('v.isSelected');

        // Select element
        component.set('v.isSelected', !isSelected);
        helper.fireSelectionEvent(component, event);    
    },
    onShowModelEvent : function(component, event, helper) {
        
        var isSelected = component.get('v.isSelected');
        component.set('v.isSelected', !isSelected);
        
        helper.onShowModelEvent(component, event,helper);
        
    },

    itemChange: function (component, event, helper) {

        var item = component.get('v.item');
        var pos = component.get('v.itemPosition');
        var refreshPos = component.get('v.refreshItem');
        if(pos.toString() == refreshPos){
            // Parse item
            var children = helper.parseItem(component);
            // Check if this is a node
            if (children.length > 0) {
                // Set default expand icon
                helper.changeIcon(component, "utility:chevrondown");
                // Check if we should collapse based on config and current level
            }
        }

    },
    navigateToRecord: function (component, event, helper) {
        helper.navigateToRecord(component, event);

    },
    onShowCrmEvent: function (component, event, helper) {
        helper.onShowCrmEvent(component, event);

    },
    handleCollapseAllEvent: function (component, event, helper) {
        helper.handleCollapseAllEvent(component, event);
    },
    ondeleteItemCheckboxEvent: function (component, event, helper) {
        helper.deleteCheckboxClicked(component, event);
    },
    onUpdateItemsEvent: function (component, event, helper) {
        helper.onUpdateItemsEvent(component, event);
    },
})
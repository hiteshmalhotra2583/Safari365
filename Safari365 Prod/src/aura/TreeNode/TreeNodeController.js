({
    toggle: function(component, event, helper) {
       // alert(component.get(v.node.items.length));
          
        component.set("v.expanded", !component.get("v.expanded"));
    }
})
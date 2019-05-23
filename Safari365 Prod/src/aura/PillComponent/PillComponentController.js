({
    doInit: function (component, event, helper) {
        var item = component.get('v.item');

        component.set('v.value', item.value);
        component.set('v.key', item.key);
    },
    removePillItem: function (component, event, helper) {
        //console.log(component.get('v.key'));
        var removePill = component.getEvent("removePill");
        removePill.setParams({"key": component.get('v.key')});
        removePill.fire();
    },
})
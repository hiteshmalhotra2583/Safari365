({
    doInit: function (component, event, helper) {
        console.log(component.get('v.values'));

    },
    focusOut: function (component, event, helper) {
        console.log('focusout');
        helper.focusOut(component, event);

    },
    showMenu: function (component, event, helper) {
        console.log('showMenu');
        helper.showMenu(component, event);
    },
    dropdownChange:function (component, event, helper) {

        helper.dropdownChange(component, event);
    }
})
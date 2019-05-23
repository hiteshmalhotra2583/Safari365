({
    dropdownChange: function (component, event) {
        var selectedItem = event.currentTarget.id;

        var selected = selectedItem.split('#--#');



        var clickEvent = component.getEvent('DropdownItemChange_Evt');
        clickEvent.setParams({
            data: {
                'key': component.get('v.key'),
                'index': selected[0],
                'item': selected[1]
            }
        })
        clickEvent.fire();
        component.set('v.selected', parseInt(selected[0]));
        component.set('v.isHidden', true);
    },
    showMenu: function (component, event) {
        component.set('v.isHidden', !component.get('v.isHidden'));
    },
    focusOut: function (component, event) {
        component.set('v.isHidden', true);
    },
})
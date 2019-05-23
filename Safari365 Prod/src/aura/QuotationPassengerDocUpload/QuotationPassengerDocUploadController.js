({
    changePassenger:function(component, event, helper) {
         helper.changePassengerHelper(component, event);
    },
    openDoc:function(component, event, helper) {
         helper.openDocHelper(component, event);
    },
    deleteDoc:function(component, event, helper) {
        if (confirm("Are you sure you want to delete this doc?")) {
            helper.deleteDocHelper(component, event);
        } else {
            return;
        }
    },
    doInit: function(component, event, helper) {
        helper.doInitHelper(component, event);
    },
	doSave: function(component, event, helper) {
        if (component.find("fileId").get("v.files")!=null) {
            helper.uploadHelper(component, event);
        } else {
            alert('Please Select a Valid File!');
        }
    },
    handleFilesChange: function(component, event, helper) {
        var fileName = 'No File Selected!';
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
        }
        component.set("v.fileName", fileName);
    },
})
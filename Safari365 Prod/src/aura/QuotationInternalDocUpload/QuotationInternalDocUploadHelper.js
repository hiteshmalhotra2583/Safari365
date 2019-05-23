({
    MAX_FILE_SIZE: 4500000, //Max file size 4.5 MB 
    CHUNK_SIZE: 750000,      //Chunk Max size 750Kb 
    
    doInitHelper:function(component, event) {
        var quotationId = component.get("v.recordId");
        var action = component.get("c.getAllInternalTravelFileDoc");
        action.setParams({
            quotationId: quotationId
        });
        
        // set call back 
        action.setCallback(this, function(response) {
             
            var responseData = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS") {
                if(responseData == 'QuotationIdNull'){
                     console.log('Error : Internal Server Error!');
                }else if(responseData == 'QuotationFolderNotExist'){
                     console.log('Error : Quotation folder does not exist!'); 
                }else if(responseData == 'internalDocFolderNotExist'){
                     console.log('Error : Internal Documentation - Travelling Files folder does not exist!');
                }else {
                    var jsonData = JSON.parse(responseData);
                    component.set("v.fileDocResponse",jsonData);
                }
            // handel the response errors        
            } else if (state === "INCOMPLETE") {
                alert("From server: " + response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error!");
                }
            }
        });
        // enqueue the action
        $A.enqueueAction(action);
    },
    uploadHelper: function(component, event) {
        // start/show the loading spinner   
        component.set("v.showLoadingSpinner", true);
        // get the selected files using aura:id [return array of files]
        var fileInput = component.find("fileId").get("v.files");
        // get the first file using array index[0]  
        var file = fileInput[0];
       
        var self = this;
        // check the selected file size, if select file size greter then MAX_FILE_SIZE,
        // then show a alert msg to user,hide the loading spinner and return from function  
        if (file.size > self.MAX_FILE_SIZE) {
            component.set("v.showLoadingSpinner", false);
            component.set("v.fileName", 'Error : File size cannot exceed ' + self.MAX_FILE_SIZE + ' bytes.\n' + ' Selected file size: ' + file.size);
            return;
        }
 
        // create a FileReader object 
        var objFileReader = new FileReader();
        // set onload function of FileReader object   
        objFileReader.onload = $A.getCallback(function() {
            var fileContents = objFileReader.result;
            var base64 = 'base64,';
            var dataStart = fileContents.indexOf(base64) + base64.length;
 
            fileContents = fileContents.substring(dataStart);
            // call the uploadProcess method 
            self.uploadProcess(component, file, fileContents);
        });
 
        objFileReader.readAsDataURL(file);
    },
 
    uploadProcess: function(component, file, fileContents) {
        var quotationId = component.get("v.recordId");
        /*console.log('@@quotationId'+quotationId);
        console.log('@@filename'+file.name);
        console.log('@@filename'+file.type);
        console.log('@@body'+fileContents);*/
        var self = this;
        var action = component.get("c.quotationUploadOnGoogleDrive");
        action.setParams({
            quotationId: quotationId,
            fileName: file.name,
            fileType: file.type,
            fileContents: fileContents
        });
        
        // set call back 
        action.setCallback(this, function(response) {
             
            var responseData = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS") {
                if(responseData == 'QuotationIdNull'){
                    alert('Error : Internal Server Error!');
                    component.set("v.showLoadingSpinner", false);
                    self.doInitHelper(component, event);
                }else if(responseData == 'QuotationFolderNotExist'){
                    alert('Error : Quotation folder does not exist!');
                    component.set("v.showLoadingSpinner", false);
                    self.doInitHelper(component, event);
                }else if(responseData == 'internalDocFolderNotExist'){
                    alert('Error : Internal Documentation - Travelling Files folder does not exist!');
                    component.set("v.showLoadingSpinner", false);
                    self.doInitHelper(component, event);
                }else if(responseData == 'SuccessUpload'){
                     alert(file.name+'is uploaded on google drive successfully!');
                    component.set("v.showLoadingSpinner", false);
                    self.doInitHelper(component, event);
                }else if(responseData == 'FailUpload'){
                    alert('Error : Internal Server Error!');
                    component.set("v.showLoadingSpinner", false);
                    self.doInitHelper(component, event);
                }
            // handel the response errors        
            } else if (state === "INCOMPLETE") {
                alert("From server: " + response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error!");
                }
            }
        });
        // enqueue the action
        $A.enqueueAction(action);
    },
    openDocHelper:function(component, event) {
        var documentLink = event.target.id; 
        window.open(
          documentLink,
          '_blank'  
        );
    },
    deleteDocHelper:function(component, event) {
        var documentId = event.target.id; 
        var action = component.get("c.removeGoogleDriveDocument");
        action.setParams({
            documentId: documentId
        });
        var self = this;
        // set call back 
        action.setCallback(this, function(response) {
             
            var resultStatus = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS") {
                if(resultStatus == "success"){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "type":"success",
                        "message": "Document on google drive deleted successfully!"
                    });
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                    self.doInitHelper(component, event);
                }else if(resultStatus == "noDocumentId"){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "type":"error",
                        "message": "No document id available!"
                    });
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                    self.doInitHelper(component, event);
                }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "type":"error",
                        "message": resultStatus
                    });
                    toastEvent.fire(); 
                    $A.get('e.force:refreshView').fire();
                    self.doInitHelper(component, event);
                }
            // handel the response errors        
            } else if (state === "INCOMPLETE") {
                alert("From server: " + response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error!");
                }
            }
        });
        // enqueue the action
        $A.enqueueAction(action);
        
    }
 
})
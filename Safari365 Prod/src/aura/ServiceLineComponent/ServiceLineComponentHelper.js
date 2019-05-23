({
    doInit : function(component, event) {
        console.log('inside servicecomponent helper init');
        this.getServiceTypes(component, event);    
        this.loadServiceStatus(component, event);
        component.set("v.date", $A.localizationService.formatDate(Date(), 'YYYY-MM-DD') );
        component.set("v.servicedate", $A.localizationService.formatDate(Date(), 'YYYY-MM-DD') );
        component.set("v.preferredSupplier", false);  
        component.set("v.ShowPopup", false);
        component.set("v.ShowWetuFields", false);
        component.set("v.ShowRoomConfiguration", false);
        component.set("v.ShowTicketsInformation", false);
        component.set("v.SaveAndSetNewClicked", false);
        
        var action1 = component.get("c.GetQuotationPassengers");
        var quotationId = component.get("v.quotationId");  
        
        var checkboxes = component.find("DependentCheckbox");
        action1.setParams({ 
            "quotationId":quotationId,
        });
        
        action1.setCallback(this, function(a) {
            console.log('result'+JSON.stringify(a.getReturnValue()));
            component.set("v.Passengers", a.getReturnValue());
        });
        
        $A.enqueueAction(action1); 
        
        
        
    },
    
    getCheckInTimes:function(component, event) {
        var InputCheckInTime = component.find("InputCheckInTime");
        
        var opts=[];
        var action = component.get("c.getTimeList");
        action.setCallback(this, function(a) {
            for(var i=0;i< a.getReturnValue().length;i++){
                opts.push({"class": "optionClass", label: a.getReturnValue()[i], value: a.getReturnValue()[i]});
            }
            InputCheckInTime.set("v.options", opts);
            
        });
        $A.enqueueAction(action); 
    },
    getTimes:function(component, event) { 
        var inputselStartTime = component.find("InputWetuStartTime");
        var inputselEndTime = component.find("InputWetuEndTime");
        
        var opts1=[];
        var opts2=[];
        var action = component.get("c.getTimeList");
        action.setCallback(this, function(a) {
            for(var i=0;i< a.getReturnValue().length;i++){
                opts1.push({"class": "optionClass", label: a.getReturnValue()[i], value: a.getReturnValue()[i]});
                opts2.push({"class": "optionClass", label: a.getReturnValue()[i], value: a.getReturnValue()[i]});
            } 
            inputselStartTime.set("v.options", opts1);
            inputselEndTime.set("v.options", opts2);
            
        });
        $A.enqueueAction(action); 
    },
    
    getServiceTypes:function(component, event) {
        var action = component.get("c.getServiceTypes");
        var inputsel = component.find("InputSelectServiceType");
        var opts=[];
        action.setCallback(this, function(a) {
            for(var i=0;i< a.getReturnValue().length;i++){
                opts.push({"class": "optionClass", label: a.getReturnValue()[i], value: a.getReturnValue()[i]});
            }
            inputsel.set("v.options", opts);
            //alert(JSON.stringify(opts));
        });
        $A.enqueueAction(action); 
    },
    getNumberOfDays:function(component,event){
        var action2 = component.get("c.GetNumberOfDays");
        var quotationId = component.get("v.quotationId"); 
        var quotationLineId = component.get("v.quotationLineId"); 
        
        action2.setParams({ 
            "quotationId":quotationId,
            "quotationLineItemId":quotationLineId,
        });
        
        var numberOfDays = component.find("InputNumberOfDays"); 
        var numberOfDaysOpts=[];
        
        action2.setCallback(this, function(a) {
            for(var i=0;i< a.getReturnValue().length;i++){
                numberOfDaysOpts.push({"class": "optionClass", label: a.getReturnValue()[i], value: a.getReturnValue()[i]});
            }
            numberOfDays.set("v.options", numberOfDaysOpts);
            
            var currentservicelineitem = component.get("v.currentServiceLineItem");
            
            if(currentservicelineitem != null && currentservicelineitem.Service_Duration__c != undefined)
            {
                numberOfDays.set("v.value",currentservicelineitem.Service_Duration__c);
            }
        });
        
        $A.enqueueAction(action2); 
        
    },
    getNumberOfNights:function(component,event){
        var action2 = component.get("c.GetNumberOfNights");
        var quotationId = component.get("v.quotationId"); 
        var quotationLineId = component.get("v.quotationLineId"); 
        action2.setParams({ 
            "quotationId":quotationId,
            "quotationLineItemId":quotationLineId
        });
        
        var numberOfDays = component.find("InputNumberOfDays"); 
        var numberOfDaysOpts=[];
        
        action2.setCallback(this, function(a) {
            for(var i=0;i< a.getReturnValue().length;i++)
            {
                numberOfDaysOpts.push({"class": "optionClass", label: a.getReturnValue()[i], value: a.getReturnValue()[i]});
            }
            numberOfDays.set("v.options", numberOfDaysOpts);
        });
        
        $A.enqueueAction(action2); 
        
    },
    loadServiceStatus : function(component, event) {
        var action = component.get("c.getServiceStatus");
        var inputsel = component.find("InputSelectServiceStatus");
        
        var opts=[];
        action.setCallback(this, function(a) {
            for(var i=0;i< a.getReturnValue().length;i++){
                opts.push({"class": "optionClass", label: a.getReturnValue()[i], value: a.getReturnValue()[i]});
            }
            inputsel.set("v.options", opts);
        });
        $A.enqueueAction(action); 
    },
    
    handleSelectLookupItemEvent : function(component, event) {
        var selectedText = event.getParam("SelectedLookupText");
        var supplierId = selectedText.val;
        var serviceTypeLength=selectedText.val;
        var serviceTypeSelectedValue ;
        
        var field_selectedServiceType = component.get("v.selectedServiceType");
        var field_selectedServiceLocation = component.get("v.selectedServiceLocation");
        if((field_selectedServiceType != undefined && field_selectedServiceType.length > 0 && field_selectedServiceType !='--Select Service Types--')
           && (field_selectedServiceLocation != undefined && field_selectedServiceLocation.length > 0 && field_selectedServiceLocation != '--Select Location--'))
        {
            
            var serviceDetailAction = component.get("c.getServiceDetailsWithSupplierId");
            var ServiceDetailSelect = component.find("InputSelectServiceDetail");
            
            serviceDetailAction.setParams({"selectedSupplierId": supplierId,
                                           "selectedServiceType":field_selectedServiceType,
                                           "selectedLocation":field_selectedServiceLocation});
            
            var ServiceDetailOpts=[];
            serviceDetailAction.setCallback(this, function(a) {
                for(var i=0;i< a.getReturnValue().length;i++){
                    ServiceDetailOpts.push({"class": "optionClass", label: a.getReturnValue()[i], value: a.getReturnValue()[i]});
                }
                
                ServiceDetailSelect.set("v.options", ServiceDetailOpts);
            });
            $A.enqueueAction(serviceDetailAction); 
        }    
        else
        {
            var action = component.get("c.GetServiceTypeForSupplier");
            var serviceTypeSel = component.find("InputSelectServiceType");
            var serviceTypeOpts=[];
            //alert(supplierId);
            action.setParams({"supplierId":supplierId});
            action.setCallback(this, function(a) {
                for(var i=0;i< a.getReturnValue().length;i++){
                    serviceTypeOpts.push({"class": "optionClass", label: a.getReturnValue()[i], value: a.getReturnValue()[i]});
                } 
                
                serviceTypeSel.set("v.options", serviceTypeOpts);
                
                if(serviceTypeOpts.length > 0)
                {
                    serviceTypeSelectedValue=serviceTypeOpts[0].value;
                    component.set("v.selectedServiceType", serviceTypeSelectedValue);  
                }
                var flag = false;
                if(serviceTypeSelectedValue == 'Flight'
                   || serviceTypeSelectedValue == 'Cruise')
                {
                    flag = true;
                    component.set("v.ShowTicketsInformation", true); 
                    component.set("v.ShowWetuFields", true);
                    component.set("v.ShowRoomConfiguration", false);
                    this.getTimes(component, event);
                    this.getCheckInTimes(component, event);
                }
                
                if(serviceTypeSelectedValue == 'Transfer' 
                   || serviceTypeSelectedValue == 'Car Rental' 
                   || serviceTypeSelectedValue == 'Rail'
                  )
                {
                    flag = true;
                    component.set("v.ShowWetuFields", true);
                    component.set("v.ShowTicketsInformation", false); 
                    component.set("v.ShowRoomConfiguration", false);
                    
                    this.getTimes(component, event);
                }
                
                if(flag== false)
                {
                    component.set("v.ShowWetuFields", false);
                    component.set("v.ShowTicketsInformation", false); 
                    component.set("v.ShowRoomConfiguration", false);
                }
                
                //this.onSupplierNameChange(component, event);  
                if(serviceTypeSelectedValue == 'Accommodation' && supplierId != 'undefined')
                {
                    this.getNumberOfNights(component, event);
                    
                    var action2 = component.get("c.GetRoomConfiguration");
                    var roomConfigurationsel = component.find("InputRoomConfiguration");
                    var opts=[];
                    action2.setParams({ 
                        "supplierId":supplierId});
                    action2.setCallback(this, function(a) {
                        for(var i=0;i< a.getReturnValue().length;i++){
                            opts.push({"class": "optionClass", label: a.getReturnValue()[i], value: a.getReturnValue()[i]});
                        }
                        roomConfigurationsel.set("v.options", opts);
                    });
                    $A.enqueueAction(action2); 
                    
                }
                else
                {
                    this.getNumberOfDays(component, event);;
                }
                
            });
            
            $A.enqueueAction(action)
            
            var action1 = component.get("c.GetLocationForSupplier");
            var locationSel = component.find("InputSelectLocation");
            
            var mode = component.get("v.Mode");
            var crmCode = component.get("v.CrmCode");
            var serviceLocationOpts=[];
            if(mode=='Edit')
            {
                action1.setParams({ 
                    "supplierIdorCode":crmCode,
                    "mode":mode});
            }
            else
            {
                action1.setParams({ 
                    "supplierIdorCode":supplierId,
                    "mode":mode});
            }
            
            action1.setCallback(this, function(a) {
                for(var i=0;i< a.getReturnValue().length;i++){
                    serviceLocationOpts.push({"class": "optionClass", label: a.getReturnValue()[i], value: a.getReturnValue()[i]});
                }
                
                locationSel.set("v.options", serviceLocationOpts);
                if(serviceLocationOpts.length > 0)
                {
                    var selectedLocation =serviceLocationOpts[0].value;
                    component.set("v.selectedServiceLocation", selectedLocation);
                    
                    var action4 = component.get("c.getServiceDetailsWithSupplierId");
                    var ServiceDetailSelect = component.find("InputSelectServiceDetail");
                    
                    action4.setParams({"selectedSupplierId": supplierId,
                                       "selectedServiceType":serviceTypeSelectedValue,
                                       "selectedLocation":selectedLocation});
                    
                    var ServiceDetailOpts=[];
                    action4.setCallback(this, function(a) {
                        for(var i=0;i< a.getReturnValue().length;i++){
                            ServiceDetailOpts.push({"class": "optionClass", label: a.getReturnValue()[i], value: a.getReturnValue()[i]});
                        }
                        ServiceDetailSelect.set("v.options", ServiceDetailOpts);
                    });
                    $A.enqueueAction(action4); 
                    
                }
            });
            
            $A.enqueueAction(action1);
        }
        event.stopPropagation();
        
    },
    
    handleCancelLookupSelectionEvent : function(component, event) {
        var opts=[];
        
        component.find("InputSelectServiceType").set("v.options", opts);
        component.find("InputSelectLocation").set("v.options", opts);
        component.find("InputSelectServiceDetail").set("v.options", opts);
        
        var IsRoomConfigurationShown = component.get("v.ShowRoomConfiguration");
        if(IsRoomConfigurationShown == true)
        {
            component.find("InputRoomConfiguration").set("v.options", opts);
        }
        component.set("v.selWetuStartLocation", null); 
        component.set("v.selWetuEndLocation", null); 
        
        component.set("v.ShowRoomConfiguration", false); 
        component.set("v.ShowWetuFields", false); 
        component.set("v.selectedServiceType", null);   
        component.set("v.selectedServiceLocation", null);   
        component.set("v.preferredSupplier", component.find("InputPreferredSupplier").get("v.value"));   
        this.getServiceTypes(component, event);
        this.getNumberOfDays(component, event);
        var showWetuFields = component.get("v.ShowWetuFields");
        if(showWetuFields== true)
        {
            component.find("InputWetuStartTime").set("v.options", opts);
            component.find("InputWetuEndTime").set("v.options", opts);
        }
        event.stopPropagation();
    },
    
    handleSelectLookupWetuStartLocationEvent : function(component, event) {
        event.stopPropagation();
    },
    
    handleCancelLookupWetuStartLocationEvent : function(component, event) {
        
        var wetuStartLocation  = component.set("v.selWetuStartLocation",null);
        event.stopPropagation();
    },
    
    handleSelectLookupWetuEndLocationEvent : function(component, event) {
        event.stopPropagation();
    },
    
    handleCancelLookupWetuEndLocationEvent : function(component, event) {
        
        var wetuStartLocation  = component.set("v.selWetuEndLocation",null);
        event.stopPropagation();
    },
    
    GetLocationForServiceType:function(component, event)
    {
        var serviceType = component.find("InputSelectServiceType").get("v.value");
        var action = component.get("c.getLocations");
        var inputsel = component.find("InputSelectLocation");
        
        action.setParams({'selectedServiceType': serviceType});
        
        var opts=[];
        action.setCallback(this, function(a) {
            for(var i=0;i< a.getReturnValue().length;i++){
                opts.push({"class": "optionClass", label: a.getReturnValue()[i], value: a.getReturnValue()[i]});
            }
            inputsel.set("v.options", opts);
        });
        $A.enqueueAction(action); 
    },
    
    GetLocationForSupplier:function(component, event)
    {
        var action1 = component.get("c.GetLocationForSupplier");
        var supplierId = component.get("v.selItem").val; 
        var locationSel = component.find("InputSelectLocation");
        var mode = component.get("v.Mode");
        var crmCode = component.get("v.CrmCode");
        var serviceLocationOpts=[];
        if(mode=='Edit')
        {
            action1.setParams({ 
                "supplierIdorCode":crmCode,
                "mode":mode});
        }
        else
        {
            action1.setParams({ 
                "supplierIdorCode":supplierId,
                "mode":mode});
        }
        action1.setCallback(this, function(a) {
            for(var i=0;i< a.getReturnValue().length;i++){
                serviceLocationOpts.push({"class": "optionClass", label: a.getReturnValue()[i], value: a.getReturnValue()[i]});
            }
            
            locationSel.set("v.options", serviceLocationOpts);
        });
        
        $A.enqueueAction(action1);
    },
    
    onServiceTypeChange : function(component, event) {
        
        var serviceType = component.find("InputSelectServiceType").get("v.value");
        
        component.set("v.selectedServiceType", serviceType);  
        var flag = false;
        if(serviceType == 'Flight'
           || serviceType == 'Cruise'
           || serviceType == 'Camper Hire'
           || serviceType == 'Coach Hire'
           || serviceType == 'Other Transport'
           || serviceType == 'Transport')
        {
            flag = true;
            component.set("v.ShowTicketsInformation", true); 
            component.set("v.ShowWetuFields", true);
            component.set("v.ShowRoomConfiguration", false);
            this.getTimes(component, event);
            this.getCheckInTimes(component, event);
        }
        
        if(serviceType == 'Transfer' 
           || serviceType == 'Car Rental' 
           || serviceType == 'Rail'
          )
        {
            flag = true;
            component.set("v.ShowWetuFields", true);
            component.set("v.ShowTicketsInformation", false); 
            component.set("v.ShowRoomConfiguration", false);
            
            this.getTimes(component, event);
        }
        
        if(flag== false)
        {
            component.set("v.ShowWetuFields", false);
            component.set("v.ShowTicketsInformation", false); 
            component.set("v.ShowRoomConfiguration", false);
        }
        /* else
        {
            var flag = component.get("v.ShowWetuFields");
            if(flag== true)
            {
                var optsa=[];
                
                component.set("v.ShowWetuFields", false);  
                component.find("InputWetuStartTime").set("v.options", optsa);
                component.find("InputWetuEndTime").set("v.options", optsa);
            }
            
        }*/
        var supplierId = component.get("v.selItem"); 
        var roomConfigurationsel = component.find("InputRoomConfiguration");
        var mode = component.get("v.Mode");
        var crmCode = component.get("v.CrmCode");
        if(serviceType == 'Accommodation' )
        {
            component.set("v.ShowRoomConfiguration", true);
            component.set("v.ShowTicketsInformation", false);
            component.set("v.ShowWetuFields", false);
            this.getNumberOfNights(component, event);
            if(supplierId != null)
            {
                this.GetLocationForSupplier(component, event); 
                var action2 = component.get("c.GetRoomConfiguration");
                
                var opts=[];
                if(mode=='Edit')
                {
                    action2.setParams({ 
                        "supplierIdorCode":crmCode,
                        "mode":mode});
                }
                else
                {
                    action2.setParams({ 
                        "supplierIdorCode":supplierId.val,
                        "mode":mode});
                }
                action2.setCallback(this, function(a) {
                    for(var i=0;i< a.getReturnValue().length;i++){
                        opts.push({"class": "optionClass", label: a.getReturnValue()[i], value: a.getReturnValue()[i]});
                    }
                    component.find("InputRoomConfiguration").set("v.options", opts);
                    
                });
                $A.enqueueAction(action2); 
            }
            else
            {
                this.GetLocationForServiceType(component, event);
                var opts2=[];
                roomConfigurationsel.set("v.options", opts2);
            }
        }
        else
        {
            this.getNumberOfDays(component, event);
            if(supplierId == null)
            {
                this.GetLocationForServiceType(component, event);
            }
            else
            {
                this.GetLocationForSupplier(component, event);
            }
            var roomConfigurationShown = component.get("v.ShowRoomConfiguration");
            if(roomConfigurationShown== true)
            {
                var opts=[];
                component.find("InputRoomConfiguration").set("v.options", opts);
            }
            
        }
        var opts1=[];
        component.find("InputSelectServiceDetail").set("v.options", opts1);
    },
    
    onLocationChange : function(component, event) { 
        var controllerValueKey = component.find("InputSelectLocation").get("v.value");
        
        component.set("v.selectedServiceLocation", controllerValueKey);  
        var selectedServiceType = component.find("InputSelectServiceType").get("v.value");
        var supplierName = component.get("v.selItem").text;
        var action = component.get("c.getServiceDetails");
        var inputsel = component.find("InputSelectServiceDetail");
        
        action.setParams({"selectedSupplierName": supplierName,
                          "selectedServiceType":selectedServiceType,
                          "selectedLocation":controllerValueKey}); 
        var opts=[];
        action.setCallback(this, function(a) { 
            for(var i=0;i< a.getReturnValue().length;i++){
                opts.push({"class": "optionClass", label: a.getReturnValue()[i], value: a.getReturnValue()[i]});
            }
            
            inputsel.set("v.options", opts);
        });
        $A.enqueueAction(action); 
    },
    
    getSupplierNameDbQuery : function(component, event) {
        var selectedLocation = component.find("InputSelectLocation").get("v.value");
        var selectedServiceType = component.find("InputSelectServiceType").get("v.value");
        var preferredSupplier  = component.find("InputPreferredSupplier").get("v.value");
        var action = component.get("c.GetSuppplierNameLookupQuery");
        //var inputsel = component.find("InputSelectSupplierName");
        action.setParams(
            {
                "selectedLocation": selectedLocation,
                "selectedServiceType":selectedServiceType,
                "preferredSupplier":preferredSupplier
            });
        component.set("v.dbQuery", '' );  
        action.setCallback(this, function(a) {
            for(var i=0;i< a.getReturnValue().length;i++){ 
                component.set("v.dbQuery", a.getReturnValue() );    
                alert( component.get("v.dbQuery")  );
            }
        });
        $A.enqueueAction(action); 
    },
    
    onPreferredSupplierChange : function(component, event) {
        var preferredSupplier  = component.find("InputPreferredSupplier").get("v.value");
        component.set("v.preferredSupplier", preferredSupplier);  
    },
    
    onSupplierNameChange : function(component, event) {
        var selectedLocation = component.find("InputSelectLocation").get("v.value");
        var selectedServiceType = component.find("InputSelectServiceType").get("v.value");
        //var controllerValueKey = event.getSource().get("v.value");
        var controllerValueKey = component.get("v.selItem").val;
        var action = component.get("c.getServiceDetails");
        var inputsel = component.find("InputSelectServiceDetail");
        
        action.setParams({"selectedSupplierName": controllerValueKey,
                          "selectedServiceType":selectedServiceType,
                          "selectedLocation":selectedLocation});
        
        var opts=[];
        action.setCallback(this, function(a) {
            for(var i=0;i< a.getReturnValue().length;i++){
                opts.push({"class": "optionClass", label: a.getReturnValue()[i], value: a.getReturnValue()[i]});
            }
            inputsel.set("v.options", opts);
        });
        $A.enqueueAction(action); 
    },
    
    dateChange: function(component) {
        var date = component.get("v.date");
    },
    
   
    
    onUpdateCheckboxes:function(component, event)
    {
        var id = event.getSource().get("v.text");
        if (event.source.get("v.value"))
        {
            
            // Checkbox is checked - add id to checkedContacts
            if (component.get("v.checkedPassengers").indexOf(id) < 0)
            {
                //var action = component.get("c.checkGivenPassengerAge");
                //action.setParams({
                //"passengerId":id,
                //});
                
                component.get("v.checkedPassengers").push(id);
            }
        } else
        {
            // Checkbox is unchecked - remove id from checkedContacts
            var index = component.get("v.checkedPassengers").indexOf(id);
            if (index > -1)
            {
                component.get("v.checkedPassengers").splice(index, 1);
            }
        }
    },
    
    save:function(component, event)
    {
        var btn = event.getSource();
        btn.set("v.disabled",true);//Disable the button
        
        var serviceLineItemName = component.find("InputServiceLineItemName").get("v.value");
        var serviceType = component.find("InputSelectServiceType").get("v.value");
        var serviceLocation = component.find("InputSelectLocation").get("v.value");
        var serviceDetail = component.find("InputSelectServiceDetail").get("v.value");
        
        var serviceClientNotes = component.find("InputClientNotes").get("v.value");
        var serviceReservationNumber = component.find("InputReservationNumber").get("v.value");
        var serviceSupplierNotes = component.find("InputSupplierNotes").get("v.value");
        var serviceSelectServiceStatus  = component.find("InputSelectServiceStatus").get("v.value");
        var overrideDetails  = component.find("CheckboxOverrideDetails").get("v.value");
        var numberOfDays  = component.find("InputNumberOfDays").get("v.value");
        
        var serviceExpiryDate  = component.get("v.date");
        var serviceDate1  = component.get("v.servicedate");
        //var sd = serviceDate1.split("/");
        //var serviceDate = new Date(sd[2],(Number(sd[1])-1),sd[0],'00','00');
        
        var serviceDate;
        
        var mode = component.get("v.Mode");
        
        if(mode=='Edit')
        {
            serviceDate =$A.localizationService.formatDate(serviceDate1, 'YYYY-MM-DD');
        }
        else
        {
            var sd = serviceDate1.split("/");
            serviceDate = new Date(sd[2],(Number(sd[1])-1),sd[0],'00','00');
        }
        var quotationLineItemId = component.get("v.quotationLineId");   
        var checkedPassengers  = component.get("v.checkedPassengers");
        var quotationId = component.get("v.quotationId");  
        var supplierName = component.get("v.selItem");
        var showRoomConfiguration = component.get("v.ShowRoomConfiguration");
        
        var roomConfiguration = null;
        if(showRoomConfiguration == true)
        {
            roomConfiguration = component.find("InputRoomConfiguration").get("v.value");  
        }
        var uiErrorMessages = '';
        
        if(overrideDetails == false)
        {
            if(serviceType=='--Select Service Types--')
            {
                uiErrorMessages =uiErrorMessages + 'Service type is not selected \n';
            }
            
            if(serviceLocation=='--Select Location--' || serviceLocation==undefined)
            {
                uiErrorMessages =uiErrorMessages + 'Location is not selected \n';
            }
            
            if(supplierName=='--Select Supplier Name--' || supplierName==null)
            {
                uiErrorMessages =uiErrorMessages + 'Supplier name is not selected \n';
            }
            if(serviceDetail=='--Select Service Details--' || serviceDetail==undefined)
            {
                uiErrorMessages =uiErrorMessages + 'Service details is not selected \n';
            }
            
            
            if(serviceType=='Accommodation' && (roomConfiguration=='--Select Room Configuration--' || roomConfiguration==undefined))
            {
                uiErrorMessages =uiErrorMessages + 'Room configuration is not selected \n';
            }
            
            if(checkedPassengers.length==0)
            {
                uiErrorMessages =uiErrorMessages + 'At least one passenger must be selected \n';
            }
            
            if(serviceSelectServiceStatus=='Confirmed' &&( serviceReservationNumber==undefined | serviceReservationNumber==null))
            {
                uiErrorMessages =uiErrorMessages + 'Please provide the reservation number \n';
            }
            var todaysDate =new Date( new Date().toDateString()); 
            var wetuFieldsShown = component.get("v.ShowWetuFields");
            var wetuStartLocation=null  ;
            var wetuEndLocation  =null;
            
            var wetuStartTime  = '00:00';
            var wetuEndTime  = '00:00';
            
            
            if(wetuFieldsShown==true)
            {
                
                wetuStartTime  = component.find("InputWetuStartTime").get("v.value");
                wetuEndTime  = component.find("InputWetuEndTime").get("v.value");
                wetuStartLocationObj  = component.get("v.selWetuStartLocation");
                wetuEndLocationObj  = component.get("v.selWetuEndLocation");
                
                if(wetuStartLocationObj != null) 
                    wetuStartLocation  = wetuStartLocationObj.text;
                
                if(wetuEndLocationObj != null) 
                    wetuEndLocation  = wetuEndLocationObj.text;
                
                
                var parts =wetuStartTime.split(':');
                var parts1 =wetuEndTime.split(':');
                var startTime = new Date(todaysDate.getFullYear(),todaysDate.getMonth(),todaysDate.getDay(),parts[0],parts[1]);
                var endTime = new Date(todaysDate.getFullYear(),todaysDate.getMonth(),todaysDate.getDay(),parts1[0],parts1[1]);
              
            }
        }
        
        if((new Date(serviceExpiryDate)) < todaysDate)
        {
            uiErrorMessages =uiErrorMessages + 'Provisional booking date cannot be in past \n';
        }
        if((new Date(serviceDate)) < todaysDate)
        {
            uiErrorMessages =uiErrorMessages + 'Service start date cannot be in past \n';
        }
        if(uiErrorMessages.length > 0)
        {
            this.PopulateErrorMessages(component,uiErrorMessages);
            var btn = event.getSource();
            btn.set("v.disabled",false);//Enable the button
            return false;
        }
        else
        {
            //var mode = component.get("v.Mode");
            //alert('mode'+mode);
            if(mode=='Edit')
            {
                var notOverrideNetCost  = component.find("CheckboxNotOverrideNetCost").get("v.value");
                var serviceLineItem = component.get("v.currentServiceLineItem");
                
                if(notOverrideNetCost == true)
                {
                    var action = component.get("c.UpdateServiceLineItem");
                    action.setParams({ 
                        "serviceLineItemId":serviceLineItem.Id,
                        "serviceClientNotes":serviceClientNotes,
                        "serviceReservationNumber":serviceReservationNumber,
                        "serviceSupplierNotes":serviceSupplierNotes,
                        "serviceStatus":serviceSelectServiceStatus,
                        "serviceExpiryDate":serviceExpiryDate,
                        "notOverrideNetCost":notOverrideNetCost
                    });
                     action.setCallback(this, function(a) {
                        var state = a.getState();
                        if (state === "INCOMPLETE") {
                            alert('No server response. The server might be down or the client might be offline.');
                            var btn = event.getSource();
                            btn.set("v.disabled",false);
                        }
                        if (state === "ERROR") {
                            var btn = event.getSource();
                            btn.set("v.disabled",false);
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
                                 alert('Successfully updated !');
                                 this.doCancel(component, event);
                             }
                         }
                     });
                    $A.enqueueAction(action); 
                }
                else
                {
                    //Delete existing service line items
                    
                    var duration  = component.find("InputNumberOfDays").get("v.value");
                    var action = component.get("c.RemoveServiceLineItems");
                    action.setParams({ 
                        "serviceLineItemId":serviceLineItem.Id,
                        "serviceDuration":duration
                    });
                    
                    action.setCallback(this, function(a) {
                        var state = a.getState();
                        if (state === "INCOMPLETE") {
                            alert('No server response. The server might be down or the client might be offline.');
                            var btn = event.getSource();
                            btn.set("v.disabled",false);
                        }
                        if (state === "ERROR") {
                            var btn = event.getSource();
                            btn.set("v.disabled",false);
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
                        if (state === "SUCCESS") {
                            //TODO: Call Save
                            this.SaveServiceLineItem(component, event);
                        }
                    });
                    $A.enqueueAction(action); 
                }
            }
            else
            {
                this.SaveServiceLineItem(component, event);
                
            }
        }
    },
    
    SaveServiceLineItem: function(component, event)
    {  
        var btn = event.getSource(); 
        var serviceLineItemName = component.find("InputServiceLineItemName").get("v.value");
        var serviceType = component.find("InputSelectServiceType").get("v.value");
        var serviceLocation = component.find("InputSelectLocation").get("v.value");
        var serviceDetail = component.find("InputSelectServiceDetail").get("v.value");
        
        var serviceClientNotes = component.find("InputClientNotes").get("v.value");
        var serviceReservationNumber = component.find("InputReservationNumber").get("v.value");
        var serviceSupplierNotes = component.find("InputSupplierNotes").get("v.value");
        var serviceSelectServiceStatus  = component.find("InputSelectServiceStatus").get("v.value");
        var overrideDetails  = component.find("CheckboxOverrideDetails").get("v.value");
        var numberOfDays  = component.find("InputNumberOfDays").get("v.value");
        var serviceExpiryDate  = component.get("v.date");
        var serviceDate1  = component.get("v.servicedate");
        //var serviceDate;
        var startDateForServer;
        var mode = component.get("v.Mode");
        if(mode=='Edit')
        {
            //serviceDate =$A.localizationService.formatDate(serviceDate1, 'YYYY-MM-DD');
            startDateForServer=$A.localizationService.formatDate(serviceDate1, 'YYYY-MM-DD');
        }
        else
        {
            //var sd = serviceDate1.split("/");
            //serviceDate = new Date(sd[2],(Number(sd[1])-1),sd[0],'00','00');
            
            var sdForServer = serviceDate1.split("/");
            startDateForServer = sdForServer[2] + '-' + sdForServer[1] + '-' + sdForServer[0] ;
        }
        
        var quotationLineItemId = component.get("v.quotationLineId");   
        var checkedPassengers  = component.get("v.checkedPassengers");
        var quotationId = component.get("v.quotationId");  
        var supplierName = component.get("v.selItem");
        var todaysDate =new Date( new Date().toDateString()); 
        
        var wetuFieldsShown = component.get("v.ShowWetuFields");
        var ticketsInformationShown = component.get("v.ShowTicketsInformation");
        var roomConfigurationShown = component.get("v.ShowRoomConfiguration");
        //alert('numberOfDays>>:'+numberOfDays);
        var wetuStartLocation=null  ;
        var wetuEndLocation  =null;
        var wetuStartLocationId=null  ;
        var wetuEndLocationId  =null;
        var wetuStartTime  = null;
        var wetuEndTime  = null;
        var startTerminal = null;
        var duration = null;
        var endTerminal = null;
        var checkInTime = null;
        var ticketClass = null;
        var roomConfiguration = null;
        var supplierNameText = null;  
        var supplierNameId = null;  
        
        if(serviceType=='--Select Service Types--')
        {
            serviceType = '';
        }
        
        if(ticketsInformationShown == true)
        {
            startTerminal = component.find("InputStartTerminal").get("v.value");
            duration = component.find("InputDuration").get("v.value");
            endTerminal = component.find("InputEndTerminal").get("v.value");
            checkInTime = component.find("InputCheckInTime").get("v.value");
            ticketClass = component.find("InputTicketClass").get("v.value");
        }
        if(roomConfigurationShown == true)
        {
            roomConfiguration = component.find("InputRoomConfiguration").get("v.value");  
        }
        if(wetuFieldsShown==true)
        {
            wetuStartTime  = component.find("InputWetuStartTime").get("v.value");
            wetuEndTime  = component.find("InputWetuEndTime").get("v.value");
            wetuStartLocationObj  = component.get("v.selWetuStartLocation");
            wetuEndLocationObj  = component.get("v.selWetuEndLocation");
            
            if(wetuStartLocationObj != null) 
                wetuStartLocation  = wetuStartLocationObj.text;
            
            if(wetuEndLocationObj != null) 
                wetuEndLocation  = wetuEndLocationObj.text;
            
            if(wetuStartLocationObj != null)
                wetuStartLocationId  = wetuStartLocationObj.val;
            
            if(wetuEndLocationObj != null)
                wetuEndLocationId  = wetuEndLocationObj.val;
            
        }
        if(supplierName != null && supplierName != undefined)
        {
            supplierNameText = supplierName.text;
            supplierNameId = supplierName.val;
        }
        else
        {
            supplierNameText = '';
        }
        
        
        var action = component.get("c.saveServiceLineItem");
        action.setParams({ 
            "serviceLineItemName":serviceLineItemName,
            "selectedServiceType": serviceType,
            "selectedLocation": serviceLocation,
            "selectedSupplierName": supplierNameText,
            "selectedSupplierId": supplierNameId,
            "selectedServiceDetail": serviceDetail,
            "quotationLineItemId":quotationLineItemId,
            "serviceClientNotes":serviceClientNotes,
            "serviceReservationNumber":serviceReservationNumber,
            "serviceSupplierNotes":serviceSupplierNotes,
            "serviceSelectServiceStatus":serviceSelectServiceStatus,
            "serviceExpiryDate":serviceExpiryDate,
            "overrideDetails":overrideDetails,
            "selectedPassengers":checkedPassengers,
            "serviceDate":startDateForServer,
            "numberOfDays":numberOfDays,
            "quotationId":quotationId,
            "roomConfiguration":roomConfiguration,
            "wetuStartLocation":wetuStartLocation,
            "wetuStartLocationId":wetuStartLocationId,
            "wetuEndLocation":wetuEndLocation,
            "wetuEndLocationId":wetuEndLocationId,
            "wetuStartTime":wetuStartTime,
            "wetuEndTime":wetuEndTime,
            "startTerminal":startTerminal,
            "endTerminal":endTerminal,
            "duration":duration,
            "checkInTime":checkInTime,
            "ticketClass":ticketClass
        });
        
        action.setCallback(this, function(a) {
            var state = a.getState();
            var btn = event.getSource();
            //alert('btn'+btn);
            btn.set("v.disabled",false);
            
            if (state === "INCOMPLETE") 
            {
                alert('No server response. The server might be down or the client might be offline.');
            }
            if (state === "SUCCESS")
            {
                var errorMessages = '';
                for(var i=0;i< a.getReturnValue().length;i++){
                    errorMessages = errorMessages + a.getReturnValue()[i] + '\n';
                }
                if(errorMessages.length > 0)
                {
                    this.PopulateErrorMessages(component,errorMessages);
                }
                else
                {
                    alert("Saved successfully!");
                    
                    var saveAndSetNewClicked =  component.get("v.SaveAndSetNewClicked");
                    
                    if(saveAndSetNewClicked == true)
                    {
                        component.set("v.SaveAndSetNewClicked", false);
                        this.setNewServiceLine(component, event); 
                    }
                    else
                    {
                        this.doCancel(component, event);
                    }
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
    
    PopulateErrorMessages:function(component,errorMessages)
    {
        $A.createComponents([
            ["ui:message",{
                "title" : "Error",
                "severity" : "error",
                "closable":true
            }],
            ["ui:outputText",{ "value" : errorMessages}]
        ],
                            function(components, status, errorMessage){
                                if (status === "SUCCESS") {
                                    var message = components[0];
                                    var outputText = components[1];
                                    // set the body of the ui:message to be the ui:outputText
                                    message.set("v.body", outputText);
                                    var div1 = component.find("div1");
                                    // Replace div body with the dynamic component
                                    div1.set("v.body", message);
                                    //event.preventDefault();
                                    
                                }
                                else if (status === "INCOMPLETE") {
                                    console.log("No response from server or client is offline.")
                                    // Show offline error
                                }
                                    else if (status === "ERROR") {
                                        console.log("Error: " + errorMessage);
                                        // Show error message
                                    }
                            }
                           );
    },
    setNewServiceLine: function(component, event) {
        
        var opts=[];
        
        var roomConfigurationShown =  component.get("v.ShowRoomConfiguration");
        var TicketsInformationShown = component.get("v.ShowTicketsInformation"); 
        var wetuLocationsShown = component.get("v.ShowWetuFields");
        
        if(roomConfigurationShown == true)
        {
            component.find("InputRoomConfiguration").set("v.options",opts);
        }
        if(TicketsInformationShown == true)      
        {
            component.find("InputWetuStartTime").set("v.value",0);
            component.find("InputWetuEndTime").set("v.value",0);  
            
            component.find("InputStartTerminal").set("v.value",null);
            component.find("InputDuration").set("v.value",null);
            component.find("InputEndTerminal").set("v.value",null);
            component.find("InputCheckInTime").set("v.value",0);
            component.find("InputTicketClass").set("v.value",null);
            
            component.set("v.selWetuStartLocation",null);        
            component.set("v.selWetuEndLocation",null);
        }
        
        if(wetuLocationsShown == true)
        {
            component.set("v.selWetuStartLocation",null);        
            component.set("v.selWetuEndLocation",null);
        }
        component.find("InputSelectServiceType").set("v.options",opts);
        component.find("InputServiceLineItemName").set("v.value",null);
        component.find("InputSelectLocation").set("v.options", opts);
        
        component.find("InputNumberOfDays").set("v.options", opts);
        component.find("InputSelectServiceDetail").set("v.options", opts);  
        component.find("InputClientNotes").set("v.value",null);
        
        component.find("InputReservationNumber").set("v.value",null);
        component.find("InputSupplierNotes").set("v.value",null);
        
        component.find("InputSelectServiceStatus").set("v.value",0);
        component.find("CheckboxOverrideDetails").set("v.value",false);
        
        component.set("v.checkedPassengers",opts);
        component.set("v.CrmCode",null);
        component.set("v.selItem",null);
        component.set("v.preferredSupplier", false);  
        component.set("v.ShowPopup", false);
        component.set("v.ShowWetuFields", false);
        component.set("v.ShowRoomConfiguration", false);
        component.set("v.ShowTicketsInformation", false);
        
        component.set("v.selectedServiceType", null);   
        component.set("v.selectedServiceLocation", null);
        
        component.set("v.date", $A.localizationService.formatDate(Date(), 'YYYY-MM-DD') );
        
        
        var p = component.get("v.Passengers");
        for(i=0;i<p.length;i++)
        {
            p[i].IsSelected = false;    
        }
        component.set("v.Passengers",p);
        this.getServiceTypes(component, event); 
    },
    
    saveAndNewServiceLine : function(component, event) {
        component.set("v.SaveAndSetNewClicked", true);
        this.save(component, event);
    },
    
    doCancel : function(component, event) {
        var quotationId = component.get("v.quotationId");   
        window.open((location.origin+"/"+quotationId),'_parent');
    },
    OpenPassengerAgeModel: function(component, event) {
        var ctarget = event.currentTarget;
        var selectedPassenger  = ctarget.dataset.value;
        
        component.set("v.SelectedPassenger", selectedPassenger);
        component.set("v.ShowPopup", true);
        var action = component.get("c.getPassengerAgeList");
        var inputsel = component.find("InputSelectPassengerAge");
        var opts=[];
        action.setCallback(this, function(a) {
            for(var i=0;i< a.getReturnValue().length;i++){
                opts.push({"class": "optionClass", label: a.getReturnValue()[i], value: a.getReturnValue()[i]});
            }
            inputsel.set("v.options", opts);
            
        });
        $A.enqueueAction(action); 
    },
    
    closeModel: function(component, event) {
        component.set("v.ShowPopup"	, false);
    },
    
    updatePassengerAge: function(component, event) {
        var age = component.find("InputSelectPassengerAge").get("v.value"); 
        if(age=='--Select Age--')
        {
            alert('Please select the age');
        }
        else
        {
            var passengerId = component.get("v.SelectedPassenger");
            
            var action = component.get("c.savePassengerAge");
            action.setParams({ 
                "passengerAge":age,
                "passengerId":passengerId
            });
            action.setCallback(this, function(a) {
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
                        var p = component.get("v.Passengers");
                        for(i=0;i<p.length;i++)
                        {
                            if(p[i].Passenger.Id == passengerId)
                            {
                                //alert(JSON.stringify(p)); to print object
                                p[i].Passenger["Given_Age__c"] = age;
                            }
                        }
                        component.set("v.ShowPopup"	, false);
                    }
                }
            });
            $A.enqueueAction(action);            
        }
    },
    
    setSelectedLineItemDate : function(component, event) {
        
        var param = event.getParam("itemDate");
       
        var mode = component.get("v.Mode");

        if(mode=='Edit')
        {
            //alert(JSON.stringify(component.get("v.currentServiceLineItem")));
            var serviceLineItem = component.get("v.currentServiceLineItem");
            this.loadServiceLineItem(component, event,serviceLineItem.Id);
        }
         //component.set("v.servicedate",$A.localizationService.formatDate(param, 'MM/DD/YYYY'));
    },
    
    loadServiceLineItem:function(component,event,currentServiceLineItemId) 
    {
        var action = component.get("c.loadServiceLineItem");
        action.setParams({ 
            "serviceLineItemId":currentServiceLineItemId
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "INCOMPLETE") {
                alert('No server response. The server might be down or the client might be offline.');
            }
            if (state === "SUCCESS") {
                var serviceLineItem = a.getReturnValue();
                //alert(JSON.stringify(serviceLineItem));
                
                component.set("v.currentServiceLineItem",serviceLineItem);
                component.find("InputServiceLineItemName").set("v.value",serviceLineItem.Name);
                component.find("InputSelectServiceStatus").set("v.value",serviceLineItem.Service_Status__c);
                component.find("InputSelectServiceType").set("v.value",serviceLineItem.Service_Type__c);
                
                var obj = new Object();
                obj.val=serviceLineItem.Selected_Supplier_Id__c;
                obj.text=serviceLineItem.SupplierName__c;
                obj.NAME__c  = serviceLineItem.SupplierName__c;
                obj.Id=serviceLineItem.Selected_Supplier_Id__c;
                component.set("v.selItem",obj);
                component.set("v.CrmCode",serviceLineItem.Crm_Code__c);
                this.onServiceTypeChange(component,event);
                
                component.find("InputSelectLocation").set("v.value",serviceLineItem.ServiceLocation__c);
                this.onLocationChange(component,event);
                
                 //component.find("CheckboxNotOverrideNetCost").set("v.value",false);
                component.find("CheckboxNotOverrideNetCost").set("v.value",serviceLineItem.Do_Not_Override_NetCost__c);
                component.find("CheckboxOverrideDetails").set("v.value",serviceLineItem.Override_details__c);
                component.find("InputReservationNumber").set("v.value",serviceLineItem.Reservation_Number__c);
                component.set("v.date",serviceLineItem.Provisional_Booking_Expiry_Date__c);
                component.set("v.servicedate",serviceLineItem.Service_Date__c);
                component.find("InputClientNotes").set("v.value",serviceLineItem.ClientNotes__c);
                component.find("InputSupplierNotes").set("v.value",serviceLineItem.Supplier_Notes__c);
                
                component.find("InputNumberOfDays").set("v.value",serviceLineItem.Service_Duration__c.toString());
                //alert(serviceLineItem.Service_Detail__c);
                component.find("InputSelectServiceDetail").set("v.value",serviceLineItem.Service_Detail__c);
                
                if(serviceLineItem.Wetu_Start_Location__c != undefined || serviceLineItem.Wetu_Start_Location__c != null)
                {
                    
                    // component.set("v.ShowWetuFields",true);
                    // this.getTimesForEdit(component, event,serviceLineItem.Wetu_Start_time__c,serviceLineItem.Wetu_End_Time__c);
                    var wetuStartLocation = new Object();
                    wetuStartLocation.val=serviceLineItem.Wetu_Start_Location_Id__c;
                    wetuStartLocation.text=serviceLineItem.Wetu_Start_Location__c;
                    wetuStartLocation.NAME__c  = serviceLineItem.Wetu_Start_Location__c;
                    wetuStartLocation.Id=serviceLineItem.Wetu_Start_Location_Id__c;
                    component.set("v.selWetuStartLocation",wetuStartLocation);
                    
                    var wetuEndLocation = new Object();
                    wetuEndLocation.val=serviceLineItem.Wetu_End_Location_Id__c;
                    wetuEndLocation.text=serviceLineItem.Wetu_End_Location__c;
                    wetuEndLocation.NAME__c  = serviceLineItem.Wetu_End_Location__c;
                    wetuEndLocation.Id=serviceLineItem.Wetu_End_Location_Id__c;
                    component.set("v.selWetuEndLocation",wetuEndLocation);
                    
                    component.find("InputWetuStartTime").set("v.value",serviceLineItem.Wetu_Start_time__c.toString());
                    component.find("InputWetuEndTime").set("v.value",serviceLineItem.Wetu_End_Time__c.toString());  
                    
                }
                
                var roomConfigurationShown =  component.get("v.ShowRoomConfiguration");
                
                if(roomConfigurationShown == true)
                {
                    component.find("InputRoomConfiguration").set("v.value",serviceLineItem.Room_Configuration__c); 
                }
                
                var TicketsInformationShown = component.get("v.ShowTicketsInformation"); 
                if(TicketsInformationShown == true)
                {
                    
                    //this.getTimes(component, event);
                    //this.getCheckInTimes(component, event);
                    component.find("InputWetuStartTime").set("v.value",serviceLineItem.Wetu_Start_time__c.toString());
                    component.find("InputWetuEndTime").set("v.value",serviceLineItem.Wetu_End_Time__c.toString());  
                    
                    component.find("InputStartTerminal").set("v.value",serviceLineItem.Start_Terminal__c );
                    component.find("InputDuration").set("v.value",serviceLineItem.Duration__c );
                    component.find("InputEndTerminal").set("v.value",serviceLineItem.End_Terminal__c );
                    component.find("InputCheckInTime").set("v.value",serviceLineItem.Checkin_Time__c );
                    component.find("InputTicketClass").set("v.value",serviceLineItem.Ticket_Class__c );
                    
                }
                
                this.loadPassengersForServiceLineItem(component,event,currentServiceLineItemId);
                
            }});
        $A.enqueueAction(action);            
    },
    
    loadPassengersForServiceLineItem:function(component,event,currentServiceLineItemId)
    { 
        var action = component.get("c.loadPassengersForServiceLineItem");
        action.setParams({ 
            "serviceLineItemId":currentServiceLineItemId
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "INCOMPLETE") {
                alert('No server response. The server might be down or the client might be offline.');
            }
            if (state === "SUCCESS") {
                
                var p = component.get("v.Passengers");
                //alert(JSON.stringify(p));
                for(i=0;i<p.length;i++)
                {
                    for(var j=0;j< a.getReturnValue().length;j++)
                    {  
                        var passengerId=a.getReturnValue()[j];
                        if(p[i].Passenger.Id == passengerId)
                        {
                            p[i].IsSelected = true;    
                            component.get("v.checkedPassengers").push(a.getReturnValue()[j]);
                        }
                    }
                }
                component.set("v.Passengers",p);
                
            }
        });
        $A.enqueueAction(action);   
    }
})
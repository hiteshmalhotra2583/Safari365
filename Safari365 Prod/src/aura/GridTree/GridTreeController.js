({
    doInit : function(component, event, helper) {
        // Validate config & set default values
        var config = component.get("v.config");
       
        if ($A.util.isUndefinedOrNull(config.labelProperties))
            config.labelProperties = ['Name'];
        if ($A.util.isUndefinedOrNull(config.expandProperties))
            config.expandProperties = [];
        if ($A.util.isUndefinedOrNull(config.expandLevel))
            config.expandLevel = 1;
        if ($A.util.isUndefinedOrNull(config.isSelectable))
            config.isSelectable = false;
        if ($A.util.isUndefinedOrNull(config.isNodeSelectionEnabled))
            config.isNodeSelectionEnabled = false;
        if ($A.util.isUndefinedOrNull(config.columns))
            config.columns = {'Name':'Name'};
        component.set("v.config", config);
		
        var columns = [];
        
        for(var i=0; i< config.columns.columnList.length; i++){
		     columns.push({
                            'field':config.columns.columnList[i],
                            'Name': config.columns.columnMap[config.columns.columnList[i]],
                            'hasFilter': false,
                            'filterFields': config.columns.columnFilter[config.columns.columnList[i]],
                            'filterIndex':config.columns.filterTable[config.columns.columnList[i]] ? config.columns.filterTable[config.columns.columnList[i]] : 0
                        });
        }
        component.set("v.columnsMap", config.columns);
        component.set("v.columns", columns);
		
    },

})
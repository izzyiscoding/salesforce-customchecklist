({
    //initialization of records
    doInit: function(component, event, helper) { 
        helper.retrieveCLRecords(component, event);
    },
  
    //this function will save a Checklist record then proceed to the Checklist Items helper.
    save: function(component, event, helper) {
        var userRec = $A.get("$SObjectType.CurrentUser.Id");
       	var action = component.get("c.saveChecklistRecord");
        action.setParams({
        	"cListRec": JSON.stringify(component.get("v.checklistRec")),
        	"userId": userRec.Id,
        });
        helper.toggleSpinner(component, "show");
        action.setCallback(this,function(response) { 
            var ret = response.getReturnValue();
            console.log("results", JSON.parse(ret.returnValue));
            if(ret.status === 'SUCCESS') {
                component.set("v.checklistRec", JSON.parse(ret.returnValue));
                helper.createChecklistItems(component, event, helper);
            }
       	}); 
            $A.enqueueAction(action);
    },
 
    //this function will add a new row when clicking the add button on the checklist item section
    addNewRow: function(component, event, helper) { 
        helper.createObjectData(component, event);
    },
 
    //this function will remove the existing row and deleting the checklist item record
    removeDeletedRow: function(component, event, helper) { 
        var index = event.getParam("indexVar");
        var recId = event.getParam("recordId");  
        var AllRowsList = component.get("v.checklistItemList");
        var cLItemsRecDel = [];
        
        AllRowsList.splice(index, 1);
        cLItemsRecDel.push(recId);
        
        component.set("v.checklistItemList", AllRowsList);
        component.set("v.checklistItemListDelete",cLItemsRecDel);
        
        helper.deleteCLItemRecords(component);
    },
})
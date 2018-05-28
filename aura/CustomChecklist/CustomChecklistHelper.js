({
    //this is a helper function to add new row on checklist item section
    createObjectData: function(component, event) { 
        var currentRows = component.get("v.checklistItemList");
        currentRows.push({
            'sobjectType': 'ChecklistItem__c',
            'ChecklistItemName__c': '',
            'ChecklistType__c': '',
            'Description__c': '',
            'Done__c': ''
        });   
        component.set("v.checklistItemList", currentRows);
    },
    
    //this is a helper function to retrieve existing records upon init
    retrieveCLRecords: function(component, event) { 
        var userRec = $A.get("$SObjectType.CurrentUser.Id");
        var action = component.get("c.getChecklistRecords");
        action.setParams({ 
            "userId" : userRec
        });
        action.setCallback(this,function(response){
            var ret = response.getReturnValue();
            console.log("response", ret);
            if(ret.status === 'SUCCESS'){
                component.set("v.checklistRec", JSON.parse(ret.returnValue).chckListRecord);
                component.set("v.checklistHeadline", JSON.parse(ret.returnValue).chckListRecord.ChecklistHeadline__c);
                
                var cListItems = JSON.parse(ret.returnValue).chckListItemRecords
                if(cListItems.length === 0){
                	this.createObjectData(component, event);
                }
                else{
                	component.set("v.checklistItemList",JSON.parse(ret.returnValue).chckListItemRecords);
                    console.log("reloaded");
                }
                this.toggleSpinner(component, "hide");
            }
            else{
                component.set("v.checklistRec", JSON.parse(ret.returnValue).chckListRecord);
            	this.createObjectData(component, event);
                alert('No Checklist created for this user. Please create one.');
                this.toggleSpinner(component, "hide");
            }
        });
        $A.enqueueAction(action);
    },

    //this is a helper function to create or update checklist item records.
    createChecklistItems: function(component, event, helper) {
    	var cListRec = component.get("v.checklistRec");
        var action = component.get("c.saveChecklistItems");
        action.setParams({
        	"listChecklistItems": JSON.stringify(component.get("v.checklistItemList")),
            "checklistId": cListRec.Id
        });
        
        action.setCallback(this,function(response) { 
            var ret = response.getReturnValue();
            if(ret.status === 'SUCCESS') {
                this.retrieveCLRecords(component);
                alert('Records have successfully created/edited.');
                this.toggleSpinner(component, "hide");
                }
         }); 
        
         $A.enqueueAction(action);
    },
    
    //this is a helper function to delete checklist item records.
    deleteCLItemRecords: function(component, event) {
        var checklistItemsDel = component.get("v.checklistItemListDelete")
        var action = component.get("c.deleteChecklistItems");
        action.setParams({ 
            "cLItemsDelRec" : checklistItemsDel
        });
        action.setCallback(this,function(response){
            var ret = response.getReturnValue();
            if(ret.status === 'SUCCESS'){
                component.set("v.checklistItemListDelete", []);
            }
        });
        $A.enqueueAction(action);
    },

    //this is a helper function to show or hide the spinner
    toggleSpinner : function(component, action){
        var spinner = component.find("spinner")
        
        if(action === "show"){
			$A.util.addClass(spinner, 'slds-show');
            $A.util.removeClass(spinner, 'slds-hide');
        } else if(action == "hide"){
            console.log("hide spinner")
            $A.util.removeClass(spinner, 'slds-show');
            $A.util.addClass(spinner, 'slds-hide');
        }    
    },
})
({
    addCLRow : function(component, event, helper){
        component.getEvent("AddCLRowEvt").fire();     
    },
    
    delCLRow : function(component, event, helper){
       var cLitemRecord = component.get("v.checklistRecord");
       console.log(cLitemRecord.Id);
       component.getEvent("DelCLRowEvt").setParams({
           "indexVar" : component.get("v.rowIndex"), 
           "recordId" : cLitemRecord.Id     
       }).fire();
    },
    
})
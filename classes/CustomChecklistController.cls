public class CustomChecklistController {
    public class Response{
        @AuraEnabled
        public String status;

        @AuraEnabled
        public String message;

        @AuraEnabled
        public String returnValue;

        public Response(){
            this.status = 'SUCCESS';
            this.message = '';
        }
    }
    
    public class ChecklistWrapper{
        @AuraEnabled
        public Checklist__c chckListRecord;
        
        @AuraEnabled
        public List<ChecklistItem__c> chckListItemRecords;

    }
        
    @AuraEnabled
    public static Response getChecklistRecords(Id userId){
        Response res = new Response();
        ChecklistWrapper cLWrapper = new ChecklistWrapper();
        Set<Id> checkListRecordId = new Set<Id>();
        
        List<Checklist__c> chckListRecs = [Select Id From Checklist__c Where OwnerId=: userId];
        
        for(Checklist__c cList : chckListRecs){
            checkListRecordId.add(cList.Id);
        }
        
		try{
            cLWrapper.chckListRecord = [Select Id, ChecklistName__c, ChecklistType__c, ChecklistHeadline__c From Checklist__c Where OwnerId=: userId];
            cLWrapper.chckListItemRecords = new List<ChecklistItem__c>([Select Id, Checklist__c, ChecklistItemName__c, Description__c, Done__c From ChecklistItem__c WHERE Checklist__c =: checkListRecordId]);
            res.returnValue = JSON.serialize(cLWrapper);
        }catch(Exception e){
            cLWrapper.chckListRecord = new Checklist__c();            
            res.status = 'FAILED';
            res.returnValue = JSON.serialize(cLWrapper);
            res.message = e.getMessage();
        }
        return res;
    }
    
   @AuraEnabled
   public static Response saveChecklistRecord(String cListRec, Id userId){
       	Response res = new Response();
        ChecklistWrapper cLWrapper = new ChecklistWrapper();
        Checklist__c checklistRecord = (Checklist__c)JSON.deserialize(cListRec, Checklist__c.class);
       			
        try{
            Database.upsert(checklistRecord);
            res.returnValue = JSON.serialize(checklistRecord);
        }catch(Exception e){
            res.status = 'FAILED';
            res.message = e.getMessage();
        }
		return res;
       
    }

   @AuraEnabled
   public static Response saveChecklistItems(String listChecklistItems, Id checklistId){
       	Response res = new Response();
        ChecklistWrapper cLWrapper = new ChecklistWrapper();
        List<ChecklistItem__c> checkListIteminsert = new List<ChecklistItem__c>();
        List<ChecklistItem__c> checkListItemupdate = new List<ChecklistItem__c>();
       	List<ChecklistItem__c> checkListItemList = (List<ChecklistItem__c>)JSON.deserialize(listChecklistItems, List<ChecklistItem__c>.class);       

        for(ChecklistItem__c cLItem : checkListItemList){
            if(cLItem.Id == null){
            cLItem.Checklist__c = checklistId;
            checkListIteminsert.add(cLItem);
            }
            else{
            checkListItemupdate.add(cLItem);  
            }
        }
        
        try{
            Database.insert(checkListIteminsert);
            Database.update(checkListItemupdate);
        }catch(Exception e){
            res.status = 'FAILED';
            res.message = e.getMessage();
        }
		return res;
       
    }
    
   @AuraEnabled
   public static Response deleteChecklistItems(List<String> cLItemsDelRec){
       	Response res = new Response();

        try{
            Database.delete(cLItemsDelRec);
        }catch(Exception e){
            res.status = 'FAILED';
            res.message = e.getMessage();
        }
		return res;
       
    }
 
}
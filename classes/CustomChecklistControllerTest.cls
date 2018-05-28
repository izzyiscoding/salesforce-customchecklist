@isTest
public class CustomChecklistControllerTest {
	static testMethod void testCustomChecklistController(){
        
        User usr = [Select Id From User Where IsActive = true limit 1];
        
        Checklist__c cList = new Checklist__c();
        cList.ChecklistName__c = 'Test Checklist';
        cList.ChecklistType__c = 'To-do';
        system.runAs(usr){
		database.insert(cList); 
        }
        
        List<ChecklistItem__c> cListItemList = new List<ChecklistItem__c>();
        
        for (Integer i=0;i<4;i++){
            ChecklistItem__c cLItem = new ChecklistItem__c();
            cLItem.ChecklistItemName__c = 'Test Checklist Item';
            cLItem.Description__c = 'Test Checklist Item Description';
            cLItem.Done__c = true;
            cLItem.Checklist__c= cList.Id;
            cListItemList.add(cLItem);
        }
        
        test.startTest();
        CustomChecklistController.Response getRecordsResponse = CustomChecklistController.getChecklistRecords(usr.Id);
        System.assertEquals(getRecordsResponse.status, 'SUCCESS', getRecordsResponse.message);
        
        CustomChecklistController.Response saveChecklistRecordResponse = CustomChecklistController.saveChecklistRecord(JSON.serialize(cList), usr.Id);
        System.assertEquals(saveChecklistRecordResponse.status, 'SUCCESS', saveChecklistRecordResponse.message);
        
        cListItemList[3].Description__c = 'Update Description';
        CustomChecklistController.Response saveChecklistItemsResponse = CustomChecklistController.saveChecklistItems(JSON.serialize(cListItemList), cList.Id);
        System.assertEquals(saveChecklistItemsResponse.status, 'SUCCESS', saveChecklistItemsResponse.message);
        
        
        List<String> cLItemsForDel = new List<String>();
        cLItemsForDel.add(cListItemList[1].Id);
        
        CustomChecklistController.Response deleteChecklistItemsResponse = CustomChecklistController.deleteChecklistItems(cLItemsForDel);
        System.assertEquals(deleteChecklistItemsResponse.status, 'FAILED', deleteChecklistItemsResponse.message);
        
		test.stopTest();
    }
}
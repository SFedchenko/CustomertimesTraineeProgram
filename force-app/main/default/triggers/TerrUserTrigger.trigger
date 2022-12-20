trigger TerrUserTrigger on TerrUser__c (after insert, after update, after delete) {

    if (Trigger.isInsert) {
        if (Trigger.isAfter) {
            TerrUserTriggerHandler.handleAfterInsert(Trigger.new);
        }
    }

    if (Trigger.isDelete) {
        if (Trigger.isAfter) {
            TerrUserTriggerHandler.handleAfterDelete(Trigger.old);
        }
    }

    if (Trigger.isUpdate) {
        if (Trigger.isAfter) {
            TerrUserTriggerHandler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}
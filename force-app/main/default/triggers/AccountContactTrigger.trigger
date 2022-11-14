trigger AccountContactTrigger on AccountContact__c (before insert, after update, after delete, after undelete) {
    if (Trigger.isInsert) {
        if (Trigger.isBefore) {
            AccountContactTriggerHandler.beforeInsert(Trigger.new);
        }
    } else if (Trigger.isUpdate) {
        if (Trigger.isAfter) {
            AccountContactTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
        }
    } else if (Trigger.isDelete) {
        if (Trigger.isAfter) {
            AccountContactTriggerHandler.afterDelete(Trigger.old);
        }
    } else if (Trigger.isUndelete) {
        if (Trigger.isAfter) {
            AccountContactTriggerHandler.afterUndelete(Trigger.new);
        }
    }
}
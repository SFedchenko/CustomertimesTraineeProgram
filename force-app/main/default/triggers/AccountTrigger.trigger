trigger AccountTrigger on Account (before insert) {

    if (Trigger.isInsert) {
        if (Trigger.isBefore) {
            AccountTriggerHandler.handleBeforeInsert(Trigger.new);
        }
    }
}
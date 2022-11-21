trigger ExceptionLogTrigger on ExceptionLog__e (after insert) {

    if (Trigger.isInsert) {
        if (Trigger.isAfter) {
            ExceptionLogTriggerHandler.handleAfterInsert(Trigger.new);
        }
    }
}
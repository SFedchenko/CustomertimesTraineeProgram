public with sharing class ExceptionLogTriggerHandler {
    
    public static void handleAfterInsert(List<ExceptionLog__e> platformEvents) {
        new ExceptionLogService().insertLogs(platformEvents);
    }
}

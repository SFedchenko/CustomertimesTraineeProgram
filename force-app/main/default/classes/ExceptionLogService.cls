public with sharing class ExceptionLogService {
    
    public void insertLogs(List<ExceptionLog__e> platformEvents) {
        List<Log__c> logs = new List<Log__c>();
        for (ExceptionLog__e pe : platformEvents) {
            Log__c log = new Log__c();
            log.LoggingLevel__c = pe.LoggingLevel__c;
            log.Message__c = pe.Message__c;
            log.ContextId__c = pe.ContextId__c;
            log.ContextName__c = pe.ContextName__c;
            log.StackTraceString__c = pe.StackTraceString__c;
            log.UserName__c = pe.UserName__c;
            logs.add(log);
        }
        if (logs.size() > 0) {
            insert logs;
        }
    }
}

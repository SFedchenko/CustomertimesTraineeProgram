public with sharing class Logger {

    public System.LoggingLevel defineLogLevel(String logLevel) {
        System.LoggingLevel loggingLevel;
        if (logLevel == 'ERROR') {
            loggingLevel = System.LoggingLevel.ERROR;
        } else {
            loggingLevel = System.LoggingLevel.INFO;
        }
        return loggingLevel;
    }

    public void log(Database.BatchableContext context, String message, String logLevel) {
        AsyncApexJob job = [
            SELECT
                Id,
                MethodName,
                CreatedById 
            FROM 
                AsyncApexJob
            WHERE 
                Id = :context.getJobId()
        ];

        Log__c log = new Log__c();
        log.LoggingLevel__c = logLevel;
        log.Message__c = message;
        log.ContextName__c = job.MethodName;
        insert log;

        System.LoggingLevel loggingLevel = new Logger().defineLogLevel(logLevel);
        System.debug(loggingLevel, message);
    }

    public void log(Database.BatchableContext context, Exception ex, String logLevel) {
        AsyncApexJob job = [
            SELECT
                Id,
                MethodName,
                CreatedById 
            FROM 
                AsyncApexJob
            WHERE 
                Id = :context.getJobId()
        ];

        List<CronTrigger> cronTriggers = [
            SELECT 
                Id,
                OwnerId 
            FROM
                CronTrigger
            WHERE
                CronJobDetailId = :context.getJobId()
        ];

        User user = new User();
        if (cronTriggers.size() > 0) {
            user = [
                SELECT
                    Name
                FROM
                    User
                WHERE
                    Id = :cronTriggers[0].OwnerId
            ];
        } else {
            user = [
                SELECT
                    Name
                FROM
                    User
                WHERE
                    Id = :job.CreatedById
            ];
        }

        ExceptionLog__e pe = new ExceptionLog__e();
        pe.LoggingLevel__c = logLevel;
        pe.Message__c = ex.getMessage();
        pe.ContextId__c = context.getJobId();
        pe.ContextName__c = job.MethodName;
        pe.StackTraceString__c = ex.getStackTraceString();
        pe.UserName__c = user.Name;
        eventBus.publish(pe);

        System.LoggingLevel loggingLevel = new Logger().defineLogLevel(logLevel);
        System.debug(loggingLevel, ex.getMessage());
    }
}

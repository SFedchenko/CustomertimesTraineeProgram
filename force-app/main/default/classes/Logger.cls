public with sharing class Logger {

    private static final String LOG_LEVEL_ERROR = 'ERROR';
    private static final String LOG_LEVEL_INFO = 'INFO';
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
                CronTriggerId,
                CreatedById 
            FROM 
                AsyncApexJob
            WHERE 
                Id = :context.getJobId()
        ];

        List<CronTrigger> cronTriggers = [
            SELECT 
                Id,
                CronJobDetail.Name,
                OwnerId 
            FROM
                CronTrigger
            WHERE
                Id = :job.CronTriggerId
        ];

        Log__c log = new Log__c();
        log.LoggingLevel__c = logLevel;
        log.Message__c = message;
        if (cronTriggers.size() > 0) {
            log.ContextName__c = (String)cronTriggers[0].getSObject ('CronJobDetail').get('Name');
        }
        insert log;

        System.LoggingLevel loggingLevel = new Logger().defineLogLevel(logLevel);
        System.debug(loggingLevel, message);
    }

    public void log(Database.BatchableContext context, Exception ex, String logLevel) {
        AsyncApexJob job = [
            SELECT
                Id,
                ApexClass.Name,
                CronTriggerId,
                CreatedById 
            FROM 
                AsyncApexJob
            WHERE 
                Id = :context.getJobId()
        ];

        List<CronTrigger> cronTriggers = [
            SELECT 
                Id,
                CronJobDetail.Name,
                OwnerId 
            FROM
                CronTrigger
            WHERE
                Id = :job.CronTriggerId
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
        pe.LoggingLevel__c = LOG_LEVEL_ERROR;
        pe.Message__c = ex.getMessage();
        pe.ContextId__c = context.getJobId();
        pe.ContextName__c = (String)job.getSObject ('ApexClass').get('Name');
        pe.StackTraceString__c = ex.getStackTraceString();
        pe.UserName__c = user.Name;
        eventBus.publish(pe);
    }
}
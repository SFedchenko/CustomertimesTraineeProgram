public with sharing class VacancyBatchScheduler implements Schedulable {

    public static final string VACANCY_BATCH_SCHEDULE_JOB = 'VacancyJob';

    public void execute(SchedulableContext sc) {
        Database.executeBatch(new VacancyBatch(), 10);
        //start();
        //System.abortJob(sc.getTriggerId());
    }

    public String start() {
        Datetime sysTime = System.now().addSeconds( 20 );
        String chronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        return System.schedule(VACANCY_BATCH_SCHEDULE_JOB + sysTime, chronExpression, new VacancyBatchScheduler());
    }
}
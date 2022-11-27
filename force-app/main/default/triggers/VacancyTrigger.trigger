trigger VacancyTrigger on Vacancy__c (after insert, after update) {

    if (Trigger.isInsert) {
        if (Trigger.isAfter) {
            VacancyTriggerHandler.handleAfterInsert(Trigger.new);
        }
    }

    if (Trigger.isUpdate) {
        if (Trigger.isAfter) {
            VacancyTriggerHandler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}
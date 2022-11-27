public with sharing class VacancyTriggerHandler {

    public static void handleAfterInsert(List<Vacancy__c> vacancies) {
        new VacancyShareService().insertVacancyShares(
            vacancies,
            VacancyShareService.ACCESS_LEVEL_READ,
            VacancyShareService.VACANCY_SHARE_ROW_CAUSE
        );
    }

    public static void handleAfterUpdate(
        List<Vacancy__c> newVacancies,
        Map<Id, Vacancy__c> idsToOldVacancies
    ) {
        new VacancyShareService().deleteVacancyShares(
            newVacancies,
            idsToOldVacancies,
            VacancyShareService.VACANCY_SHARE_ROW_CAUSE
        );

        new VacancyShareService().insertVacancyShares(
            newVacancies,
            idsToOldVacancies,
            VacancyShareService.ACCESS_LEVEL_READ,
            VacancyShareService.VACANCY_SHARE_ROW_CAUSE
        );
    }
}
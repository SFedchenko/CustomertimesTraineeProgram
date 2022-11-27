public with sharing class VacancyShareService {

    public static final String ACCESS_LEVEL_READ = 'Read';
    public static final String VACANCY_SHARE_ROW_CAUSE = Schema.Vacancy__Share.RowCause.ShareVacancyToAssignee__c;
    
    public void insertVacancyShares(
        List<Vacancy__c> vacancies,
        String accessLevel,
        String rowCause
    ) {
        Set<Id> newAssigneeIds = new VacancyService().getNotNullAssigneeIds(vacancies);

        if (newAssigneeIds.size() > 0) {
            Map<Id, Id> vacancyIdsToNewAssigneeIds = new VacancyService().getVacancyIdsToNotNullAssigneeIds(vacancies);

            List<Vacancy__Share> vacancySharesToInsert  = new VacancyShareService().createVacancyShares(
                newAssigneeIds,
                vacancyIdsToNewAssigneeIds,
                accessLevel,
                rowCause
            );
            insert vacancySharesToInsert;
        }
    }

    public void deleteVacancyShares(
        List<Vacancy__c> newVacancies,
        Map<Id, Vacancy__c> idsToOldVacancies,
        String rowCause
    ) {
        Set<Id> oldAssigneeIds = new VacancyService().getNotNullOldAssigneeIds(
            newVacancies,
            idsToOldVacancies
        );
        
        if (oldAssigneeIds.size() > 0) {
            Set<Id> vacancyWithOldAssigneeIds = new VacancyService().getVacancyWithOldAssigneeIds(
                newVacancies,
                idsToOldVacancies
            );

            Set<Id> oldAssigneeUserIds = new Set<Id>();
            List<Manager__c> oldAssignees = new ManagerSelector().selectByIds(oldAssigneeIds);
            for (Manager__c oldAssignee : oldAssignees) {
                oldAssigneeUserIds.add(oldAssignee.User__c);
            }
            List<Vacancy__Share> vacancySharesToDelete = new VacancyShareSelector().selectByParentAndUserIdsAndRowCause(
                vacancyWithOldAssigneeIds,
                oldAssigneeUserIds,
                rowCause
            );
            delete vacancySharesToDelete;
        }
    }

    public void insertVacancyShares(
        List<Vacancy__c> newVacancies,
        Map<Id, Vacancy__c> idsToOldVacancies,
        String accessLevel,
        String rowCause
    ) {
        Set<Id> newAssigneeIds = new VacancyService().getNotNullNewAssigneeIds(
            newVacancies,
            idsToOldVacancies
        );

        if (newAssigneeIds.size() > 0) {
            Map<Id, Id> vacancyIdsToNewAssigneeIds = new VacancyService().getVacancyIdsToNotNullNewAssigneeIds(
                newVacancies,
                idsToOldVacancies
            );

            List<Vacancy__Share> vacancySharesToInsert  = new VacancyShareService().createVacancyShares(
                newAssigneeIds,
                vacancyIdsToNewAssigneeIds,
                accessLevel,
                rowCause
            );
            insert vacancySharesToInsert;
        }
    }

    public List<Vacancy__Share> createVacancyShares(
        Set<Id> newAssigneeIds,
        Map<Id, Id> vacancyIdsToNewAssigneeIds,
        String accessLevel,
        String rowCause
    ) {
        List<Manager__c> newAssignees = new ManagerSelector().selectByIds(newAssigneeIds);
        Map<Id, Manager__c> IdsToNewAssignees = new Map<Id, Manager__c>(newAssignees);

        List<Vacancy__Share> vacancyShares  = new List<Vacancy__Share>();
        for (Id vacancyId : vacancyIdsToNewAssigneeIds.keySet()) {
            Vacancy__Share vacancyShare = new Vacancy__Share();
            vacancyShare.ParentId = vacancyId;
            vacancyShare.UserOrGroupId = IdsToNewAssignees.get( vacancyIdsToNewAssigneeIds.get(vacancyId) ).User__c;
            vacancyShare.AccessLevel = accessLevel;
            vacancyShare.RowCause = rowCause;
            vacancyShares.add(vacancyShare);
        }
        return vacancyShares;
    }
}
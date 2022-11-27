public with sharing class VacancyService {
    
    public Set<Id> getVacancyWithOldAssigneeIds(
        List<Vacancy__c> newVacancies,
        Map<Id, Vacancy__c> idsToOldVacancies
    ) {
        Set<Id> vacancyIds = new Set<Id>();
        for (Vacancy__c newVacancy : newVacancies) {
            Vacancy__c oldVacancy = idsToOldVacancies.get(newVacancy.Id);
            if (
                newVacancy.Assignee__c != oldVacancy.Assignee__c
                &&
                oldVacancy.Assignee__c != null
            ) {
                vacancyIds.add(newVacancy.Id);
            }
        }
        return vacancyIds;
    }
    
    public Set<Id> getNotNullAssigneeIds(List<Vacancy__c> vacancies) {
        Set<Id> assigneeIds = new Set<Id>();
        for (Vacancy__c vacancy : vacancies) {
            if (vacancy.Assignee__c != null) {
                assigneeIds.add(vacancy.Assignee__c);
            }
        }
        return assigneeIds;
    }

    public Set<Id> getNotNullOldAssigneeIds(
        List<Vacancy__c> newVacancies,
        Map<Id, Vacancy__c> idsToOldVacancies
    ) {
        Set<Id> oldAssigneeIds = new Set<Id>();
        for (Vacancy__c newVacancy : newVacancies) {
            Vacancy__c oldVacancy = idsToOldVacancies.get(newVacancy.Id);
            if (
                newVacancy.Assignee__c != oldVacancy.Assignee__c
                &&
                oldVacancy.Assignee__c != null
            ) {
                oldAssigneeIds.add(oldVacancy.Assignee__c);
            }
        }
        return oldAssigneeIds;
    }

    public Set<Id> getNotNullNewAssigneeIds(
        List<Vacancy__c> newVacancies,
        Map<Id, Vacancy__c> idsToOldVacancies
    ) {
        Set<Id> newAssigneeIds = new Set<Id>();
        for (Vacancy__c newVacancy : newVacancies) {
            Vacancy__c oldVacancy = idsToOldVacancies.get(newVacancy.Id);
            if (
                newVacancy.Assignee__c != oldVacancy.Assignee__c
                &&
                newVacancy.Assignee__c != null
            ) {
                newAssigneeIds.add(newVacancy.Assignee__c);
            }
        }
        return newAssigneeIds;
    }

    public Map<Id, Id> getVacancyIdsToNotNullAssigneeIds(List<Vacancy__c> vacancies) {
        Map<Id, Id> vacancyIdsToAssigneeIds = new Map<Id, Id>();
        for (Vacancy__c vacancy : vacancies) {
            if (vacancy.Assignee__c != null) {
                vacancyIdsToAssigneeIds.put(vacancy.Id, vacancy.Assignee__c);
            }
        }
        return vacancyIdsToAssigneeIds;
    }

    public Map<Id, Id> getVacancyIdsToNotNullNewAssigneeIds(
        List<Vacancy__c> newVacancies,
        Map<Id, Vacancy__c> idsToOldVacancies
    ) {
        Map<Id, Id> vacancyIdsToAssigneeIds = new Map<Id, Id>();
        for (Vacancy__c newVacancy : newVacancies) {
            Vacancy__c oldVacancy = idsToOldVacancies.get(newVacancy.Id);
            if (
                newVacancy.Assignee__c != oldVacancy.Assignee__c
                &&
                newVacancy.Assignee__c != null
            ) {
                vacancyIdsToAssigneeIds.put(newVacancy.Id, newVacancy.Assignee__c);
            }
        }
        return vacancyIdsToAssigneeIds;
    }
}
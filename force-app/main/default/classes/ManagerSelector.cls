public with sharing class ManagerSelector {
    
    public List<Manager__c> selectByIds(Set<Id> assigneeIds) {
        return [
            SELECT
                Id,
                User__c
            FROM
                Manager__c
            WHERE
                Id IN :assigneeIds
        ];
    }
}
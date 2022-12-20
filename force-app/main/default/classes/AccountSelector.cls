public with sharing class AccountSelector {
    
    public List<Account> selectByTerritoryIds(Set<Id> territoryIds) {
        return [
            SELECT
                Id,
                Territory__c,
                (SELECT Contact__c FROM Reference__r)
            FROM
                Account
            WHERE
                Territory__c IN :territoryIds
        ];
    }
}
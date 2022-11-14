public with sharing class AccountContactSelector {

    public List<AccountContact__c> selectByContactIdsAndIsPrimaryOrdered(Set<Id> contactIds, Boolean isPrimary) {
        string q = 'SELECT Id, Contact__c, isPrimary__c FROM AccountContact__c WHERE isPrimary__c =: isPrimary AND Contact__c IN :contactIds ORDER BY CreatedDate';
        return Database.query(q);
    }

    public List<AggregateResult> countByContactIdsAndIsPrimary (Set<Id> contactIds, Boolean isPrimary) {
        string q = 'SELECT COUNT(ID), Contact__c, isPrimary__c FROM AccountContact__c GROUP BY Contact__c, isPrimary__c HAVING COUNT(ID) > 1 AND Contact__c IN :contactIds AND isPrimary__c = :isPrimary';
        return Database.query(q);
    }
}

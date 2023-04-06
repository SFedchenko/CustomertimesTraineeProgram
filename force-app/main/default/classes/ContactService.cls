public with sharing class ContactService {
    
    public Map<Id, Set<Id>> getContactIdsByUserIds(
        Map<Id, Set<Id>> territoryIdsByUserIds,
        List<Account> accounts
    ) {
        Map<Id,Set<Id>> contactIdsByUserIds = new Map<Id,Set<Id>>();
        for (Id userId : territoryIdsByUserIds.keySet()) {
            Set<Id> accessibleTerritoryIds = territoryIdsByUserIds.get(userId);
            contactIdsByUserIds.put(userId, new Set<Id>());
            for (Account account : accounts) {
                if ( accessibleTerritoryIds.contains(account.Territory__c) ) {
                    Set<Id> contactIds = new Set<Id>();
                    for (Reference__c reference : account.Reference__r) {
                        contactIds.add(reference.Contact__c);
                    }
                    contactIdsByUserIds.get(userId).addAll(contactIds);
                }
            }
        }
        return contactIdsByUserIds;
    }
}
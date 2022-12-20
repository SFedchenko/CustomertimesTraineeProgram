public with sharing class AccountService {
    
    public Map<Id, Set<Id>> getAccountIdsByUserIds(
        Map<Id, Set<Id>> territoryIdsByUserIds,
        List<Account> accounts
    ) {
        Map<Id,Set<Id>> accountIdsByUserIds = new Map<Id,Set<Id>>();
        for (Id userId : territoryIdsByUserIds.keySet()) {
            Set<Id> accessibleTerritoryIds = territoryIdsByUserIds.get(userId);
            accountIdsByUserIds.put(userId, new Set<Id>());
            for (Account account : accounts) {
                if ( accessibleTerritoryIds.contains(account.Territory__c) ) {
                    accountIdsByUserIds.get(userId).add(account.Id);
                }
            }
        }
        return accountIdsByUserIds;
    }
}
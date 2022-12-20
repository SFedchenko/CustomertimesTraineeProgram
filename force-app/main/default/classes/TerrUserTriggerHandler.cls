public with sharing class TerrUserTriggerHandler {

    private static final String ROW_CAUSE_MANUAL = 'Manual';
    
    public static void handleAfterInsert(List<TerrUser__c> terrUserRecords) {
        TerrUserService terrUserService = new TerrUserService();
        Map<Id, Set<Id>> territoryIdsByUserIds = terrUserService.getAccessibleTerritoryIdsByUserIds(
            terrUserService.getTerritoryIdsByUserIds(terrUserRecords)
        );
        Set<Id> territoryIds = new MapUtils().getAllValueIds(territoryIdsByUserIds);
        List<Account> accounts = new AccountSelector().getAccountsByTerritoryIds(territoryIds);
        if (accounts.size() > 0) {
            Map<Id,Set<Id>> accountIdsByUserIds = new AccountService().getAccountIdsByUserIds(
                territoryIdsByUserIds,
                accounts
            );
            List<AccountShare> accountSharesToInsert = new AccountShareService().generateAccountShares(accountIdsByUserIds);
            try {
                insert accountSharesToInsert;
            } catch (Exception ex) {
                System.debug( ex.getMessage() );
            }
            Map<Id,Set<Id>> contactIdsByUserIds = new AccountService().getContactIdsByUserIds(
                territoryIdsByUserIds,
                accounts
            );
            List<ContactShare> contactSharesToInsert = new ContactShareService().generateContactShares(contactIdsByUserIds);
            try {
                insert contactSharesToInsert;
            } catch (Exception ex) {
                System.debug( ex.getMessage() );
            }
        }
    }

    public static void handleAfterDelete(List<TerrUser__c> terrUserRecords) {
        TerrUserService terrUserService = new TerrUserService();
        Map<Id, Set<Id>> territoryIdsByUserIds = terrUserService.getAccessibleTerritoryIdsByUserIds(
            terrUserService.getTerritoryIdsByUserIds(terrUserRecords)
        );
        Set<Id> territoryIds = new MapUtils().getAllValueIds(territoryIdsByUserIds);
        List<Account> accounts = new AccountSelector().getAccountsByTerritoryIds(territoryIds);
        if (accounts.size() > 0) {
            Map<Id,Set<Id>> accountIdsByUserIds = new AccountService().getAccountIdsByUserIds(
                territoryIdsByUserIds,
                accounts
            );
            List<AccountShare> accountSharesToDelete = new AccountShareSelector().selectByAccountIdsUserIdsRowCause(
                new MapUtils().getAllValueIds(accountIdsByUserIds),
                accountIdsByUserIds.keySet(),
                ROW_CAUSE_MANUAL
            );
            try {
                delete accountSharesToDelete;
            } catch (Exception ex) {
                System.debug( ex.getMessage() );
            }
            Map<Id,Set<Id>> contactIdsByUserIds = new AccountService().getContactIdsByUserIds(
                territoryIdsByUserIds,
                accounts
            );
            List<ContactShare> contactSharesToDelete = new ContactShareSelector().selectByContactIdsUserIdsRowCause(
                new MapUtils().getAllValueIds(contactIdsByUserIds),
                contactIdsByUserIds.keySet(),
                ROW_CAUSE_MANUAL
            );
            try {
                delete contactSharesToDelete;
            } catch (Exception ex) {
                System.debug( ex.getMessage() );
            }
        }
    }

    public static void handleAfterUpdate(
        List<TerrUser__c> newRecords,
        Map<Id, TerrUser__c> oldRecordsMap
    ) {
        List<TerrUser__c> terrUserRecordsForDeleteShares = new TerrUserService()
            .getOldRecordsWithUserIdOrTerrIdChanged(newRecords, oldRecordsMap);
        TerrUserTriggerHandler.handleAfterDelete(terrUserRecordsForDeleteShares);

        List<TerrUser__c> terrUserRecordsForInsertShares = new TerrUserService()
            .getNewRecordsWithUserIdOrTerrIdChanged(newRecords, oldRecordsMap);
        TerrUserTriggerHandler.handleAfterInsert(terrUserRecordsForInsertShares);
    }
}
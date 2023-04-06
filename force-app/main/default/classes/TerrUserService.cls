public with sharing class TerrUserService {
    
    public Map<Id, Set<Id>> getTerritoryIdsByUserIds(List<TerrUser__c> terrUserRecords) {
        Map<Id, Set<Id>> territoryIdsByUserIds = new Map<Id, Set<Id>>();
        for (TerrUser__c terrUserRecord : terrUserRecords) {
            territoryIdsByUserIds.put(
                terrUserRecord.User__c,
                new Set<Id>()
            );
            territoryIdsByUserIds.get(terrUserRecord.User__c).add(terrUserRecord.Territory__c);
        }
        return territoryIdsByUserIds;
    }

    public Map<Id, Set<Id>> getAccessibleTerritoryIdsByUserIds(
        Map<Id, Set<Id>> territoryIdsByUserIds
    ) {
        for (Id userId : territoryIdsByUserIds.keySet()) {
            territoryIdsByUserIds.put(
                userId,
                new TerritoryService().getAccessibleTerritoryIds(
                    territoryIdsByUserIds.get(userId)
                )
            );
        }
        return territoryIdsByUserIds;
    }

    public List<TerrUser__c> getNewRecordsWithUserIdOrTerrIdChanged(
        List<TerrUser__c> newRecords,
        Map<Id, TerrUser__c> oldRecordsMap
    ) {
        List<TerrUser__c> newRecordsWithUserIdOrTerrIdChanged = new List<TerrUser__c>();
        for (TerrUser__c newTerrUserRecord : newRecords) {
            TerrUser__c oldTerrUserRecord = oldRecordsMap.get(newTerrUserRecord.Id);
            if (
                newTerrUserRecord.User__c != oldTerrUserRecord.User__c
                ||
                newTerrUserRecord.Territory__c != oldTerrUserRecord.Territory__c
            ) {
                newRecordsWithUserIdOrTerrIdChanged.add(newTerrUserRecord);
            }
        }
        return newRecordsWithUserIdOrTerrIdChanged;
    }

    public List<TerrUser__c> getOldRecordsWithUserIdOrTerrIdChanged(
        List<TerrUser__c> newRecords,
        Map<Id, TerrUser__c> oldRecordsMap
    ) {
        List<TerrUser__c> oldRecordsWithUserIdOrTerrIdChanged = new List<TerrUser__c>();
        for (TerrUser__c newTerrUserRecord : newRecords) {
            TerrUser__c oldTerrUserRecord = oldRecordsMap.get(newTerrUserRecord.Id);
            if (
                newTerrUserRecord.User__c != oldTerrUserRecord.User__c
                ||
                newTerrUserRecord.Territory__c != oldTerrUserRecord.Territory__c
            ) {
                oldRecordsWithUserIdOrTerrIdChanged.add(oldTerrUserRecord);
            }
        }
        return oldRecordsWithUserIdOrTerrIdChanged;
    }
}
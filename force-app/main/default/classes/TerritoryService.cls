public with sharing class TerritoryService {
    
    public Set<Id> getAccessibleTerritoryIds(Set<Id> territoryIds) {
        List<Territory__c> childTerritories = [
            SELECT
                Id
            FROM
                Territory__c
            WHERE
                Territory__c IN :territoryIds
        ];
        if (childTerritories.size() > 0) {
            Set<Id> childTerritoryIds = new Map<Id, Territory__c>(childTerritories).keySet();
            territoryIds.addAll( getAccessibleTerritoryIds(childTerritoryIds.clone()) );
        }
        return territoryIds;
    }
}
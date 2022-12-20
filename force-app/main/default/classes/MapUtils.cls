public with sharing class MapUtils {
    
    public Set<Id> getAllValueIds(Map<Id, Set<Id>> valueIdsByKeyIds) {
        Set<Id> valueIds = new Set<Id>();
        for (Id keyId : valueIdsByKeyIds.keySet()) {
            valueIds.addAll(
                valueIdsByKeyIds.get(keyId)
            );
        }
        return valueIds;
    }
}
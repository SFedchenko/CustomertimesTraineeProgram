public with sharing class AccountContactTriggerHandler {

    public static void beforeInsert(List<AccountContact__c> triggerNewRecords) {
        new AccountContactService().setIsPrimaryTriggerInsert(triggerNewRecords);
    }

    public static void afterUpdate(List<AccountContact__c> triggerNewRecords, Map<Id, AccountContact__c> triggerOldMap) {
        new AccountContactService().setIsPrimaryTriggerUpdate(triggerNewRecords, triggerOldMap);
    }

    public static void afterDelete(List<AccountContact__c> triggerOldRecords) {
        new AccountContactService().setIsPrimaryTriggerDelete(triggerOldRecords);
    }

    public static void afterUndelete(List<AccountContact__c> triggerNewRecords) {
        new AccountContactService().setIsPrimaryTriggerUndelete(triggerNewRecords);
    }
}

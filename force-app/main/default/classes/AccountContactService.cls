public with sharing class AccountContactService {
    
    public static Set<Id> getContactIds(List<AccountContact__c> accountContacts) {
        Set<Id> contactIds = new Set<Id>();
        for (AccountContact__c ac : accountContacts) {
            contactIds.add(ac.Contact__c);
        }
        return contactIds;
    }
    
    public static Set<Id> getContactIdsIsPrimaryChange(List<AccountContact__c> triggerNewRecords, Map<Id, AccountContact__c> triggerOldMap, Boolean oldIsPrimary, Boolean newIsPrimary) {
        Set<Id> contactIds = new Set<Id>();
        for (AccountContact__c newAccountContact : triggerNewRecords) {
            AccountContact__c oldAccountContact = triggerOldMap.get(newAccountContact.Id);
            if (oldAccountContact.isPrimary__c == oldIsPrimary && newAccountContact.isPrimary__c == newIsPrimary) {
                contactIds.add(newAccountContact.Contact__c);
            }
        }
        return contactIds;
    }
    
    public static Set<Id> getAccountContactIdsIsPrimaryChange(List<AccountContact__c> triggerNewRecords, Map<Id, AccountContact__c> triggerOldMap, Boolean oldIsPrimary, Boolean newIsPrimary) {
        Set<Id> accountContactIds = new Set<Id>();
        for (AccountContact__c newAccountContact : triggerNewRecords) {
            AccountContact__c oldAccountContact = triggerOldMap.get(newAccountContact.Id);
            if (oldAccountContact.isPrimary__c == oldIsPrimary && newAccountContact.isPrimary__c == newIsPrimary) {
                accountContactIds.add(newAccountContact.Id);
            }
        }
        return accountContactIds;
    }
    
    public void setIsPrimaryTriggerInsert(List<AccountContact__c> triggerNewRecords) {
        Set<Id> contactIdsFromTrigger = AccountContactService.getContactIds(triggerNewRecords);
        List<AccountContact__c> accountContacts = new AccountContactSelector().selectByContactIdsAndIsPrimaryOrdered(contactIdsFromTrigger, true);
        Map<Id, AccountContact__c> lastRecordsForEachContact = new Map<Id, AccountContact__c>();
        for (AccountContact__c ac : triggerNewRecords) {
            lastRecordsForEachContact.put(ac.Contact__c, ac);
        }
        Set<Id> contactIdsFromList = AccountContactService.getContactIds(accountContacts);
        for (AccountContact__c ac : lastRecordsForEachContact.values()) {
            if (!contactIdsFromList.contains(ac.Contact__c)) {
                ac.isPrimary__c = true;
            }
        }
    }
    
    public void setIsPrimaryTriggerUpdate(List<AccountContact__c> triggerNewRecords, Map<Id, AccountContact__c> triggerOldMap) {
        if (CheckRecursive.firstCall) {
            CheckRecursive.firstCall = false;
            
            Set<Id> contactIdsFalseTrue = AccountContactService.getContactIdsIsPrimaryChange(triggerNewRecords, triggerOldMap, false, true);
            Set<Id> contactIdsTrueFalse = AccountContactService.getContactIdsIsPrimaryChange(triggerNewRecords, triggerOldMap, true, false);
            Set<Id> accountContactIdsFalseTrue = AccountContactService.getAccountContactIdsIsPrimaryChange(triggerNewRecords, triggerOldMap, false, true);
            Set<Id> accountContactIdsTrueFalse = AccountContactService.getAccountContactIdsIsPrimaryChange(triggerNewRecords, triggerOldMap, true, false);
            
            List<AccountContact__c> accountContactsToUpdate = new List<AccountContact__c>();
            
            if (contactIdsFalseTrue.size() > 0) {
                List<AccountContact__c> accountContacts = new AccountContactSelector().selectByContactIdsAndIsPrimaryOrdered(contactIdsFalseTrue, true);
                for (AccountContact__c ac : accountContacts) {
                    if (!accountContactIdsFalseTrue.contains(ac.Id)) {
                        ac.isPrimary__c = false;
                        accountContactsToUpdate.add(ac);
                    }
                }
            }
            if (contactIdsTrueFalse.size() > 0) {
                Map<Id, AccountContact__c> mostRecentRecords = new Map<Id, AccountContact__c>();
                List<AccountContact__c> accountContacts = new AccountContactSelector().selectByContactIdsAndIsPrimaryOrdered(contactIdsTrueFalse, false);
                List<AggregateResult> accountContactsAggregated = new AccountContactSelector().countByContactIdsAndIsPrimary(contactIdsTrueFalse, false);
                Set<Id> contactIdsAggregated = new Set<Id>();
                for (AggregateResult ar : accountContactsAggregated) {
                    contactIdsAggregated.add((Id)ar.get('Contact__c'));
                }
                for (AccountContact__c ac : accountContacts) {
                    if (contactIdsAggregated.contains(ac.Contact__c) && !accountContactIdsTrueFalse.contains(ac.Id)) {
                        mostRecentRecords.put(ac.Contact__c, ac);
                    } else if (!contactIdsAggregated.contains(ac.Contact__c)) {
                        mostRecentRecords.put(ac.Contact__c, ac);
                    }
                }
                for (AccountContact__c ac : mostRecentRecords.values()) {
                    ac.isPrimary__c = true;
                    accountContactsToUpdate.add(ac);
                }
            }
            update accountContactsToUpdate;
    	}
    }

    public void setIsPrimaryTriggerDelete(List<AccountContact__c> triggerOldRecords) {
        if (CheckRecursive.firstCall) {
            CheckRecursive.firstCall = false;
            
            Set<Id> contactIdsIsPrimaryTrue = new Set<Id>();
            for (AccountContact__c ac : triggerOldRecords) {
                if (ac.isPrimary__c == true) {
                    contactIdsIsPrimaryTrue.add(ac.Contact__c);
                }
            }

            if (contactIdsIsPrimaryTrue.size() > 0) {
                Map<Id, AccountContact__c> mostRecentRecords = new Map<Id, AccountContact__c>();
                List<AccountContact__c> accountContacts = new AccountContactSelector().selectByContactIdsAndIsPrimaryOrdered(contactIdsIsPrimaryTrue, false);
                for (AccountContact__c ac : accountContacts) {
                    mostRecentRecords.put(ac.Contact__c, ac);
                }
                List<AccountContact__c> accountContactsToUpdate = new List<AccountContact__c>();
                for (AccountContact__c ac : mostRecentRecords.values()) {
                    ac.isPrimary__c = true;
                    accountContactsToUpdate.add(ac);
                }
                update accountContactsToUpdate;
            }
    	}
    }

    public void setIsPrimaryTriggerUndelete(List<AccountContact__c> triggerNewRecords) {
        if (CheckRecursive.firstCall) {
            CheckRecursive.firstCall = false;
            
            Set<Id> contactIdsIsPrimaryTrue = new Set<Id>();
            Set<Id> accountContactIdsIsPrimaryTrue = new Set<Id>();
            for (AccountContact__c ac : triggerNewRecords) {
                if (ac.isPrimary__c == true) {
                    contactIdsIsPrimaryTrue.add(ac.Contact__c);
                    accountContactIdsIsPrimaryTrue.add(ac.Id);
                }
            }

            if (contactIdsIsPrimaryTrue.size() > 0) {
                List<AccountContact__c> accountContacts = new AccountContactSelector().selectByContactIdsAndIsPrimaryOrdered(contactIdsIsPrimaryTrue, true);
                List<AccountContact__c> accountContactsToUpdate = new List<AccountContact__c>();
                for (AccountContact__c ac : accountContacts) {
                    if (!accountContactIdsIsPrimaryTrue.contains(ac.Id)) {
                        ac.isPrimary__c = false;
                        accountContactsToUpdate.add(ac);
                    }
                }
                update accountContactsToUpdate;
            }
    	}
    }
}

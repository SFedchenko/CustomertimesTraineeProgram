@isTest
private class AccountContactService_Test {

    @isTest
    static void testGetContactIds() {
        
        List<Account> testAccounts = TestDataFactory.generateAccounts(2);
        
        List<Contact> testContacts = TestDataFactory.generateContacts(2);
        Set<Id> contactIds = new Set<Id>();
        for (Contact contact : testContacts) {
            contactIds.add(contact.Id);
        }
        
        List<AccountContact__c> testAccountContacts0 = TestDataFactory.generateAccountContacts(testAccounts[0].Id, contactIds);
        List<AccountContact__c> testAccountContacts1 = TestDataFactory.generateAccountContacts(testAccounts[1].Id, contactIds);
        
        List<AccountContact__c> accountContacts = new List<AccountContact__c>();
        accountContacts.addAll(testAccountContacts0);
        accountContacts.addAll(testAccountContacts1);
        
        Test.startTest();
        
        Set<Id> methodContactIds = AccountContactService.getContactIds(accountContacts);
        
        Test.stopTest();
        
        System.assertEquals (contactIds, methodContactIds);
    }
    
    @isTest
    static void testGetContactIdsIsPrimaryChange() {
        
        List<Account> testAccounts = TestDataFactory.generateAccounts(2);
        
        List<Contact> testContacts = TestDataFactory.generateContacts(2);
        Set<Id> contactIds = new Set<Id>();
        for (Contact contact : testContacts) {
            contactIds.add(contact.Id);
        }
        
        List<AccountContact__c> testAccountContacts0 = TestDataFactory.generateAccountContacts(testAccounts[0].Id, contactIds);
        List<AccountContact__c> testAccountContacts1 = TestDataFactory.generateAccountContacts(testAccounts[1].Id, contactIds);
        
        Test.startTest();
        
        List<AccountContact__c> accountContactsTrue = new AccountContactSelector().selectByContactIdsAndIsPrimaryOrdered(contactIds, true);
        List<AccountContact__c> accountContactsTrueChanged = accountContactsTrue.deepClone(true);
        accountContactsTrueChanged[0].isPrimary__c = false;
        Set<Id> contactTrueChangedIds = new Set<Id>();
        contactTrueChangedIds.add(accountContactsTrueChanged[0].Contact__c);
        Map<Id, AccountContact__c> accountContactsTrueChangedMap = new Map<Id, AccountContact__c>(accountContactsTrueChanged);
        
        List<AccountContact__c> accountContactsFalse = new AccountContactSelector().selectByContactIdsAndIsPrimaryOrdered(contactIds, false);
        List<AccountContact__c> accountContactsFalseChanged = accountContactsFalse.deepClone(true);
        accountContactsFalseChanged[0].isPrimary__c = true;
        Set<Id> contactFalseChangedIds = new Set<Id>();
        contactFalseChangedIds.add(accountContactsFalseChanged[0].Contact__c);
        Map<Id, AccountContact__c> accountContactsFalseChangedMap = new Map<Id, AccountContact__c>(accountContactsFalseChanged);
        
        Set<Id> methodContactIdsTrueFalse = AccountContactService.getContactIdsIsPrimaryChange(accountContactsFalse, accountContactsFalseChangedMap, true, false);
        Set<Id> methodContactIdsFalseTrue = AccountContactService.getContactIdsIsPrimaryChange(accountContactsTrue, accountContactsTrueChangedMap, false, true);
        
        Test.stopTest();
        
        System.assertEquals (contactTrueChangedIds, methodContactIdsTrueFalse);
        System.assertEquals (contactFalseChangedIds, methodContactIdsFalseTrue);
    }
    
    @isTest
    static void testGetAccountContactIdsIsPrimaryChange() {
        
        List<Account> testAccounts = TestDataFactory.generateAccounts(2);
        
        List<Contact> testContacts = TestDataFactory.generateContacts(2);
        Set<Id> contactIds = new Set<Id>();
        for (Contact contact : testContacts) {
            contactIds.add(contact.Id);
        }
        
        List<AccountContact__c> testAccountContacts0 = TestDataFactory.generateAccountContacts(testAccounts[0].Id, contactIds);
        List<AccountContact__c> testAccountContacts1 = TestDataFactory.generateAccountContacts(testAccounts[1].Id, contactIds);
        
        Test.startTest();
        
        List<AccountContact__c> accountContactsTrue = new AccountContactSelector().selectByContactIdsAndIsPrimaryOrdered(contactIds, true);
        List<AccountContact__c> accountContactsTrueChanged = accountContactsTrue.deepClone(true);
        accountContactsTrueChanged[0].isPrimary__c = false;
        Set<Id> accountContactTrueChangedIds = new Set<Id>();
        accountContactTrueChangedIds.add(accountContactsTrueChanged[0].Id);
        Map<Id, AccountContact__c> accountContactsTrueChangedMap = new Map<Id, AccountContact__c>(accountContactsTrueChanged);
        
        List<AccountContact__c> accountContactsFalse = new AccountContactSelector().selectByContactIdsAndIsPrimaryOrdered(contactIds, false);
        List<AccountContact__c> accountContactsFalseChanged = accountContactsFalse.deepClone(true);
        accountContactsFalseChanged[0].isPrimary__c = true;
        Set<Id> accountContactFalseChangedIds = new Set<Id>();
        accountContactFalseChangedIds.add(accountContactsFalseChanged[0].Id);
        Map<Id, AccountContact__c> accountContactsFalseChangedMap = new Map<Id, AccountContact__c>(accountContactsFalseChanged);
        
        Set<Id> methodAccountContactIdsTrueFalse = AccountContactService.getAccountContactIdsIsPrimaryChange(accountContactsFalse, accountContactsFalseChangedMap, true, false);
        Set<Id> methodAccountContactIdsFalseTrue = AccountContactService.getAccountContactIdsIsPrimaryChange(accountContactsTrue, accountContactsTrueChangedMap, false, true);
        
        Test.stopTest();
        
        System.assertEquals (accountContactFalseChangedIds, methodAccountContactIdsTrueFalse);
        System.assertEquals (accountContactTrueChangedIds, methodAccountContactIdsFalseTrue);
    }
    
    @isTest
    static void testSetIsPrimaryTriggerInsert() {
        
        List<Account> testAccounts = TestDataFactory.generateAccounts(2);
        
        List<Contact> testContacts = TestDataFactory.generateContacts(2);
        Set<Id> contactId0 = new Set<Id>{testContacts[0].Id};
        Set<Id> contactIds = new Set<Id>();
        for (Contact contact : testContacts) {
            contactIds.add(contact.Id);
        }
        
        List<AccountContact__c> testAccountContacts0 = TestDataFactory.generateAccountContacts(testAccounts[0].Id, contactId0);
        
        List<AccountContact__c> testAccountContacts = new List<AccountContact__c>();
        
        AccountContact__c accountContact0 = new AccountContact__c();
        accountContact0.Account__c = testAccounts[1].Id;
        accountContact0.Contact__c = testContacts[0].Id;
        accountContact0.isPrimary__c = false;
        testAccountContacts.add(accountContact0);
        
        AccountContact__c accountContact1 = new AccountContact__c();
        accountContact1.Account__c = testAccounts[0].Id;
        accountContact1.Contact__c = testContacts[1].Id;
        accountContact1.isPrimary__c = false;
        testAccountContacts.add(accountContact1);
        
        Test.startTest();
        
        new AccountContactService().setIsPrimaryTriggerInsert(testAccountContacts);
        
        Test.stopTest();
        
        System.assertEquals (false, testAccountContacts[0].isPrimary__c);
        System.assertEquals (true, testAccountContacts[1].isPrimary__c);
    }
    
    @isTest
    static void testSetIsPrimaryTriggerUpdate() {
        
        List<Account> testAccounts = TestDataFactory.generateAccounts(3);
        
        List<Contact> testContacts = TestDataFactory.generateContacts(2);
        Set<Id> contact1Id = new Set<Id>{testContacts[0].Id};
        Set<Id> contact2Id = new Set<Id>{testContacts[1].Id};
        
        List<AccountContact__c> testAccount1Contact1 = TestDataFactory.generateAccountContacts(testAccounts[0].Id, contact1Id); //isPrimary__c = true
        List<AccountContact__c> testAccount2Contact1 = TestDataFactory.generateAccountContacts(testAccounts[1].Id, contact1Id); //isPrimary__c = false
        List<AccountContact__c> testAccount3Contact1 = TestDataFactory.generateAccountContacts(testAccounts[2].Id, contact1Id); //isPrimary__c = false
        List<AccountContact__c> testAccount1Contact2 = TestDataFactory.generateAccountContacts(testAccounts[0].Id, contact2Id); //isPrimary__c = true
        List<AccountContact__c> testAccount2Contact2 = TestDataFactory.generateAccountContacts(testAccounts[1].Id, contact2Id); //isPrimary__c = false
        List<AccountContact__c> testAccount3Contact2 = TestDataFactory.generateAccountContacts(testAccounts[2].Id, contact2Id); //isPrimary__c = false
        
        Test.startTest();
        
        List<AccountContact__c> account1Contact1 = [SELECT Id, Contact__c, isPrimary__c FROM AccountContact__c WHERE Id =: testAccount1Contact1[0].Id]; //isPrimary__c = true
        List<AccountContact__c> account1Contact1Changed = account1Contact1.deepClone(true);
        account1Contact1Changed[0].isPrimary__c = false;
        
        List<AccountContact__c> account2Contact2 = [SELECT Id, Contact__c, isPrimary__c FROM AccountContact__c WHERE Id =: testAccount2Contact2[0].Id]; //isPrimary__c = false
        List<AccountContact__c> account2Contact2Changed = account2Contact2.deepClone(true);
        account2Contact2Changed[0].isPrimary__c = true;
        
        List<AccountContact__c> triggerNewRecords = new List<AccountContact__c>();
        triggerNewRecords.addAll(account1Contact1Changed);
        triggerNewRecords.addAll(account2Contact2Changed);
        System.debug(triggerNewRecords);
        
        List<AccountContact__c> accountContactsForMap = new List<AccountContact__c>();
        accountContactsForMap.addAll(account1Contact1);
        accountContactsForMap.addAll(account2Contact2);
        Map<Id, AccountContact__c> triggerOldMap = new Map<Id, AccountContact__c>(accountContactsForMap);
        System.debug(triggerOldMap);
        
        new AccountContactService().setIsPrimaryTriggerUpdate(triggerNewRecords, triggerOldMap);
        
        List<AccountContact__c> account3Contact1 = [SELECT Id, isPrimary__c FROM AccountContact__c WHERE Id =: testAccount3Contact1[0].Id]; //isPrimary__c should change to true
        List<AccountContact__c> account1Contact2 = [SELECT Id, isPrimary__c FROM AccountContact__c WHERE Id =: testAccount1Contact2[0].Id]; //isPrimary__c should change to false
        
        Test.stopTest();
        
        System.assertEquals (true, account3Contact1[0].isPrimary__c);
        System.assertEquals (false, account1Contact2[0].isPrimary__c);
    }

    @isTest
    static void testSetIsPrimaryTriggerDelete() {
        
        List<Account> testAccounts = TestDataFactory.generateAccounts(3);
        
        List<Contact> testContacts = TestDataFactory.generateContacts(2);
        Set<Id> contact1Id = new Set<Id>{testContacts[0].Id};
        Set<Id> contact2Id = new Set<Id>{testContacts[1].Id};
        
        List<AccountContact__c> testAccount1Contact1 = TestDataFactory.generateAccountContacts(testAccounts[0].Id, contact1Id); //isPrimary__c = true
        List<AccountContact__c> testAccount2Contact1 = TestDataFactory.generateAccountContacts(testAccounts[1].Id, contact1Id); //isPrimary__c = false
        List<AccountContact__c> testAccount3Contact1 = TestDataFactory.generateAccountContacts(testAccounts[2].Id, contact1Id); //isPrimary__c = false
        List<AccountContact__c> testAccount1Contact2 = TestDataFactory.generateAccountContacts(testAccounts[0].Id, contact2Id); //isPrimary__c = true
        List<AccountContact__c> testAccount2Contact2 = TestDataFactory.generateAccountContacts(testAccounts[1].Id, contact2Id); //isPrimary__c = false
        List<AccountContact__c> testAccount3Contact2 = TestDataFactory.generateAccountContacts(testAccounts[2].Id, contact2Id); //isPrimary__c = false

        List<AccountContact__c> accountContactsToDelete = new List<AccountContact__c>();
        accountContactsToDelete.addAll(testAccount1Contact1);
        accountContactsToDelete.addAll(testAccount1Contact2);
        
        Test.startTest();
        
        delete accountContactsToDelete;
        
        List<AccountContact__c> account3Contact1 = [SELECT Id, isPrimary__c FROM AccountContact__c WHERE Id =: testAccount3Contact1[0].Id]; //isPrimary__c should change to true
        List<AccountContact__c> account3Contact2 = [SELECT Id, isPrimary__c FROM AccountContact__c WHERE Id =: testAccount3Contact2[0].Id]; //isPrimary__c should change to true
        
        Test.stopTest();
        
        System.assertEquals (true, account3Contact1[0].isPrimary__c);
        System.assertEquals (true, account3Contact2[0].isPrimary__c);
    }
}
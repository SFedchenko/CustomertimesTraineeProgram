@isTest
private class AccountContactSelector_Test {
    
    @isTest
    static void testSelectByContactIdsAndIsPrimaryOrdered() {
        
        List<Account> testAccounts = TestDataFactory.generateAccounts(2);
        
        List<Contact> testContacts = TestDataFactory.generateContacts(2);
        Set<Id> contactIds = new Set<Id>();
        for (Contact contact : testContacts) {
            contactIds.add(contact.Id);
        }
        
        List<AccountContact__c> testAccountContacts0 = TestDataFactory.generateAccountContacts(testAccounts[0].Id, contactIds);
        Set<Id> testAccountContactIdsTrue = new Set<Id>();
        for (AccountContact__c accountContact : testAccountContacts0) {
            testAccountContactIdsTrue.add(accountContact.Id);
        }
        
        List<AccountContact__c> testAccountContacts1 = TestDataFactory.generateAccountContacts(testAccounts[1].Id, contactIds);
        Set<Id> testAccountContactIdsFalse = new Set<Id>();
        for (AccountContact__c accountContact : testAccountContacts1) {
            testAccountContactIdsFalse.add(accountContact.Id);
        }
        
        Test.startTest();
        
        List<AccountContact__c> methodAccountContactsTrue = new AccountContactSelector().selectByContactIdsAndIsPrimaryOrdered(contactIds, true);
        List<AccountContact__c> methodAccountContactsFalse = new AccountContactSelector().selectByContactIdsAndIsPrimaryOrdered(contactIds, false);
        
        Test.stopTest();
        
        Set<Id> methodAccountContactIdsTrue = new Set<Id>();
        for (AccountContact__c accountContact : methodAccountContactsTrue) {
            methodAccountContactIdsTrue.add(accountContact.Id);
        }
        
        Set<Id> methodAccountContactIdsFalse = new Set<Id>();
        for (AccountContact__c accountContact : methodAccountContactsFalse) {
            methodAccountContactIdsFalse.add(accountContact.Id);
        }
        
        System.assertEquals (testAccountContactIdsTrue, methodAccountContactIdsTrue);
        System.assertEquals (testAccountContactIdsFalse, methodAccountContactIdsFalse);
    }

    @isTest
    static void testCountByContactIdsAndIsPrimary() {
        
        List<Account> testAccounts = TestDataFactory.generateAccounts(3);
        
        List<Contact> testContacts = TestDataFactory.generateContacts(2);
        Set<Id> contactIds = new Set<Id>();
        for (Contact contact : testContacts) {
            contactIds.add(contact.Id);
        }
        
        List<AccountContact__c> testAccount0Contacts = TestDataFactory.generateAccountContacts(testAccounts[0].Id, contactIds);
        List<AccountContact__c> testAccount1Contacts = TestDataFactory.generateAccountContacts(testAccounts[1].Id, contactIds);
        List<AccountContact__c> testAccount2Contacts = TestDataFactory.generateAccountContacts(testAccounts[2].Id, contactIds);
        
        
        Test.startTest();
        
        List<AggregateResult> arFalse = new AccountContactSelector().countByContactIdsAndIsPrimary(contactIds, false);
        
        Test.stopTest();
        
        System.assertEquals (2, (Integer)arFalse[0].get('expr0'));
        System.assertEquals (2, (Integer)arFalse[1].get('expr0'));
    }
}
@isTest
public class TestDataFactory {

    public static List<Account> generateAccounts(Integer amount) {
        List<Account> accounts = new List<Account>();
        for (Integer i = 1; i <= amount; i++) {
            Account account = new Account();
            account.Name = 'Account' + i;
            accounts.add(account);
        }
        insert accounts;
        return accounts;
    }
    
    public static List<Contact> generateContacts(Integer amount) {
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 1; i <= amount; i++) {
            Contact contact = new Contact();
            contact.LastName = 'Contact' + i;
            contacts.add(contact);
        }
        insert contacts;
        return contacts;
    }
    
    public static List<AccountContact__c> generateAccountContacts(Id accountId, Set<Id> contactIds) {
        List<AccountContact__c> accountContacts = new List<AccountContact__c>();
        for (Id contactId : contactIds) {
            AccountContact__c accountContact = new AccountContact__c();
            accountContact.Account__c = accountId;
            accountContact.Contact__c = contactId;
            accountContacts.add(accountContact);
        }
        insert accountContacts;
        return accountContacts;
    }
}
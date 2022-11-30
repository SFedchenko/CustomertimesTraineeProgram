@RestResource(UrlMapping='/Account/*')
global with sharing class AccountRestResource {

    private static final String externalAccount = 'External Account';

    @HttpPost
    global static void insertAccounts(List<Account> accounts){
        for (Account account : accounts) {
            account.OriginalSource__c = account.AccountSource;
            account.AccountSource = externalAccount;
        }
        insert accounts;
    }
}
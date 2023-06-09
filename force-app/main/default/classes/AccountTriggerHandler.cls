public with sharing class AccountTriggerHandler {
    
    public static void handleBeforeInsert(List<Account> newAccounts) {
        String newAccountsJSON = JSON.serialize(
            Callout.wrapAccounts(newAccounts)
        );
        Callout.makeCreateAccountCallout(newAccountsJSON);
    }
}

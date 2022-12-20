public with sharing class AccountShareService {

    private static final String ACCESS_LEVEL_EDIT = 'Edit';
    private static final String ACCESS_LEVEL_NONE = 'None';
    private static final String ROW_CAUSE_MANUAL = 'Manual';

    public List<AccountShare> generateAccountShares(Map<Id, Set<Id>> accountIdsByUserIds) {
        List<AccountShare> accountShares = new List<AccountShare>();
        for (Id userId : accountIdsByUserIds.keySet()) {
            for (Id accountId : accountIdsByUserIds.get(userId)) {
                accountShares.add(
                    new AccountShare(
                        AccountAccessLevel = ACCESS_LEVEL_EDIT,
                        AccountId = accountId,
                        CaseAccessLevel = ACCESS_LEVEL_NONE,
                        ContactAccessLevel = ACCESS_LEVEL_NONE,
                        OpportunityAccessLevel = ACCESS_LEVEL_NONE,
                        RowCause = ROW_CAUSE_MANUAL,
                        UserOrGroupId = userId
                    )
                );
            }
        }
        return accountShares;
    }
}
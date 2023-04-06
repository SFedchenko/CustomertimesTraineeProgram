public with sharing class AccountShareSelector {
    
    public List<AccountShare> selectByAccountIdsUserIdsRowCause(
        Set<Id> accountIds,
        Set<Id> userIds,
        String rowCause
    ) {
        return [
            SELECT
                Id
            FROM
                AccountShare
            WHERE
                AccountId IN :accountIds
                AND
                UserOrGroupId IN :userIds
                AND
                RowCause = :rowCause
        ];
    }
}
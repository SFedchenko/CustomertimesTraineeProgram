public with sharing class ContactShareSelector {
    
    public List<ContactShare> selectByContactIdsUserIdsRowCause(
        Set<Id> contactIds,
        Set<Id> userIds,
        String rowCause
    ) {
        return [
            SELECT
                Id
            FROM
                ContactShare
            WHERE
                ContactId IN :contactIds
                AND
                UserOrGroupId IN :userIds
                AND
                RowCause = :rowCause
        ];
    }
}
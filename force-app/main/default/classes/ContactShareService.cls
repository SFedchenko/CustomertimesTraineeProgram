public with sharing class ContactShareService {

    private static final String ACCESS_LEVEL_EDIT = 'Edit';
    private static final String ROW_CAUSE_MANUAL = 'Manual';
    
    public List<ContactShare> generateContactShares(Map<Id, Set<Id>> contactIdsByUserIds) {
        List<ContactShare> contactShares = new List<ContactShare>();
        for (Id userId : contactIdsByUserIds.keySet()) {
            for (Id contactId : contactIdsByUserIds.get(userId)) {
                contactShares.add(
                    new ContactShare(
                        ContactAccessLevel = ACCESS_LEVEL_EDIT,
                        ContactId = contactId,
                        RowCause = ROW_CAUSE_MANUAL,
                        UserOrGroupId = userId
                    )
                );
            }
        }
        return contactShares;
    }
}
public with sharing class VacancyShareSelector {
    
    public List<Vacancy__Share> selectByParentAndUserIdsAndRowCause(
        Set<Id> parentIds,
        Set<Id> userOrGroupIds,
        String rowCause
    ) {
        return [
            SELECT
                Id
            FROM
                Vacancy__Share
            WHERE
                ParentId IN :parentIds
                AND
                UserOrGroupId IN :userOrGroupIds
                AND
                RowCause = :rowCause
        ];
    }
}
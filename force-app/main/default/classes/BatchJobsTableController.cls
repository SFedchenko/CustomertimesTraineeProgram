public with sharing class BatchJobsTableController {

    private static final String JOB_TYPE_BATCH_APEX = 'BatchApex';
    private static final String STRING_SUCCESS = 'Success';
    private static final String STRING_ABORTED = 'Aborted';
    private static final String STRING_ERROR = 'Error';
    private static final String STRING_PROCESSING = 'Processing';
    private static final String STRING_TRUE = 'true';
    
    public Class BatchJobsTableData {
        @AuraEnabled
        public String Id;
        @AuraEnabled
        public String batchClassName;
        @AuraEnabled
        public String status;
        @AuraEnabled
        public DateTime completedDate;
        @AuraEnabled
        public Boolean isRerunButton;
        @AuraEnabled
        public Boolean isAbortButton;
    }

    public class Column {
        @AuraEnabled
        public String label;
        @AuraEnabled
        public String fieldName;
        @AuraEnabled
        public String type;
        @AuraEnabled
        public String hideDefaultActions;

        public Column(String label, String fieldName, String type, String hideDefaultActions) {
            this.label = label;
            this.fieldName = fieldName;
            this.type = type;
            this.hideDefaultActions = hideDefaultActions;
        }
    }

    public class BatchJobLogsTableData {
        @AuraEnabled
        public List<Column> columns;
        @AuraEnabled
        public List<Log__c> logs;

        public BatchJobLogsTableData(List<Column> columns, List<Log__c> logs) {
            this.columns = columns;
            this.logs = logs;
        }
    }

    @AuraEnabled
    public static List<BatchJobsTableData> getBatchJobsTableData() {
        List<AsyncApexJob> batchJobs = [
            SELECT
                Id,
                ApexClass.Name,
                Status,
                CompletedDate,
                NumberOfErrors 
            FROM 
                AsyncApexJob
            WHERE 
                JobType = :JOB_TYPE_BATCH_APEX
            ORDER BY
                CompletedDate
            DESC
        ];

        List<BatchJobsTableData> batchJobsTableData = new List<BatchJobsTableData>();
        for (AsyncApexJob batchJob : batchJobs) {
            BatchJobsTableData batchJobData = new BatchJobsTableData();
            batchJobData.Id = (String)batchJob.Id;
            batchJobData.batchClassName = (String)batchJob.getSObject('ApexClass').get('Name');
            batchJobData.completedDate = batchJob.CompletedDate;
            if (
                batchJob.Status == 'Aborted'
            ) {
                batchJobData.status = STRING_ABORTED;
                batchJobData.isAbortButton = false;
                batchJobData.isRerunButton = true;
            }
            else if (
                batchJob.Status == 'Completed'
                &&
                batchJob.NumberOfErrors == 0
            ) {
                batchJobData.status = STRING_SUCCESS;
                batchJobData.isAbortButton = false;
                batchJobData.isRerunButton = true;
            }
            else if (
                (batchJob.Status == 'Completed'
                &&
                batchJob.NumberOfErrors > 0)
                ||
                batchJob.Status == 'Failed'
            ) {
                batchJobData.status = STRING_ERROR;
                batchJobData.isAbortButton = false;
                batchJobData.isRerunButton = true;
            }
            else {
                batchJobData.status = STRING_PROCESSING;
                batchJobData.isAbortButton = true;
                batchJobData.isRerunButton = false;
            }
            batchJobsTableData.add(batchJobData);
        }
        return batchJobsTableData;
    }

    @AuraEnabled
    public static Id rerunBatch(String batchClassName) {
        return Database.executeBatch(
            (Database.Batchable<SObject>)Type.forName(batchClassName).newInstance()
        );
    }

    @AuraEnabled
    public static String abortBatch(Id batchJobId) {
        try {
            System.abortJob(batchJobId);
            return STRING_SUCCESS;
        } catch (Exception ex) {
            return ex.getMessage();
        }
    }

    private List<Column> getColumns(List<Schema.FieldSetMember> accountsTableFieldSetFields) {
        List<Column> columns = new List<Column>();
        for (Schema.FieldSetMember field : accountsTableFieldSetFields) {
            Column column = new Column(
                field.getLabel(),
                field.getFieldPath(),
                String.valueOf( field.getType() ).toLowerCase(),
                STRING_TRUE
            );
            columns.add(column);
        }
        return columns;
    }

    private List<Log__c> getLogs(List<Schema.FieldSetMember> accountsTableFieldSetFields, Id batchJobId) {
        String query = 'SELECT ';
        for (Schema.FieldSetMember field : accountsTableFieldSetFields) {
            query += field.getFieldPath() + ', ';
        }
        query += 'Id FROM Log__c WHERE ContextId__c = :batchJobId';
        List<Log__c> logs = Database.query(query);
        List<Log__c> securedLogs = Security.stripInaccessible(
            AccessType.READABLE,
            logs
        ).getRecords();
        return securedLogs;
    }

    @AuraEnabled
    public static BatchJobLogsTableData getBatchJobLogsTableData(String fieldSetName, Id batchJobId) {
        List<Schema.FieldSetMember> batchJobLogsTableFeldSetFields = new Utils()
            .getFieldSetFields('Log__c', fieldSetName);
        BatchJobsTableController batchJobsTableController = new BatchJobsTableController();
        return new BatchJobLogsTableData(
            batchJobsTableController.getColumns(batchJobLogsTableFeldSetFields),
            batchJobsTableController.getLogs(batchJobLogsTableFeldSetFields, batchJobId)
        );
    }
}
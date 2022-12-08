public with sharing class AccountsTableController {

    private static final String ACCOUNT_OBJECT_NAME = 'Account';
    private static final String ACCOUNT_SOURCE_FIELD_NAME = 'AccountSource';
    private static final Schema.DescribeFieldResult ACCOUNT_SOURCE_FIELD = new Utils().getField(ACCOUNT_OBJECT_NAME, ACCOUNT_SOURCE_FIELD_NAME);
    private static final String STRING_SELECT = 'SELECT ';
    private static final String STRING_FROM = ' FROM ';

    public class Column {
        @AuraEnabled
        public String label;
        @AuraEnabled
        public String fieldName;
        @AuraEnabled
        public String type;

        public Column(String label, String fieldName, String type) {
            this.label = label;
            this.fieldName = fieldName;
            this.type = type;
        }
    }

    public class AccountsTableData {
        @AuraEnabled
        public List<Column> columns;
        @AuraEnabled
        public List<Account> accounts;

        public AccountsTableData(List<Column> columns, List<Account> accounts) {
            this.columns = columns;
            this.accounts = accounts;
        }
    }
    
    private List<Column> getColumns(List<Schema.FieldSetMember> accountsTableFieldSetFields) {
        List<Column> columns = new List<Column>();
        for (Schema.FieldSetMember field : accountsTableFieldSetFields) {
            Column column = new Column(
                field.getLabel(),
                field.getFieldPath(),
                String.valueOf( field.getType() ).toLowerCase()
            );
            columns.add(column);
        }
        columns.add(
            new Column(
                ACCOUNT_SOURCE_FIELD.getLabel(),
                ACCOUNT_SOURCE_FIELD_NAME,
                String.valueOf( ACCOUNT_SOURCE_FIELD.getType() ).toLowerCase()
            )
        );
        return columns;
    }

    private List<Account> getAccounts(List<Schema.FieldSetMember> accountsTableFieldSetFields) {
        String query = STRING_SELECT;
        for (Schema.FieldSetMember field : accountsTableFieldSetFields) {
            query += field.getFieldPath() + ', ';
        }
        query += ACCOUNT_SOURCE_FIELD_NAME + STRING_FROM + ACCOUNT_OBJECT_NAME;
        List<Account> accounts = Database.query(query);
        List<Account> securedAccounts = Security.stripInaccessible(
            AccessType.READABLE,
            accounts
        ).getRecords();
        return securedAccounts;
    }

    @AuraEnabled(cacheable=true)
    public static AccountsTableData getAccountsTableData(String fieldSetName) {
        List<Schema.FieldSetMember> accountsTableFieldSetFields = new Utils()
            .getFieldSetFields(ACCOUNT_OBJECT_NAME, fieldSetName);
        AccountsTableController accountsTableController = new AccountsTableController();
        return new AccountsTableData(
            accountsTableController.getColumns(accountsTableFieldSetFields),
            accountsTableController.getAccounts(accountsTableFieldSetFields)
        );
    }
}
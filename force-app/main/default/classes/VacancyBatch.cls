public with sharing class VacancyBatch implements Database.Batchable<SObject> {

    private String batchQuery;
    private String standardQuery = 'SELECT Id FROM Vacancy__c WHERE Status__c = \'Closed\' ';
  
    public VacancyBatch(String query) {
        this.batchQuery = query; 
    }
    public VacancyBatch() {
        this.batchQuery = standardQuery;
    }
  
    public Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator(this.batchQuery);
    }

    public void execute(
        Database.BatchableContext context,
        List<Vacancy__c> vacancies
    ) {
        try {
            delete vacancies;
            new Logger().log(context, 'Batch finished successfully', 'INFO');
        } catch (CustomException ex) {
            new Logger().log(context, ex, 'ERROR');
            throw new CustomException('There was an error during batch processed>>', ex);
        }
    }
    
    public void finish(Database.BatchableContext context) {}
  
    public class CustomException extends Exception {}
}
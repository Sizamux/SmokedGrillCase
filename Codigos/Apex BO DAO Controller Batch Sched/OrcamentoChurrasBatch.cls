public with sharing class OrcamentoChurrasBatch implements Database.Batchable<sObject>{

    public Database.QueryLocator start(Database.BatchableContext bc) {
        // Puxa via Select Contas com seus contatos 
        return Database.getQueryLocator([   SELECT Id, Inicio__c
                                            FROM OrcamentoChurras__c
                                            WHERE Inicio__c < TODAY 
                                                AND Status__c != 'Concluído'
                                        ]);
    }
    
    public void execute(Database.BatchableContext bc, List<OrcamentoChurras__c> orcChurrasList){
        // process each batch of records
        If(!orcChurrasList.isEmpty()){
                delete orcChurrasList;
        }
    }
    public void finish(Database.BatchableContext bc){
        // execute any post-processing operations
    }
}
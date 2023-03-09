public with sharing class AvaliacaoDAO {
    public static List<Avaliacao__c> buscaAvaliacoesRetornaBool(Id recordId){

        List<Avaliacao__c> avaliacoes = [SELECT id FROM  Avaliacao__c WHERE OrcamentoChurras__c = :recordId];
        return avaliacoes;
    }
}
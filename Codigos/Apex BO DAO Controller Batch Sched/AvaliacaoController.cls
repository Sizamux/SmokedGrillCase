public with sharing class AvaliacaoController {
    @AuraEnabled
    public static void enviarAvaliacao(AvaliacaoTo avaliacaoTo){

        Avaliacao__c itemAvaliado = new Avaliacao__c();
        itemAvaliado.Nota__c = avaliacaoTo.nota;
        itemAvaliado.Observacoes__c = avaliacaoTo.observacoes;
        itemAvaliado.OrcamentoChurras__c = avaliacaoTo.orcamentoId;

        insert itemAvaliado;
    }

    @AuraEnabled
    public static Boolean buscaAvaliacoesRetornaBool(Id orcId){

        List<Avaliacao__c> itemAvaliado = AvaliacaoDAO.buscaAvaliacoesRetornaBool(orcId);
        
        if (!itemAvaliado.isEmpty()) {  
            return true;
        }else{
            return false;
        }
    }

    public Class AvaliacaoTo{
        @AuraEnabled public Integer nota{get;set;}
        @AuraEnabled public String  observacoes{get;set;}
        @AuraEnabled public String  orcamentoId{get;set;}
    }
}
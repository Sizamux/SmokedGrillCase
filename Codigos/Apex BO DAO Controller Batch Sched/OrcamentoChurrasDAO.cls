public with sharing class OrcamentoChurrasDAO {
    //Busca Item Orcamento com produtos a partir de Set Id de ItensOrcamento e Id Produtos
    public static List<OrcamentoChurras__c> buscarItmOrcProdEspecifico(Set<Id> recordId, Set<Id>  idDeProdutoSet){
        List<OrcamentoChurras__c> itnChurrasDeOrc = [  SELECT Id, (SELECT Id, Produto__c,OrcamentoChurras__c 
                                                                    FROM ItemsOrcamentoChurras__r
                                                                    WHERE Produto__c = :idDeProdutoSet)
                                                        FROM OrcamentoChurras__c 
                                                        WHERE id IN :recordId];
        return itnChurrasDeOrc;
    }
   

}
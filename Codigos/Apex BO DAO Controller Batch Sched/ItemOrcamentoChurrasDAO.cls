public with sharing class ItemOrcamentoChurrasDAO {
   
    //Busca 1 registro de Item Orçamento Churras que possuem1 produtos de serviço via SOQL
    public static List<ItemOrcamentoChurras__c> buscarItmOrcProdComServicos(List<Id> recordId, Id recordTypeId){
        List<ItemOrcamentoChurras__c> itmOrcProdList = [SELECT id, OrcamentoChurras__c,Produto__c 
                                                            FROM ItemOrcamentoChurras__c
                                                            WHERE Produto__c IN     (SELECT id 
                                                                                    FROM Product2 
                                                                                    WHERE RecordTypeId = :recordTypeId ) 
                                                            AND  OrcamentoChurras__c IN :recordId LIMIT 1];
        return itmOrcProdList;
    }

    public static List<ItemOrcamentoChurras__c> buscarItmOrcRelacionamentos(Set<Id> recordId){
        List<ItemOrcamentoChurras__c> itnChurras = [  SELECT id, Valor__c,Quantidade__c, Produto__r.Valor__c, 
                                                                Produto__r.Servico__c, Produto__r.RecordTypeId,
                                                                OrcamentoChurras__r.Inicio__c, OrcamentoChurras__r.Fim__c       
                                                                FROM ItemOrcamentoChurras__c
                                                                WHERE Id IN :recordId];
        return itnChurras;
    }
}
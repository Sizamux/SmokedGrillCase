public with sharing class ItemOrcamentoChurrasBO {
    //////Trigger
    //Before Insert
    public static void aoVerificaDuplicidade(List<ItemOrcamentoChurras__c> itnChurrasNewList){
        //Lista de Variavel para teste de Valor Duplicado
        Set<Id> idDeProdutoSet = new Set<Id>();
        //Set de OrçamentoId
        Set<Id> idOrcSet = new Set<Id>();

        for (ItemOrcamentoChurras__c churrasNew : itnChurrasNewList) {
            idOrcSet.add(churrasNew.OrcamentoChurras__c);
            idDeProdutoSet.add(churrasNew.Produto__c);
        }
        //Busca Orcamento dos item q foram Adicionados e seus produtos
        List<OrcamentoChurras__c> orcChurrasList = OrcamentoChurrasDAO.buscarItmOrcProdEspecifico(idOrcSet,idDeProdutoSet);
        //Verifica se Orçamento já possui outros Itens
        if(!orcChurrasList.isEmpty()){
            for (OrcamentoChurras__c orcChurras : orcChurrasList) {
                //Possui Item Duplicado
                if(orcChurras.ItemsOrcamentoChurras__r.size() > 0){
                    //Faz Varredura para encontrar qual Orçamento New possui item duplicado
                    for (ItemOrcamentoChurras__c churrasNew : itnChurrasNewList) {
                        if(churrasNew.OrcamentoChurras__c == orcChurras.Id)
                            churrasNew.Produto__c.addError('Este Item ja Existe neste Orçamento');
                    }
                }
            }
        }
    }

    public static void aoInserirValoresDeItmOrcChurras(Map<Id,ItemOrcamentoChurras__c> itnChurrasNewMap){
        //Busca nova Lista de Item Churras com Relações Produto__r.Valor__c e itemChurras.Produto__r.RecordTypeId
        List<ItemOrcamentoChurras__c> itnChurrasComRlc = ItemOrcamentoChurrasDAO.buscarItmOrcRelacionamentos(itnChurrasNewMap.keySet());

        if(!itnChurrasComRlc.isEmpty()){
            //Busca Metadados Tabela Preço Serviços
            List<TabelaPrecoServicos__mdt> servicosMtd = [SELECT id, Tipo__c, ValorHoraServico__c FROM TabelaPrecoServicos__mdt];
            //RecordTypes de Produtos   
            Id prodId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Produto').getRecordTypeId();
            Id ServId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Serviço').getRecordTypeId();

            for (ItemOrcamentoChurras__c ItmChurras : itnChurrasComRlc){
                System.debug(ItmChurras.Produto__r.RecordTypeId);
                System.debug(ItmChurras.Produto__r.Servico__c);
                //Verifica Qual é o RecordType 
                if(ItmChurras.Produto__c != null){
                    if(ItmChurras.Produto__r.RecordTypeId == prodId){ //Se for do tipo Produto
                        Integer valorTemporario = (integer)itmChurras.Produto__r.Valor__c;
                        itmChurras.Valor__c = (integer)itmChurras.Quantidade__c*valorTemporario; //Atribui Valor ao Item Crs
                    }else if(ItmChurras.Produto__r.RecordTypeId == ServId ){//Se for do tipo Serviço
                        for (TabelaPrecoServicos__mdt itemMtd : servicosMtd) {
                            //E Se o Valor PickList de Serviço for o mesmo do tipo do metadado faz atribuição de Valor em ItmChurras
                            if(ItmChurras.Produto__r.Servico__c == itemMtd.Tipo__c){
                                //Considreando Regra de Validação, 
                                Integer horasDeServico =(Integer)(ItmChurras.OrcamentoChurras__r.Fim__c.hour() - ItmChurras.OrcamentoChurras__r.Inicio__c.hour());
                                if(itemMtd.Tipo__c == 'Churrasqueiro'){ 
                                    ItmChurras.Valor__c    = (Integer)ItmChurras.Quantidade__c * itemMtd.ValorHoraServico__c * horasDeServico;
                                }else if(itemMtd.Tipo__c == 'Limpeza'){
                                    ItmChurras.Valor__c    = (Integer)ItmChurras.Quantidade__c * itemMtd.ValorHoraServico__c * horasDeServico;
                                }else if(itemMtd.Tipo__c == 'Garçom'){
                                    ItmChurras.Valor__c    = (Integer)ItmChurras.Quantidade__c * itemMtd.ValorHoraServico__c * horasDeServico;
                                }
                            }
                        }
                    }
                }
            }
            update itnChurrasComRlc;
        }
    }
    //After Update
    public static void aoAtualizarValoresDeItmOrcChurras(Map<Id,ItemOrcamentoChurras__c> itnChurrasNewMap, Map<Id,ItemOrcamentoChurras__c> itnChurrasOldMap){
        //Verifica Se Ro Registro Foi Modificado
        if(itnChurrasNewMap != itnChurrasOldMap){
            //Busca nova Lista de Item Churras com Relações Produto__r.Valor__c e itemChurras.Produto__r.RecordTypeId
            List<ItemOrcamentoChurras__c> itnChurrasComRlc = ItemOrcamentoChurrasDAO.buscarItmOrcRelacionamentos(itnChurrasNewMap.keySet());

            if(!itnChurrasComRlc.isEmpty()){
                //Busca Metadados Tabela Preço Serviços
                List<TabelaPrecoServicos__mdt> servicosMtd = [SELECT id, Tipo__c, ValorHoraServico__c FROM TabelaPrecoServicos__mdt];
                //RecordTypes de Produtos   
                Id prodId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Produto').getRecordTypeId();
                Id ServId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Serviço').getRecordTypeId();
                
                for (ItemOrcamentoChurras__c itmChurras : itnChurrasComRlc){
                    //Verifica Qual é o RecordType 
                    if(itmChurras.Produto__r.RecordTypeId == prodId){ //Se for do tipo Produto
                        Integer valorTemporario = (integer)itmChurras.Produto__r.Valor__c;
                        itmChurras.Valor__c = (integer)itmChurras.Quantidade__c*valorTemporario; //Atribui Valor ao Item Crs
                    }else if(itmChurras.Produto__r.RecordTypeId == ServId ){//Se for do tipo Serviço
                        for (TabelaPrecoServicos__mdt itemMtd : servicosMtd) {
                            //E Se o Valor PickList de Serviço for o mesmo do tipo do metadado faz atribuição de Valor em itmChurras
                            if(itmChurras.Produto__r.Servico__c == itemMtd.Tipo__c){

                                //Considreando Regra de Validação de Horario e mesmo Dia
                                Integer horasDeServico =(Integer)itmChurras.OrcamentoChurras__r.Fim__c.hour() - itmChurras.OrcamentoChurras__r.Inicio__c.hour();
                                
                                if(itemMtd.Tipo__c == 'Churrasqueiro'){
                                    itmChurras.Valor__c    = (Integer)itmChurras.Quantidade__c * itemMtd.ValorHoraServico__c * horasDeServico;
                                }else if(itemMtd.Tipo__c == 'Limpeza'){
                                    itmChurras.Valor__c    = (Integer)itmChurras.Quantidade__c * itemMtd.ValorHoraServico__c * horasDeServico;
                                }else if(itemMtd.Tipo__c == 'Garçom'){
                                    itmChurras.Valor__c    = (Integer)itmChurras.Quantidade__c * itemMtd.ValorHoraServico__c * horasDeServico;
                                }
                            }
                        }
                    }
                }
                update itnChurrasComRlc;
            }
        }
    }

    //////Flow
    //Anotação Usada para metodo ser reconhecido no Flow
    @InvocableMethod (label='Busca ItmOrcProd que Possui Serviços' 
    description='Retorna ItemOrçamentoChurras com Serviços utilizando Id de OrçamentoChurras' category='ItemOrcamentoChurras__c')
    public static List<ItemOrcamentoChurras__c> verificaSeItemOrcProdpossuiServ(List<Id> orcChurrasdId){//Parametro Id de ItemOrcamentoChurras__c
        //Busca Id do RecordType Serviço
        Id prodServRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Serviço').getRecordTypeId();
        //Chama a Busca de Item Orçamento Churras que possuem produtos de serviço via SOQL
        List<ItemOrcamentoChurras__c> itmOrcProdList = ItemOrcamentoChurrasDAO.buscarItmOrcProdComServicos(orcChurrasdId, prodServRecordTypeId);
        
        //Se Orçamento Possuir Serviços retorna Lista Senão retorna Null
        if(!itmOrcProdList.isEmpty()){
            return itmOrcProdList;
        }else {
            return null;
        }
    }


}
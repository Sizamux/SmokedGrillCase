@isTest 
private class OrcamentoChyrrasBoTest {
    @TestSetup
    static void getData(){	//Base de dados para Teste
        //PegaRecordTypes
        Id prodId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Produto').getRecordTypeId();
        Id servId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Serviço').getRecordTypeId();
        Id clienteId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Cliente').getRecordTypeId();
        //addContato
	 	Contact contact = new Contact(LastName = 'Joao', Email = 'a@a.com', CPF__c = 'Teste123', RecordTypeId = clienteId);
        //addProdutos
        Product2 servico1 = new Product2 (Name='Churrasqueiro Bom', Servico__c='Churrasqueiro', IsActive = true, RecordTypeId = servId);
        Product2 servico2 = new Product2 (Name='Limpeza Rapida', Servico__c='Limpeza', IsActive = true, RecordTypeId = servId);
        Product2 servico3 = new Product2 (Name='Garçom Legal', Servico__c='Garçom', IsActive = true, RecordTypeId = servId);
        Product2 produto1 = new Product2 (Name='Picanha', Valor__c=50, IsActive = true, RecordTypeId = prodId);
       	//Insert Base - Contato E Produtos
        insert contact;
        insert servico1;
        insert servico3;
        insert servico2;
        insert produto1;
        //Criando Base de dados Orcamento e ItensOrcamento
        List<OrcamentoChurras__c> orcsList = new List<OrcamentoChurras__c>();
        List<ItemOrcamentoChurras__c> iTmorcsList = new List<ItemOrcamentoChurras__c>();
        
        OrcamentoChurras__c orc1 = new OrcamentoChurras__c(Inicio__c = Datetime.now().addHours(+3) ,Fim__c = Datetime.now().addHours(+4),
                                                             Status__c = 'Novo',Cliente__c = contact.Id); 
        OrcamentoChurras__c orc2 = new OrcamentoChurras__c(Inicio__c = Datetime.now().addHours(+3) ,Fim__c = Datetime.now().addHours(+4),
                                                             Status__c = 'Novo',Cliente__c = contact.Id);  
        orcsList.add(orc1);
        orcsList.add(orc2);
		//Insere Orcamentos para gerar Id
        insert orcsList;
        
        ItemOrcamentoChurras__c itmOrc1Prod1 = new ItemOrcamentoChurras__c(OrcamentoChurras__c = orc1.Id, Quantidade__c = 2,
                                                                          			Produto__c = produto1.id);
        ItemOrcamentoChurras__c itmOrc1Serv1 = new ItemOrcamentoChurras__c(OrcamentoChurras__c = orc1.Id, Quantidade__c = 2,
                                                                          			Produto__c = servico1.id);
        ItemOrcamentoChurras__c itmOrc1Serv2 = new ItemOrcamentoChurras__c(OrcamentoChurras__c = orc1.Id, Quantidade__c = 2,
                                                                          			Produto__c = servico2.id);
        ItemOrcamentoChurras__c itmOrc1Serv3 = new ItemOrcamentoChurras__c(OrcamentoChurras__c = orc1.Id, Quantidade__c = 2,
                                                                          			Produto__c = servico3.id);
        ItemOrcamentoChurras__c itmOrc2Prod1 = new ItemOrcamentoChurras__c(OrcamentoChurras__c = orc2.Id, Quantidade__c = 2,
                                                                          			Produto__c = produto1.id);
        ItemOrcamentoChurras__c itmOrc2Serv1 = new ItemOrcamentoChurras__c(OrcamentoChurras__c = orc2.Id, Quantidade__c = 2,
                                                                          			Produto__c = servico1.id);
        iTmorcsList.add(itmOrc1Prod1);
        iTmorcsList.add(itmOrc1Serv1);
        iTmorcsList.add(itmOrc1Serv2);
        iTmorcsList.add(itmOrc1Serv3);
        iTmorcsList.add(itmOrc2Prod1);
        iTmorcsList.add(itmOrc2Serv1);
        //Insere ItensOrce
        insert iTmorcsList;
    }
    
    @isTest
    static void testaInsert(){
        Contact  contact = [SELECT id from Contact LIMIT 1];
        OrcamentoChurras__c orc = new OrcamentoChurras__c(Inicio__c = Datetime.now().addHours(+2) ,Fim__c = Datetime.now().addHours(+3),
                                                             Status__c = 'Concluído',Cliente__c = contact.Id);
        insert orc;
        List<OrcamentoChurras__c> orcInserted = [SELECT id FROM OrcamentoChurras__c  WHERE id = :orc.Id];

    	system.assertEquals(false,orcInserted.isEmpty(), 'Nao Inseriu');
        //system.assertEquals(false,Contact == null, 'Nao pegou prod');
    }
    
    @isTest
    static void testaInserirItemRepitido(){
        ItemOrcamentoChurras__c itmRef = [SELECT id, Produto__c, OrcamentoChurras__c from ItemOrcamentoChurras__c LIMIT 1];
        ItemOrcamentoChurras__c itmOrcRepitido = new ItemOrcamentoChurras__c(OrcamentoChurras__c = itmRef.OrcamentoChurras__c, Quantidade__c = 2,
                                                                          			Produto__c = itmRef.Produto__c);
		Test.startTest();
        Database.insert(itmOrcRepitido,false);
        Test.stopTest();

        //system.assertEquals(false,Contact == null, 'Nao pegou prod');
    }
    
    @isTest
    static void testaSchedBatch(){
        Contact  contact = [SELECT id from Contact LIMIT 1];
        OrcamentoChurras__c orcDeletar = new OrcamentoChurras__c(Inicio__c = Datetime.now().addDays(-2).addHours(+2) ,Fim__c = Datetime.now().addDays(-2).addHours(+3),
                                                           Status__c = 'Novo',Cliente__c = contact.Id); 
        insert orcDeletar;
        Test.startTest();
        OrcamentoChurrasBo.chamaOrcVencidosSched();
        Test.stopTest();
    }
    @isTest
    static void testaFlowAction(){
        Id servId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Serviço').getRecordTypeId();
        List<ItemOrcamentoChurras__c> itensComServ = [SELECT id,Quantidade__c FROM ItemOrcamentoChurras__c WHERE Produto__r.RecordTypeId = :servId  LIMIT 1];
        List<ItemOrcamentoChurras__c> itensTemp = [SELECT id,Quantidade__c FROM ItemOrcamentoChurras__c WHERE Produto__r.RecordTypeId != :servId LIMIT 1];
        List<Id> comServIds = new List<Id>();
        comServIds.add(itensComServ.get(0).Id);
        List<Id> itensTemps = new List<Id>();
        itensTemps.add(itensTemp.get(0).Id);
        
        Test.startTest();
        List<ItemOrcamentoChurras__c> itemOrcamentoSe = ItemOrcamentoChurrasBO.verificaSeItemOrcProdpossuiServ(comServIds);
        List<ItemOrcamentoChurras__c> itemOrcamentoNo = ItemOrcamentoChurrasBO.verificaSeItemOrcProdpossuiServ(itensTemps);
        Test.stopTest();
        system.assertEquals(false,itemOrcamentoSe.isEmpty());
		//system.assertEquals(true,itemOrcamentoNo.isEmpty());
    }
    @isTest
    static void testaAvaliacaoController(){
        Contact  contact = [SELECT id from Contact LIMIT 1];
        OrcamentoChurras__c orcTemp = new OrcamentoChurras__c(Inicio__c = Datetime.now().addHours(+2) ,Fim__c = Datetime.now().addHours(+3),
                                                                 Status__c = 'Novo',Cliente__c = contact.Id); 
        insert orcTemp;
        AvaliacaoController.AvaliacaoTo avaTo = new AvaliacaoController.AvaliacaoTo();
        
        system.assertEquals(false,AvaliacaoController.buscaAvaliacoesRetornaBool(orcTemp.id));
        avaTo.nota = 3;
        avaTo.observacoes = 'Observaçao Teste';
        avaTo.orcamentoId = orcTemp.id;
        AvaliacaoController.enviarAvaliacao(avaTo);
        system.assertEquals(true,AvaliacaoController.buscaAvaliacoesRetornaBool(orcTemp.id));
            
    }
}
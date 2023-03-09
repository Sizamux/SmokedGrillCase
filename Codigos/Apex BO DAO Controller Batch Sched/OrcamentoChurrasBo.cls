public with sharing class OrcamentoChurrasBo {

    //CallBatch - Chama Batch
    public static void chamaOrcVencidosBatch(){
        OrcamentoChurrasBatch CtcsBatch = new OrcamentoChurrasBatch();
        Database.executeBatch(CtcsBatch);
    }
    //CallSched - Chama Sched
    public static void chamaOrcVencidosSched(){
        String CRON = '0 0 9 * * ?'; //9 da Manhan GMT
        System.schedule('Chama Batch diaramente para verificar Orçamentos Vencidos que não foram Concluidos', 
						CRON, new OrcamentoChurrasSched());
    }
}
public with sharing class OrcamentoChurrasSched implements Schedulable {
    public void execute(SchedulableContext ctx) {
        OrcamentoChurrasBo.chamaOrcVencidosBatch();
    }
}
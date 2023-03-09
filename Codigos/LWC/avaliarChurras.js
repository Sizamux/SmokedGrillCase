import { LightningElement, api, track, wire } from 'lwc';
import enviarAvaliacaoCls from '@salesforce/apex/AvaliacaoController.enviarAvaliacao';
import buscaAvaliacoesRetornaBoolCls from '@salesforce/apex/AvaliacaoController.buscaAvaliacoesRetornaBool';

export default class AvaliarChurras extends LightningElement {
    //Orçamento recordId
    @api recordId;


    //TO de Avaliação
    avaTo = {
        id: '',
        nota: 0,
        observacoes: '',
        orcamentoId: ''
    };
    //Opções
    get options() {
        return [
            { label: '1', value: '1' },
            { label: '2', value: '2' },
            { label: '3', value: '3' },
            { label: '4', value: '4' },
            { label: '5', value: '5' },
        ];
    }

    //Flags para habilitar elementos HTML
    @track boolPossuiAvaliacoes = false;
    //Handler
    onHandler(event){
        this.avaTo.orcamentoId = this.recordId      
        let idComponente = event.target.dataset.id;
        if (idComponente == 'nota') {
            this.avaTo.nota = event.target.value; 
        }else if (idComponente == 'observacoes') {
            this.avaTo.observacoes = event.target.value;
        }
   
    }

    //Envia TO para Controller
    enviaAvaliacao(){
        enviarAvaliacaoCls({ avaliacaoTo: this.avaTo })
        .then(result => {
            this.boolPossuiAvaliacoes = true;
        })
        .catch(error => {
            alert('Falhou: Escolha uma Nota');
        });
    }    

    connectedCallback(){
        buscaAvaliacoesRetornaBoolCls({ orcId: this.recordId })
        .then(result => {

            this.boolPossuiAvaliacoes = result;
        })
        .catch(error => {
            alert('Falhou o carregamento das variaveis :' + error);
        });
    }
}
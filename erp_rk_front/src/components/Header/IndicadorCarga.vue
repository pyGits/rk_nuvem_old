<template>
  <!-- O botao da carga ja existia no cabecalho como atalho para a tela; aqui
       ele ganha o estado da carga em andamento. Continua sendo link direto:
       virar menu tiraria o atalho de um clique que as pessoas ja usam. -->
  <v-tooltip bottom :disabled="!temCarga" content-class="tooltip-carga">
    <template v-slot:activator="{ on, attrs }">
      <v-btn
        icon
        to="/carga/loja"
        class="indicador-carga"
        :title="temCarga ? '' : 'Enviar carga para as lojas'"
        v-bind="attrs"
        v-on="on"
      >
        <v-badge
          :value="cargas.length > 1"
          :content="cargas.length"
          color="orange darken-2"
          bordered
          offset-x="10"
          offset-y="10"
        >
          <!-- Sem carga o botao fica exatamente como era antes. -->
          <v-icon v-if="!temCarga">mdi-cloud-upload-outline</v-icon>

          <!-- Com carga, o anel envolve o numero. O sync antigo nao reporta
               etapa e nao manda percentual: nesse caso nao ha numero para
               mostrar e o anel gira indeterminado, como a barra da tela de
               carga ja faz. -->
          <v-progress-circular
            v-else
            :value="percentual"
            :indeterminate="!temPercentual"
            :rotate="-90"
            :size="36"
            :width="3"
            color="white"
          >
            <!-- O percentual e o motivo deste indicador existir: fica no
                 centro do anel, nao escondido atras de um hover. -->
            <span v-if="temPercentual" class="percentual-carga pulsando">
              {{ percentual }}
            </span>
            <v-icon v-else x-small class="pulsando">
              {{ aguardandoSync ? "mdi-clock-outline" : "mdi-cloud-upload-outline" }}
            </v-icon>
          </v-progress-circular>
        </v-badge>
      </v-btn>
    </template>

    <!-- O anel mostra o andamento da loja mais atrasada; o detalhe por loja
         fica aqui, que e onde ele cabe. -->
    <div class="py-1">
      <div class="font-weight-medium mb-1">
        {{ cargas.length === 1 ? "Carga em andamento" : `${cargas.length} lojas recebendo carga` }}
      </div>
      <div v-for="carga in cargas" :key="carga.codigo" class="linha-tooltip">
        <span class="mr-2">{{ nomeDaLoja(carga.codigo) }}</span>
        <span class="text-caption">
          {{ estado(carga).texto }}
          <template v-if="estado(carga).mostraPercentual"> · {{ estado(carga).valor }}%</template>
        </span>
      </div>
    </div>
  </v-tooltip>
</template>

<script>
// Mesma leitura de estado da tela de carga e do painel administrativo: os
// textos das etapas ("Enviando produtos") precisam ser os mesmos aqui e la.
import { estadoDaCarga } from "@/utils/carga";

// A consulta so le a lista em memoria do backend, nao o banco. Ainda assim ela
// roda em TODA tela, o dia inteiro: sem carga nenhuma basta descobrir que uma
// comecou, e a cada 20s da conta. Com carga em andamento o anel precisa andar,
// e ai vale o intervalo curto.
const INTERVALO_PARADO_MS = 20000;
const INTERVALO_EM_CARGA_MS = 3000;
// Backend fora do ar nao pode virar uma requisicao a cada 3s vinda de cada aba
// aberta. O intervalo dobra a cada falha ate este teto e volta ao normal no
// primeiro acerto.
const INTERVALO_MAXIMO_ERRO_MS = 120000;

export default {
  data() {
    return {
      timer: null,
      encerrado: false,
      intervaloErro: 0,
      // Guardado para avisar quando a carga termina. So conta como "terminou"
      // o que esta tela viu comecar - depois de um F5 o contador zera e nenhum
      // aviso atrasado aparece.
      lojasEmCarga: [],
    };
  },
  mounted() {
    // Quem nao tem acesso a tela de carga tomaria 403 a cada tique: a rota
    // /carga/status e anotada com exigeAcesso("carga.loja").
    if (!this.$podeAcessar("carga.loja")) return;

    this.consulta();
  },
  beforeDestroy() {
    this.encerrado = true;
    clearTimeout(this.timer);
  },
  methods: {
    async consulta() {
      if (this.encerrado) return;

      try {
        // A tela de carga faz o proprio polling, de 2s, e alimenta o mesmo
        // estado. Consultar junto seria o dobro de requisicoes para o mesmo
        // dado — o ciclo continua girando, so nao pergunta de novo.
        if (this.$route.path !== "/carga/loja") {
          await this.$store.dispatch("verificaCargaStatus");
        }
        this.intervaloErro = 0;
      } catch (err) {
        this.intervaloErro = Math.min(
          INTERVALO_MAXIMO_ERRO_MS,
          (this.intervaloErro || INTERVALO_EM_CARGA_MS) * 2
        );
      }

      this.agenda();
    },
    agenda() {
      if (this.encerrado) return;

      const intervalo =
        this.intervaloErro ||
        (this.temCarga ? INTERVALO_EM_CARGA_MS : INTERVALO_PARADO_MS);

      this.timer = setTimeout(this.consulta, intervalo);
    },
    estado(carga) {
      return estadoDaCarga({
        cargaStatus: carga.status,
        cargaEtapa: carga.etapa,
        cargaIndice: carga.indice,
        cargaTotal: carga.total,
        cargaPercentual: carga.percentual,
      });
    },
    // O /carga/status devolve so o codigo da loja. O nome aparece quando a
    // lista de lojas ja foi carregada por alguma tela; senao, o codigo resolve.
    nomeDaLoja(codigo) {
      const loja = this.$store.state.loja.lojaList.find(
        (l) => String(l.codigo) === String(codigo)
      );
      return loja && loja.nome ? loja.nome : `Loja ${codigo}`;
    },
  },
  computed: {
    cargas() {
      return this.$store.state.loja.cargasEmAndamento;
    },
    temCarga() {
      return this.cargas.length > 0;
    },
    // Enquanto nenhum sync pegou a carga ainda, o que esta acontecendo e
    // espera, nao envio - e o icone diz isso.
    aguardandoSync() {
      return this.cargas.every((c) => c.status === "PENDENTE");
    },
    percentuais() {
      return this.cargas
        .map((c) => c.percentual)
        .filter((p) => typeof p === "number");
    },
    temPercentual() {
      // Uma loja sem percentual (sync antigo) no meio de outras que reportam
      // deixaria o anel mentindo por ela. So mostra numero quando TODAS
      // reportam; caso contrario, gira indeterminado.
      return this.percentuais.length > 0 && this.percentuais.length === this.cargas.length;
    },
    // A loja mais atrasada e a resposta honesta para "quanto falta": a carga
    // so acaba quando a ultima terminar.
    percentual() {
      if (!this.temPercentual) return 0;
      return Math.min(...this.percentuais);
    },
  },
  watch: {
    cargas(atual) {
      const codigosAgora = atual.map((c) => String(c.codigo));
      const terminaram = this.lojasEmCarga.filter((codigo) => !codigosAgora.includes(codigo));

      if (terminaram.length) {
        this.$store.dispatch(
          "showToastMessage",
          terminaram.length === 1
            ? `Carga concluída na ${this.nomeDaLoja(terminaram[0])}.`
            : `Carga concluída em ${terminaram.length} lojas.`
        );
      }

      this.lojasEmCarga = codigosAgora;
    },
  },
};
</script>

<style lang="scss" scoped>
// A carga demora minutos. Sem movimento nenhum, um anel parado em 40% e
// indistinguivel de uma tela travada.
@keyframes pulso-carga {
  0%,
  100% {
    opacity: 1;
  }
  50% {
    opacity: 0.45;
  }
}

.pulsando {
  color: white !important;
  animation: pulso-carga 1.6s ease-in-out infinite;
}

// O anel tem 36px: 2 digitos em 11px cabem com folga, 3 nao - por isso o
// percentual da fila nunca chega a 100 (ver percentualDaCarga no backend, que
// trava em 99 ate o sync avisar que terminou).
// Sem trilho o anel mostra so o arco preenchido, e "43% de quanto" fica por
// conta da imaginacao. O trilho fecha o circulo e da a referencia.
.indicador-carga ::v-deep .v-progress-circular__underlay {
  stroke: rgba(255, 255, 255, 0.3);
}

.percentual-carga {
  font-size: 11px;
  font-weight: 700;
  line-height: 1;
  letter-spacing: -0.3px;
}

// Respeita quem desligou animacoes no sistema operacional.
@media (prefers-reduced-motion: reduce) {
  .pulsando {
    animation: none;
  }
}

.indicador-carga {
  // O anel e maior que o icone sozinho; sem isto ele encosta no sininho.
  margin-right: 4px;
}

.linha-tooltip {
  display: flex;
  justify-content: space-between;
  align-items: baseline;
  gap: 12px;
}
</style>

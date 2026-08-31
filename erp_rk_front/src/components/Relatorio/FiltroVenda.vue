<template>
  <div class="mb-4">
    <v-btn color="primary" outlined @click="mostrar = !mostrar">
      <v-icon left>mdi-filter-variant</v-icon>
      {{ mostrar ? "Ocultar Filtros" : "Exibir Filtros" }}
      <v-chip v-if="qtdFiltrosAtivos" x-small color="primary" class="ml-2">{{ qtdFiltrosAtivos }}</v-chip>
    </v-btn>

    <v-sheet v-if="mostrar" class="pa-4 mt-3" elevation="1" rounded color="grey lighten-4">
      <v-row dense>
        <v-col cols="6" sm="2">
          <v-text-field v-model="rascunho.numero" label="Número" outlined dense clearable hide-details @keyup.enter="aplicar"></v-text-field>
        </v-col>
        <v-col cols="6" sm="2">
          <v-text-field v-model="rascunho.caixa" label="Caixa" outlined dense clearable hide-details @keyup.enter="aplicar"></v-text-field>
        </v-col>
        <v-col cols="6" sm="2">
          <v-text-field v-model="rascunho.cpfConsumidor" label="CPF Consumidor" outlined dense clearable hide-details @keyup.enter="aplicar"></v-text-field>
        </v-col>
        <v-col cols="6" sm="2">
          <v-text-field v-model="rascunho.vendedor" label="Vendedor" outlined dense clearable hide-details @keyup.enter="aplicar"></v-text-field>
        </v-col>
        <v-col cols="6" sm="2">
          <v-text-field v-model="rascunho.valorTotal" label="Valor da Venda" outlined dense clearable hide-details @keyup.enter="aplicar"></v-text-field>
        </v-col>
        <v-col cols="6" sm="2">
          <v-text-field v-model="rascunho.xmlVenda" label="Chave XML" outlined dense clearable hide-details @keyup.enter="aplicar"></v-text-field>
        </v-col>
      </v-row>

      <v-row dense class="mt-2">
        <v-col cols="12" md="6">
          <v-text-field
            :value="rascunho.clienteDescricao"
            label="Cliente"
            placeholder="Todos"
            prepend-inner-icon="mdi-account-outline"
            outlined
            dense
            readonly
            hide-details
            append-icon="mdi-magnify"
            :clearable="!!rascunho.cliente"
            @click:append="abrirBusca('cliente')"
            @click:clear="limparSelecao('cliente')"
          ></v-text-field>
        </v-col>
        <v-col cols="12" md="6">
          <v-text-field
            :value="rascunho.finalizadoraDescricao"
            label="Finalizadora"
            placeholder="Todas"
            prepend-inner-icon="mdi-credit-card-outline"
            outlined
            dense
            readonly
            hide-details
            append-icon="mdi-magnify"
            :clearable="!!rascunho.finalizadora"
            @click:append="abrirBusca('finalizadora')"
            @click:clear="limparSelecao('finalizadora')"
          ></v-text-field>
        </v-col>
      </v-row>

      <v-row dense align="center" class="mt-2">
        <v-col cols="12" sm="6">
          <v-subheader class="pl-0">Situação</v-subheader>
          <v-radio-group v-model="rascunho.cancelado" row dense hide-details class="mt-0">
            <v-radio label="Todos" value=""></v-radio>
            <v-radio label="Cancelados" value="1"></v-radio>
            <v-radio label="Normais" value="0"></v-radio>
          </v-radio-group>
        </v-col>
        <v-col cols="12" sm="6" class="d-flex justify-end align-center">
          <v-btn color="primary" @click="aplicar">
            <v-icon left>mdi-filter</v-icon>
            Aplicar Filtro
          </v-btn>
          <v-btn class="ml-2" outlined @click="limpar">
            <v-icon left>mdi-filter-remove</v-icon>
            Limpar Filtros
          </v-btn>
        </v-col>
      </v-row>
    </v-sheet>

    <!-- Um único diálogo serve para cliente e finalizadora: muda a lista, não a tela. -->
    <v-dialog v-model="dialogBusca" max-width="500">
      <v-card>
        <v-card-title>
          <span class="headline">{{ buscando === "cliente" ? "Localizar Cliente" : "Localizar Finalizadora" }}</span>
        </v-card-title>
        <v-card-text>
          <v-text-field v-model="termoBusca" label="Pesquisar" prepend-inner-icon="mdi-magnify" outlined dense clearable autofocus></v-text-field>
          <v-list dense class="lista-busca">
            <v-list-item v-for="opcao in opcoesBusca" :key="opcao.codigo" @click="selecionar(opcao)">
              <v-list-item-content>
                <v-list-item-title>{{ opcao.codigo }} - {{ opcao.nome }}</v-list-item-title>
                <v-list-item-subtitle v-if="opcao.cnpjcpf">{{ opcao.cnpjcpf }}</v-list-item-subtitle>
              </v-list-item-content>
            </v-list-item>
            <v-list-item v-if="!opcoesBusca.length">
              <v-list-item-content>
                <span class="grey--text">Nenhum registro encontrado</span>
              </v-list-item-content>
            </v-list-item>
          </v-list>
        </v-card-text>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
// Filtros de venda do painel: ficam acima das abas e valem para todas elas.
// Como as abas agregadas somam no banco, quem aplica o filtro é o backend —
// aqui os campos só são digitados e, no Aplicar, vão para o store, de onde as
// actions do painel os mandam como query params.
const FILTRO_VAZIO = {
  numero: "",
  caixa: "",
  cpfConsumidor: "",
  vendedor: "",
  valorTotal: "",
  xmlVenda: "",
  cliente: "",
  clienteDescricao: "",
  finalizadora: "",
  finalizadoraDescricao: "",
  cancelado: "0",
};

export default {
  name: "FiltroVenda",
  data() {
    return {
      mostrar: false,
      // Rascunho: digitar não dispara consulta, só o Aplicar.
      rascunho: { ...FILTRO_VAZIO },
      dialogBusca: false,
      buscando: "cliente",
      termoBusca: "",
    };
  },
  computed: {
    filtro() {
      return this.$store.state.relatorio.filtro;
    },
    clienteList() {
      return this.$store.state.cliente.clienteList || [];
    },
    finalizadoraList() {
      return this.$store.state.finalizadora.finalizadoraList || [];
    },
    opcoesBusca() {
      const lista = this.buscando === "cliente" ? this.clienteList : this.finalizadoraList;
      if (!this.termoBusca) return lista;
      const termo = this.termoBusca.toLowerCase();
      return lista.filter((opcao) =>
        [opcao.codigo, opcao.nome, opcao.cnpjcpf].some((campo) => String(campo || "").toLowerCase().includes(termo))
      );
    },
    // Conta o que está de fato restringindo a consulta, para o botão avisar que
    // há filtro ativo mesmo com o painel recolhido. A situação padrão (Normais)
    // não conta.
    qtdFiltrosAtivos() {
      return Object.keys(FILTRO_VAZIO)
        .filter((campo) => !campo.endsWith("Descricao"))
        .filter((campo) => String(this.filtro[campo] || "") !== FILTRO_VAZIO[campo]).length;
    },
    // Só os campos desta barra: mudar período ou loja não pode apagar o que o
    // usuário já digitou aqui e ainda não aplicou.
    assinaturaFiltro() {
      return JSON.stringify(Object.keys(FILTRO_VAZIO).map((campo) => this.filtro[campo]));
    },
  },
  watch: {
    // O Limpar do cabeçalho zera o filtro no store; o rascunho acompanha.
    assinaturaFiltro() {
      this.sincronizar();
    },
  },
  created() {
    this.sincronizar();
  },
  mounted() {
    if (!this.clienteList.length) this.$store.dispatch("getClientes");
    if (!this.finalizadoraList.length) this.$store.dispatch("getFinalizadoras");
  },
  methods: {
    sincronizar() {
      Object.keys(FILTRO_VAZIO).forEach((campo) => {
        this.rascunho[campo] = this.filtro[campo] !== undefined && this.filtro[campo] !== null ? this.filtro[campo] : FILTRO_VAZIO[campo];
      });
    },
    abrirBusca(tipo) {
      this.buscando = tipo;
      this.termoBusca = "";
      this.dialogBusca = true;
      if (tipo === "cliente" && !this.clienteList.length) this.$store.dispatch("getClientes");
      if (tipo === "finalizadora" && !this.finalizadoraList.length) this.$store.dispatch("getFinalizadoras");
    },
    selecionar(opcao) {
      this.rascunho[this.buscando] = opcao.codigo;
      this.rascunho[this.buscando + "Descricao"] = `${opcao.codigo} - ${opcao.nome || ""}`.trim();
      this.dialogBusca = false;
    },
    limparSelecao(tipo) {
      this.rascunho[tipo] = "";
      this.rascunho[tipo + "Descricao"] = "";
    },
    aplicar() {
      // clearable devolve null quando o usuário limpa o campo.
      const filtro = {};
      Object.keys(FILTRO_VAZIO).forEach((campo) => {
        filtro[campo] = this.rascunho[campo] === null || this.rascunho[campo] === undefined ? "" : this.rascunho[campo];
      });
      this.$store.commit("setRelatorioFiltroVenda", filtro);
      this.$emit("alterado");
    },
    limpar() {
      this.$store.commit("limparRelatorioFiltroVenda");
      this.sincronizar();
      this.$emit("alterado");
    },
  },
};
</script>

<style scoped>
.lista-busca {
  max-height: 300px;
  overflow-y: auto;
}
.lista-busca >>> .v-list-item {
  cursor: pointer;
}
</style>

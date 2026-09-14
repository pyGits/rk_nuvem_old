<template>
  <div class="pa-4">
    <v-alert v-if="acessoTotal" type="info" text dense class="mb-4">
      Este usuário está com <strong>acesso total</strong> — ele abre todas as telas, inclusive as que
      forem criadas daqui para frente. Desligue abaixo para escolher tela a tela.
    </v-alert>

    <v-switch v-model="acessoTotal" class="mt-0" hide-details label="Acesso total a todas as telas"></v-switch>

    <v-divider class="my-4"></v-divider>

    <div v-if="!catalogo.length" class="text-body-2 grey--text">Nenhuma tela disponível para liberar.</div>

    <div v-for="grupo in grupos" :key="grupo.nome" class="mb-6">
      <div class="d-flex align-center mb-1">
        <div class="text-subtitle-2 font-weight-bold">{{ grupo.nome }}</div>
        <v-spacer></v-spacer>
        <v-btn text x-small color="primary" :disabled="acessoTotal" @click="marcarGrupo(grupo, true)">
          Marcar tudo
        </v-btn>
        <v-btn text x-small :disabled="acessoTotal" @click="marcarGrupo(grupo, false)">Limpar</v-btn>
      </div>
      <v-divider class="mb-2"></v-divider>

      <v-row dense>
        <v-col v-for="tela in grupo.telas" :key="tela.id" cols="12" sm="6" md="4">
          <v-checkbox
            :input-value="estaLiberada(tela.id)"
            :label="tela.rotulo"
            :disabled="acessoTotal"
            hide-details
            dense
            class="mt-0"
            @change="alternar(tela.id, $event)"
          ></v-checkbox>
        </v-col>
      </v-row>
    </div>

    <v-alert v-if="!acessoTotal && telas.length === 0" type="warning" text dense class="mt-4">
      Sem nenhuma tela marcada, este usuário entra no sistema mas só enxerga a tela inicial e as
      configurações da própria conta.
    </v-alert>
  </div>
</template>

<script>
// Telas que este usuario web pode abrir. A lista vem do catalogo que o backend
// devolve no GET /me - nao existe copia aqui no front, senao a tela mostraria
// uma coisa e o backend liberaria outra.
export default {
  name: "AcessosTab",
  computed: {
    catalogo() {
      return this.$store.getters.catalogoTelas;
    },
    // O catalogo ja vem na ordem certa; aqui so quebra em grupos preservando
    // essa ordem, para a tela espelhar o menu lateral.
    grupos() {
      const porGrupo = [];

      this.catalogo.forEach((tela) => {
        let grupo = porGrupo.find((g) => g.nome === tela.grupo);
        if (!grupo) {
          grupo = { nome: tela.grupo, telas: [] };
          porGrupo.push(grupo);
        }
        grupo.telas.push(tela);
      });

      return porGrupo;
    },
    telas() {
      return this.$store.state.usuario.usuario.telas || [];
    },
    acessoTotal: {
      get() {
        return this.$store.state.usuario.usuario.acessoTotal;
      },
      set(valor) {
        this.$store.commit("setUsuarioAcessoTotal", valor);
      },
    },
  },
  methods: {
    estaLiberada(id) {
      return this.telas.indexOf(id) >= 0;
    },
    alternar(id, marcado) {
      const telas = this.telas.filter((tela) => tela !== id);
      if (marcado) telas.push(id);

      this.$store.commit("setUsuarioTelas", telas);
    },
    marcarGrupo(grupo, marcar) {
      const idsDoGrupo = grupo.telas.map((tela) => tela.id);
      const telas = this.telas.filter((tela) => idsDoGrupo.indexOf(tela) < 0);

      if (marcar) telas.push(...idsDoGrupo);

      this.$store.commit("setUsuarioTelas", telas);
    },
  },
};
</script>

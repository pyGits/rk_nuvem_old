<template>
  <v-container>
    <v-row class="align-items-end">
      <v-col cols="12" sm="4">
        <label class="form-label" for="codigo_auxiliar">Código de Barras (EAN):</label>
        <input
          id="codigo_auxiliar"
          ref="codigoAuxiliar"
          type="text"
          inputmode="numeric"
          maxlength="14"
          class="form-control"
          placeholder="Digite o código e tecle Enter"
          v-model="novoCodigo"
          @keyup.enter="adicionar"
        />
      </v-col>
      <v-col cols="12" sm="3" class="d-flex align-end">
        <v-btn color="primary" @click="adicionar">
          <v-icon left>mdi-plus</v-icon>
          Adicionar
        </v-btn>
      </v-col>
    </v-row>

    <v-row>
      <v-col cols="12" sm="7">
        <v-data-table
          :headers="headers"
          :items="items"
          :no-data-text="'Nenhum código auxiliar cadastrado'"
          :footer-props="{ 'items-per-page-text': 'Códigos por pág.' }"
          dense
        >
          <template v-slot:item.acao="{ item }">
            <v-btn icon color="red" @click="remover(item.codigo)">
              <v-icon>mdi-delete</v-icon>
            </v-btn>
          </template>
        </v-data-table>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
export default {
  data() {
    return {
      novoCodigo: "",
      headers: [
        { text: "Código de Barras (EAN)", value: "codigo" },
        { text: "", value: "acao", sortable: false, align: "end", width: "80px" },
      ],
    };
  },
  watch: {
    // Permite apenas números, no máximo 14 dígitos, já durante a digitação/colagem.
    novoCodigo(valor) {
      const limpo = String(valor || "")
        .replace(/[^0-9]/g, "")
        .substring(0, 14);
      if (limpo !== valor) {
        this.novoCodigo = limpo;
      }
    },
  },
  computed: {
    codigoBarrasPrincipal() {
      return this.$store.state.produto.produto.codigo_barras;
    },
    codigoProduto() {
      return this.$store.state.produto.produto.codigo;
    },
    auxiliares() {
      return this.$store.state.produto.produto.codigos_barras_auxiliares;
    },
    items() {
      return this.auxiliares.map((codigo) => ({ codigo }));
    },
  },
  methods: {
    // Normaliza como o backend faz ao salvar: apenas dígitos e sem zeros à
    // esquerda, para que "0789" e "789" sejam tratados como o mesmo código.
    normalizarCodigo(valor) {
      return String(valor || "")
        .replace(/[^0-9]/g, "")
        .replace(/^0+/, "");
    },
    async adicionar() {
      const codigo = String(this.novoCodigo || "")
        .replace(/[^0-9]/g, "")
        .substring(0, 14);

      if (codigo === "") {
        this.$store.dispatch("showToastMessage", "Informe um código de barras válido!");
        return;
      }

      const principalNormalizado = this.normalizarCodigo(this.codigoBarrasPrincipal);
      if (principalNormalizado !== "" && this.normalizarCodigo(codigo) === principalNormalizado) {
        this.$store.dispatch("showToastMessage", "O código auxiliar não pode ser igual ao código de barras principal do produto!");
        return;
      }
      if (this.auxiliares.includes(codigo)) {
        this.$store.dispatch("showToastMessage", "Esse código auxiliar já foi adicionado!");
        return;
      }

      // Não permite usar um código que já pertença a outro produto (principal ou auxiliar).
      const emUso = await this.$store.dispatch("verificarCodigoBarrasEmUso", {
        codigo,
        ignorarCodigoProduto: this.codigoProduto,
      });
      if (emUso) {
        this.$store.dispatch("showToastMessage", "Esse código de barras já está em uso por outro produto!");
        return;
      }

      this.$store.commit("addProdutoCodigoAuxiliar", codigo);
      this.novoCodigo = "";
      this.$nextTick(() => {
        if (this.$refs.codigoAuxiliar) this.$refs.codigoAuxiliar.focus();
      });
    },
    remover(codigo) {
      this.$store.commit("removeProdutoCodigoAuxiliar", codigo);
    },
  },
};
</script>

<style lang="scss" scoped></style>

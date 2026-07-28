<template>
  <v-dialog v-model="dialog">
    <v-card>
      <!-- Cabeçalho -->
      <v-card-title>
        Cadastrar Fornecedor
        <v-spacer></v-spacer>
        <v-btn icon @click="cancelar">
          <v-icon>mdi-close</v-icon>
        </v-btn>
      </v-card-title>

      <!-- Conteúdo -->
      <v-card-text class="pt-4">
        <slot name="content">
          <v-card>
            <v-tabs v-model="tabIndex">
              <v-tab :key="0">Geral</v-tab>
              <v-tab :key="1">Endereço</v-tab>

              <v-tab-item :key="0">
                <v-container>
                  <v-row>
                    <v-col cols="12" sm="1">
                      <label class="form-label" for="fornecedor.codigo">Código:</label>
                      <InputNumber :limit="6" v-model="fornecedor.codigo" field="fornecedor.codigo" :disabled="true"></InputNumber>
                    </v-col>
                    <v-col cols="12" sm="3">
                      <label class="form-label" for="fornecedor.cnpjcpf">CNPJ/CPF:</label>
                      <InputNumber :limit="14" v-model="fornecedor.cnpjcpf" field="fornecedor.cnpjcpf" :disabled="!insertMode"></InputNumber>
                    </v-col>
                    <v-col cols="12" sm="8">
                      <label class="form-label" for="fornecedor.nome">Nome do Fornecedor:</label>
                      <InputText v-model="fornecedor.nome" field="fornecedor.nome" :upper-case="true" :limit="80"></InputText>
                    </v-col>
                  </v-row>
                  <v-row>
                    <v-col cols="12" sm="6">
                      <label class="form-label" for="fornecedor.nome_fantasia">Nome Fantasia:</label>
                      <InputText v-model="fornecedor.nome_fantasia" field="fornecedor.nome_fantasia" :upper-case="true" :limit="80"></InputText>
                    </v-col>
                    <v-col cols="12" sm="2">
                      <label class="form-label" for="fornecedor.ierg">RG/IE:</label>
                      <InputNumber :limit="14" v-model="fornecedor.ierg" field="fornecedor.ierg" :disabled="false"></InputNumber>
                    </v-col>
                    <v-col cols="12" sm="2">
                      <label class="form-label" for="fornecedor.im">IM:</label>
                      <InputNumber :limit="14" v-model="fornecedor.im" field="fornecedor.im" :disabled="false"></InputNumber>
                    </v-col>
                  </v-row>
                  <v-row>
                    <v-col cols="12" sm="3">
                      <label class="form-label" for="fornecedor.telefone">Telefone:</label>
                      <InputNumber :limit="14" v-model="fornecedor.telefone" field="fornecedor.telefone" :disabled="false"></InputNumber>
                    </v-col>
                    <v-col cols="12" sm="3">
                      <label class="form-label" for="fornecedor.telefone2">Telefone 2:</label>
                      <InputNumber :limit="14" v-model="fornecedor.telefone2" field="fornecedor.telefone2" :disabled="false"></InputNumber>
                    </v-col>
                    <v-col cols="12" sm="3">
                      <label class="form-label" for="fornecedor.celular">Celular:</label>
                      <InputNumber :limit="14" v-model="fornecedor.celular" field="fornecedor.celular" :disabled="false"></InputNumber>
                    </v-col>
                  </v-row>
                  <v-row>
                    <v-col cols="12" sm="8">
                      <label class="form-label" for="fornecedor.email">E-mail:</label>
                      <InputText v-model="fornecedor.email" field="fornecedor.email" :limit="80"></InputText>
                    </v-col>
                  </v-row>
                  <v-row>
                    <v-col cols="12" sm="12">
                      <label class="form-label" for="fornecedor.observacao">Observacao</label>
                      <InputText v-model="fornecedor.observacao" field="fornecedor.observacao" :upper-case="true" :limit="80"></InputText>
                    </v-col>
                  </v-row>
                </v-container>
              </v-tab-item>
              <v-tab-item :key="1">
                <v-container>
                  <v-row>
                    <v-col cols="12" sm="2">
                      <label class="form-label" for="input-cep">CEP:</label>
                      <InputText type="text" placeholder="CEP" v-model="fornecedor.cep" field="fornecedor.cep" :limit="8" />
                    </v-col>
                    <v-col cols="12" sm="6">
                      <label class="form-label" for="input-logradouro">Logradouro:</label>
                      <InputText type="text" placeholder="Logradouro" v-model="fornecedor.logradouro" id="input-logradouro" />
                    </v-col>
                    <v-col cols="12" sm="1">
                      <label class="form-label" for="input-uf">UF:</label>
                      <v-autocomplete v-model="fornecedor.uf" :items="listaUF" @change="carregarCidades" density="compact"></v-autocomplete>
                    </v-col>
                    <v-col cols="12" sm="3" class="teste">
                      <label class="form-label" for="input-uf">Cidade:</label>
                      <v-autocomplete v-model="fornecedor.cidade" :items="listaCidade" density="compact"></v-autocomplete>
                    </v-col>
                  </v-row>
                  <v-row>
                    <v-col cols="12" sm="6">
                      <label class="form-label" for="input-bairro">Bairro:</label>
                      <InputText type="text" placeholder="Bairro" v-model="fornecedor.bairro" id="input-bairro" />
                    </v-col>
                    <v-col cols="12" sm="6">
                      <label class="form-label" for="input-complemento">Complemento:</label>
                      <InputText type="text" placeholder="Complemento" v-model="fornecedor.complemento" id="input-complemento" />
                    </v-col>
                  </v-row>
                </v-container>
              </v-tab-item>
            </v-tabs>
          </v-card>
        </slot>
      </v-card-text>

      <!-- Rodapé (Ações) -->
      <v-card-actions>
        <v-spacer></v-spacer>
        <v-btn color="primary" text @click="cancelar"> Cancelar </v-btn>
        <v-btn color="primary" @click="salvar"> Gravar </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
import Fornecedor from "@/infra/entity/Fornecedor";
import InputNumber from "@/components/Input/InputNumber.vue";
import InputText from "@/components/Input/InputText.vue";
import ToastService from "@/infra/service/ToastService";
import Cidade from "@/infra/entity/value_object/Cidade";

export default {
  inject: ["fornecedorController"],
  components: {
    InputNumber,
    InputText,
  },
  name: "FornecedorModal",

  data() {
    return {
      insertMode: false,
      fornecedor: new Fornecedor(),
      tabIndex: 0,
      listaUF: [],
      listaCidade: [],
      dialog: false,
      dialogResolver: null, // ✅ nome sem underline
    };
  },

  methods: {
    carregarUFs() {
      this.listaUF = Cidade.getUFS();
    },

    carregarCidades() {
      this.listaCidade = Cidade.getCidadesPorUF(this.fornecedor.uf);
    },

    // ✅ método abrir agora retorna uma Promise
    async abrir(fornecedor) {
      this.fornecedor = fornecedor;
      this.dialog = true;
      this.carregarUFs();
      this.carregarCidades();

      return new Promise((resolve) => {
        this.dialogResolver = resolve;
      });
    },

    isFornecedorExists() {
      return this.fornecedor.codigo !== "";
    },

    // ✅ resolve a Promise após salvar
    async salvar() {
      let res;
      if (this.isFornecedorExists()) {
        res = await this.fornecedorController.update({ fornecedor: this.fornecedor });
        ToastService.showSuccess(res.message);
      } else {
        res = await this.fornecedorController.insert({ fornecedor: this.fornecedor });
        this.fornecedor.codigo = res.data;
        ToastService.showSuccess(res.message);
      }

      this.dialog = false;

      if (this.dialogResolver) {
        this.dialogResolver(this.fornecedor);
        this.dialogResolver = null;
      }
    },

    // ✅ resolve null se o usuário cancelar
    cancelar() {
      this.dialog = false;

      if (this.dialogResolver) {
        this.dialogResolver(null); // ou false, dependendo da lógica
        this.dialogResolver = null;
      }
    },
  },
};
</script>

<style lang="scss" scoped>
.v-card__text {
  overflow-y: auto;
}
</style>

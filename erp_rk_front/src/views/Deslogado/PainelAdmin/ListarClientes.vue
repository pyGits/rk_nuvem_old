<template>
  <MenuAdmin>
    <v-card>
      <v-card-title>Listar Clientes</v-card-title>
      <v-card-text>
        <v-text-field
          v-model="search"
          label="Pesquisar"
          outlined
          dense
        ></v-text-field>
        <v-data-table
          id="tableTenants"
          :headers="headers"
          :items="filteredTenantList"
          @click:row="selecionarCliente"
        >
          <template v-slot:item="{ item }">
            <tr @click="selecionarCliente(item)">
              <td>{{ item.id }}</td>
              <td>{{ item.cnpjcpf }}</td>
              <td>{{ item.name }}</td>
              <td>{{ item.qtdLojas }}</td>
              <td>{{ item.qtdUsuarios }}</td>
              <td>{{ item.user }}</td>
              <td>{{ item.userAdmin }}</td>
              <td>
                <v-icon v-if="item.ativo === 'S'" color="green"
                  >mdi-check</v-icon
                >
                <v-icon v-else color="red">mdi-close</v-icon>
              </td>
            </tr>
          </template>
        </v-data-table>
      </v-card-text>
    </v-card>

    <v-dialog v-model="dialog" width="auto">
      <v-card>
        <v-card-title>
          <span class="headline">Editar Cliente</span>
        </v-card-title>

        <v-card-text>
          <v-row>
            <v-col cols="12" sm="2">
              <label class="form-label" for="input-example">Código:</label>
              <input
                disabled
                type="text"
                class="form-control"
                placeholder="Código"
                v-model="id"
              />
            </v-col>
          </v-row>
          <v-row>
            <v-col cols="12" sm="3">
              <label class="form-label" for="input-example">CNPJ/CPF:</label>
              <input
                disabled
                v-model="cnpjcpf"
                type="text"
                class="form-control"
                placeholder="CNPJ/CPF"
              />
            </v-col>

            <v-col cols="12" sm="3">
              <label class="form-label" for="input-example"
                >Nome da Loja:</label
              >
              <input
                v-model="name"
                type="text"
                class="form-control"
                placeholder="Nome da Loja"
              />
            </v-col>
            <v-col cols="12" sm="3">
              <label class="form-label" for="input-example"
                >Qtd Lojas Habilitadas:</label
              >
              <input
                v-model="qtdLojas"
                type="number"
                class="form-control"
                placeholder="Lojas"
              />
            </v-col>
            <v-col cols="12" sm="3">
              <label class="form-label" for="input-example"
                >Qtd Usuários Habilitados:</label
              >
              <input
                v-model="qtdUsuarios"
                type="number"
                class="form-control"
                placeholder="Qtd Usuários"
              />
            </v-col>
          </v-row>
          <v-row>
            <v-col cols="12" sm="3">
              <label class="form-label" for="input-example">Login:</label>
              <input
                v-model="user"
                type="text"
                class="form-control"
                placeholder="Login Do Cliente"
              />
            </v-col>
            <v-col cols="12" sm="3">
              <label class="form-label" for="input-example">Ativo:</label>
              <v-checkbox
                v-model="ativo"
                true-value="S"
                false-value="N"
                label="Ativo"
                class="mt-0"
              ></v-checkbox>
            </v-col>
          </v-row>
        </v-card-text>

        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="primary" @click="salvarTenant">Atualizar</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- Snackbar para exibir mensagens -->
    <v-snackbar
      v-model="showSnackbar"
      :color="snackbarColor"
      :timeout="snackbarTimeout"
    >
      {{ snackbarMessage }}
    </v-snackbar>
  </MenuAdmin>
</template>

<script>
import MenuAdmin from "@/components/Admin/Menu/MenuAdmin.vue";

export default {
  components: {
    MenuAdmin,
  },
  data() {
    return {
      dialog: false,
      headers: [
        { text: "Código", value: "id" },
        { text: "CNPJ/CPF", value: "cnpjcpf" },
        { text: "Nome", value: "name" },
        { text: "Qtd. Lojas", value: "qtdLojas" },
        { text: "Qtd. Usuários", value: "qtdUsuarios" },
        { text: "Login", value: "user" },
        { text: "Criado Por", value: "userAdmin" },
        { text: "Ativo", value: "ativo" },
      ],
      showSnackbar: false,
      snackbarMessage: "",
      snackbarColor: "",
      snackbarTimeout: 3000,
      search: "",
    };
  },
  computed: {
    tenantList() {
      return this.$store.state.admin.tenantList.tenantList;
    },
    filteredTenantList() {
      return this.tenantList.filter((tenant) => {
        const searchTerm = this.search.toLowerCase();
        return (
          tenant.cnpjcpf.toLowerCase().includes(searchTerm) ||
          tenant.name.toLowerCase().includes(searchTerm) ||
          tenant.user.toLowerCase().includes(searchTerm)
        );
      });
    },
    id() {
      return this.$store.state.admin.tenant.id;
    },
    cnpjcpf() {
      return this.$store.state.admin.tenant.cnpjcpf;
    },
    name: {
      get() {
        return this.$store.state.admin.tenant.name;
      },
      set(valor) {
        this.$store.commit("setAdminTenantName", valor);
      },
    },
    qtdLojas: {
      get() {
        return this.$store.state.admin.tenant.qtdLojas;
      },
      set(valor) {
        this.$store.commit("setAdminTenantQtdLojas", valor);
      },
    },
    qtdUsuarios: {
      get() {
        return this.$store.state.admin.tenant.qtdUsuarios;
      },
      set(valor) {
        this.$store.commit("setAdminTenantQtdUsuarios", valor);
      },
    },
    user: {
      get() {
        return this.$store.state.admin.tenant.user;
      },
      set(valor) {
        this.$store.commit("setAdminTenantUser", valor);
      },
    },
    ativo: {
      get() {
        return this.$store.state.admin.tenant.ativo;
      },
      set(valor) {
        this.$store.commit("setAdminTenantAtivo", valor);
      },
    },
  },
  methods: {
    selecionarCliente(cliente) {
      this.dialog = true;
      this.$store.commit("setAdminTenant", cliente);
    },
    async salvarTenant() {
      try {
        await this.$store.dispatch("updateTenant");
        this.dialog = false;
        this.showSnackbar = true;
        this.snackbarMessage = "Cliente atualizado com sucesso";
        this.snackbarColor = "success";
      } catch (error) {
        this.showSnackbar = true;
        this.snackbarMessage = error.response.data.message;
        this.snackbarColor = "error";
      } finally {
        await this.carregarClientes();
      }
    },
    async carregarClientes() {
      await this.$store.dispatch(
        "getAdminTenantList",
        this.$store.state.admin.admin.token
      );
    },
  },
  async mounted() {
    await this.carregarClientes();
  },
};
</script>

<style lang="scss" scoped>
#tableTenants {
  cursor: pointer;
}
</style>

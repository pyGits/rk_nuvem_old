import Vue from "vue";
interface Admin {
  user: string;
  password: string;
  token: string;
}

interface Tenant {
  id: number;
  cnpjcpf: string;
  name: string;
  qtdLojas: number;
  qtdUsuarios: number;
  user: string;
  ativo: string;
}

const initialAdmin: Admin = {
  user: "",
  password: "",
  token: localStorage.getItem("access_token_admin") || "",
};

const initialTenant: Tenant = {
  id: 0,
  cnpjcpf: "",
  name: "",
  qtdLojas: 0,
  qtdUsuarios: 0,
  user: "",
  ativo: "N",
};

const initialTenantList: any = {
  tenantList: [],
};

export default {
  state: (): { admin: Admin; tenantList: any; tenant: Tenant } => ({
    admin: { ...initialAdmin },
    tenantList: initialTenantList,
    tenant: initialTenant,
  }),

  mutations: {
    setAdminUser(state: any, payload: string) {
      state.admin.user = payload;
      state.admin.user = payload.toUpperCase();
      state.admin.user = state.admin.user.substring(0, 50);
    },
    setAdminPassword(state: any, payload: string) {
      state.admin.password = payload;
    },
    setAdminToken(state: any, payload: string) {
      state.admin.token = payload;
    },
    setAdminTenant(state: any, payload: any) {
      Object.assign(state.tenant, payload);
    },
    setTenantList(state: any, payload: any) {
      state.tenantList.tenantList = payload;
    },
    setAdminTenantName(state: any, payload: string) {
      state.tenant.name = payload;
    },
    setAdminTenantQtdLojas(state: any, payload: string) {
      state.tenant.qtdLojas = payload;
    },
    setAdminTenantQtdUsuarios(state: any, payload: string) {
      state.tenant.qtdUsuarios = payload;
    },
    setAdminTenantUser(state: any, payload: string) {
      state.tenant.user = payload;
    },
    setAdminTenantAtivo(state: any, payload: string) {
      state.tenant.ativo = payload;
    },
  },

  actions: {
    async loginAdmin({ state }: any) {
      return await Vue.prototype.$http.post("/loginAdmin", state.admin);
    },
    async updateTenant({ state }: any) {
      return await Vue.prototype.$http.put("/tenants", state.tenant);
    },
    async getAdminTenantList({ commit }: any) {
      await Vue.prototype.$http.get("/tenants").then((res: any) => {
        commit("setTenantList", res.data);
      });
    },
  },
};

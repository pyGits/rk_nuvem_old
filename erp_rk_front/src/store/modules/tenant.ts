import Vue from "vue";
interface Tenant {
  id: number;
  name: string;
  cnpjcpf: string;
  logo: string;
}

const initialTenant: Tenant = {
  id: 0,
  name: "",
  cnpjcpf: "",
  logo: "",
};

export default {
  state: (): { tenant: Tenant; tenantList: Tenant[] } => ({
    tenant: { ...initialTenant },
    tenantList: [],
  }),

  mutations: {
    setTenant(state: any, payload: any) {
      state.tenant.id = payload.id;
      state.tenant.name = payload.name;
      state.tenant.cnpjcpf = payload.cnpjcpf;
      state.tenant.logo = payload.logo;
    },
  },
  actions: {
    async getTenant({ commit }: any) {
      return await Vue.prototype.$http.get("/tenant");
    },
  },
};

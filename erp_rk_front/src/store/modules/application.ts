import Vue from "vue";
export enum TSaveMode {
  INSERT = "INSERT",
  UPDATE = "UPDATE",
  NONE = "NONE",
}

type ModalConfirmAction = () => void;

interface Application {
  msgComercial: string;
  logado: boolean;
  drawer: boolean;
  containerLoading: boolean;
  headerText: string;
  toast: {
    show: boolean;
    message: string;
  };
  mode: TSaveMode;
  dialogNCM: boolean;
  dialogCEST: boolean;
  dialogFederal: boolean;
  dialogTributacao: boolean;
  dialogFornecedor: boolean;
  dialogLoja: boolean;
  modalYesOrNo: {
    title: string;
    message: string;
    show: boolean;
    confirmAction?: ModalConfirmAction;
  };
}

export default {
  state: (): Application => ({
    msgComercial:
      "Entrar em contato através do número (11)96768-7583 (Comercial) || (11)2628-1356 (Suporte)",
    logado: false,
    headerText: "",
    drawer: true,
    containerLoading: false,
    dialogNCM: false,
    dialogCEST: false,
    dialogTributacao: false,
    dialogFederal: false,
    dialogFornecedor: false,
    dialogLoja: false,
    toast: {
      show: false,
      message: "",
    },
    mode: TSaveMode.NONE,
    modalYesOrNo: {
      show: false,
      title: "",
      message: "",
      confirmAction: undefined,
    },
  }),
  mutations: {
    setLogado(state: Application, payload: boolean) {
      state.logado = payload;
    },
    setDialogNCM(state: Application, payload: boolean) {
      state.dialogNCM = payload;
    },
    setDialogFederal(state: Application, payload: boolean) {
      state.dialogFederal = payload;
    },
    setDialogTributacao(state: Application, payload: boolean) {
      state.dialogTributacao = payload;
    },
    setDialogCEST(state: Application, payload: boolean) {
      state.dialogCEST = payload;
    },
    setDialogFornecedor(state: Application, payload: boolean) {
      state.dialogFornecedor = payload;
    },
    setDialogLoja(state: Application, payload: boolean) {
      state.dialogLoja = payload;
    },
    setDrawerApplication(state: Application, payload: boolean) {
      state.drawer = payload;
    },
    setContainerLoading(state: Application, payload: boolean) {
      state.containerLoading = payload;
    },
    setToastMessage(state: Application, payload: string) {
      state.toast.message = payload;
    },
    setToastShow(state: Application, payload: boolean) {
      state.toast.show = payload;
    },
    setHeaderText(state: Application, payload: string) {
      state.headerText = payload;
    },
    setModeEdit(state: Application) {
      state.mode = TSaveMode.UPDATE;
    },
    setModeInsert(state: Application) {
      state.mode = TSaveMode.INSERT;
    },
    setModeNone(state: Application) {
      state.mode = TSaveMode.NONE;
    },
    setDialogYesNoShow(state: Application, payload: boolean) {
      state.modalYesOrNo.show = payload;
    },
    setDialogYesNoMessage(state: Application, payload: string) {
      state.modalYesOrNo.message = payload;
    },
    setDialogYesNoTitle(state: Application, payload: string) {
      state.modalYesOrNo.title = payload;
    },
    setDialogYesNoConfirmAction(state: Application, payload: any) {
      state.modalYesOrNo.confirmAction = payload;
    },
  },
  actions: {
    async uploadClientLogo({ commit }: any, logo: any) {
      const response = await Vue.prototype.$http.post(
        "/tenants/uploadLogo",
        logo,
        {
          headers: { "Content-Type": "multipart/form-data" },
        }
      );
    },
    resetState({ commit, dispatch }: any) {
      commit("resetError");
      commit("setHeaderText", "");
      commit("setModeNone");

      commit("resetTributacao");

      commit("resetProduto");
      commit("setProdutoList", []);
      commit("resetLoja");
      commit("setLojas", []);
      commit("resetCliente");
      commit("setClientes", []);
      commit("resetUsuario");
      commit("setUsuarios", []);
      commit("resetSecao");
      commit("resetGrupo");
      commit("resetGrupoList");
      commit("resetImpFederal");
      commit("setImpFederalList", []);
      commit("resetRelatorio");
    },
    showToastMessage({ commit }: any, payload: string) {
      commit("setToastShow", true);
      commit("setToastMessage", payload);
    },
    showDialogYesOrNo({ commit }: any, message: any) {
      commit("setDialogYesNoMessage", message.message);
      commit("setDialogYesNoTitle", message.title);
      commit("setDialogYesNoShow", true);
    },
  },
};

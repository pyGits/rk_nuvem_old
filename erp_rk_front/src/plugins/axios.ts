import Vue from "vue";
import axios from "axios";
import router from "@/router";
import store from "@/store";
// Em produção o nginx serve o front e faz proxy de /api para o backend, então a
// chamada é na mesma origem. Em desenvolvimento o devServer do vue-cli faz o
// mesmo proxy para http://localhost:3000 (ver vue.config.js).
// Para apontar para outro host, defina VUE_APP_API_URL no build.
axios.defaults.baseURL = process.env.VUE_APP_API_URL || "/api";

// Manda para o login quando a sessao cai, sem repetir a navegacao se ja
// estamos la. Era esse o "Avoided redundant navigation to current location:
// /login" que aparecia no console: senha errada devolve 401, o interceptor
// empurrava para /login, e a tela de login ja e /login.
function irParaLogin(): void {
  if (router.currentRoute.path === "/login") return;

  // Dois 401 simultaneos ainda podem disputar a navegacao. E redundancia, nao
  // falha - nao deve virar unhandled rejection.
  router.push("/login").catch(() => undefined);
}

axios.interceptors.response.use(
  (response) => response,
  (error) => {
    // Sem `response` nao houve resposta do servidor (queda de rede, timeout,
    // backend fora). Ler `.status` direto lancava TypeError DENTRO do
    // interceptor e escondia o erro real de quem chamou.
    if (error?.response?.status === 401) {
      localStorage.removeItem("access_token");
      irParaLogin();
    }

    // Sem acesso a tela. NAO e sessao expirada: o token continua valido, entao
    // nao se apaga nada - apagar aqui jogaria o usuario para fora do sistema so
    // por ele ter clicado numa tela que nao e dele.
    //
    // Acontece de verdade quando o dono tira um acesso enquanto a pessoa esta
    // logada: o menu dela ainda mostra a tela antiga. Recarregar a sessao aqui
    // reajusta o menu na hora, sem esperar o proximo F5.
    if (error?.response?.status === 403 && error?.response?.data?.codigo === "SEM_PERMISSAO") {
      store.dispatch("carregarSessao").catch(() => undefined);
      store.dispatch("showToastMessage", "Você não tem acesso a esta tela.");

      const destino = store.getters.rotaInicial();
      if (router.currentRoute.path !== destino) router.push(destino).catch(() => undefined);
    }

    return Promise.reject(error);
  }
);

Vue.use({
  install(Vue) {
    Vue.prototype.$http = axios;
  },
});

import Vue from "vue";
import axios from "axios";
import router from "@/router";
// Em produção o nginx serve o front e faz proxy de /api para o backend, então a
// chamada é na mesma origem. Em desenvolvimento o devServer do vue-cli faz o
// mesmo proxy para http://localhost:3000 (ver vue.config.js).
// Para apontar para outro host, defina VUE_APP_API_URL no build.
axios.defaults.baseURL = process.env.VUE_APP_API_URL || "/api";

axios.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response.status === 401) {
      localStorage.removeItem("access_token");
      router.push("/login");
    }
    return Promise.reject(error);
  }
);

Vue.use({
  install(Vue) {
    Vue.prototype.$http = axios;
  },
});

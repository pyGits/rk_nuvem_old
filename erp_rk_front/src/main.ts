import Vue from "vue";
import App from "./App.vue";
import router from "./router";
import store from "./store";
import vuetify from "./plugins/vuetify";
import "./plugins/axios";
import Toast from "vue-toastification";
import "vue-toastification/dist/index.css";
import ToastService from "./infra/service/ToastService";
import ErrorService from "./infra/service/ErrorService";
import { maskMoney } from "./utils/masks";

Vue.config.productionTip = false;
Vue.config.devtools = true;

// Configuração do Toast
Vue.use(Toast, {
  position: "top-right",
  timeout: 3000,
  closeOnClick: true,
  pauseOnFocusLoss: true,
  pauseOnHover: true,
  draggable: true,
  draggablePercent: 0.6,
  showCloseButtonOnHover: false,
  hideProgressBar: false,
  closeButton: "button",
  icon: true,
  rtl: false,
  // Personalização para integrar com Vuetify
  toastClassName: "v-toast__item",
  bodyClassName: ["v-toast__body", "vuetify-font"],
});

Vue.filter("money", maskMoney);
Vue.config.errorHandler = function (err, vm, info) {
  ErrorService.showError(err);
  console.error("Erro capturado:", err);
  console.log("Componente:", vm);
  console.log("Info:", info);
};
window.addEventListener("unhandledrejection", function (event) {
  ErrorService.showError(event.reason);
});
router.beforeEach((to, from, next) => {
  store.dispatch("resetState");
  next();
});

new Vue({
  router,
  store,
  vuetify,
  render: (h) => h(App),
}).$mount("#app");

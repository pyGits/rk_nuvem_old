import Vue from "vue";
import store from "@/store";

// $podeAcessar("cadastro.produto") em qualquer componente, sem precisar puxar o
// getter do store em cada um. Serve para esconder atalho fixo que nao passa
// pelo menu (o botao de carga do Header, por exemplo).
//
// Isto e conveniencia de tela: quem recusa de verdade e o backend, com o
// middleware exigeAcesso. Esconder o botao evita que a pessoa clique em algo
// que vai levar um erro, mas nao e a barreira.
declare module "vue/types/vue" {
  interface Vue {
    $podeAcessar(tela: string): boolean;
  }
}

Vue.prototype.$podeAcessar = function (tela: string): boolean {
  return store.getters.podeAcessar(tela);
};

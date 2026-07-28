<template>
  <v-navigation-drawer app v-model="drawer">
    <v-toolbar flat>
      <v-img :src="require('@/assets/logo.png')" height="60" contain></v-img>
    </v-toolbar>
    <v-divider> </v-divider>
    <!-- <v-img :src="tenantLogo" height="60" :width="300" contain></v-img> -->
    <v-img height="60" contain :src="tenantLogo"></v-img>
    <v-divider class="my-1"></v-divider>
    <v-list nav dense>
      <v-list-item>
        <v-list-item-content>
          <v-list-item-title style="color: #5995ed" class="tenant-title">
            {{ tenantNome }}
          </v-list-item-title>

          <v-list-item-title style="color: #0d6efd" class="tenant-subtitle">{{ tenantCnpjCpf }}</v-list-item-title>
        </v-list-item-content>
      </v-list-item>
      <v-list>
        <!-- <v-list nav dense> -->
        <v-list-item to="/">
          <v-list-item-icon>
            <v-icon>mdi-home</v-icon>
          </v-list-item-icon>

          <v-list-item-title>Início</v-list-item-title>
        </v-list-item>
        <!--Main category list-->
        <v-list-group v-for="item in filterMenu" :key="item.text" :prepend-icon="item.icon" no-action>
          <template v-slot:activator>
            <v-list-item-title>{{ item.text }}</v-list-item-title>
          </template>
          <!--Sub category item-->
          <!--if 2nd lvl child available-->
          <v-list-group :key="subItems.name" v-if="subItems.subSubItems ? subItems.subSubItems.length > 0 : false" v-for="subItems in item.subItems" :value="true" sub-group>
            <template v-slot:activator>
              <v-list-item-content>
                <v-list-item-title>{{ subItems.name }}</v-list-item-title>
              </v-list-item-content>
            </template>
            <!--subsubitem category list-->
            <v-list-item v-for="subSubItem in subItems.subSubItems" :key="subSubItem.name" :to="subSubItem.to">
              <v-list-item-icon>
                <v-icon></v-icon>
              </v-list-item-icon>
              <v-list-item-title>
                {{ subSubItem.name }}
              </v-list-item-title>
            </v-list-item>
          </v-list-group>
          <!--if not 2nd lvl child available-->
          <v-list-item v-for="subItems in item.subItems" v-if="subItems.subSubItems ? subItems.subSubItems.length === 0 : true" :prepend-icon="'mdi-sync'" :to="subItems.to" :key="subItems.name">
            <v-list-item-title>{{ subItems.name }}</v-list-item-title>
          </v-list-item>
        </v-list-group>
      </v-list>
      <v-list-item to="/configuracoes">
        <v-list-item-icon>
          <v-icon>mdi-cog</v-icon>
        </v-list-item-icon>

        <v-list-item-title>Configurações</v-list-item-title>
      </v-list-item>
    </v-list>
  </v-navigation-drawer>
</template>

<script>
import Menu from "./Menu.json";
import Vue from "vue";

export default {
  computed: {
    drawer: {
      get() {
        return this.$store.state.Application.drawer;
      },
      set(value) {
        this.$store.commit("setDrawerApplication", value);
      },
    },
    tenantNome: {
      get() {
        return this.$store.state.tenant.tenant.name;
      },
    },
    tenantCnpjCpf: {
      get() {
        return this.$store.state.tenant.tenant.cnpjcpf;
      },
    },
    tenantLogo: {
      get() {
        return Vue.prototype.$http.defaults.baseURL + `/logo/${this.$store.state.tenant.tenant.id}/` + this.$store.state.tenant.tenant.logo;
      },
    },

    filterMenu() {
      return this.menuItems.filter((item) => {
        if (!item.rule) return true;
      });
    },
  },
  data() {
    return {
      menuItems: Menu,
    };
  },
};
</script>

<style lang="scss" scoped>
.tenant-title {
  font-size: 18px;

  color: #1a1a1a;
  text-transform: uppercase;
}

.tenant-subtitle {
  font-size: 16px;
  color: #666;
}
</style>

<template>
  <v-navigation-drawer app v-model="drawer">
    <div class="pa-4 text-center logo-area">
      <v-img :src="require('@/assets/logo.png')" height="46" contain></v-img>
    </div>
    <v-divider></v-divider>

    <div class="pa-4 d-flex align-center tenant-area">
      <v-avatar size="40" color="primary" class="mr-3">
        <v-img v-if="tenant.logo" :src="tenantLogo"></v-img>
        <span v-else class="white--text text-subtitle-1 font-weight-medium">{{ inicialTenant }}</span>
      </v-avatar>
      <div class="overflow-hidden">
        <div class="text-body-2 font-weight-medium text-truncate tenant-nome">{{ tenantNome || "Minha empresa" }}</div>
        <div class="text-caption grey--text text--darken-1 text-truncate">{{ tenantCnpjCpf }}</div>
      </div>
    </div>
    <v-divider></v-divider>

    <v-list nav dense color="primary" class="menu-lista">
      <v-list-item to="/" exact>
        <v-list-item-icon>
          <v-icon>mdi-home-outline</v-icon>
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
        <v-list-group
          v-for="subItems in item.subItems"
          v-if="subItems.subSubItems ? subItems.subSubItems.length > 0 : false"
          :key="subItems.name"
          :value="true"
          sub-group
        >
          <template v-slot:activator>
            <v-list-item-content>
              <v-list-item-title>{{ subItems.name }}</v-list-item-title>
            </v-list-item-content>
          </template>
          <!--subsubitem category list-->
          <v-list-item v-for="subSubItem in subItems.subSubItems" :key="subSubItem.name" :to="subSubItem.to">
            <v-list-item-title>
              {{ subSubItem.name }}
            </v-list-item-title>
          </v-list-item>
        </v-list-group>
        <!--if not 2nd lvl child available-->
        <v-list-item
          v-for="subItems in item.subItems"
          v-if="subItems.subSubItems ? subItems.subSubItems.length === 0 : true"
          :to="subItems.to"
          :key="subItems.name"
        >
          <v-list-item-title>{{ subItems.name }}</v-list-item-title>
        </v-list-item>
      </v-list-group>

      <v-divider class="my-2"></v-divider>

      <v-list-item to="/configuracoes">
        <v-list-item-icon>
          <v-icon>mdi-cog-outline</v-icon>
        </v-list-item-icon>
        <v-list-item-title>Configurações</v-list-item-title>
      </v-list-item>
    </v-list>

    <template v-slot:append>
      <v-divider></v-divider>
      <div class="pa-3 text-caption rodape-contato">
        <div class="font-weight-medium mb-1">CONTATO</div>
        <div class="d-flex align-start mb-1">
          <v-icon x-small class="mr-1 mt-1">mdi-map-marker-outline</v-icon>
          <span>Rua Doutor Olavo Egídio, 655</span>
        </div>
        <div class="d-flex align-start mb-1">
          <v-icon x-small class="mr-1 mt-1">mdi-phone-outline</v-icon>
          <span>(11) 2628-1356 ou (11) 2506-1348</span>
        </div>
        <div class="d-flex align-start">
          <v-icon x-small class="mr-1 mt-1">mdi-clock-outline</v-icon>
          <span>Seg - Sex: 9:00 - 18:00</span>
        </div>
      </div>
    </template>
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
    tenant() {
      return this.$store.state.tenant.tenant;
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
    inicialTenant() {
      return (this.tenantNome || "?").trim().charAt(0).toUpperCase();
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
.logo-area {
  background-color: #fff;
}

.tenant-area {
  background-color: #f5f8ff;
}

.tenant-nome {
  text-transform: uppercase;
}

.menu-lista ::v-deep .v-list-item--active {
  border-radius: 8px;
  font-weight: 500;
}

.rodape-contato {
  color: #666;
  line-height: 1.3;
}
</style>

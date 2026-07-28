<template>
  <v-container>    
      <v-card>
        <v-card-title>
          <span class="headline">Lista de CESTs</span>
        </v-card-title>
        <v-data-table
          id="tableCEST"
          :headers="header"
          :items="items"
          @click:row="selectCEST"
        ></v-data-table>
      </v-card>
  </v-container>
</template>

<script>
import CEST from '@/infra/entity/CEST'
export default {
  props:['ncm'],
  methods:{
    selectCEST(cest){           
      console.log('selecionar',cest)
      this.$emit('selecionar-cest', cest);
    },
    carregarPorNCM(ncm){
      this.items = CEST.filterByNCM(ncm)
    }
  },
  data() {
    return {
      items:[],
      header: [
        {
          text: "CEST",
          value: "CEST",
        },
        {
          text: "NCM",
          value: "NCM",
        },
        { text: "CEST", value: "DESCRICAO" },
      ],
    };
  },
 
};
</script>

<style lang="scss" scoped>
#tableCEST {
  cursor: pointer;
}
</style>

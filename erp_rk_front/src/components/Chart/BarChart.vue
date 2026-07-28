<template>
  <div>
    <canvas ref="barChart"></canvas>
  </div>
</template>

<script>
import { defineComponent } from "vue";
import {
  Chart,
  CategoryScale,
  LinearScale,
  BarController,
  BarElement,
  Title,
} from "chart.js";

Chart.register(CategoryScale, LinearScale, BarController, BarElement, Title);

export default defineComponent({
  name: "BarChart",
  props: {
    data: {
      type: Array,
      required: true,
    },
    labels: {
      type: Array,
      required: true,
    },
  },
  mounted() {
    this.renderChart();
  },
  methods: {
    renderChart() {
      const ctx = this.$refs.barChart.getContext("2d");
      new Chart(ctx, {
        type: "bar",
        data: {
          labels: this.labels,
          datasets: [
            {
              label: "Data",
              backgroundColor: "rgba(75, 192, 192, 0.6)",
              borderColor: "rgba(75, 192, 192, 1)",
              data: this.data,
            },
          ],
        },
        options: {
          responsive: true,
          scales: {
            y: {
              beginAtZero: true,
            },
          },
        },
      });
    },
  },
});
</script>

<style scoped>
canvas {
  max-width: 600px;
  margin: 0 auto;
}
</style>

const { defineConfig } = require("@vue/cli-service");
module.exports = defineConfig({
  transpileDependencies: ["vuetify"],
  devServer: {
    port: 8080,
    client: { overlay: false },
    // Espelha o proxy que o nginx faz em produção, para que baseURL "/api"
    // funcione igual nos dois ambientes.
    proxy: {
      "/api": {
        target: process.env.DEV_API_TARGET || "http://localhost:3000",
        changeOrigin: true,
        ws: true,
      },
    },
  },
});

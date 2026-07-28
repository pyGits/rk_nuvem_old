import { Client } from "pg"; // Importa o Client do pacote 'pg'

class NuvemConnection {
  private client: Client;

  constructor() {
    this.client = new Client({
      host: "vps47862.publiccloud.com.br", // Endereço do servidor PostgreSQL
      port: 5432, // Porta padrão do PostgreSQL
      user: "postgres", // Nome do usuário PostgreSQL
      password: "D%f<CAR0)yDF", // Senha do usuário PostgreSQL
      database: "erp", // Nome do banco de dados
    });
    this.connect();
  }

  // Método para conectar ao banco
  async connect() {
    try {
      await this.client.connect(); // Conecta ao banco de dados
      console.log("Conexão com o PostgreSQL estabelecida com sucesso.");
    } catch (err) {
      console.error("Erro ao conectar ao PostgreSQL", err);
    }
  }

  // Método para desconectar do banco
  async disconnect() {
    try {
      await this.client.end(); // Fecha a conexão com o banco de dados
      console.log("Conexão com o PostgreSQL fechada.");
    } catch (err) {
      console.error("Erro ao fechar a conexão com o PostgreSQL", err);
    }
  }

  // Método para executar uma consulta SQL
  async executeQuery(query: string, params?: any[]) {
    try {
      const res = await this.client.query(query, params);
      return res.rows; // Retorna as linhas de resultado da consulta
    } catch (err) {
      console.log("Erro ao executar a consulta SQL", err);
      throw err; // Lança erro para tratamento externo
    }
  }
}

export default new NuvemConnection();

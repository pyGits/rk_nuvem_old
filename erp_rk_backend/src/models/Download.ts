import db from "../database/config";
import { DataTypes } from "sequelize";

// Arquivos publicados pelo painel administrativo (instalador do sistema,
// integrador etc.). Nao tem tenant_id de proposito: a lista e a mesma para
// todos os clientes.
const Download = db.define(
  "Download",
  {
    id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
    titulo: { type: DataTypes.STRING(100), allowNull: false },
    descricao: { type: DataTypes.STRING(255), defaultValue: "" },
    versao: { type: DataTypes.STRING(30), defaultValue: "" },
    arquivo: { type: DataTypes.STRING(255), allowNull: false },
    arquivo_original: { type: DataTypes.STRING(255), allowNull: false },
    tamanho: { type: DataTypes.BIGINT, defaultValue: 0 },
    ativo: { type: DataTypes.BOOLEAN, defaultValue: true },
  },
  {
    // Nomeia os atributos igual as colunas: assim "updated_at" funciona tanto
    // no attributes da consulta quanto no JSON que o front recebe.
    createdAt: "created_at",
    updatedAt: "updated_at",
  }
);

export default Download;

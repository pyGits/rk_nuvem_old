import db from "../database/config";
import { DataTypes } from "sequelize";

// Cache das respostas da IA, com a descricao do produto como chave: a mesma
// pergunta em clientes diferentes reaproveita a resposta.
const IbptSugestaoIa = db.define(
  "IbptSugestaoIa",
  {
    id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
    descricao: { type: DataTypes.TEXT, allowNull: false },
    // null = a IA olhou e nao soube dizer. Guardado para nao perguntar de novo.
    ncm: { type: DataTypes.STRING(8) },
    ncm_descricao: { type: DataTypes.TEXT },
    modelo: { type: DataTypes.STRING(60), defaultValue: "" },
  },
  {
    tableName: "ibpt_sugestao_ia",
    createdAt: "created_at",
    updatedAt: "updated_at",
  }
);

export default IbptSugestaoIa;

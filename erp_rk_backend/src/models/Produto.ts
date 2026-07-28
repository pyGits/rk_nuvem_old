import db from "../database/config";
import { DataTypes } from "sequelize";
const Produto = db.define(
  "Produto",
  {
    id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
    codigo: { type: DataTypes.STRING(6), primaryKey: true },
    codigo_barras: { type: DataTypes.STRING(14), primaryKey: true },
    descricao: {
      type: DataTypes.STRING(80),
      validate: {
        descricaoVazia(descricao: string) {
          if (descricao.trim() === "") {
            throw new Error("A descrição não pode ser vazia");
          }
        },
      },
    },
    secao: { type: DataTypes.STRING(3) },
    fornecedor: { type: DataTypes.STRING(3) },
    grupo: { type: DataTypes.STRING(3) },
    formaVenda: { type: DataTypes.STRING(2) },
    unidade: { type: DataTypes.STRING(3) },
    tributacao: { type: DataTypes.STRING(3) },
    impfederal: { type: DataTypes.STRING(3) },
    ncm: { type: DataTypes.STRING(8) },
    cest: { type: DataTypes.STRING(7) },
    balanca: { type: DataTypes.STRING(1) },
    balanca_validade: { type: DataTypes.INTEGER },
    diversos: { type: DataTypes.STRING(1) },
    ativo: { type: DataTypes.STRING(1) },
    carga_pendente: { type: DataTypes.BOOLEAN },
    tenant_id: { type: DataTypes.INTEGER, primaryKey: true },
  },
  {
    defaultScope: {
      attributes: {
        exclude: ["tenant_id"],
      },
    },
    indexes: [
      {
        unique: true,
        fields: ["tenant_id", "codigo"],
      },
      {
        unique: true,
        fields: ["tenant_id", "codigo_barras"],
      },
    ],
  }
);

export default Produto;

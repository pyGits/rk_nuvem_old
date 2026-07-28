import db from "../database/config";
import { DataTypes } from "sequelize";

const Grupo = db.define(
  "Grupo",
  {
    id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
    codigo: { type: DataTypes.STRING(3), unique: "codigo_secao_unique" },
    margem: { type: DataTypes.FLOAT(15, 2), defaultValue: 0 },
    codigo_secao: {
      type: DataTypes.STRING(3),
      unique: "codigo_secao_unique",
      validate: {
        notZero: function (codigo_secao: any) {
          if (codigo_secao === "0") {
            throw new Error("Selecione uma seção");
          }
        },
      },
    },
    nome: {
      type: DataTypes.STRING(50),
      validate: {
        notEmpty: {
          msg: "O nome não pode ser em branco",
        },
      },
    },
    tenant_id: { type: DataTypes.INTEGER },
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
        fields: ["codigo", "codigo_secao", "tenant_id"],
      },
    ],
  }
);

export default Grupo;

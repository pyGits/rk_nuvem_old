import db from "../database/config";
import { DataTypes } from "sequelize";

const Secao = db.define(
  "Secao",
  {
    id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
    codigo: {
      type: DataTypes.STRING(3),
      primaryKey: true,
      validate: {
        notZero: function (codigo: any) {
          if (codigo === "0") {
            throw new Error("O código não pode ser 0");
          }
        },
        length: function (codigo: any) {
          if (codigo && codigo.length > 3) {
            throw new Error("O código não pode ter mais de 3 caracteres");
          }
        },
      },
    },
    margem: { type: DataTypes.FLOAT(15, 2), defaultValue: 0 },
    nome: {
      type: DataTypes.STRING(50),
      validate: {
        notEmpty: {
          msg: "O nome não pode ser em branco",
        },
      },
    },
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
    ],
  }
);

export default Secao;

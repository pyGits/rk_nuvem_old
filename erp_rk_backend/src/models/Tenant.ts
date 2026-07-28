import db from "../database/config";
import { DataTypes } from "sequelize";
const Tenant = db.define(
  "Tenant",
  {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      unique: true,
      autoIncrement: true,
    },
    email: { type: DataTypes.STRING(100), unique: true },
    user: { type: DataTypes.STRING(50), unique: true },
    cnpjcpf: { type: DataTypes.STRING(14), unique: true },
    password: { type: DataTypes.STRING },
    name: { type: DataTypes.STRING(50) },
    qtdUsuarios: { type: DataTypes.INTEGER },
    qtdLojas: { type: DataTypes.INTEGER },
    ativo: { type: DataTypes.STRING(1) },
    userAdmin: { type: DataTypes.STRING(20) },
    logo: { type: DataTypes.STRING },
  },
  {
    defaultScope: {
      // attributes: {
      // exclude: ["password"],
      // },
    },
  }
);
export default Tenant;

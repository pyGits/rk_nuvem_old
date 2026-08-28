import db from "../database/config";
import { DataTypes } from "sequelize";

// Certificado proprio do painel para as consultas de GTIN na SEFAZ. Uma linha
// so: subir um novo substitui o anterior.
const SefazCertificado = db.define(
  "SefazCertificado",
  {
    id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
    certificado: { type: DataTypes.TEXT, allowNull: false },
    senha: { type: DataTypes.STRING(255), allowNull: false },
    titular: { type: DataTypes.STRING(255) },
    documento: { type: DataTypes.STRING(20) },
    validade: { type: DataTypes.DATE },
  },
  {
    tableName: "sefaz_certificado",
    createdAt: "created_at",
    updatedAt: "updated_at",
  }
);

export default SefazCertificado;

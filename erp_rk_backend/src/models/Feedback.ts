import db from "../database/config";
import { DataTypes } from "sequelize";

// Feedback livre que o cliente deixa pelo sistema (o que melhorar, elogio,
// problema). Lido pelo painel administrativo, não pelo próprio tenant.
const Feedback = db.define(
  "Feedback",
  {
    id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
    tenant_id: { type: DataTypes.INTEGER, allowNull: false },
    mensagem: { type: DataTypes.TEXT, allowNull: false },
    nota: { type: DataTypes.INTEGER, allowNull: true },
    lido: { type: DataTypes.BOOLEAN, defaultValue: false },
  },
  {
    createdAt: "created_at",
    updatedAt: "updated_at",
  }
);

export default Feedback;

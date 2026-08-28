import db from "../database/config";
import { DataTypes } from "sequelize";

// Cada upload substitui a tabela ibpt inteira; esta guarda o que foi carregado
// para o painel mostrar versao e vigencia sem varrer as 12 mil linhas.
const IbptCarga = db.define(
  "IbptCarga",
  {
    id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
    arquivo_original: { type: DataTypes.STRING(255), allowNull: false },
    versao: { type: DataTypes.STRING(20), defaultValue: "" },
    vigencia_inicio: { type: DataTypes.DATEONLY },
    vigencia_fim: { type: DataTypes.DATEONLY },
    registros: { type: DataTypes.INTEGER, defaultValue: 0 },
  },
  {
    tableName: "ibpt_carga",
    createdAt: "created_at",
    updatedAt: "updated_at",
  }
);

export default IbptCarga;

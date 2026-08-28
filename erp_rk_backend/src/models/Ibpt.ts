import db from "../database/config";
import { DataTypes } from "sequelize";

// Catalogo de NCM com as aliquotas aproximadas da Lei da Transparencia,
// carregado do arquivo do IBPT pelo painel administrativo.
//
// Nao tem tenant_id de proposito, como downloads: o NCM e tabela publica, a
// mesma para todos os clientes.
const Ibpt = db.define(
  "Ibpt",
  {
    id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
    // 10, e nao 8: o arquivo tras NCM (8), NBS (9, servicos) e LC116 (4).
    codigo: { type: DataTypes.STRING(8), allowNull: false },
    // Excecao da TIPI: o mesmo NCM pode ter aliquota diferente por EX.
    ex: { type: DataTypes.STRING(3), defaultValue: "" },
    // 0 = NCM (produto), 1 = NBS, 2 = LC116 (os dois ultimos sao servicos).
    tipo: { type: DataTypes.INTEGER, defaultValue: 0 },
    descricao: { type: DataTypes.TEXT, defaultValue: "" },
    nacional_federal: { type: DataTypes.DECIMAL(5, 2), defaultValue: 0 },
    importado_federal: { type: DataTypes.DECIMAL(5, 2), defaultValue: 0 },
    estadual: { type: DataTypes.DECIMAL(5, 2), defaultValue: 0 },
    municipal: { type: DataTypes.DECIMAL(5, 2), defaultValue: 0 },
    vigencia_inicio: { type: DataTypes.DATEONLY },
    vigencia_fim: { type: DataTypes.DATEONLY },
    chave: { type: DataTypes.STRING(10), defaultValue: "" },
    versao: { type: DataTypes.STRING(20), defaultValue: "" },
    fonte: { type: DataTypes.STRING(60), defaultValue: "" },
  },
  {
    tableName: "ibpt",
    createdAt: "created_at",
    updatedAt: "updated_at",
  }
);

export default Ibpt;

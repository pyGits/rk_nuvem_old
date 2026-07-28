import { DataTypes } from "sequelize";

// Definir a classe abstrata
const Pessoa = {
  nome: { type: DataTypes.STRING(80) },
  fantasia: { type: DataTypes.STRING(80) },
  cnpjcpf: { type: DataTypes.STRING(80), primaryKey: true },
  telefone: { type: DataTypes.STRING(30) },
  telefone2: { type: DataTypes.STRING(30) },
  tipo: { type: DataTypes.STRING(2) },
  celular: { type: DataTypes.STRING(30) },
  email: { type: DataTypes.STRING(80) },
  ierg: { type: DataTypes.STRING(20) },
};
export default Pessoa;

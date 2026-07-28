"use strict";
var __importDefault =
  (this && this.__importDefault) ||
  function (mod) {
    return mod && mod.__esModule ? mod : { default: mod };
  };
Object.defineProperty(exports, "__esModule", { value: true });
exports.seederAdmin = seederAdmin;
exports.default = seeder;
const Finalizadora_1 = __importDefault(require("../src/models/Finalizadora"));
const Loja_1 = __importDefault(require("../src/models/Loja"));
const Tributacao_1 = __importDefault(require("../src/models/Tributacao"));
const Secao_1 = __importDefault(require("../src/models/Secao"));
const ImpFederais_1 = __importDefault(require("../src/models/ImpFederais"));
const Admin_1 = __importDefault(require("../src/models/Admin"));
const utils_1 = require("../src/utils/utils");
const Funcionario_1 = __importDefault(require("../src/models/Funcionario"));
async function seederAdmin() {
  await Admin_1.default.bulkCreate([
    { user: "RODRIGO", password: (0, utils_1.md5WithSalt)("456123789RKS0L") },
    { user: "CHINA", password: (0, utils_1.md5WithSalt)("6425025Erik#s3") },
  ]);
}
async function seeder(tenant) {
  await ImpFederais_1.default.bulkCreate([
    {
      codigo: "1",
      nome: "ALIQUOTA ZERO",
      cstEntrada: "73",
      cstSaida: "49",
      pis: 0,
      cofins: 0,
      tenant_id: tenant.id,
    },
  ]);
  await Secao_1.default.bulkCreate([{ codigo: 1, nome: "GERAL", tenant_id: tenant.id }]);
  await Loja_1.default.bulkCreate([
    {
      codigo: 1,
      nome: tenant.dataValues.name,
      cnpjcpf: tenant.dataValues.cnpjcpf,
      email: tenant.dataValues.email,
      tenant_id: tenant.id,
    },
  ]);
  await Finalizadora_1.default.bulkCreate([
    {
      codigo: "001",
      nome: "DINHEIRO",
      especie: "1",
      tipo: "N",
      utiliza99: "0",
      tenant_id: tenant.id,
    },
    {
      codigo: "002",
      nome: "DÉBITO",
      especie: "2",
      tipo: "N",
      utiliza99: "0",
      tenant_id: tenant.id,
    },
    {
      codigo: "003",
      nome: "CRÉDITO",
      especie: "3",
      tipo: "N",
      utiliza99: "0",
      tenant_id: tenant.id,
    },
    {
      codigo: "004",
      nome: "CONVÊNIO",
      especie: "5",
      tipo: "C",
      utiliza99: "0",
      tenant_id: tenant.id,
    },
    {
      codigo: "005",
      nome: "TICKET",
      especie: "10",
      tipo: "N",
      utiliza99: "0",
      tenant_id: tenant.id,
    },
  ]);
  await Funcionario_1.default.bulkCreate([
    {
      codigo: "15",
      nome: "RK",
      cnpjcpf: "08115094000156",
      password: "81eb4b2f2a50ba",
      cargo: "0",
      comissao: 0,
      tenant_id: tenant.id,
    },
  ]);
  await Tributacao_1.default.bulkCreate([
    {
      codigo: "1",
      nome: "FONTE",
      cfop: "5405",
      csosn: "500",
      cst: "060",
      icms: 0,
      tenant_id: tenant.id,
    },
    {
      codigo: "2",
      nome: "ISENTO",
      cfop: "5102",
      csosn: "300",
      cst: "00",
      icms: 0,
      tenant_id: tenant.id,
    },
    {
      codigo: "3",
      nome: "TRIBUTADO 18%",
      cfop: "5102",
      csosn: "102",
      cst: "00",
      icms: 18,
      tenant_id: tenant.id,
    },
    {
      codigo: "4",
      nome: "TRIBUTADO 12%",
      cfop: "5102",
      csosn: "102",
      cst: "00",
      icms: 12,
      tenant_id: tenant.id,
    },
    {
      codigo: "5",
      nome: "TRIBUTADO 7%",
      cfop: "5102",
      csosn: "102",
      cst: "00",
      icms: 7,
      tenant_id: tenant.id,
    },
  ]);
}

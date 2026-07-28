import Finalizadora from "../src/models/Finalizadora";
import Loja from "../src/models/Loja";
import Tributacao from "../src/models/Tributacao";
import Secao from "../src/models/Secao";
import ImpFederal from "../src/models/ImpFederais";
import Admin from "../src/models/Admin";
import { md5WithSalt } from "../src/utils/utils";
import Funcionario from "../src/models/Funcionario";

export async function seederAdmin() {
  await Admin.bulkCreate([
    { user: "RODRIGO", password: md5WithSalt("456123789RKS0L") },
    { user: "CHINA", password: md5WithSalt("6425025Erik#s3") },
  ]);
}

export default async function seeder(tenant: any) {
  await ImpFederal.bulkCreate([
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
  await Secao.bulkCreate([{ codigo: 1, nome: "GERAL", tenant_id: tenant.id }]);

  await Loja.bulkCreate([
    {
      codigo: 1,
      nome: tenant.dataValues.name,
      cnpjcpf: tenant.dataValues.cnpjcpf,
      email: tenant.dataValues.email,
      tenant_id: tenant.id,
    },
  ]);

  await Finalizadora.bulkCreate([
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
  await Funcionario.bulkCreate([
    {
      codigo: "15",
      nome: "RK",
      cnpjcpf: "08115094000156",
      password: "81eb4b2f2a50ba",
      tenant_id: tenant.id,
    },
  ]);

  await Tributacao.bulkCreate([
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

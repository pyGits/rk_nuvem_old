import { msgComercial } from "./messages";
import Loja from "../models/Loja";
import Tenant from "../models/Tenant";
import { getNextSequencial } from "./UtilsController";
import crypto from "crypto";

export default {
  async getLoja(req: any, res: any) {
    const { tenant_id } = req;
    const codigo = req.params.codigo;

    if (codigo === "novo") {
      const sequencial = await getNextSequencial("lojas", "codigo", tenant_id);
      return res.status(200).json({ codigo: sequencial });
    } else {
      const loja = await Loja.findOne({
        where: { codigo: codigo, tenant_id: tenant_id },
      });

      if (!loja) {
        return res.status(404).json({ message: "Loja não encontrada !" });
      } else {
        return res.status(200).json(loja);
      }
    }
  },
  async getLojas(req: any, res: any) {
    const { tenant_id } = req;
    const lojas = await Loja.findAll({ where: { tenant_id: tenant_id } });

    res.status(200).json(lojas);
  },
  async insertLoja(req: any, res: any) {
    const { tenant_id } = req;
    const { codigo } = req.body;
    const token = generateUniqueHash();

    const { celular, cnpjcpf, email, fantasia, ierg, nome } = req.body.pessoa;
    const { logradouro, cep, uf, cidade, bairro, complemento } =
      req.body.endereco;
    const endereco = { logradouro, cep, uf, cidade, bairro, complemento };
    const pessoa = { celular, cnpjcpf, email, fantasia, ierg, nome };

    const isTenantLojaQtd = await Tenant.findOne({ where: { id: tenant_id } });
    const qtdLojasRegistred = await Loja.findAndCountAll({
      where: { tenant_id },
    });

    if (qtdLojasRegistred.count >= isTenantLojaQtd?.dataValues.qtdUsuarios) {
      return res.status(400).json({
        message: "Quantidade máxima de Lojas registradas, " + msgComercial,
      });
    }

    try {
      await Loja.create({ codigo, ...endereco, ...pessoa, token, tenant_id });
      res.status(201).json({ message: "Loja inserida com sucesso !" });
    } catch (error) {
      res.status(400).json({ message: error });
    }
  },
  async updateLoja(req: any, res: any) {
    const { tenant_id } = req;
    const { codigo } = req.body;
    const { celular, email, fantasia, ierg, nome } = req.body.pessoa;
    const { logradouro, cep, uf, cidade, bairro, complemento } =
      req.body.endereco;
    const endereco = { logradouro, cep, uf, cidade, bairro, complemento };
    const pessoa = { celular, email, fantasia, ierg, nome };
    try {
      await Loja.update(
        { codigo, ...endereco, ...pessoa, tenant_id },
        {
          where: {
            codigo: codigo,
            tenant_id: tenant_id,
          },
        }
      );
      res.status(200).json({ message: "Loja atualizada com sucesso !" });
    } catch (error) {
      res.status(400).json({ message: error });
    }
  },
};

function generateUniqueHash() {
  const bytes = crypto.randomBytes(32);
  const hash = crypto.createHash("sha256").update(bytes).digest("hex");
  return hash;
}

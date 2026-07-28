import { getNextSequencial } from "./UtilsController";
import Tributacao from "../models/Tributacao";
export default {
  async getTributacao(req: any, res: any) {
    const { tenant_id } = req;
    const codigo = req.params.codigo;
    if (codigo === "novo") {
      const sequencial = await getNextSequencial("tributacaos", "codigo", tenant_id);
      return res.status(200).json({ codigo: sequencial });
    } else {
      const tributacao = await Tributacao.findOne({
        where: { codigo: codigo, tenant_id: tenant_id },
      });
      return res.status(200).json(tributacao);
    }
  },

  async insertTributacao(req: any, res: any) {
    const { tenant_id } = req;
    const { codigo, cst, cfop, csosn, icms, nome } = req.body;
    try {
      await Tributacao.create({
        codigo,
        nome,
        cst,
        cfop,
        csosn,
        icms,
        tenant_id,
        carga_pendente: true,
      });
      res.status(201).json({ message: "Tributação criada com sucesso !" });
    } catch (error: any) {
      res.status(400).json({
        message: "Erro ao criar tributação: " + error.message,
      });
    }
  },

  async updateTributacao(req: any, res: any) {
    const { tenant_id } = req;
    const { codigo, cst, cfop, csosn, icms, nome } = req.body;

    await Tributacao.update({ nome: nome, cst, cfop, csosn, icms, carga_pendente: true }, { where: { codigo: codigo, tenant_id: tenant_id } });

    res.status(200).json({ message: "Tributação atualizada com sucesso !" });
  },

  async getTributacoes(req: any, res: any) {
    const { tenant_id } = req;
    const { alterados } = req.query;
    const whereClause: any = { tenant_id };
    if (alterados) {
      whereClause.carga_pendente = true;
    }
    const orderClause: [string, "ASC" | "DESC"][] = [["codigo", "ASC"]];
    const tributacaoList = await Tributacao.findAll({
      where: whereClause,
      order: orderClause,
    });
    res.status(200).json(tributacaoList);
  },
};

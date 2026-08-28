import { Op } from "sequelize";
import { Request, Response } from "express";
import moment from "moment";
import ErroPdv from "../models/ErroPdv";
import Tenant from "../models/Tenant";

const LIMITE_LISTAGEM = 500;

// O agente Delphi manda data no formato dd/mm/yyyy, como nas demais rotas dele.
function dataDoSync(valor: any): string | null {
  if (!valor) return null;
  const convertida = moment(String(valor), "DD/MM/YYYY");
  return convertida.isValid() ? convertida.format("YYYY-MM-DD") : null;
}

export default {
  // Rota do Sync_NUVEM. A resposta precisa ser exatamente esta: o agente só
  // marca o erro como enviado quando recebe {"message":"SINCRONIZADO"}.
  async sincronizar(req: any, res: Response) {
    const { tenant_id } = req.params;
    const body = req.body || {};

    const chave = {
      tenant_id: Number(tenant_id),
      loja: Number(body.loja || 0),
      caixa: Number(body.caixa || 0),
      codigo: Number(body.codigo || 0),
    };

    const dados = {
      ...chave,
      operador: Number(body.operador || 0),
      data: dataDoSync(body.data),
      hora: String(body.hora || "").substring(0, 8),
      erro: String(body.erro || ""),
      origem: String(body.origem || "").substring(0, 60),
    };

    // Reenvio acontece quando o UPDATE de NUVEM = 1 falha no PDV depois de a
    // nuvem já ter recebido. Atualizar em vez de duplicar torna isso inofensivo.
    const existente: any = await ErroPdv.findOne({ where: chave });

    if (existente) {
      await existente.update(dados);
    } else {
      await ErroPdv.create(dados as any);
    }

    res.status(201).json({ message: "SINCRONIZADO" });
  },

  // Painel administrativo: erros de todos os clientes.
  async listar(req: Request, res: Response) {
    const where: any = {};

    if (req.query.tenant_id) where.tenant_id = Number(req.query.tenant_id);
    if (req.query.dataDe || req.query.dataAte) {
      where.data = {
        ...(req.query.dataDe ? { [Op.gte]: req.query.dataDe } : {}),
        ...(req.query.dataAte ? { [Op.lte]: req.query.dataAte } : {}),
      };
    }
    if (req.query.busca) {
      where.erro = { [Op.iLike]: `%${req.query.busca}%` };
    }

    const erros: any[] = await ErroPdv.findAll({
      where,
      order: [
        ["data", "DESC"],
        ["hora", "DESC"],
        ["id", "DESC"],
      ],
      limit: LIMITE_LISTAGEM,
    });

    // O nome do cliente não está na tabela: uma consulta para todos os tenants
    // da página, em vez de um join que traria o registro inteiro por linha.
    const tenants: any[] = await Tenant.findAll({ attributes: ["id", "name"] });
    const nomePorTenant = new Map<number, string>();
    tenants.forEach((tenant: any) => nomePorTenant.set(tenant.id, tenant.name));

    res.status(200).json(
      erros.map((erro: any) => ({
        id: erro.id,
        tenantId: erro.tenant_id,
        cliente: nomePorTenant.get(erro.tenant_id) || `Cliente ${erro.tenant_id}`,
        loja: erro.loja,
        caixa: erro.caixa,
        operador: erro.operador,
        data: erro.data,
        hora: erro.hora,
        erro: erro.erro,
        origem: erro.origem,
        recebidoEm: erro.created_at,
      }))
    );
  },
};

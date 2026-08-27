import moment from "moment";
import NaoFiscal from "../models/NaoFiscal"; // Importe o modelo adequado para a sua tabela de não fiscais
import Funcionario from "../models/Funcionario";
import Finalizadora from "../models/Finalizadora";
import Loja from "../models/Loja";
import { Op } from "sequelize";
import { sincronizarLote, validaCorpoLote } from "./sincronizarLote";
export default {
  async getSangrias(req: any, res: any) {
    const { tenant_id } = req;
    const dtInicio = req.query.dtInicio;
    const dtFim = req.query.dtFim;
    try {
      const reforcos = await NaoFiscal.findAll({
        include: [
          {
            model: Funcionario,
            where: {
              tenant_id,
            },
          },
          {
            model: Finalizadora,
            where: {
              tenant_id,
            },
          },
          {
            model: Loja,
            where: {
              tenant_id,
            },
          },
        ],
        where: {
          tenant_id,
          data: { [Op.gte]: dtInicio, [Op.lte]: dtFim },
          indice: "01",
        },
      });
      res.status(200).json(reforcos);
    } catch (error) {
      res.status(400).json({ message: "Erro ao gerar relatorio reforço" });
    }
  },
  async getReforcos(req: any, res: any) {
    const { tenant_id } = req;
    const dtInicio = req.query.dtInicio;
    const dtFim = req.query.dtFim;
    try {
      const reforcos = await NaoFiscal.findAll({
        include: [
          {
            model: Funcionario,
            where: {
              tenant_id,
            },
          },
          {
            model: Finalizadora,
            where: {
              tenant_id,
            },
          },
          {
            model: Loja,
            where: {
              tenant_id,
            },
          },
        ],
        where: {
          tenant_id,
          data: { [Op.gte]: dtInicio, [Op.lte]: dtFim },
          indice: "02",
        },
      });
      res.status(200).json(reforcos);
    } catch (error) {
      res.status(400).json({ message: "Erro ao gerar relatorio reforço" });
    }
  },
  async InserirNaoFiscal(req: any, res: any) {
    const { tenant_id } = req;
    const {
      codigo,
      data,
      indice,
      Descricao,
      Valor,
      Hora,
      Vendedor,
      fzcod,
      caixa,
      loja,
    } = req.body;

    try {
      // A busca tem que usar exatamente a chave primária
      // (tenant_id, loja, caixa, codigo). A versão anterior procurava por
      // (loja, codigo, data), o que dava errado de duas formas:
      //   - sem `tenant_id`, podia encontrar o documento de OUTRO tenant, cair no
      //     update (que filtra por tenant_id), não atualizar nada e ainda assim
      //     responder SINCRONIZADO — o agente marcava NUVEM=1 e o registro se
      //     perdia em silêncio;
      //   - com `data`, que não é parte da identidade do documento, não achava o
      //     registro já gravado e tentava inserir de novo, batendo na PK.
      const isNaoFiscalExists = await NaoFiscal.findOne({
        where: { tenant_id, loja, caixa, codigo },
      });

      if (!isNaoFiscalExists) {
        await NaoFiscal.create({
          codigo,
          data: moment(data, "DD/MM/YYYY").format("YYYY-MM-DD"),
          indice,
          Descricao,
          Valor,
          Hora,
          Vendedor,
          fzcod,
          caixa,
          loja,
          tenant_id,
        });
      } else {
        await NaoFiscal.update(
          {
            codigo,
            data: moment(data, "DD/MM/YYYY").format("YYYY-MM-DD"),
            indice,
            Descricao,
            Valor,
            Hora,
            Vendedor,
            fzcod,
            caixa,
            loja,
          },
          {
            where: { tenant_id, loja, caixa, codigo },
          }
        );
      }

      res.status(201).json({ message: "SINCRONIZADO" });
    } catch (error) {
      console.log(error);
      res.status(400).json({ error });
    }
  },

  // Versao em lote do InserirNaoFiscal. Mesma chave (tenant_id, loja, caixa,
  // codigo) e mesmos campos; o handler unitario acima segue intacto para os
  // agentes ainda nao atualizados.
  async InserirNaoFiscalLote(req: any, res: any) {
    const { tenant_id } = req;
    const registros = req.body;

    const invalido = validaCorpoLote(registros);
    if (invalido) return res.status(400).json({ error: invalido });

    try {
      const resultado = await sincronizarLote({
        model: NaoFiscal,
        tenant_id,
        registros,
        chave: (registro: any) => ({
          loja: registro.loja,
          caixa: registro.caixa,
          codigo: registro.codigo,
        }),
        mapear: (registro: any) => ({
          codigo: registro.codigo,
          data: moment(registro.data, "DD/MM/YYYY").format("YYYY-MM-DD"),
          indice: registro.indice,
          Descricao: registro.Descricao,
          Valor: registro.Valor,
          Hora: registro.Hora,
          Vendedor: registro.Vendedor,
          fzcod: registro.fzcod,
          caixa: registro.caixa,
          loja: registro.loja,
          tenant_id,
        }),
      });

      res.status(201).json(resultado);
    } catch (error) {
      console.log(error);
      res.status(400).json({ error });
    }
  },
};

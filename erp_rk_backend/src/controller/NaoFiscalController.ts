import moment from "moment";
import NaoFiscal from "../models/NaoFiscal"; // Importe o modelo adequado para a sua tabela de não fiscais
import Funcionario from "../models/Funcionario";
import Finalizadora from "../models/Finalizadora";
import Loja from "../models/Loja";
import { Op } from "sequelize";
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
      const isNaoFiscalExists = await NaoFiscal.findOne({
        where: {
          loja,
          codigo,
          data: moment(data, "DD/MM/YYYY").format("YYYY-MM-DD"),
        },
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
            where: {
              loja,
              codigo,
              data: moment(data, "DD/MM/YYYY").format("YYYY-MM-DD"),
              tenant_id,
            },
          }
        );
      }

      res.status(201).json({ message: "SINCRONIZADO" });
    } catch (error) {
      console.log(error);
      res.status(400).json({ error });
    }
  },
};

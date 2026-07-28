import moment from "moment";
import { Fechamento, FechamentoForma } from "../models/Fechamento";
import { Op } from "sequelize";
import sequelize from "../database/config";

export default {
  async getFechamentoFormas(req: any, res: any) {
    const { tenant_id } = req;
    const { codCaixa, codigo } = req.query;

    try {
      const fechamentoForma = await sequelize.query(`
      select * from fechamento_formas ff
      join finalizadoras f
      on ff.finalizadora = f.codigo
      where 
      ff.tenant_id = ${tenant_id}
      and
      f.tenant_id = ${tenant_id}
      and ff.id_fechamento = '${codigo}'
      and ff.cod_caixa = '${codCaixa}'
      
      `);

      res.status(200).json(fechamentoForma[0]);
    } catch (error) {
      console.log(error);
      res.status(400).json({ message: "Erro ao buscar fechamento" });
    }
  },
  async InserirFechamentoForma(req: any, res: any) {
    const { tenant_id } = req;
    const {
      id,
      Finalizadora,
      valorLiquido,
      valorEntrada,
      valorTroco,
      valorReforco,
      valorSangria,
      valorConferencia,
      valorTotal,
      codCaixa,
      loja,
    } = req.body;

    try {
      const isFechamentoExists = await FechamentoForma.findOne({
        where: {
          loja: loja,
          codCaixa: codCaixa,
          idFechamento: id,
          Finalizadora: Finalizadora,
          tenant_id,
        },
      });

      if (!isFechamentoExists) {
        await FechamentoForma.create({
          idFechamento: id,
          Finalizadora,
          valorLiquido,
          valorEntrada,
          valorTroco,
          valorReforco,
          valorSangria,
          valorConferencia,
          valorTotal,
          codCaixa,
          loja,
          tenant_id,
        });
      } else {
        await FechamentoForma.update(
          {
            idFechamento: id,
            Finalizadora,
            valorLiquido,
            valorEntrada,
            valorTroco,
            valorReforco,
            valorSangria,
            valorConferencia,
            valorTotal,
            codCaixa,
            loja,
            tenant_id,
          },
          {
            where: {
              loja: loja,
              codCaixa: codCaixa,
              Finalizadora: Finalizadora,
              idFechamento: id,
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
  async InserirFechamento(req: any, res: any) {
    const { tenant_id } = req;
    const {
      codigo,
      loja,
      dataAbertura,
      dataFechamento,
      horaAbertura,
      horaFechamento,
      operador,
      codOperador,
      codCaixa,
      vendaBruta,
      cancelamentoCupom,
      cancelamentoItem,
      descontoItem,
      descontoCupom,
      acrescimoCupom,
      vendaLiquida,
      fundoCaixa,
      sangria,
      totais,
    } = req.body;

    try {
      const isFechamentoExists = await Fechamento.findOne({
        where: {
          loja: loja,
          codCaixa: codCaixa,
          codigo: codigo,
          tenant_id,
        },
      });

      if (!isFechamentoExists) {
        await Fechamento.create({
          dataAbertura: moment(dataAbertura, "DD/MM/YYYY").format("YYYY-MM-DD"),
          dataFechamento: moment(dataFechamento, "DD/MM/YYYY").format(
            "YYYY-MM-DD"
          ),
          horaAbertura: moment(horaAbertura, "DD/MM/YYYY HH:mm:ss").format(
            "HH:mm:ss"
          ),
          horaFechamento: moment(horaFechamento, "DD/MM/YYYY HH:mm:ss").format(
            "HH:mm:ss"
          ),
          codOperador,
          vendaBruta,
          operador,
          cancelamentoCupom,
          cancelamentoItem,
          descontoItem,
          descontoCupom,
          acrescimoCupom,
          vendaLiquida,
          fundoCaixa,
          sangria,
          totais,
          tenant_id,
          loja,
          codCaixa,
          codigo,
        });
      } else {
        await Fechamento.update(
          {
            dataAbertura: moment(dataAbertura, "DD/MM/YYYY").format(
              "YYYY-MM-DD"
            ),
            dataFechamento: moment(dataFechamento, "DD/MM/YYYY").format(
              "YYYY-MM-DD"
            ),

            horaAbertura: moment(horaAbertura, "DD/MM/YYYY HH:mm:ss").format(
              "HH:mm:ss"
            ),
            horaFechamento: moment(
              horaFechamento,
              "DD/MM/YYYY HH:mm:ss"
            ).format("HH:mm:ss"),
            vendaBruta,
            operador,
            cancelamentoCupom,
            cancelamentoItem,
            descontoItem,
            descontoCupom,
            acrescimoCupom,
            vendaLiquida,
            fundoCaixa,
            sangria,
            totais,
            tenant_id,
            loja,
            codCaixa,
            codigo,
          },
          {
            where: {
              loja: loja,
              codCaixa: codCaixa,
              codigo: codigo,
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

  async getFechamentos(req: any, res: any) {
    const { tenant_id } = req;
    const dtInicio = req.query.dtInicio;
    const dtFim = req.query.dtFim;

    try {
      const fechamentos = await Fechamento.findAll({
        where: {
          tenant_id: tenant_id,
          dataFechamento: { [Op.gte]: dtInicio, [Op.lte]: dtFim },
        },
      });
      res.status(200).json(fechamentos);
    } catch (error) {
      console.log(error);
      res.status(400).json({ message: "Erro ao tentar gerar relatório" });
    }
  },
};

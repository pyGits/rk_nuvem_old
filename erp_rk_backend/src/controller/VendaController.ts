import moment from "moment";
import Venda from "../models/Venda";
import VendaForma from "../models/VendaForma";
import VendaItem from "../models/VendaItem";

export default {
  async InserirVendaForma(req: any, res: any) {
    const { tenant_id } = req;
    const { loja, codigo, data, caixa, codigo_cupom, prestacao, valor, finalizadora, tipo, valor_troco, cancelado } = req.body;
    try {
      const existingVendaForma = await VendaForma.findOne({
        where: {
          loja,
          codigo: codigo,
          codigo_cupom: codigo_cupom,
          prestacao: prestacao,
          data: moment(data, "DD/MM/YYYY").format("YYYY-MM-DD"),
          caixa: caixa,
          tenant_id: tenant_id,
        },
      });

      if (existingVendaForma) {
        await VendaForma.update(
          {
            loja,
            codigo,
            data: moment(data, "DD/MM/YYYY").format("YYYY-MM-DD"),
            caixa,
            codigo_cupom,
            prestacao,
            valor,
            finalizadora,
            tipo,
            valor_troco,
            cancelado,
            tenant_id,
          },
          {
            where: {
              loja,
              codigo: codigo,
              codigo_cupom: codigo_cupom,
              prestacao: prestacao,
              data: moment(data, "DD/MM/YYYY").format("YYYY-MM-DD"),
              caixa: caixa,
              tenant_id: tenant_id,
            },
          }
        );
      } else {
        await VendaForma.create({
          loja,
          codigo,
          data: moment(data, "DD/MM/YYYY").format("YYYY-MM-DD"),
          caixa,
          codigo_cupom,
          prestacao,
          valor,
          finalizadora,
          tipo,
          valor_troco,
          cancelado,
          tenant_id,
        });
      }
      res.status(201).json({ message: "SINCRONIZADO" });
    } catch (error) {
      console.log(error);
      res.status(400).json({ error });
    }
  },
  async InserirVenda(req: any, res: any) {
    const { tenant_id } = req;
    const { loja, codigo, numero, data, hora, caixa, qtde_item, valor_desconto, valor_acrescimo, valor_total, valor_custo, codigo_cliente, cancelado, cpf_consumidor, nome_consumidor, vendedor, xml_venda, xml_cancelamento } = req.body;
    try {
      const isVendaExists = await Venda.findOne({
        where: {
          loja,
          codigo: codigo,
          data: moment(data, "DD/MM/YYYY").format("YYYY-MM-DD"),
          numero: numero,
          caixa: caixa,
          tenant_id: tenant_id,
        },
      });

      if (!isVendaExists) {
        await Venda.create({
          loja,
          codigo,
          numero,
          data: moment(data, "DD/MM/YYYY").format("YYYY-MM-DD"),
          hora: moment(hora, "DD/MM/YYYY HH:mm:ss").format("HH:mm:ss"),
          caixa,
          qtde_item,
          valor_desconto,
          valor_custo,
          valor_acrescimo,
          valor_total,
          codigo_cliente,
          cancelado,
          cpf_consumidor,
          nome_consumidor,
          vendedor,
          xml_venda,
          xml_cancelamento,
          tenant_id,
        });
      } else {
        await Venda.update(
          {
            loja,
            codigo,
            numero,
            data: moment(data, "DD/MM/YYYY").format("YYYY-MM-DD"),
            hora: moment(hora, "DD/MM/YYYY HH:mm:ss").format("HH:mm:ss"),
            caixa,
            qtde_item,
            valor_desconto,
            valor_custo,
            valor_acrescimo,
            valor_total,
            codigo_cliente,
            cancelado,
            cpf_consumidor,
            nome_consumidor,
            vendedor,
            xml_venda,
            xml_cancelamento,
            tenant_id,
          },
          {
            where: {
              loja,
              codigo: codigo,
              numero: numero,
              caixa: caixa,
              tenant_id: tenant_id,
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
  async InserirVendaItem(req: any, res: any) {
    const { tenant_id } = req;
    const { loja, codigo, codigo_cupom, data, caixa, codigo_produto, item, unidade, qtde, valor_unitario, valor_desconto, valor_acrescimo, valor_total, cancelado, valor_custo, valor_custo_total } = req.body;
    try {
      const existingVendaItem = await VendaItem.findOne({
        where: {
          loja,
          codigo: codigo,
          caixa: caixa,
          tenant_id: tenant_id,
          data: moment(data, "DD/MM/YYYY").format("YYYY-MM-DD"),
        },
      });

      if (existingVendaItem) {
        await VendaItem.update(
          {
            loja,
            codigo,
            codigo_cupom,
            data: moment(data, "DD/MM/YYYY").format("YYYY-MM-DD"),
            caixa,
            codigo_produto,
            item,
            unidade,
            qtde,
            valor_unitario,
            valor_desconto,
            valor_acrescimo,
            valor_total,
            cancelado,
            valor_custo,
            valor_custo_total,
            tenant_id,
          },
          {
            where: {
              loja,
              data: moment(data, "DD/MM/YYYY").format("YYYY-MM-DD"),
              codigo: codigo,
              caixa: caixa,
              tenant_id: tenant_id,
            },
          }
        );
      } else {
        await VendaItem.create({
          loja,
          codigo,
          codigo_cupom,
          data: moment(data, "DD/MM/YYYY").format("YYYY-MM-DD"),
          caixa,
          codigo_produto,
          item,
          unidade,
          qtde,
          valor_unitario,
          valor_desconto,
          valor_acrescimo,
          valor_total,
          cancelado,
          valor_custo,
          valor_custo_total,
          tenant_id,
        });
      }

      res.status(201).json({ message: "SINCRONIZADO" });
    } catch (error) {
      res.status(400).json(error);
    }
  },
};

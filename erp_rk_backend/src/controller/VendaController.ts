import moment from "moment";
import { Op } from "sequelize";
import Venda from "../models/Venda";
import VendaForma from "../models/VendaForma";
import VendaItem from "../models/VendaItem";
import Preco from "../models/Preco";
import { sincronizarLote, validaCorpoLote } from "./sincronizarLote";

// O custo que sobe do sync e o que estava gravado no PDV no momento da venda,
// que chega zerado ou desatualizado. Por isso o custo do item passa a ser lido
// do cadastro de precos da propria loja. Se o produto nao tiver preco cadastrado
// ali, o valor enviado pelo sync ainda e usado como ultimo recurso.
//
// Le todos os produtos do lote de uma vez: a versao unitaria faz um SELECT por
// item, o que num cupom de 20 itens custa 20 idas ao banco.
async function custosPorProduto(tenant_id: number, loja: number, codigos: string[]) {
  const mapa = new Map<string, number>();

  const unicos = Array.from(new Set(codigos.filter((codigo) => !!codigo)));
  if (!unicos.length) return mapa;

  const precos: any[] = await Preco.findAll({
    where: { tenant_id, loja, codigo_produto: { [Op.in]: unicos } },
    attributes: ["codigo_produto", "custo"],
  });

  for (const preco of precos) {
    // mesma regra do PrecoRepository: custo invalido cai fora do mapa (vale
    // como produto sem preco, usando o custo do sync); negativo vale zero.
    const custo = Number(preco.getDataValue("custo"));
    if (!Number.isFinite(custo)) continue;

    mapa.set(String(preco.getDataValue("codigo_produto")), custo < 0 ? 0 : custo);
  }

  return mapa;
}

function custoDoItem(mapa: Map<string, number>, codigo_produto: string, custoInformado: any) {
  const custoSync = Number(custoInformado) || 0;

  if (!codigo_produto) return custoSync;

  const custo = mapa.get(String(codigo_produto));
  return custo === undefined ? custoSync : custo;
}

async function custoAtualDoProduto(tenant_id: number, loja: number, codigo_produto: string, custoInformado: any) {
  const custoSync = Number(custoInformado) || 0;

  if (!codigo_produto) return custoSync;

  const mapa = await custosPorProduto(tenant_id, loja, [codigo_produto]);
  return custoDoItem(mapa, codigo_produto, custoSync);
}

// Converte o payload do agente para as colunas do model. Sao os mesmos campos
// que os handlers unitarios ja gravam - a rota de lote nao muda regra nenhuma,
// so troca N requisicoes por uma.
function colunasDaVenda(registro: any, tenant_id: number) {
  return {
    loja: registro.loja,
    codigo: registro.codigo,
    numero: registro.numero,
    data: moment(registro.data, "DD/MM/YYYY").format("YYYY-MM-DD"),
    hora: moment(registro.hora, "DD/MM/YYYY HH:mm:ss").format("HH:mm:ss"),
    caixa: registro.caixa,
    qtde_item: registro.qtde_item,
    valor_desconto: registro.valor_desconto,
    valor_custo: registro.valor_custo,
    valor_acrescimo: registro.valor_acrescimo,
    valor_total: registro.valor_total,
    codigo_cliente: registro.codigo_cliente,
    cancelado: registro.cancelado,
    cpf_consumidor: registro.cpf_consumidor,
    nome_consumidor: registro.nome_consumidor,
    vendedor: registro.vendedor,
    xml_venda: registro.xml_venda,
    xml_cancelamento: registro.xml_cancelamento,
    tenant_id,
  };
}

function colunasDaVendaForma(registro: any, tenant_id: number) {
  return {
    loja: registro.loja,
    codigo: registro.codigo,
    data: moment(registro.data, "DD/MM/YYYY").format("YYYY-MM-DD"),
    caixa: registro.caixa,
    codigo_cupom: registro.codigo_cupom,
    prestacao: registro.prestacao,
    valor: registro.valor,
    finalizadora: registro.finalizadora,
    tipo: registro.tipo,
    valor_troco: registro.valor_troco,
    cancelado: registro.cancelado,
    tenant_id,
  };
}

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
    // valor_custo_total nao e mais lido do body: o custo do item vem do cadastro
    const { loja, codigo, codigo_cupom, data, caixa, codigo_produto, item, unidade, qtde, valor_unitario, valor_desconto, valor_acrescimo, valor_total, cancelado, valor_custo } = req.body;
    try {
      const custoUnitario = await custoAtualDoProduto(tenant_id, loja, codigo_produto, valor_custo);
      const custoTotal = Number((custoUnitario * (Number(qtde) || 0)).toFixed(2));

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
            valor_custo: custoUnitario,
            valor_custo_total: custoTotal,
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
          valor_custo: custoUnitario,
          valor_custo_total: custoTotal,
          tenant_id,
        });
      }

      res.status(201).json({ message: "SINCRONIZADO" });
    } catch (error) {
      res.status(400).json(error);
    }
  },

  // ---------------------------------------------------------------------
  // Rotas de lote. As unitarias acima continuam valendo para os agentes que
  // ainda nao foram atualizados em campo; estas so existem ao lado delas.
  // A resposta devolve os indices aceitos porque o agente marca NUVEM = 1
  // apenas do que a nuvem confirmou, registro a registro.
  // ---------------------------------------------------------------------

  async InserirVendaLote(req: any, res: any) {
    const { tenant_id } = req;
    const registros = req.body;

    const invalido = validaCorpoLote(registros);
    if (invalido) return res.status(400).json({ error: invalido });

    try {
      const resultado = await sincronizarLote({
        model: Venda,
        tenant_id,
        registros,
        chave: (registro: any) => ({
          loja: registro.loja,
          codigo: registro.codigo,
          numero: registro.numero,
          data: moment(registro.data, "DD/MM/YYYY").format("YYYY-MM-DD"),
          caixa: registro.caixa,
        }),
        mapear: (registro: any) => colunasDaVenda(registro, tenant_id),
      });

      res.status(201).json(resultado);
    } catch (error) {
      console.log(error);
      res.status(400).json({ error });
    }
  },

  async InserirVendaItemLote(req: any, res: any) {
    const { tenant_id } = req;
    const registros = req.body;

    const invalido = validaCorpoLote(registros);
    if (invalido) return res.status(400).json({ error: invalido });

    try {
      // um SELECT em precos para o lote inteiro, no lugar de um por item
      const loja = registros[0]?.loja;
      const custos = await custosPorProduto(
        tenant_id,
        loja,
        registros.map((registro: any) => registro.codigo_produto)
      );

      const resultado = await sincronizarLote({
        model: VendaItem,
        tenant_id,
        registros,
        chave: (registro: any) => ({
          loja: registro.loja,
          codigo: registro.codigo,
          caixa: registro.caixa,
          data: moment(registro.data, "DD/MM/YYYY").format("YYYY-MM-DD"),
        }),
        mapear: (registro: any) => {
          const custoUnitario = custoDoItem(custos, registro.codigo_produto, registro.valor_custo);
          const custoTotal = Number((custoUnitario * (Number(registro.qtde) || 0)).toFixed(2));

          return {
            loja: registro.loja,
            codigo: registro.codigo,
            codigo_cupom: registro.codigo_cupom,
            data: moment(registro.data, "DD/MM/YYYY").format("YYYY-MM-DD"),
            caixa: registro.caixa,
            codigo_produto: registro.codigo_produto,
            item: registro.item,
            unidade: registro.unidade,
            qtde: registro.qtde,
            valor_unitario: registro.valor_unitario,
            valor_desconto: registro.valor_desconto,
            valor_acrescimo: registro.valor_acrescimo,
            valor_total: registro.valor_total,
            cancelado: registro.cancelado,
            valor_custo: custoUnitario,
            valor_custo_total: custoTotal,
            tenant_id,
          };
        },
      });

      res.status(201).json(resultado);
    } catch (error) {
      console.log(error);
      res.status(400).json({ error });
    }
  },

  async InserirVendaFormaLote(req: any, res: any) {
    const { tenant_id } = req;
    const registros = req.body;

    const invalido = validaCorpoLote(registros);
    if (invalido) return res.status(400).json({ error: invalido });

    try {
      const resultado = await sincronizarLote({
        model: VendaForma,
        tenant_id,
        registros,
        chave: (registro: any) => ({
          loja: registro.loja,
          codigo: registro.codigo,
          codigo_cupom: registro.codigo_cupom,
          prestacao: registro.prestacao,
          data: moment(registro.data, "DD/MM/YYYY").format("YYYY-MM-DD"),
          caixa: registro.caixa,
        }),
        mapear: (registro: any) => colunasDaVendaForma(registro, tenant_id),
      });

      res.status(201).json(resultado);
    } catch (error) {
      console.log(error);
      res.status(400).json({ error });
    }
  },
};

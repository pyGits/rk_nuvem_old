import { QueryTypes } from "sequelize";
import sequelize from "../database/config";
import { podeAcessar } from "../permissao/PermissaoService";

// Alertas do próprio negócio do tenant, mostrados no sininho do front:
// contas a pagar vencendo/vencidas e produtos com estoque baixo/zerado.
// Não é uma tabela — cada request recalcula a partir dos dados atuais.
const DIAS_ANTECEDENCIA_VENCIMENTO = 7;
const LIMITE_POR_TIPO = 15;

// Cada consulta fica numa funcao propria para o filtro de acesso acima ficar
// legivel - e para as duas continuarem indo ao banco em paralelo.
function consultarContasAVencer(tenant_id: number) {
  return sequelize.query(
    `
    SELECT id, descricao_conta, numero_documento_conta, vencimento, valor, valor_pago
    FROM conta_pagar_titulo
    WHERE tenant_id = :tenant_id
      AND status = 'ABERTO'
      AND vencimento <= (CURRENT_DATE + make_interval(days => :dias))
    ORDER BY vencimento ASC
    LIMIT :limite
    `,
    {
      replacements: { tenant_id, dias: DIAS_ANTECEDENCIA_VENCIMENTO, limite: LIMITE_POR_TIPO },
      type: QueryTypes.SELECT,
    }
  );
}

function consultarEstoqueBaixo(tenant_id: number) {
  return sequelize.query(
    `
    SELECT p.codigo, p.descricao, e.loja, e.estoque, e.estoque_minimo
    FROM estoques e
    JOIN produtos p ON p.codigo = e.codigo_produto AND p.tenant_id = e.tenant_id
    WHERE e.tenant_id = :tenant_id
      AND (e.estoque <= 0 OR (e.estoque_minimo > 0 AND e.estoque < e.estoque_minimo))
    ORDER BY e.estoque ASC
    LIMIT :limite
    `,
    { replacements: { tenant_id, limite: LIMITE_POR_TIPO }, type: QueryTypes.SELECT }
  );
}

export default {
  async listar(req: any, res: any) {
    const { tenant_id } = req;

    try {
      // O alerta carrega o dado, nao so o aviso: o de conta a pagar mostra
      // descricao e valor em aberto, e o de estoque mostra o saldo por loja.
      // Quem nao tem acesso a tela nao pode ve-los pelo sininho.
      const [verContas, verEstoque] = await Promise.all([
        podeAcessar(req, "financeiro.contas_pagar"),
        podeAcessar(req, "relatorio.estoque.painel"),
      ]);

      const [contas, estoques] = await Promise.all([
        verContas ? consultarContasAVencer(tenant_id) : Promise.resolve([]),
        verEstoque ? consultarEstoqueBaixo(tenant_id) : Promise.resolve([]),
      ]);

      const hoje = new Date();
      hoje.setHours(0, 0, 0, 0);

      const notificacoesContas = (contas as any[]).map((conta) => {
        const vencimento = new Date(conta.vencimento);
        vencimento.setHours(0, 0, 0, 0);
        const diasParaVencer = Math.round((vencimento.getTime() - hoje.getTime()) / (1000 * 60 * 60 * 24));
        const restante = Number(conta.valor) - Number(conta.valor_pago || 0);
        const vencida = diasParaVencer < 0;

        return {
          id: `conta-${conta.id}`,
          tipo: vencida ? "CONTA_VENCIDA" : "CONTA_VENCENDO",
          severidade: vencida ? "error" : "warning",
          titulo: conta.descricao_conta || conta.numero_documento_conta || "Conta a pagar",
          mensagem: vencida
            ? `Venceu há ${Math.abs(diasParaVencer)} dia(s) · R$ ${restante.toFixed(2)}`
            : diasParaVencer === 0
            ? `Vence hoje · R$ ${restante.toFixed(2)}`
            : `Vence em ${diasParaVencer} dia(s) · R$ ${restante.toFixed(2)}`,
          data: conta.vencimento,
          link: "/financeiro/contas-a-pagar",
        };
      });

      const notificacoesEstoque = (estoques as any[]).map((item) => {
        const zerado = Number(item.estoque) <= 0;

        return {
          id: `estoque-${item.codigo}-${item.loja}`,
          tipo: zerado ? "ESTOQUE_ZERADO" : "ESTOQUE_BAIXO",
          severidade: zerado ? "error" : "warning",
          titulo: item.descricao || item.codigo,
          mensagem: zerado
            ? `Estoque zerado ou negativo na loja ${item.loja} (${item.estoque})`
            : `Estoque abaixo do mínimo na loja ${item.loja}: ${item.estoque} (mín. ${item.estoque_minimo})`,
          data: null,
          link: "/relatorio/estoque/painel",
        };
      });

      const notificacoes = [...notificacoesContas, ...notificacoesEstoque].sort((a, b) => {
        if (a.severidade === b.severidade) return 0;
        return a.severidade === "error" ? -1 : 1;
      });

      res.status(200).json(notificacoes);
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: "Erro ao buscar notificações" });
    }
  },
};

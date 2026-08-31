import { Router } from "express";
import { verifyJWT } from "./auth.middleware";
import RelatorioController from "../controller/RelatorioController";

const router = Router();

/**
 * Envolve o handler para que uma falha vire resposta de erro, e não queda.
 *
 * Estas rotas vão direto no Express, sem passar pelo httpServer que atende as
 * /v2 e /v3 — e lá o try/catch já existe. Aqui, um handler async que rejeita
 * (um erro de SQL, um timeout do banco) não era capturado por ninguém: virava
 * unhandledRejection e o Node encerrava o processo. Uma consulta de relatório
 * que falhasse tirava o sistema inteiro do ar, e todo mundo com a tela aberta
 * era jogado para o login.
 */
function rota(handler: (req: any, res: any) => any) {
  return (req: any, res: any) => {
    Promise.resolve(handler(req, res)).catch((error: any) => {
      console.error(`[relatorios] ${req.originalUrl}`, error?.stack || error);
      if (!res.headersSent) res.status(400).json({ message: error?.message || "Falha ao gerar o relatório" });
    });
  };
}

router.get("/relatorios/painel/lojas", verifyJWT, rota(RelatorioController.relPainelLoja));
router.get("/relatorios/painel/produtos", verifyJWT, rota(RelatorioController.relPainelProduto));
router.get("/relatorios/painel/caixas", verifyJWT, rota(RelatorioController.relPainelCaixa));
router.get("/relatorios/painel/finalizadoras", verifyJWT, rota(RelatorioController.relPainelFinalizadora));
router.get("/relatorios/painel/secoes", verifyJWT, rota(RelatorioController.relPainelSecoes));
router.get("/relatorios/painel/cupom", verifyJWT, rota(RelatorioController.relPainelCupom));
router.get("/relatorios/painel/cupom/analitico", verifyJWT, rota(RelatorioController.relPainelCupomAnalitico));
router.get("/relatorios/estoque/saldo", verifyJWT, rota(RelatorioController.relPainelSaldoEstoque));

router.get("/relatorios/cupom", verifyJWT, rota(RelatorioController.relCupomUnico));

router.get("/relatorios/produtos/listagem", verifyJWT, rota(RelatorioController.relProdutoListagem));

export default router;

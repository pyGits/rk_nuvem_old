import { Router } from "express";
import { verifyJWT } from "./auth.middleware";
import RelatorioController from "../controller/RelatorioController";

const router = Router();

router.get(
  "/relatorios/painel/lojas",
  verifyJWT,
  RelatorioController.relPainelLoja
);
router.get(
  "/relatorios/painel/produtos",
  verifyJWT,
  RelatorioController.relPainelProduto
);
router.get(
  "/relatorios/painel/caixas",
  verifyJWT,
  RelatorioController.relPainelCaixa
);
router.get(
  "/relatorios/painel/finalizadoras",
  verifyJWT,
  RelatorioController.relPainelFinalizadora
);
router.get(
  "/relatorios/painel/secoes",
  verifyJWT,
  RelatorioController.relPainelSecoes
);
router.get(
  "/relatorios/painel/cupom",
  verifyJWT,
  RelatorioController.relPainelCupom
);
router.get(
  "/relatorios/painel/cupom/analitico",
  verifyJWT,
  RelatorioController.relPainelCupomAnalitico
);
router.get(
  "/relatorios/estoque/saldo",
  verifyJWT,
  RelatorioController.relPainelSaldoEstoque
);

router.get("/relatorios/cupom", verifyJWT, RelatorioController.relCupomUnico);

router.get(
  "/relatorios/produtos/listagem",
  verifyJWT,
  RelatorioController.relProdutoListagem
);

export default router;

import { Router } from "express";
import { verifyJWT } from "./auth.middleware";
import { exigeAcesso } from "../permissao/permissao.middleware";
import FechamentoController from "../controller/FechamentoController";

// Nivel de acesso: a anotacao exigeAcesso(...) diz a que tela(s) do catalogo
// (src/permissao/CatalogoTelas.ts) esta rota pertence. Quando a rota serve mais
// de uma tela, basta ter acesso a qualquer uma delas.
const router = Router();
router.post("/fechamento", verifyJWT, FechamentoController.InserirFechamento);
router.post(
  "/fechamentoForma",
  verifyJWT,
  FechamentoController.InserirFechamentoForma
);

router.post(
  "/fechamento/lote",
  verifyJWT,
  FechamentoController.InserirFechamentoLote
);
router.post(
  "/fechamentoForma/lote",
  verifyJWT,
  FechamentoController.InserirFechamentoFormaLote
);

router.get("/fechamento", verifyJWT, exigeAcesso("relatorio.caixa.controle"), FechamentoController.getFechamentos);
router.get(
  "/fechamento-formas",
  verifyJWT,
  exigeAcesso("relatorio.caixa.controle"),
  FechamentoController.getFechamentoFormas
);
export default router;

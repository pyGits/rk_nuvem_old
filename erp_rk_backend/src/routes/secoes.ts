import { Router } from "express";
import { verifyJWT } from "./auth.middleware";
import { exigeAcesso } from "../permissao/permissao.middleware";
import SecaoController from "../controller/SecaoController";
import GrupoController from "../controller/GrupoController";

// Nivel de acesso: a anotacao exigeAcesso(...) diz a que tela(s) do catalogo
// (src/permissao/CatalogoTelas.ts) esta rota pertence.
//
// Criterio usado: GRAVACAO leva a anotacao da tela dona do cadastro. As
// LEITURAS que varias telas compartilham (a entrada de nota, os relatorios e a
// carga leem produto, preco, loja, secao...) ficam so com o verifyJWT - anotar
// uma delas com uma tela so tiraria do ar a outra tela de quem tem acesso
// legitimo a ela.
const router = Router();

router.get("/secoes/:codigo", verifyJWT, SecaoController.getSecao);
router.get("/secoes", verifyJWT, SecaoController.getSecoes);
router.post("/secoes", verifyJWT, exigeAcesso("cadastro.secao"), SecaoController.insertSecao);
router.put("/secoes", verifyJWT, exigeAcesso("cadastro.secao"), SecaoController.updateSecao);
router.delete("/secoes/:codigo", verifyJWT, exigeAcesso("cadastro.secao"), SecaoController.deleteSecao);

router.get("/secoes/:codigosecao/grupos", verifyJWT, GrupoController.getGrupos);
router.get(
  "/secoes/:codigosecao/grupos/:codigogrupo",
  verifyJWT,
  GrupoController.getGrupo
);
router.delete(
  "/secoes/:codigosecao/grupos/:codigogrupo",
  verifyJWT,
  exigeAcesso("cadastro.secao"),
  GrupoController.deleteGrupo
);
router.post(
  "/secoes/:codigosecao/grupos",
  verifyJWT,
  exigeAcesso("cadastro.secao"),
  GrupoController.insertGrupo
);
router.put(
  "/secoes/:codigosecao/grupos/:codigo",
  verifyJWT,
  exigeAcesso("cadastro.secao"),
  GrupoController.updateGrupo
);

export default router;

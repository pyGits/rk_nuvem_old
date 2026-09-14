import { Router } from "express";
import { verifyJWT } from "./auth.middleware";
import { exigeAcesso } from "../permissao/permissao.middleware";
import ImpFederaisController from "../controller/ImpFederaisController";

// Nivel de acesso: a anotacao exigeAcesso(...) diz a que tela(s) do catalogo
// (src/permissao/CatalogoTelas.ts) esta rota pertence.
//
// Criterio usado: GRAVACAO leva a anotacao da tela dona do cadastro. As
// LEITURAS que varias telas compartilham (a entrada de nota, os relatorios e a
// carga leem produto, preco, loja, secao...) ficam so com o verifyJWT - anotar
// uma delas com uma tela so tiraria do ar a outra tela de quem tem acesso
// legitimo a ela.
const router = Router();

router.get("/impfederal", verifyJWT, ImpFederaisController.getImpFederais);
router.post("/impfederal", verifyJWT, exigeAcesso("fiscal.impfederal"), ImpFederaisController.insertImpFederal);
router.put(
  "/impfederal/:codigo",
  verifyJWT,
  exigeAcesso("fiscal.impfederal"),
  ImpFederaisController.updateImpFederal
);
router.get(
  "/impfederal/:codigo",
  verifyJWT,
  ImpFederaisController.getImpFederal
);

export default router;

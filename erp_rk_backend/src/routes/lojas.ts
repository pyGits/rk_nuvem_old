import { Router } from "express";
import { verifyJWT } from "./auth.middleware";
import { exigeAcesso } from "../permissao/permissao.middleware";
import LojaController from "../controller/LojaController";

// Nivel de acesso: a anotacao exigeAcesso(...) diz a que tela(s) do catalogo
// (src/permissao/CatalogoTelas.ts) esta rota pertence.
//
// Criterio usado: GRAVACAO leva a anotacao da tela dona do cadastro. As
// LEITURAS que varias telas compartilham (a entrada de nota, os relatorios e a
// carga leem produto, preco, loja, secao...) ficam so com o verifyJWT - anotar
// uma delas com uma tela so tiraria do ar a outra tela de quem tem acesso
// legitimo a ela.
const router = Router();

router.get("/lojas", verifyJWT, LojaController.getLojas);
router.get("/lojas/:codigo", verifyJWT, LojaController.getLoja);
router.put("/lojas/:codigo", verifyJWT, exigeAcesso("cadastro.loja"), LojaController.updateLoja);
router.post("/lojas", verifyJWT, exigeAcesso("cadastro.loja"), LojaController.insertLoja);

export default router;

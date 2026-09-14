import { Router } from "express";
import { verifyJWT } from "./auth.middleware";
import { exigeAcesso } from "../permissao/permissao.middleware";
import NaoFiscalController from "../controller/NaoFiscalController";

// Nivel de acesso: a anotacao exigeAcesso(...) diz a que tela(s) do catalogo
// (src/permissao/CatalogoTelas.ts) esta rota pertence. Quando a rota serve mais
// de uma tela, basta ter acesso a qualquer uma delas.
const router = Router();

router.post("/naoFiscal", verifyJWT, NaoFiscalController.InserirNaoFiscal);
router.post("/naoFiscal/lote", verifyJWT, NaoFiscalController.InserirNaoFiscalLote);
router.get("/reforcos", verifyJWT, exigeAcesso("relatorio.caixa.controle"), NaoFiscalController.getReforcos);
router.get("/sangrias", verifyJWT, exigeAcesso("relatorio.caixa.controle"), NaoFiscalController.getSangrias);

export default router;

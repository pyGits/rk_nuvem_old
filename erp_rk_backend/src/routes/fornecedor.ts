import { Router } from "express";
import { verifyJWT } from "./auth.middleware";
import { exigeAcesso } from "../permissao/permissao.middleware";
import FornecedorController from "../controller/FornecedorController";

// Nivel de acesso: a anotacao exigeAcesso(...) diz a que tela(s) do catalogo
// (src/permissao/CatalogoTelas.ts) esta rota pertence.
//
// Criterio usado: GRAVACAO leva a anotacao da tela dona do cadastro. As
// LEITURAS que varias telas compartilham (a entrada de nota, os relatorios e a
// carga leem produto, preco, loja, secao...) ficam so com o verifyJWT - anotar
// uma delas com uma tela so tiraria do ar a outra tela de quem tem acesso
// legitimo a ela.
const router = Router();

router.get("/fornecedors", verifyJWT, FornecedorController.getFornecedors);
router.get("/fornecedors/:codigo", verifyJWT, FornecedorController.getFornecedor);
router.put("/fornecedors/:codigo", verifyJWT, exigeAcesso("cadastro.fornecedor", "compra.recebimento"), FornecedorController.updateFornecedor);
router.post("/fornecedors", verifyJWT, exigeAcesso("cadastro.fornecedor", "compra.recebimento"), FornecedorController.insertFornecedor);

export default router;

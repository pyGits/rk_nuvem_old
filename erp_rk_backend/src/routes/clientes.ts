import { Router } from "express";
import { verifyJWT } from "./auth.middleware";
import { exigeAcesso } from "../permissao/permissao.middleware";
import ClienteController from "../controller/ClienteController";

// Nivel de acesso: a anotacao exigeAcesso(...) diz a que tela(s) do catalogo
// (src/permissao/CatalogoTelas.ts) esta rota pertence.
//
// Criterio usado: GRAVACAO leva a anotacao da tela dona do cadastro. As
// LEITURAS que varias telas compartilham (a entrada de nota, os relatorios e a
// carga leem produto, preco, loja, secao...) ficam so com o verifyJWT - anotar
// uma delas com uma tela so tiraria do ar a outra tela de quem tem acesso
// legitimo a ela.
const router = Router();

router.get("/clientes", verifyJWT, ClienteController.getClientes);
router.get("/clientes/:codigo", verifyJWT, ClienteController.getCliente);
router.put("/clientes/:codigo", verifyJWT, exigeAcesso("cadastro.cliente"), ClienteController.updateCliente);
router.post("/clientes", verifyJWT, exigeAcesso("cadastro.cliente"), ClienteController.insertCliente);

export default router;

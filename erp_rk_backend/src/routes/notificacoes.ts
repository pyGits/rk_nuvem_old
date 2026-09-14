import { Router } from "express";
import { verifyJWT } from "./auth.middleware";
import { exigeAcesso } from "../permissao/permissao.middleware";
import NotificacaoController from "../controller/NotificacaoController";

const router = Router();

// Os avisos sao o conteudo da tela inicial e do sininho do topo; o proprio
// controller ainda filtra cada tipo pelo acesso a tela de origem do dado.
router.get("/notificacoes", verifyJWT, exigeAcesso("inicio"), NotificacaoController.listar);

export default router;

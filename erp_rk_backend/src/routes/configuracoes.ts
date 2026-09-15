import { Router } from "express";
import { verifyJWT } from "./auth.middleware";
import { somentePrincipal } from "../permissao/permissao.middleware";
import ConfiguracaoController from "../controller/ConfiguracaoController";

// Configurações do cliente. Fora do catálogo de telas (CatalogoTelas.ts) pelo
// mesmo motivo da tela /configuracoes: a gravação é do dono do inquilino, e é
// o somentePrincipal que barra, não acesso de tela.
//
// A leitura fica só com o verifyJWT — a tela de carga a consome para avisar
// que a carga automática está ligada, e isso vale para qualquer usuário.
const router = Router();

// Mesmo adaptador das rotas de carga: handler async que lança num Router vira
// unhandled rejection e derruba o processo.
const seguro = (handler: any) => async (req: any, res: any) => {
  try {
    await handler(req, res);
  } catch (error: any) {
    res.status(422).json({ message: error?.message || "Erro ao processar a requisição." });
  }
};

router.get("/configuracoes", verifyJWT, seguro(ConfiguracaoController.getConfiguracao));
router.put("/configuracoes", verifyJWT, somentePrincipal, seguro(ConfiguracaoController.updateConfiguracao));

export default router;

import { Router } from "express";
import { verifyJWT } from "./auth.middleware";
import { verifyJWTADMIN } from "./auth.middleware.admin";
import ErroPdvController from "../controller/ErroPdvController";

const router = Router();

// Mesmo adaptador das rotas do IBPT: handler async que lança num Router vira
// unhandled rejection e derruba o processo (o 502 que aparece no lugar do erro).
const seguro = (handler: any) => async (req: any, res: any) => {
  try {
    await handler(req, res);
  } catch (error: any) {
    res.status(422).json({ message: error?.message || "Erro ao processar a requisição." });
  }
};

// Rota do Sync_NUVEM. Sem /v2 e com resposta literal {"message":"SINCRONIZADO"},
// como as demais do agente.
router.post("/erroPdv", verifyJWT, seguro(ErroPdvController.sincronizar));

// Painel administrativo
router.get("/admin/erros-pdv", verifyJWTADMIN, seguro(ErroPdvController.listar));

export default router;

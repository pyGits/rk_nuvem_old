import { Router } from "express";
import { verifyJWT } from "./auth.middleware";
import { exigeAcesso } from "../permissao/permissao.middleware";
import { verifyJWTADMIN } from "./auth.middleware.admin";
import CargaController from "../controller/CargaController";

// Nivel de acesso: a anotacao exigeAcesso(...) diz a que tela(s) do catalogo
// (src/permissao/CatalogoTelas.ts) esta rota pertence. Quando a rota serve mais
// de uma tela, basta ter acesso a qualquer uma delas.
const router = Router();

// Mesmo adaptador das rotas do IBPT e dos erros do PDV: handler async que lanca
// num Router vira unhandled rejection e derruba o processo (o 502 que aparece
// no lugar do erro). As rotas antigas ficam como estavam.
const seguro = (handler: any) => async (req: any, res: any) => {
  try {
    await handler(req, res);
  } catch (error: any) {
    res.status(422).json({ message: error?.message || "Erro ao processar a requisição." });
  }
};

router.get("/carga/finalizaCarga", verifyJWT, exigeAcesso("carga.loja"), CargaController.finalizaCarga);
router.get("/carga/status", verifyJWT, exigeAcesso("carga.loja"), CargaController.verificaCargaStatus);
// Precisa vir antes de "/carga/:loja", senao o parametro captura "progresso".
router.get("/carga/progresso", verifyJWT, exigeAcesso("carga.loja"), CargaController.atualizaProgressoCarga);
router.get("/carga/:loja", verifyJWT, exigeAcesso("carga.loja"), CargaController.verificaCarga);
router.post("/cargaCompleta", verifyJWT, exigeAcesso("carga.loja"), CargaController.enviaCargaCompleta);
router.post("/cargaAlterados", verifyJWT, exigeAcesso("carga.loja"), CargaController.enviaCargaAlterados);

// Painel administrativo: carga para as lojas de todos os clientes. Caminho
// proprio (/admin/...) para nao esbarrar no "/carga/:loja" acima nem no token
// de cliente — aqui quem autentica e o token do painel.
router.get("/admin/carga/lojas", verifyJWTADMIN, seguro(CargaController.listaLojasAdmin));
router.get("/admin/carga/status", verifyJWTADMIN, seguro(CargaController.statusAdmin));
router.post("/admin/carga", verifyJWTADMIN, seguro(CargaController.enviaCargaAdmin));

export default router;

import { Router } from "express";
import { verifyJWT } from "./auth.middleware";
import SecaoController from "../controller/SecaoController";
import GrupoController from "../controller/GrupoController";

const router = Router();

router.get("/secoes/:codigo", verifyJWT, SecaoController.getSecao);
router.get("/secoes", verifyJWT, SecaoController.getSecoes);
router.post("/secoes", verifyJWT, SecaoController.insertSecao);
router.put("/secoes", verifyJWT, SecaoController.updateSecao);
router.delete("/secoes/:codigo", verifyJWT, SecaoController.deleteSecao);

router.get("/secoes/:codigosecao/grupos", verifyJWT, GrupoController.getGrupos);
router.get(
  "/secoes/:codigosecao/grupos/:codigogrupo",
  verifyJWT,
  GrupoController.getGrupo
);
router.delete(
  "/secoes/:codigosecao/grupos/:codigogrupo",
  verifyJWT,
  GrupoController.deleteGrupo
);
router.post(
  "/secoes/:codigosecao/grupos",
  verifyJWT,
  GrupoController.insertGrupo
);
router.put(
  "/secoes/:codigosecao/grupos/:codigo",
  verifyJWT,
  GrupoController.updateGrupo
);

export default router;

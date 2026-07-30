import { Router } from "express";
import { verifyJWT } from "./auth.middleware";
import CargaController from "../controller/CargaController";

const router = Router();

router.get("/carga/finalizaCarga", verifyJWT, CargaController.finalizaCarga);
router.get("/carga/status", verifyJWT, CargaController.verificaCargaStatus);
// Precisa vir antes de "/carga/:loja", senao o parametro captura "progresso".
router.get("/carga/progresso", verifyJWT, CargaController.atualizaProgressoCarga);
router.get("/carga/:loja", verifyJWT, CargaController.verificaCarga);
router.post("/cargaCompleta", verifyJWT, CargaController.enviaCargaCompleta);
router.post("/cargaAlterados", verifyJWT, CargaController.enviaCargaAlterados);

export default router;

import { Router } from "express";
import { verifyJWT } from "./auth.middleware";
import CargaController from "../controller/CargaController";

const router = Router();

router.get("/carga/finalizaCarga", verifyJWT, CargaController.finalizaCarga);
router.get("/carga/status", verifyJWT, CargaController.verificaCargaStatus);
router.get("/carga/:loja", verifyJWT, CargaController.verificaCarga);
router.post("/cargaCompleta", verifyJWT, CargaController.enviaCargaCompleta);
router.post("/cargaAlterados", verifyJWT, CargaController.enviaCargaAlterados);

export default router;

import { Router } from "express";
import { verifyJWT } from "./auth.middleware";
import FinalizadoraController from "../controller/FinalizadoraController";

const router = Router();

router.get(
  "/finalizadoras/:codigo",
  verifyJWT,
  FinalizadoraController.getFinalizadora
);
router.get(
  "/finalizadoras",
  verifyJWT,
  FinalizadoraController.getFinalizadoras
);
router.post(
  "/finalizadoras",
  verifyJWT,
  FinalizadoraController.insertFinalizadora
);
router.put(
  "/finalizadoras",
  verifyJWT,
  FinalizadoraController.updateFinalizadora
);

export default router;

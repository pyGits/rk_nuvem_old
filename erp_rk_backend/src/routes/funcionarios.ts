import { Router } from "express";
import { verifyJWT } from "./auth.middleware";
import FuncionarioController from "../controller/FuncionarioController";

const router = Router();

router.get("/funcionarios", verifyJWT, FuncionarioController.getFuncionarios);
router.get(
  "/funcionarios/:codigo",
  verifyJWT,
  FuncionarioController.getFuncionario
);
router.put(
  "/funcionarios/:codigo",
  verifyJWT,
  FuncionarioController.updateFuncionario
);
router.post(
  "/funcionarios",
  verifyJWT,
  FuncionarioController.insertFuncionario
);

export default router;

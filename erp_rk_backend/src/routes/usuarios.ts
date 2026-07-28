import { Router } from "express";
import { verifyJWT } from "./auth.middleware";
import UsuarioController from "../controller/UsuarioController";

const router = Router();

router.get("/usuarios", verifyJWT, UsuarioController.getUsuarios);
router.get("/usuarios/:codigo", verifyJWT, UsuarioController.getUsuario);
router.put("/usuarios/:codigo", verifyJWT, UsuarioController.updateUsuario);
router.post("/usuarios", verifyJWT, UsuarioController.insertUsuario);
router.post("/usuarios/verificar", UsuarioController.verifyUser);

export default router;

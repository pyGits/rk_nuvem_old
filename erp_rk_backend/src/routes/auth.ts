import { Router } from "express";
import { verifyJWT } from "./auth.middleware";
import { verifyJWTADMIN } from "./auth.middleware.admin";
import { somentePrincipal } from "../permissao/permissao.middleware";
import AuthController from "../controller/AuthController";

const router = Router();

router.post("/login", AuthController.login);
router.post("/loginCarga", AuthController.loginCarga);

router.get("/tenant", verifyJWT, AuthController.getTenant);

// Quem sou eu e a que telas tenho acesso. E a primeira chamada do front depois
// do login, e a que ele refaz a cada F5.
router.get("/me", verifyJWT, AuthController.me);

// A senha do login principal e do dono. A checagem da senha atual continua no
// controller (ela prova a identidade); o somentePrincipal impede que um usuario
// web sequer chegue la para ficar tentando senha.
router.put(
  "/tenant/senha",
  verifyJWT,
  somentePrincipal,
  AuthController.updateTenantPassword
);
router.post("/register", verifyJWTADMIN, AuthController.register);

export default router;

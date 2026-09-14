import { Router } from "express";
import { verifyJWT } from "./auth.middleware";
import { verifyJWTADMIN } from "./auth.middleware.admin";
import { somentePrincipal } from "../permissao/permissao.middleware";
import AdminController from "../controller/AdminController";

const router = Router();
router.get("/tenants", verifyJWTADMIN, AdminController.getTenantList);
router.put("/tenants", verifyJWTADMIN, AdminController.updateTenant);

// A logo e a identidade da empresa inteira, nao um cadastro do dia a dia: quem
// troca e o dono do inquilino.
router.post("/tenants/uploadLogo", verifyJWT, somentePrincipal, AdminController.uploadTenantLogo);

router.post("/loginAdmin", AdminController.login);

export default router;

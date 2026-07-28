import { Router } from "express";
import { verifyJWT } from "./auth.middleware";
import { verifyJWTADMIN } from "./auth.middleware.admin";
import AdminController from "../controller/AdminController";

const router = Router();
router.get("/tenants", verifyJWTADMIN, AdminController.getTenantList);
router.put("/tenants", verifyJWTADMIN, AdminController.updateTenant);

router.post("/tenants/uploadLogo", verifyJWT, AdminController.uploadTenantLogo);

router.post("/loginAdmin", AdminController.login);

export default router;

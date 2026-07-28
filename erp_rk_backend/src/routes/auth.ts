import { Router } from "express";
import { verifyJWT } from "./auth.middleware";
import { verifyJWTADMIN } from "./auth.middleware.admin";
import AuthController from "../controller/AuthController";

const router = Router();

router.post("/login", AuthController.login);
router.post("/loginCarga", AuthController.loginCarga);

router.get("/tenant", verifyJWT, AuthController.getTenant);
router.post("/register", verifyJWTADMIN, AuthController.register);

export default router;

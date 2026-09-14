import { Router } from "express";
import { verifyJWT } from "./auth.middleware";
import { exigeAcesso, somentePrincipal } from "../permissao/permissao.middleware";
import UsuarioController from "../controller/UsuarioController";

const router = Router();

// As rotas de acesso vem ANTES de "/usuarios/:codigo": registrada depois, a
// rota com parametro capturaria "/usuarios/001/acessos" achando que o codigo
// e "001/acessos".
//
// somentePrincipal, e nao exigeAcesso("usuarios.web"): quem tem a tela de
// usuarios liberada pode cadastrar gente, mas so o dono do inquilino decide o
// que cada um acessa. Sem isso, um usuario web com essa tela daria acesso a si
// mesmo e o nivel de acesso nao valeria nada.
router.get("/usuarios/:codigo/acessos", verifyJWT, somentePrincipal, UsuarioController.getAcessos);
router.put("/usuarios/:codigo/acessos", verifyJWT, somentePrincipal, UsuarioController.updateAcessos);

router.get("/usuarios", verifyJWT, exigeAcesso("usuarios.web"), UsuarioController.getUsuarios);
router.get("/usuarios/:codigo", verifyJWT, exigeAcesso("usuarios.web"), UsuarioController.getUsuario);
router.put("/usuarios/:codigo", verifyJWT, exigeAcesso("usuarios.web"), UsuarioController.updateUsuario);
router.post("/usuarios", verifyJWT, exigeAcesso("usuarios.web"), UsuarioController.insertUsuario);

// Checa se um login ja existe, para a tela avisar antes de gravar. Responde
// sobre o namespace de login inteiro (todos os inquilinos), entao exige estar
// logado - quem usa isso e a tela de cadastro, que ja tem token.
router.post("/usuarios/verificar", verifyJWT, UsuarioController.verifyUser);

export default router;

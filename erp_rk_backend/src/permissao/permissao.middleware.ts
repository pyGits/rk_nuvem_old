import { podeAcessar } from "./PermissaoService";

// Middlewares de acesso. Sempre DEPOIS do verifyJWT na cadeia da rota - eles
// dependem de req.principal / req.tenant_id / req.usuario_codigo, que e o
// verifyJWT quem preenche.

// 403, e nao 401, de proposito: o interceptor do front (src/plugins/axios.ts)
// derruba o token e manda para a tela de login quando ve 401, e "voce nao tem
// acesso a esta tela" nao e "sua sessao expirou". O campo `codigo` e o que o
// front usa para distinguir isto de um 422 qualquer.
// Aceita mais de uma tela porque as telas deste sistema reaproveitam muito
// endpoint: /produtos serve o cadastro de produto E a entrada de nota fiscal,
// /precos serve os dois, e assim por diante. Anotar uma rota dessas com uma
// tela so tiraria do ar a outra tela de quem tem acesso legitimo a ela.
//
// A regra e "esta rota serve a estas telas": passa quem tiver acesso a
// qualquer uma delas.
export function exigeAcesso(...telas: string[]) {
  return async (req: any, res: any, next: any) => {
    try {
      for (const tela of telas) {
        if (await podeAcessar(req, tela)) return next();
      }

      return res.status(403).json({
        codigo: "SEM_PERMISSAO",
        tela: telas[0],
        message: "Você não tem acesso a esta tela.",
      });
    } catch (error) {
      console.log("[permissao] falha ao validar acesso", error);
      return res.status(500).json({ message: "Falha ao validar o acesso." });
    }
  };
}

// Para o que so o dono do inquilino pode fazer - inclusive definir os acessos
// dos outros. Sem isto, um usuario web com a tela "Usuários WEB" liberada
// poderia dar acesso a si mesmo.
export function somentePrincipal(req: any, res: any, next: any) {
  if (req.principal) return next();

  return res.status(403).json({
    codigo: "SOMENTE_PRINCIPAL",
    message: "Somente o login principal pode fazer isso.",
  });
}

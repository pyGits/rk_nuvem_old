import jwt from "jsonwebtoken";

// Alem do tenant, o token passou a dizer QUEM esta logado - sem isso nao havia
// onde pendurar o nivel de acesso, porque o login principal e os usuarios web
// recebiam tokens identicos.
//
// REGRA QUE SUSTENTA A COMPATIBILIDADE: token sem `usuario_codigo` e tratado
// como login principal, com acesso a tudo. Isso cobre, sem tocar em nada:
//   - os tokens de 24h emitidos antes desta mudanca, que continuam chegando
//     pelo primeiro dia depois do deploy;
//   - o token de 30 anos do loginCarga, que o agente das lojas (Sync_NUVEM)
//     tem gravado e nao vai renovar;
//   - o proprio loginCarga.
// NUNCA inverta esse padrao para negar quando falta o campo: isso derrubaria a
// carga e a subida de venda de todas as lojas instaladas de uma vez.
//
// req.params recebe os mesmos campos porque as rotas v2/v3 leem tudo de la - o
// httpServer.register passa req.params como primeiro argumento do callback.
// Com isso, `tenant_id`, `principal`, `usuario_codigo` e `usuario_user` viram
// nomes reservados de parametro de rota: nenhuma rota de hoje os usa, e uma
// rota nova que usasse teria o valor sobrescrito aqui.
export function verifyJWT(req: any, res: any, next: any) {
  const token = req.headers["x-access-token"];
  jwt.verify(token, "B0RG55!", (err: any, decoded: any) => {
    if (err) return res.status(401).end();

    req.tenant_id = decoded.tenant_id;
    req.params.tenant_id = decoded.tenant_id;

    const ehUsuarioWeb = decoded.usuario_codigo !== undefined && decoded.usuario_codigo !== null;

    req.principal = !ehUsuarioWeb;
    req.usuario_codigo = ehUsuarioWeb ? String(decoded.usuario_codigo) : null;
    req.usuario_user = ehUsuarioWeb ? decoded.usuario_user : null;

    req.params.principal = req.principal;
    req.params.usuario_codigo = req.usuario_codigo;
    req.params.usuario_user = req.usuario_user;

    next();
  });
}

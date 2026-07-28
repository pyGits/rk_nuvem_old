import jwt from "jsonwebtoken";
export function verifyJWT(req: any, res: any, next: any) {
  const token = req.headers["x-access-token"];
  jwt.verify(token, "B0RG55!", (err: any, decoded: any) => {
    if (err) return res.status(401).end();
    req.tenant_id = decoded.tenant_id;
    req.params.tenant_id = decoded.tenant_id;
    next();
  });
}

import jwt from "jsonwebtoken";
export function verifyJWTADMIN(req: any, res: any, next: any) {
  const token = req.headers["x-access-token-admin"];
  jwt.verify(token, "9#4pG5*XbE", (err: any, decoded: any) => {
    if (err) return res.status(401).end();
    req.userAdmin = decoded.userAdmin;
    next();
  });
}

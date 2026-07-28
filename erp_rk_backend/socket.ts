import net from "net";
import crypto from "crypto";

type ClientSocket = net.Socket & { tenant_id: string };
const SALT = "6425025B0rg35";

const clientsConnected: { [id: string]: ClientSocket } = {};

export const server = net.createServer((socket: any) => {
  socket.on("data", (data: any) => {
    console.log(data.toString());
    const obj = JSON.parse(data.toString());

    if (obj.type === "ENVIA_CARGA") {
      const tenant_id = obj.token;
      console.log(tenant_id);
      const clientSocket = clientsConnected[tenant_id];
      if (clientSocket) {
        clientSocket.write("ENVIA_CARGA");
      }
    }

    if (obj.type === "CLIENTE_CONECTA") {
      const tenant_id = obj.token;
      socket.tenant_id = tenant_id;
      clientsConnected[tenant_id] = socket;
      console.log("Cliente conectado:" + tenant_id);
    }
  });

  socket.on("end", () => {
    const tenant_id = socket.tenant_id;
    delete clientsConnected[tenant_id];
    console.log(`Cliente ${tenant_id} desconectado`);
  });

  socket.on("error", (err: any) => {
    console.error(`Error: ${err}`);
  });
});

function encryptWithSalt(data: string, salt: string): string {
  const hash = crypto.createHash("md5");
  hash.update(data + salt);
  return hash.digest("hex");
}

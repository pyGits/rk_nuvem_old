export default class Loja {
  constructor(public codigo = "", public nome = "", public fantasia = "", public cnpjcpf = "", public certificado = "", public senha = "") {}

  decodeCertificado() {
    return Buffer.from(this.certificado, "base64");
  }
}

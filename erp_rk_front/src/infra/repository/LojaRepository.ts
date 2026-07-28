import Loja from "../entity/Loja";
import Connection from "./Connection";

class LojaRepository {
  async getAll() {
    const res = await Connection.get("/v2/loja");
    return res.data;
  }
  async getAllByFilter(filter: any) {
    const res = await Connection.get("/v2/loja", { params: filter });
    return res.data;
  }
  async uploadCertificado(certificado: File, senha: string, loja_id: string): Promise<any> {
    const formData = new FormData();
    formData.append("arquivo", certificado);
    formData.append("senha", senha);
    const res = await Connection.uploadFormData(`/v2/loja/${loja_id}/certificado`, formData);
    return res.data;
  }
  async atualizarSenhaCertificado(senha: string, loja_id: string): Promise<void> {
    await Connection.post(`/v2/loja/${loja_id}/certificado/senha`, { senha: senha });
  }
  async getByCodigo(codigo: string): Promise<Loja> {
    const res = await Connection.get(`/v2/loja/${codigo}`);
    const data = res.data;
    if (!data) return new Loja();
    return new Loja(data.codigo, data.nome, data.fantasia, data.cnpjcpf);
  }
}
export default new LojaRepository();

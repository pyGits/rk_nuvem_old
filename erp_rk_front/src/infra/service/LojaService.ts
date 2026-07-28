import Loja from "../entity/Loja";
import LojaRepository from "../repository/LojaRepository";

class LojaService {
  async getAll(): Promise<GetAllOutput> {
    const lojas = await LojaRepository.getAll();

    return { lojas: lojas };
  }
  async getAllByFilter(filter: any) {
    const data = await LojaRepository.getAllByFilter(filter);
    return data;
  }
  async uploadCertificado(certificado: File, senha: string, loja_id: string) {
    if (!certificado) throw new Error("Selecione o arquivo do certificado (.pfx) !");
    if (senha.trim() === "") throw new Error("Senha inválida !");
    // Envia o certificado e a senha juntos; o backend valida o .pfx e a senha na hora.
    return await LojaRepository.uploadCertificado(certificado, senha, loja_id);
  }
  async getByCodigo(codigo: string): Promise<Loja> {
    if (codigo.trim() === "") throw new Error("Digite o código da Loja !");
    const loja = await LojaRepository.getByCodigo(codigo);
    return loja;
  }
}

type GetAllOutput = {
  lojas: any;
};

export default new LojaService();

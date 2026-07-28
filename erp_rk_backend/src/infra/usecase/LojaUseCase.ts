import LojaRepository from "../repository/LojaRepository";
import SefazService from "../service/sefaz/SefazService";
import path from "path";

export default class LojaUseCase {
  constructor(readonly lojaRepository: LojaRepository) {}

  /**
   * Recebe a senha do certificado (fluxo do front antigo, que envia a senha num
   * request separado após o upload). Valida o certificado já armazenado e dispara
   * a primeira sincronização.
   */
  async atualizarSenhaCertificado(input: { senha: string; lojaId: string; tenant_id: number }) {
    const senha = (input.senha || "").trim();
    if (senha === "") throw new Error("Informe a senha do certificado !");

    const certificado = await this.lojaRepository.getCertificado(input.lojaId, input.tenant_id);

    if (certificado && String(certificado).trim() !== "") {
      // Valida certificado + senha e grava tudo (senha, titular, validade).
      const info = SefazService.validarCertificado(certificado, senha);
      await this.lojaRepository.salvarCertificado({
        certificado_base64: certificado,
        senha,
        titular: info.titular,
        validade: info.validade,
        loja_id: input.lojaId,
        tenant_id: input.tenant_id,
      });
      await this.sincronizarInicial(input.lojaId, input.tenant_id);
    } else {
      // Ainda não há certificado; apenas guarda a senha.
      await this.lojaRepository.atualizarSenhaCertificado(senha, input.lojaId, input.tenant_id);
    }
  }

  async getByCodigo(input: { codigo: string; tenant_id: number }): Promise<Output> {
    const loja = await this.lojaRepository.getByCodigo(input.codigo, input.tenant_id);
    return { status: 200, data: loja };
  }

  async uploadCertificado(input: Input): Promise<Output> {
    const cer = input.file;
    if (!cer) throw new Error("Arquivo do certificado não enviado !");

    const extensao = path.extname(cer.originalname).toLowerCase();
    if (extensao !== ".pfx") throw new Error("Extensão de arquivo não suportada ! somente .pfx");

    const cer_base64 = cer.buffer.toString("base64");
    const senha = (input.senha || "").trim();

    // Fluxo NOVO (front atualizado): senha vem junto do arquivo -> valida e sincroniza já.
    if (senha !== "") {
      const info = SefazService.validarCertificado(cer_base64, senha);
      await this.lojaRepository.salvarCertificado({
        certificado_base64: cer_base64,
        senha,
        titular: info.titular,
        validade: info.validade,
        loja_id: input.lojaId,
        tenant_id: input.tenant_id,
      });
      await this.sincronizarInicial(input.lojaId, input.tenant_id);
      return { status: 201, data: { titular: info.titular, validade: info.validade } };
    }

    // Fluxo ANTIGO: só o arquivo. Guarda o certificado; a validação/sync ocorre
    // quando a senha chegar em /certificado/senha.
    await this.lojaRepository.updateCertificado(cer_base64, input.lojaId, input.tenant_id);
    return { status: 201 };
  }

  private async sincronizarInicial(lojaId: string, tenant_id: number) {
    try {
      const loja = await this.lojaRepository.getSefazByCodigo(lojaId, tenant_id);
      if (loja && loja.uf) {
        const { ultimoNsu } = await SefazService.sincronizarDistribuicao({ ...loja, tenant_id });
        await this.lojaRepository.atualizarSincronizacao(loja.codigo, tenant_id, ultimoNsu);
      }
    } catch (error) {
      console.error("Falha na sincronização inicial da SEFAZ após configurar o certificado:", error);
    }
  }

  async getAll(input: Input): Promise<Output> {
    const res = await this.lojaRepository.getAll(input.tenant_id, input.filtro);
    return { status: 200, data: res };
  }
}

type Input = {
  tenant_id: number;
  file?: any;
  senha?: string;
  lojaId?: any;
  filtro?: any;
};

type Output = {
  status: number;
  data?: any;
};

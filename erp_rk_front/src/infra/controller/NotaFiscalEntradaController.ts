import { NotaFiscal } from "../entity/NotaFiscal";
import CompraRepository from "../repository/NotaFiscalEntradaRepository";

export default class NotaFiscalEntradaController {
  constructor(readonly compraRepository: CompraRepository) {}
  async desfazerNota(input: { nota: NotaFiscal }) {
    await this.compraRepository.desfazerNota(input.nota);
    return { status: 200, message: "Desfeita !" };
  }
  async efetivarNota(input: { nota: NotaFiscal }) {
    input.nota.validate();
    await this.compraRepository.efetivarNota(input.nota);
    await this.compraRepository.atualizarEtapa(input.nota.protocolo.chave, "ENTRADA_NOTA_ETAPA");
    return { status: 200, message: "Nota Efetivada" };
  }
  async getByChave(input: { chave_nota: string }) {
    const res = await this.compraRepository.getByChave(input.chave_nota);
    return { nota: res.nota, fornecedor: res.fornecedor, produtos: res.produtos };
  }
  async ImportarXMLDiretorio(input: Input): Promise<Output> {
    if (!(input.arquivo && input.arquivo.name.endsWith(".xml"))) throw new Error("Arquivo deve ser .XML");
    const res = await this.compraRepository.uploadXML(input.arquivo);
    const nota = await this.compraRepository.getByChave(res.chave_xml);

    return { message: "Nota processada com sucesso !", data: nota };
  }
  async ImportarLoteXML(lote: FormData): Promise<Output> {
    const res = await this.compraRepository.uploadLoteXML(lote);
    return { status: res.status, message: res.message };
  }
  async carregarNotas(): Promise<Output> {
    const res = await this.compraRepository.getAll();
    return { status: 200, data: res };
  }
  async carregarNotasSefaz(): Promise<Output> {
    const res = await this.compraRepository.getAllFromSefaz();
    return { status: 200, data: res.data };
  }

  async avancarWizard(input: { etapa: string; nota: NotaFiscal }) {
    if (input.etapa === "ENTRADA") {
      if (input.nota.entrada_nota_etapa) return;
      input.nota.validate();
      await this.compraRepository.efetivarNota(input.nota);
      await this.compraRepository.atualizarEtapa(input.nota.protocolo.chave, input.etapa);
      input.nota.entrada_nota_etapa = true;
    }
    if (input.etapa === "FINANCEIRO") {
      await this.compraRepository.atualizarEtapa(input.nota.protocolo.chave, input.etapa);
    }
    if (input.etapa === "PRECOS") {
      await this.compraRepository.atualizarEtapa(input.nota.protocolo.chave, input.etapa);
    }

    if (input.etapa === "ROMANEIO") {
      await this.compraRepository.atualizarEtapa(input.nota.protocolo.chave, input.etapa);
      await this.compraRepository.atualizarTransportadora(input.nota);
      const romaneio = await this.compraRepository.gerarRomaneio(input.nota.protocolo.chave);
      return { romaneio: romaneio };
    }
  }
  async capturarNotaDaSefaz(chave: string) {
    if (chave.length !== 44) {
      throw new Error("A chave de acesso deve conter 44 dígitos.");
    }
    const nota = await this.compraRepository.capturarNotaDaSefaz(chave);
  }
}

type Input = {
  arquivo: File;
};

type Output = {
  nota?: NotaFiscal;
  status?: number;
  data?: any;
  message?: string;
};

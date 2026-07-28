import Connection from "./Connection";
import { NotaFiscal } from "../entity/NotaFiscal";
import { Associacao, Imposto, NotaFiscalItem } from "../entity/NotaFiscalItem";
import FornecedorFactory from "../entity/factory/FornecedorFactory";
import NotaFiscalFactory from "../entity/factory/NotaFiscalFactory";

export default interface NotaFiscalEntradaRepository {
  uploadXML(arquivo: File): Promise<any>;
  uploadLoteXML(lote: FormData): Promise<Output>;
  getAll(): Promise<Output>;
  getByArquivo(arquivo: string): Promise<NotaFiscal>;
  getByChave(chave: string): Promise<any>;
  efetivarNota(nota: NotaFiscal): Promise<void>;
  desfazerNota(nota: NotaFiscal): Promise<void>;
  atualizarEtapa(chave: string, etapa: string): Promise<void>;
  gerarRomaneio(chave: string): Promise<void>;
  capturarNotaDaSefaz(chave: string): Promise<void>;
  getAllFromSefaz(): Promise<Output>;
  atualizarTransportadora(nota: NotaFiscal): Promise<void>;
}
type Output = {
  status: number;
  message?: string;
  data?: any;
};

export class NotaFiscalEntradaRepositoryApi implements NotaFiscalEntradaRepository {
  async atualizarTransportadora(nota: NotaFiscal): Promise<void> {
    await Connection.post("/v2/compra/notas/atualizarTransportadora", nota);
  }
  async getAllFromSefaz() {
    const res = await Connection.get("/v2/compra/notas/sefaz");
    return res.data;
  }
  async capturarNotaDaSefaz(chave: string) {
    const res = await Connection.get(`/v2/compra/notas/${chave}/capturar`);
    return res.nota;
  }
  async gerarRomaneio(chave: string): Promise<void> {
    const res = await Connection.get(`/v2/compra/notas/${chave}/romaneio`);
    return res.data.romaneio;
  }
  async atualizarEtapa(chave: string, etapa: string): Promise<void> {
    await Connection.put(`/v2/compra/notas/${chave}/etapa/${etapa}`);
  }
  async desfazerNota(nota: NotaFiscal): Promise<void> {
    await Connection.post(`/v2/compra/notas/desfazer`, nota);
  }
  async efetivarNota(nota: NotaFiscal): Promise<void> {
    await Connection.post(`/v2/compra/notas/efetivar`, nota);
  }
  async getByChave(chave: string): Promise<any> {
    const res = await Connection.get(`/v2/compra/notas/${chave}`);
    const nota = NotaFiscalFactory.createFromApi(res.data.nota);
    const fornecedor = FornecedorFactory.create(res.data.fornecedor);
    return { nota: nota, fornecedor: fornecedor };
  }
  async getByArquivo(arquivo: string): Promise<NotaFiscal> {
    const res = await Connection.get(`/v2/compra/notas/${arquivo}`);
    const nota = Object.assign(new NotaFiscal(), res.data);

    nota.items = res.data.items.map((item: any) => {
      const notaItem = Object.assign(new NotaFiscalItem(), item);

      // Corrigir os objetos aninhados
      notaItem.associacao = Object.assign(new Associacao(), item.associacao);
      notaItem.imposto = Object.assign(new Imposto(), item.imposto); // Se tiver a classe Imposto

      return notaItem;
    });
    return nota;
  }
  async getAll(): Promise<Output> {
    const res = await Connection.get("/v2/compra/notas");
    return res.data;
  }
  async uploadLoteXML(lote: FormData): Promise<Output> {
    const res = await Connection.uploadFormData("/v2/compra/uploadLoteXML", lote);
    return { message: res.data.message, status: res.data.status };
  }
  async uploadXML(arquivo: File) {
    if (!arquivo) throw new Error("Arquivo não selecionado ! carregue o XML");
    const res = await Connection.uploadFile("/v2/compra/uploadXML", arquivo, "arquivo");
    return { chave_xml: res.data.chave_xml };
    // const nota = Object.assign(new NotaFiscal(), res.data.data);

    // nota.items = res.data.data.items.map((item: any) => {
    //   const notaItem = Object.assign(new NotaFiscalItem(), item);

    //   // Corrigir os objetos aninhados
    //   notaItem.associacao = Object.assign(new Associacao(), item.associacao);
    //   notaItem.imposto = Object.assign(new Imposto(), item.imposto); // Se tiver a classe Imposto

    //   return notaItem;
    // });
  }
}

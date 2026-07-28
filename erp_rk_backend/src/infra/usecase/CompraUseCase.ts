import FornecedorFactory from "../entity/Factory.ts/FornecedorFactory";
import NotaFiscalFactory from "../entity/Factory.ts/NotaFiscalFactory";
import Fornecedor from "../entity/Fornecedor";
import { NotaFiscal } from "../entity/NotaFiscal";
import { Associacao, ItemDistribuicao } from "../entity/NotaFiscalItem";
import AssociacaoRepository from "../repository/AssociacaoRepository";
import EstoqueRepository from "../repository/EstoqueRepository";
import FornecedorRepository from "../repository/FornecedorRepository";
import LojaRepository from "../repository/LojaRepository";
import { NotaFiscalItemRepository } from "../repository/NotaFiscalItemRepository";
import { NotaFiscalRepositoryPG } from "../repository/NotaFiscalRepository";
import PrecoRepository from "../repository/PrecoRepository";
import ProdutoRepository from "../repository/ProdutoRepository";
type Output = {
  status: number;
  message?: string;
  data?: any;
};

export interface CompraUseCase {
  getAll(input: { tenant_id: number }): Promise<Output>;
}

export default class CompraUseCasePG implements CompraUseCase {
  constructor(
    readonly fornecedorRepository: FornecedorRepository,
    readonly associacaoRepository: AssociacaoRepository,
    readonly lojaRepository: LojaRepository,
    readonly notaFiscalRepository: NotaFiscalRepositoryPG,
    readonly notaFiscalItemRepository: NotaFiscalItemRepository,
    readonly produtoRepository: ProdutoRepository,
    readonly precoRepository: PrecoRepository,
    readonly estoqueRepository: EstoqueRepository
  ) {}
  async atualizarTransportadora(input: { body: any; tenant_id: number }) {
    const nota = input.body;
    await this.notaFiscalRepository.atualizarTransportadora(nota, input.tenant_id);
    return { status: 200 };
  }

  async getAllSefaz(input: { tenant_id: number }) {
    const notas = await this.notaFiscalRepository.getAllSefaz(input.tenant_id);
    return { status: 200, data: notas };
  }
  async gerarRomaneio(input: { chave: string; tenant_id: number }) {
    const nota = await this.notaFiscalRepository.getByChave(input.chave, input.tenant_id);
    nota.items = await this.notaFiscalItemRepository.getByChave(input.chave, input.tenant_id);
    const fornecedor = await this.fornecedorRepository.getByCodigo(nota.fornecedor.codigo, input.tenant_id);
    const romaneio = await this.notaFiscalRepository.gerarRomaneio(nota, fornecedor);
    return { status: 200, romaneio: romaneio };
  }
  async atualizarEtapa(input: { chave: string; etapa: string; tenant_id: number }) {
    await this.notaFiscalRepository.atualizarEtapa(input.chave, input.etapa, input.tenant_id);
    return { status: 200 };
  }
  async desfazerNota(input: { body: any; tenant_id: number }) {
    const nota = input.body;
    await this.estoqueRepository.removeMovimentacaoByNota(nota.protocolo_chave, nota.loja_id, input.tenant_id);
    await this.notaFiscalRepository.desfazerEtapa(nota.protocolo_chave, "ENTRADA", input.tenant_id);
    return { status: 200 };
  }

  async efetivarNota(input: { body: any; tenant_id: number }) {
    const nota = NotaFiscalFactory.createFromBody(input.body);
    nota.loja = await this.lojaRepository.getByCNPJCPF(nota.loja.cnpjcpf, input.tenant_id);
    if (!nota.loja) throw new Error("Loja Destinatário não cadastrada !");

    nota.fornecedor = await this.fornecedorRepository.getByCNPJCPF(nota.fornecedor.cnpjcpf, input.tenant_id);
    if (!nota.fornecedor) throw new Error("Fornecedor não associado !");
    this.notaFiscalRepository.upinsert(nota, input.tenant_id);
    // atualizar itens
    for (let item of nota.items) {
      if (!item.associacao.isAssociado()) throw new Error("Existem produtos não associados !");
      if (!item.associacao.itemManual) {
        item.codigo_produto = item.associacao.codigo_produto;
      }
      const produto = await this.produtoRepository.getByCodigo(item.codigo_produto, input.tenant_id);

      // Atualiza custo em todas as lojas que recebem estoque deste item (conforme a distribuição).
      const lojas = [];
      for (const codigoLoja of item.lojasDistribuicao(Number(nota.loja.codigo))) {
        const loja = await this.lojaRepository.getByCodigo(String(codigoLoja), input.tenant_id);
        if (loja) lojas.push(loja);
      }
      produto.precos = await this.precoRepository.getByProduto(produto.codigo, lojas, input.tenant_id);
      for (const preco of produto.precos) {
        preco.atualizarCustoPorItemNota(item, nota.rateioFrete(), nota.rateioDesconto());
      }

      await this.precoRepository.insertByProduto(produto, input.tenant_id);
      this.notaFiscalItemRepository.upinsert(item, nota.protocolo.chave, input.tenant_id);
      this.associacaoRepository.upinsert(item.associacao, input.tenant_id);
    }

    await this.estoqueRepository.insertMovimentacaoByNota(nota, input.tenant_id);
    // await this.notaFiscalRepository.efetivarNota(nota.protocolo.chave, input.tenant_id);
    return { status: 200 };
  }

  async getAll(input: { tenant_id: number }): Promise<Output> {
    const notas = await this.notaFiscalRepository.getAll(input.tenant_id);
    return { status: 200, data: notas };
  }

  async getNota(input: { chave_nota: string; tenant_id: number }): Promise<any> {
    let produtos = [];
    let nota = await this.notaFiscalRepository.getByChave(input.chave_nota, input.tenant_id);

    if (!nota) throw new Error("Nota Não Encontrada !");
    nota.items = await this.notaFiscalItemRepository.getByChave(input.chave_nota, input.tenant_id);

    nota.fornecedor = await this.fornecedorRepository.getByCodigo(nota.fornecedor.codigo, input.tenant_id);
    if (!nota.fornecedor) nota.fornecedor = FornecedorFactory.createFromNotaFiscal(nota);

    nota.transportadora = await this.fornecedorRepository.getByCodigo(nota.transportadora.codigo, input.tenant_id);
    if (!nota.transportadora) nota.transportadora = new Fornecedor();

    nota.loja = await this.lojaRepository.getByCodigo(nota.loja.codigo, input.tenant_id);
    for (const item of nota.items) {
      item.associacao = await this.associacaoRepository.get(item.codigo, nota.fornecedor.codigo, input.tenant_id);

      if (!item.associacao && nota.notaManual === true) {
        item.associacao = new Associacao(undefined, undefined, undefined, undefined, undefined, true);
      }
    }

    // Movimentações já efetivadas desta nota — usadas para reconstruir a distribuição por loja.
    const movimentacoes = await this.estoqueRepository.getMovimentacoesByNota(input.chave_nota, input.tenant_id);

    for (const item of nota.items) {
      if (item.codigo_produto.trim() !== "") {
        item.produto = await this.produtoRepository.getByCodigo(item.codigo_produto, input.tenant_id);

        // Reconstrói a distribuição a partir das movimentações (uma linha por loja) quando já efetivada.
        const movsItem = movimentacoes.filter((m) => Number(m.item) === Number(item.numeroItem));
        if (movsItem.length > 0) {
          item.distribuicoes = movsItem.map((m) => new ItemDistribuicao(Number(m.loja), Number(m.qtde)));
        }

        // Carrega preços de todas as lojas que recebem estoque (ou da loja destinatária por padrão).
        const codigosLojas = item.distribuicoes && item.distribuicoes.length > 0 ? [...new Set(item.distribuicoes.map((d) => Number(d.lojaCodigo)))] : [Number(nota.loja.codigo)];
        const lojas = [];
        for (const codigoLoja of codigosLojas) {
          const loja = await this.lojaRepository.getByCodigo(String(codigoLoja), input.tenant_id);
          if (loja) lojas.push(loja);
        }
        item.produto.precos = await this.precoRepository.getByProduto(item.codigo_produto, lojas, input.tenant_id);
      }
    }

    return { nota: nota, fornecedor: nota.fornecedor, produtos: produtos };
  }
  async uploadLoteXML(lote: any, tenant_id: number) {
    for (const arquivo of lote) {
      const nota = NotaFiscalFactory.createFromXML(arquivo);
      if (!nota) continue;
      const isNotaExists = await this.notaFiscalRepository.getByChave(nota.protocolo.chave, tenant_id);
      if (isNotaExists) continue;

      const isLojaExists = await this.lojaRepository.getByCNPJCPF(nota.destinatario.cnpj, tenant_id);
      if (!isLojaExists) continue;

      nota.loja = isLojaExists;
      nota.notaManual = false;

      try {
        await this.notaFiscalRepository.upinsert(nota, tenant_id);
        for (const item of nota.items) {
          const isItemExists = await this.notaFiscalItemRepository.get(nota.protocolo.chave, item.numeroItem, tenant_id);
          if (isItemExists) continue;
          await this.notaFiscalItemRepository.upinsert(item, nota.protocolo.chave, tenant_id);
        }
      } catch (error) {
        await this.notaFiscalRepository.delete(nota, tenant_id);
        throw error;
      }
    }

    return { status: 200, message: "Arquivos Carregados com sucesso !" };
  }
  async capturaXml(chave_nota: string, tenant_id: number) {
    let nota: NotaFiscal = null;
    // tenta carregar pelo banco
    nota = await this.notaFiscalRepository.getByChave(chave_nota, tenant_id);

    // ja existe no banco de dados, retornar a nota somente
    if (nota) {
      nota.items = await this.notaFiscalItemRepository.getByChave(chave_nota, tenant_id);
      return { status: 200, nota: nota };
    }
    // tenta carregar pela sefaz
    if (!nota) {
      nota = await this.notaFiscalRepository.getNotaBySefazDatabase(chave_nota, "1", tenant_id);
    }
    if (!nota) throw new Error("Nota não encontrada !");

    const isLojaExists = await this.lojaRepository.getByCNPJCPF(nota.destinatario.cnpj, tenant_id);

    if (!isLojaExists) throw new Error(`CNPJ Destinatário do XML não encontrado cadastrado !, CNPJ Destinatário: ${nota.destinatario.cnpj}`);

    nota.loja = isLojaExists;

    // se tudo validado inserir nota no banco de dados !
    await this.notaFiscalRepository.upinsert(nota, tenant_id);

    for (const item of nota.items) {
      await this.notaFiscalItemRepository.upinsert(item, nota.protocolo.chave, tenant_id);
    }
    // retornar nota
    return { status: 200, nota: nota };
  }
  async uploadXML(xml: any, tenant_id: number) {
    let nota = NotaFiscalFactory.createFromXML(xml[0]);
    const chave_xml = nota.protocolo.chave;
    if (!nota) throw new Error("Erro ao carregar nota");
    const isNotaExists = await this.notaFiscalRepository.getByChave(nota.protocolo.chave, tenant_id);
    if (isNotaExists) nota = isNotaExists;

    const isLojaExists = await this.lojaRepository.getByCNPJCPF(nota.destinatario.cnpj, tenant_id);
    if (!isLojaExists) throw new Error("CNPJ da loja na nota não cadastrado !");
    nota.loja = isLojaExists;
    nota.notaManual = false;

    const isFornecedorExists = await this.fornecedorRepository.getByCNPJCPF(nota.emitente.cnpj, tenant_id);
    if (isFornecedorExists) nota.fornecedor = isFornecedorExists;

    try {
      await this.notaFiscalRepository.upinsert(nota, tenant_id);
      for (const item of nota.items) {
        const isItemExists = await this.notaFiscalItemRepository.get(nota.protocolo.chave, item.numeroItem, tenant_id);
        if (isItemExists) continue;
        await this.notaFiscalItemRepository.upinsert(item, nota.protocolo.chave, tenant_id);
      }
    } catch (error) {
      await this.notaFiscalRepository.delete(nota, tenant_id);
      throw error;
    }

    return { status: 200, message: "Arquivos Carregados com sucesso !", chave_xml: chave_xml };
  }
}

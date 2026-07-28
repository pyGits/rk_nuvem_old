import Fornecedor from "../Fornecedor";
import Loja from "../Loja";
import { NotaFiscal, Emitente, Endereco, Destinatario, Total, Protocolo } from "../NotaFiscal";
import { NotaFiscalItem, Imposto, ICMS, IPI, PIS, COFINS, Associacao } from "../NotaFiscalItem";
import NFe from "djf-nfe";
import path from "path";

export default class NotaFiscalFactory {
  static createFromBody(body: any): NotaFiscal {
    const nota = Object.assign(new NotaFiscal(), body);
    nota.items = (nota.items || []).map((item: any) => {
      const notaItem = Object.assign(new NotaFiscalItem(), item);
      notaItem.associacao = Object.assign(new Associacao(), item.associacao);
      return notaItem;
    });
    return nota;
  }
  static createFromString(xmlString: string) {
    if (!xmlString.includes("<NFe") || !xmlString.includes("<nfeProc")) return null;
    const nfe = NFe(xmlString);
    // info
    const naturezaOperacao = nfe.naturezaOperacao();
    const nrNota = nfe.nrNota();
    const serie = nfe.serie();
    const modelo = nfe.modelo();
    const tipoAmbiente = nfe.tipoAmbiente();
    const tipoOperacao = nfe.tipoOperacao();
    const operacao = nfe.operacao();
    const dataEmissao = nfe.dataEmissao();
    const dataEntradaSaida = nfe.dataEntradaSaida();
    const informacoesComplementares = nfe.informacoesComplementares();
    const informacoesFisco = nfe.informacoesFisco();
    const nrObservacoes = nfe.nrObservacoes();
    const observacoes = [];

    const infoProtocolo = nfe.informacoesProtocolo();
    const protocolo = new Protocolo(infoProtocolo.dataHoraRecebimento?.(), infoProtocolo.protocolo(), infoProtocolo.chave(), infoProtocolo.tipoAmbiente(), infoProtocolo.codigoStatusResposta());
    // emitente
    const infoEmitente = nfe.emitente();

    const cepEmitente = infoEmitente.endereco().cep();
    const logradouroEmitente = infoEmitente.endereco().logradouro();
    const ufEmitente = infoEmitente.endereco().uf();
    const numeroEmitente = infoEmitente.endereco().numero();
    const bairroEmitente = infoEmitente.endereco().bairro();
    const complementoEmitente = infoEmitente.endereco().complemento();
    const municipioEmitente = infoEmitente.endereco().municipio();
    const codigoMunicipioEmitente = infoEmitente.endereco().codigoMunicipio();
    const paisEmitente = infoEmitente.endereco().pais();
    const codigoPaisEmitente = infoEmitente.endereco().codigoPais();
    const telefoneEmitente = infoEmitente.endereco().telefone();

    const enderecoEmitente = new Endereco(ufEmitente, cepEmitente, logradouroEmitente, numeroEmitente, bairroEmitente, complementoEmitente, municipioEmitente, codigoMunicipioEmitente, paisEmitente, codigoPaisEmitente, telefoneEmitente);

    const cnpjEmitente = infoEmitente.cnpj();
    const nomeEmitente = infoEmitente.nome();
    const fantasiaEmitente = infoEmitente.fantasia();
    const emailEmitente = infoEmitente.email();
    const cpfEmitente = infoEmitente.cpf();
    const inscricaoNacionalEmitente = infoEmitente.inscricaoNacional();
    const inscricaoMunicipalEmitente = infoEmitente.inscricaoMunicipal();
    const inscricaoEstadualEmitente = infoEmitente.inscricaoEstadual();
    const inscricaoEstadualSTEmitente = infoEmitente.inscricaoEstadualST();
    const codigoRegimeTributarioEmitente = infoEmitente.codigoRegimeTributario();

    const emitente = new Emitente(nomeEmitente, fantasiaEmitente, emailEmitente, cpfEmitente, cnpjEmitente, inscricaoNacionalEmitente, inscricaoMunicipalEmitente, inscricaoEstadualEmitente, inscricaoEstadualSTEmitente, codigoRegimeTributarioEmitente, enderecoEmitente);

    const infoDestinatario = nfe.destinatario();
    const nomeDestinatario = infoDestinatario.nome();
    const fantasiaDestinatario = infoDestinatario.fantasia();
    const emailDestinatario = infoDestinatario.email();
    const cpfDestinatario = infoDestinatario.cpf();
    const cnpjDestinatario = infoDestinatario.cnpj();
    const inscricaoNacionalDestinatario = infoDestinatario.inscricaoNacional();
    const inscricaoMunicipalDestinatario = infoDestinatario.inscricaoMunicipal();
    const inscricaoEstadualDestinatario = infoDestinatario.inscricaoEstadual();
    const inscricaoEstadualSTDestinatario = infoDestinatario.inscricaoEstadualST();

    const cepDestinatario = infoDestinatario.endereco().cep();
    const logradouroDestinatario = infoDestinatario.endereco().logradouro();
    const ufDestinatario = infoDestinatario.endereco().uf();
    const numeroDestinatario = infoDestinatario.endereco().numero();
    const bairroDestinatario = infoDestinatario.endereco().bairro();
    const complementoDestinatario = infoDestinatario.endereco().complemento();
    const municipioDestinatario = infoDestinatario.endereco().municipio();
    const codigoMunicipioDestinatario = infoDestinatario.endereco().codigoMunicipio();
    const paisDestinatario = infoDestinatario.endereco().pais();
    const codigoPaisDestinatario = infoDestinatario.endereco().codigoPais();
    const telefoneDestinatario = infoDestinatario.endereco().telefone();

    const enderecoDestinatario = new Endereco(ufDestinatario, cepDestinatario, logradouroDestinatario, numeroDestinatario, bairroDestinatario, complementoDestinatario, municipioDestinatario, codigoMunicipioDestinatario, paisDestinatario, codigoPaisDestinatario, telefoneDestinatario);

    const destinatario = new Destinatario(nomeDestinatario, fantasiaDestinatario, emailDestinatario, cpfDestinatario, cnpjDestinatario, inscricaoNacionalDestinatario, inscricaoMunicipalDestinatario, inscricaoEstadualDestinatario, inscricaoEstadualSTDestinatario, enderecoDestinatario);

    const infoTotal = nfe.total();
    const total = new Total(
      infoTotal.baseCalculoIcms(),
      infoTotal.valorIcms(),
      infoTotal.valorIcmsDesonerado(),
      infoTotal.baseCalculoIcmsST(),
      infoTotal.baseCalculoIcmsSTRetido(),
      infoTotal.valorIcmsST(),
      infoTotal.valorIcmsSTRetido(),
      infoTotal.valorProdutos(),
      infoTotal.valorFrete(),
      infoTotal.valorSeguro(),
      infoTotal.valorDesconto(),
      infoTotal.valorII(),
      infoTotal.valorIPI(),
      infoTotal.valorPIS(),
      infoTotal.valorCOFINS(),
      infoTotal.valorOutrasDespesas(),
      infoTotal.valorNota(),
      infoTotal.valorTotalTributos()
    );

    const itens = this.criarItensNotaFiscal(nfe);
    return new NotaFiscal(
      naturezaOperacao,
      nrNota,
      serie,
      modelo,
      tipoAmbiente,
      tipoOperacao,
      operacao,
      dataEmissao,
      dataEntradaSaida,
      protocolo,
      emitente,
      destinatario,
      total,
      informacoesComplementares,
      informacoesFisco,
      nrObservacoes,
      observacoes,
      itens,
      new Loja(),
      "PENDENTE",
      undefined,
      undefined,
      undefined,
      undefined,
      new Fornecedor()
    );
  }
  static createFromXML(file: Express.Multer.File) {
    const ext = path.extname(file.originalname).toLowerCase();
    if (ext !== ".xml") return null;
    const xmlString = file.buffer.toString("utf-8");
    return this.createFromString(xmlString);
  }
  static criarItensNotaFiscal(nfe: any): NotaFiscalItem[] {
    // itens
    const totalItems = nfe.nrItens();
    let itensNotaFiscal = [];

    for (let i = 1; i <= totalItems; i++) {
      const item = nfe.item(i);
      const itemImposto = item.imposto();
      // Alguns emitentes omitem o atributo `nItem` no <det>; nesse caso o djf-nfe
      // devolve um objeto em vez do número. Usamos o índice do laço como número do item.
      const numeroItem = Number(item.numeroItem()) || i;

      const icms = new ICMS(
        itemImposto.icms().cst(),
        itemImposto.icms().baseCalculo(),
        itemImposto.icms().porcetagemIcms(),
        itemImposto.icms().porcetagemIcmsST(),
        itemImposto.icms().valorIcms(),
        itemImposto.icms().baseCalculoIcmsST(),
        itemImposto.icms().valorIcmsST(),
        itemImposto.icms().origem(),
        itemImposto.icms().csosn(),
        itemImposto.icms().porcentagemMVAST(),
        itemImposto.icms().modalidadeBCST(),
        itemImposto.icms().valorFCP(),
        itemImposto.icms().valorFCPST(),
        itemImposto.icms().valorFCPSTRetido(),
        itemImposto.icms().porcentagemFCP(),
        itemImposto.icms().porcentagemFCPST(),
        itemImposto.icms().porcentagemFCPSTRetido(),
        itemImposto.icms().baseCalculoFCP(),
        itemImposto.icms().baseCalculoFCPST(),
        itemImposto.icms().baseCalculoFCPSTRetido()
      );
      const ipi = new IPI(item.ipi()?.cst?.(), item.ipi()?.baseCalculo?.(), item.ipi()?.valorIPI?.(), item.ipi()?.porcentagemIPI?.());
      const pis = new PIS(itemImposto.pis().cst(), itemImposto.pis().baseCalculo(), itemImposto.pis().valorPIS(), itemImposto.pis().porcentagemPIS());
      const cofins = new COFINS(itemImposto.cofins().cst(), itemImposto.cofins().baseCalculo(), itemImposto.cofins().valorPIS(), itemImposto.cofins().porcentagemPIS());
      const imposto = new Imposto(icms, ipi, pis, cofins);
      itensNotaFiscal.push(
        new NotaFiscalItem(
          numeroItem,
          item.codigo(),
          item.descricao(),
          item.ean(),
          item.ncm(),
          item.cest(),
          item.cfop(),
          item.codigoBeneficioFiscal(),
          item.numeroFCI(),
          item.unidadeComercial(),
          item.valorUnitario(),
          item.unidadeTributavel(),
          item.eanTributavel(),
          item.quantidadeTributavel(),
          item.quantidadeComercial(),
          item.valorUnitarioTributavel(),
          item.valorOutrasDespesas(),
          item.indicadorTotal(),
          item.codigoANP(),
          item.informacoesProduto(),
          item.pedido(),
          item.numeroItemPedido(),
          item.valorProdutos(),
          imposto
        )
      );
    }

    return itensNotaFiscal;
  }
}

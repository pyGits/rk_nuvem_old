import DatabaseConnection from "./DatabaseConnection";
import path from "path";
import { promises as fs } from "fs";
import { NotaFiscal } from "../entity/NotaFiscal";
import NotaFiscalFactory from "../entity/Factory.ts/NotaFiscalFactory";
import PDFDocument from "pdfkit";
import Fornecedor from "../entity/Fornecedor";
import { maskDateBR, maskMoney, maskQtd } from "../../masks/masks";
import LojaRepository, { LojaRepositoryPG } from "./LojaRepository";
import NFeSefazRepository from "./NFeSefazRepository";
import SefazService from "../service/sefaz/SefazService";

export default interface NotaFiscalRepository {
  getByChave(chave: string, tenant_id: number): Promise<NotaFiscal>;
  getAll(tenant_id: number): Promise<any>;
  upinsert(nota: NotaFiscal, tenant_id: number): Promise<void>;
  delete(nota: NotaFiscal, tenant_id: number): Promise<void>;
  atualizarEtapa(chave_nota: string, etapa: string, tenant_id: number): Promise<void>;
  atualizarTransportadora(nota: NotaFiscal, tenant_id: number): Promise<void>;
}

export class NotaFiscalRepositoryPG implements NotaFiscalRepository {
  lojaRepository: LojaRepositoryPG;
  constructor() {
    this.lojaRepository = new LojaRepositoryPG();
  }
  async atualizarTransportadora(nota: NotaFiscal, tenant_id: number): Promise<void> {
    await DatabaseConnection.query("update nota_fiscal_entrada set transportadora = $1 where tenant_id = $2 and protocolo_chave = $3", [nota.transportadora.codigo, tenant_id, nota.protocolo.chave]);
  }

  /**
   * Sincroniza (best-effort) as notas de entrada disponíveis na SEFAZ para as
   * lojas do tenant que possuem certificado. Respeita um intervalo mínimo entre
   * consultas para não incorrer em "consumo indevido" (rate limit da SEFAZ).
   */
  async sincronizarNotasSefaz(tenant_id: number): Promise<void> {
    const intervaloMs = Number(process.env.SEFAZ_SYNC_INTERVAL_MS || 60 * 60 * 1000);
    const lojas = await this.lojaRepository.getLojasParaSincronizar(tenant_id, intervaloMs);
    for (const loja of lojas) {
      try {
        const { ultimoNsu } = await SefazService.sincronizarDistribuicao({ ...loja, tenant_id });
        await this.lojaRepository.atualizarSincronizacao(loja.codigo, tenant_id, ultimoNsu);
      } catch (error) {
        console.error(`Falha ao sincronizar SEFAZ da loja ${loja.codigo}:`, error);
      }
    }
  }

  async getAllSefaz(tenant_id: number) {
    await this.sincronizarNotasSefaz(tenant_id);
    return await NFeSefazRepository.getPendentes(tenant_id);
  }
  async gerarRomaneio(nota: NotaFiscal, fornecedor: Fornecedor): Promise<any> {
    return new Promise((resolve, reject) => {
      const doc = new PDFDocument();
      const buffers: Buffer[] = [];

      doc.on("data", (data) => buffers.push(data));
      doc.on("end", () => {
        const pdfBuffer = Buffer.concat(buffers);
        const base64 = pdfBuffer.toString("base64");
        resolve(base64);
      });
      doc.on("error", reject);

      doc.fontSize(18).text("Romaneio de Entrada", { align: "center" });
      doc.moveDown();

      doc.fontSize(12).text(`Fornecedor: ${fornecedor.nome}`);
      doc.text(`CNPJ/CPF: ${fornecedor.cnpjcpf}`);
      doc.moveDown();
      doc.text(`Data Emissão: ${maskDateBR(nota.dataEmissao)}`);
      doc.text(`Nota Fiscal: ${nota.nrNota} - Série: ${nota.serie}`);
      doc.moveDown();

      doc.text("Itens:");
      nota.items.forEach((item, index) => {
        doc.fontSize(12).text(`${index + 1}. ${item.descricao} - ${maskMoney(item.valorUnitario)} x ${maskQtd(item.quantidadeComercial)} = ${maskMoney(item.valorProdutos)}`);
      });

      doc.moveDown();
      doc.text("Total:");
      doc.fontSize(12).text(`${maskMoney(nota.total.valorProdutos)}`);

      doc.end();
    });
  }

  async atualizarEtapa(chave_nota: string, etapa: string, tenant_id: number): Promise<void> {
    if (etapa === "ENTRADA") {
      await DatabaseConnection.query("update nota_fiscal_entrada set entrada_nota_etapa = true where protocolo_chave = $1 and tenant_id =$2", [chave_nota, tenant_id]);
      await NFeSefazRepository.marcarProcessada(chave_nota, tenant_id);
    }
    if (etapa === "FINANCEIRO") {
      await DatabaseConnection.query("update nota_fiscal_entrada set lancamento_financeiro_etapa = true where protocolo_chave = $1 and tenant_id =$2", [chave_nota, tenant_id]);
    }
    if (etapa === "PRECOS") {
      await DatabaseConnection.query("update nota_fiscal_entrada set alteracao_precos_etapa = true where protocolo_chave = $1 and tenant_id =$2", [chave_nota, tenant_id]);
    }
    if (etapa === "ROMANEIO") {
      await DatabaseConnection.query("update nota_fiscal_entrada set romaneio_etapa = true where protocolo_chave = $1 and tenant_id =$2", [chave_nota, tenant_id]);
    }
  }
  async desfazerEtapa(chave_nota: string, etapa: string, tenant_id: number): Promise<void> {
    if (etapa === "ENTRADA") {
      await DatabaseConnection.query("update nota_fiscal_entrada set entrada_nota_etapa = false where protocolo_chave = $1 and tenant_id =$2", [chave_nota, tenant_id]);
    }
    if (etapa === "FINANCEIRO") {
      await DatabaseConnection.query("update nota_fiscal_entrada set lancamento_financeiro_etapa = false where protocolo_chave = $1 and tenant_id =$2", [chave_nota, tenant_id]);
    }
    if (etapa === "PRECOS") {
      await DatabaseConnection.query("update nota_fiscal_entrada set alteracao_precos_etapa = false where protocolo_chave = $1 and tenant_id =$2", [chave_nota, tenant_id]);
    }
    if (etapa === "ROMANEIO") {
      await DatabaseConnection.query("update nota_fiscal_entrada set romaneio_etapa = false where protocolo_chave = $1 and tenant_id =$2", [chave_nota, tenant_id]);
    }
  }

  async delete(nota: NotaFiscal, tenant_id: number): Promise<void> {
    await DatabaseConnection.query("DELETE FROM nota_fiscal_entrada where protocolo_chave = $1 and tenant_id =$2", [nota.protocolo.chave, tenant_id]);
  }
  async getNotaBySefazDatabase(chave: string, codigoLoja: string, tenant_id: number): Promise<NotaFiscal> {
    try {
      // Descobre a loja destinatária a partir do documento já resumido na tabela `nfe`.
      const registro = await NFeSefazRepository.getByChave(chave, tenant_id);

      // XML completo já disponível (capturado na sincronização) — não precisa consultar a SEFAZ.
      if (registro && registro.resumo === false && String(registro.xml || "").trim() !== "") {
        return NotaFiscalFactory.createFromString(registro.xml);
      }

      let loja = registro?.cnpjcpf ? await this.lojaRepository.getSefazByCNPJCPF(registro.cnpjcpf, tenant_id) : null;
      // Fallback: usa a loja informada quando o registro ainda não tem o destinatário.
      if (!loja) loja = await this.lojaRepository.getSefazByCodigo(codigoLoja, tenant_id);
      if (!loja) throw new Error(`Nenhuma loja com certificado encontrada para capturar a nota ${chave}.`);
      if (!loja.certificado || !loja.senha) throw new Error(`A loja ${loja.codigo} não possui certificado configurado.`);

      const resultado = await SefazService.capturarPorChave({ ...loja, tenant_id }, chave);
      if (!resultado.sucesso) throw new Error(resultado.msg || "A SEFAZ não retornou o XML completo.");

      const res = await NFeSefazRepository.getByChave(chave, tenant_id);
      if (!res || String(res.xml || "").trim() === "") return null;
      return NotaFiscalFactory.createFromString(res.xml);
    } catch (error: any) {
      throw new Error(`Falha ao capturar a nota ${chave} na SEFAZ: ${error.message}`);
    }
  }

  async getByChave(chave: string, tenant_id: number): Promise<NotaFiscal> {
    const row = await DatabaseConnection.queryFirst("SELECT * FROM nota_fiscal_entrada WHERE protocolo_chave = $1 and tenant_id = $2", [chave, tenant_id]);
    if (!row) return null;
    const nota = {
      naturezaOperacao: row.natureza_operacao,
      nrNota: row.nr_nota,
      serie: row.serie,
      modelo: row.modelo,
      tipoAmbiente: row.tipo_ambiente,
      tipoOperacao: row.tipo_operacao,
      operacao: row.operacao,
      dataEmissao: row.data_emissao,
      dataEntradaSaida: row.data_entrada_saida,

      protocolo: {
        protocolo: row.protocolo_numero,
        chave: row.protocolo_chave,
        dataHoraRecebimento: row.protocolo_data_hora_recebimento,
        tipoAmbiente: row.protocolo_tipo_ambiente,
        codigoStatusResposta: row.protocolo_codigo_status_resposta,
      },

      emitente: {
        nome: row.emitente_nome,
        fantasia: row.emitente_fantasia,
        email: row.emitente_email,
        cpf: row.emitente_cpf,
        cnpj: row.emitente_cnpj,
        inscricaoNacional: row.emitente_inscricao_nacional,
        inscricaoMunicipal: row.emitente_inscricao_municipal,
        inscricaoEstadual: row.emitente_inscricao_estadual,
        inscricaoEstadualST: row.emitente_inscricao_estadual_st,
        codigoRegimeTributario: row.emitente_codigo_regime_tributario,
        endereco: {
          uf: row.emitente_uf,
          cep: row.emitente_cep,
          logradouro: row.emitente_logradouro,
          numero: row.emitente_numero,
          bairro: row.emitente_bairro,
          complemento: row.emitente_complemento,
          municipio: row.emitente_municipio,
          codigoMunicipio: row.emitente_codigo_municipio,
          pais: row.emitente_pais,
          codigoPais: row.emitente_codigo_pais,
          telefone: row.emitente_telefone,
        },
      },

      destinatario: {
        nome: row.destinatario_nome,
        fantasia: row.destinatario_fantasia,
        email: row.destinatario_email,
        cpf: row.destinatario_cpf,
        cnpj: row.destinatario_cnpj,
        inscricaoNacional: row.destinatario_inscricao_nacional,
        inscricaoMunicipal: row.destinatario_inscricao_municipal,
        inscricaoEstadual: row.destinatario_inscricao_estadual,
        inscricaoEstadualST: row.destinatario_inscricao_estadual_st,
        endereco: {
          uf: row.destinatario_uf,
          cep: row.destinatario_cep,
          logradouro: row.destinatario_logradouro,
          numero: row.destinatario_numero,
          bairro: row.destinatario_bairro,
          complemento: row.destinatario_complemento,
          municipio: row.destinatario_municipio,
          codigoMunicipio: row.destinatario_codigo_municipio,
          pais: row.destinatario_pais,
          codigoPais: row.destinatario_codigo_pais,
          telefone: row.destinatario_telefone,
        },
      },

      total: {
        baseCalculoIcms: Number(row.total_base_calculo_icms),
        valorIcms: Number(row.total_valor_icms),
        valorIcmsDesonerado: Number(row.total_valor_icms_desonerado),
        baseCalculoIcmsST: Number(row.total_base_calculo_icms_st),
        baseCalculoIcmsSTRetido: Number(row.total_base_calculo_icms_st_retido),
        valorIcmsST: Number(row.total_valor_icms_st),
        valorIcmsSTRetido: Number(row.total_valor_icms_st_retido),
        valorProdutos: Number(row.total_valor_produtos),
        valorFrete: Number(row.total_valor_frete),
        valorSeguro: Number(row.total_valor_seguro),
        valorDesconto: Number(row.total_valor_desconto),
        valorII: Number(row.total_valor_ii),
        valorIPI: Number(row.total_valor_ipi),
        valorPIS: Number(row.total_valor_pis),
        valorCOFINS: Number(row.total_valor_cofins),
        valorOutrasDespesas: Number(row.total_valor_outras_despesas),
        valorNota: Number(row.total_valor_nota),
        valorTotalTributos: Number(row.total_valor_tributos),
      },

      informacoesComplementares: row.informacoes_complementares,
      informacoesFisco: row.informacoes_fisco,
      nrObservacoes: row.nr_observacoes,
      loja: {
        codigo: row.loja_id,
      },
      transportadora: {
        codigo: row.transportadora,
      },
      fornecedor: {
        codigo: row.codigo_fornecedor,
      },
      situacao: row.situacao,
      entrada_nota_etapa: row.entrada_nota_etapa,
      lancamento_financeiro_etapa: row.lancamento_financeiro_etapa,
      alteracao_precos_etapa: row.alteracao_precos_etapa,
      romaneio_etapa: row.romaneio_etapa,
      tenant_id: row.tenant_id,
      notaManual: row.nota_manual,
    };
    return Object.assign(new NotaFiscal(), nota);
  }
  async upinsert(nota: NotaFiscal, tenant_id: number): Promise<void> {
    const params = [
      // Dados básicos
      nota.naturezaOperacao || null,
      nota.nrNota || null,
      nota.serie || null,
      nota.modelo || null,
      nota.tipoAmbiente || null,
      nota.tipoOperacao || null,
      nota.operacao || null,
      nota.dataEmissao || null,
      nota.dataEntradaSaida || null,

      // Protocolo
      nota.protocolo.protocolo || null,
      nota.protocolo.chave || null,
      nota.protocolo.dataHoraRecebimento || null,
      nota.protocolo.tipoAmbiente || null,
      nota.protocolo.codigoStatusResposta || null,

      // Emitente
      nota.emitente.nome || null,
      nota.emitente.fantasia || null,
      nota.emitente.email || null,
      nota.emitente.cpf || null,
      nota.emitente.cnpj || null,
      nota.emitente.inscricaoNacional || null,
      nota.emitente.inscricaoMunicipal || null,
      nota.emitente.inscricaoEstadual || null,
      nota.emitente.inscricaoEstadualST || null,
      nota.emitente.codigoRegimeTributario || null,

      // Endereço Emitente
      nota.emitente.endereco.uf || null,
      nota.emitente.endereco.cep || null,
      nota.emitente.endereco.logradouro || null,
      nota.emitente.endereco.numero || null,
      nota.emitente.endereco.bairro || null,
      nota.emitente.endereco.complemento || null,
      nota.emitente.endereco.municipio || null,
      nota.emitente.endereco.codigoMunicipio || null,
      nota.emitente.endereco.pais || null,
      nota.emitente.endereco.codigoPais || null,
      nota.emitente.endereco.telefone || null,

      // Destinatário
      nota.destinatario.nome || null,
      nota.destinatario.fantasia || null,
      nota.destinatario.email || null,
      nota.destinatario.cpf || null,
      nota.destinatario.cnpj || null,
      nota.destinatario.inscricaoNacional || null,
      nota.destinatario.inscricaoMunicipal || null,
      nota.destinatario.inscricaoEstadual || null,
      nota.destinatario.inscricaoEstadualST || null,

      // Endereço Destinatário
      nota.destinatario.endereco.uf || null,
      nota.destinatario.endereco.cep || null,
      nota.destinatario.endereco.logradouro || null,
      nota.destinatario.endereco.numero || null,
      nota.destinatario.endereco.bairro || null,
      nota.destinatario.endereco.complemento || null,
      nota.destinatario.endereco.municipio || null,
      nota.destinatario.endereco.codigoMunicipio || null,
      nota.destinatario.endereco.pais || null,
      nota.destinatario.endereco.codigoPais || null,
      nota.destinatario.endereco.telefone || null,

      // Totais
      nota.total.baseCalculoIcms || 0,
      nota.total.valorIcms || 0,
      nota.total.valorIcmsDesonerado || 0,
      nota.total.baseCalculoIcmsST || 0,
      nota.total.baseCalculoIcmsSTRetido || 0,
      nota.total.valorIcmsST || 0,
      nota.total.valorIcmsSTRetido || 0,
      nota.total.valorProdutos || 0,
      nota.total.valorFrete || 0,
      nota.total.valorSeguro || 0,
      nota.total.valorDesconto || 0,
      nota.total.valorII || 0,
      nota.total.valorIPI || 0,
      nota.total.valorPIS || 0,
      nota.total.valorCOFINS || 0,
      nota.total.valorOutrasDespesas || 0,
      nota.total.valorNota || 0,
      nota.total.valorTotalTributos || 0,

      // Informações adicionais
      nota.informacoesComplementares || null,
      nota.informacoesFisco || null,
      nota.nrObservacoes || 0,

      // Loja (simplificado - assumindo que loja tem um id)
      nota.loja.codigo || null,
      nota.situacao,
      // Tenant
      tenant_id,
      nota.fornecedor.codigo || null,
      nota.notaManual || false,
    ];
    console.log(nota.notaManual);

    await DatabaseConnection.query(
      `INSERT INTO nota_fiscal_entrada (
    natureza_operacao, nr_nota, serie, modelo, tipo_ambiente, tipo_operacao, operacao,
    data_emissao, data_entrada_saida,
    protocolo_numero, protocolo_chave, protocolo_data_hora_recebimento, protocolo_tipo_ambiente, protocolo_codigo_status_resposta,
    emitente_nome, emitente_fantasia, emitente_email, emitente_cpf, emitente_cnpj, emitente_inscricao_nacional, 
    emitente_inscricao_municipal, emitente_inscricao_estadual, emitente_inscricao_estadual_st, emitente_codigo_regime_tributario,
    emitente_uf, emitente_cep, emitente_logradouro, emitente_numero, emitente_bairro, emitente_complemento,
    emitente_municipio, emitente_codigo_municipio, emitente_pais, emitente_codigo_pais, emitente_telefone,
    destinatario_nome, destinatario_fantasia, destinatario_email, destinatario_cpf, destinatario_cnpj, destinatario_inscricao_nacional,
    destinatario_inscricao_municipal, destinatario_inscricao_estadual, destinatario_inscricao_estadual_st,
    destinatario_uf, destinatario_cep, destinatario_logradouro, destinatario_numero, destinatario_bairro, destinatario_complemento,
    destinatario_municipio, destinatario_codigo_municipio, destinatario_pais, destinatario_codigo_pais, destinatario_telefone,
    total_base_calculo_icms, total_valor_icms, total_valor_icms_desonerado, total_base_calculo_icms_st, total_base_calculo_icms_st_retido,
    total_valor_icms_st, total_valor_icms_st_retido, total_valor_produtos, total_valor_frete, total_valor_seguro, total_valor_desconto,
    total_valor_ii, total_valor_ipi, total_valor_pis, total_valor_cofins, total_valor_outras_despesas, total_valor_nota, total_valor_tributos,
    informacoes_complementares, informacoes_fisco, nr_observacoes, loja_id, situacao, tenant_id,codigo_fornecedor,nota_manual
  ) VALUES (
    $1, $2, $3, $4, $5, $6, $7, 
    $8, $9, $10, $11, $12, $13, $14,
    $15, $16, $17, $18, $19, $20, $21, $22, $23, $24,
    $25, $26, $27, $28, $29, $30, $31, $32, $33, $34, $35,
    $36, $37, $38, $39, $40, $41, $42, $43, $44, $45,
    $46, $47, $48, $49, $50, $51, $52, $53, $54, $55,
    $56, $57, $58, $59, $60, $61, $62, $63, $64, $65,
    $66, $67, $68, $69, $70, $71, $72, $73, $74, $75,
    $76, $77, $78, $79,$80,$81
  )
  ON CONFLICT (protocolo_chave, loja_id, tenant_id) 
  DO UPDATE SET
    natureza_operacao = EXCLUDED.natureza_operacao,
    nr_nota = EXCLUDED.nr_nota,
    serie = EXCLUDED.serie,
    modelo = EXCLUDED.modelo,
    tipo_ambiente = EXCLUDED.tipo_ambiente,
    tipo_operacao = EXCLUDED.tipo_operacao,
    operacao = EXCLUDED.operacao,
    data_emissao = EXCLUDED.data_emissao,
    data_entrada_saida = EXCLUDED.data_entrada_saida,
    protocolo_numero = EXCLUDED.protocolo_numero,
    protocolo_data_hora_recebimento = EXCLUDED.protocolo_data_hora_recebimento,
    protocolo_tipo_ambiente = EXCLUDED.protocolo_tipo_ambiente,
    protocolo_codigo_status_resposta = EXCLUDED.protocolo_codigo_status_resposta,
    emitente_nome = EXCLUDED.emitente_nome,
    emitente_fantasia = EXCLUDED.emitente_fantasia,
    emitente_email = EXCLUDED.emitente_email,
    emitente_cpf = EXCLUDED.emitente_cpf,
    emitente_cnpj = EXCLUDED.emitente_cnpj,
    emitente_inscricao_nacional = EXCLUDED.emitente_inscricao_nacional,
    emitente_inscricao_municipal = EXCLUDED.emitente_inscricao_municipal,
    emitente_inscricao_estadual = EXCLUDED.emitente_inscricao_estadual,
    emitente_inscricao_estadual_st = EXCLUDED.emitente_inscricao_estadual_st,
    emitente_codigo_regime_tributario = EXCLUDED.emitente_codigo_regime_tributario,
    emitente_uf = EXCLUDED.emitente_uf,
    emitente_cep = EXCLUDED.emitente_cep,
    emitente_logradouro = EXCLUDED.emitente_logradouro,
    emitente_numero = EXCLUDED.emitente_numero,
    emitente_bairro = EXCLUDED.emitente_bairro,
    emitente_complemento = EXCLUDED.emitente_complemento,
    emitente_municipio = EXCLUDED.emitente_municipio,
    emitente_codigo_municipio = EXCLUDED.emitente_codigo_municipio,
    emitente_pais = EXCLUDED.emitente_pais,
    emitente_codigo_pais = EXCLUDED.emitente_codigo_pais,
    emitente_telefone = EXCLUDED.emitente_telefone,
    destinatario_nome = EXCLUDED.destinatario_nome,
    destinatario_fantasia = EXCLUDED.destinatario_fantasia,
    destinatario_email = EXCLUDED.destinatario_email,
    destinatario_cpf = EXCLUDED.destinatario_cpf,
    destinatario_cnpj = EXCLUDED.destinatario_cnpj,
    destinatario_inscricao_nacional = EXCLUDED.destinatario_inscricao_nacional,
    destinatario_inscricao_municipal = EXCLUDED.destinatario_inscricao_municipal,
    destinatario_inscricao_estadual = EXCLUDED.destinatario_inscricao_estadual,
    destinatario_inscricao_estadual_st = EXCLUDED.destinatario_inscricao_estadual_st,
    destinatario_uf = EXCLUDED.destinatario_uf,
    destinatario_cep = EXCLUDED.destinatario_cep,
    destinatario_logradouro = EXCLUDED.destinatario_logradouro,
    destinatario_numero = EXCLUDED.destinatario_numero,
    destinatario_bairro = EXCLUDED.destinatario_bairro,
    destinatario_complemento = EXCLUDED.destinatario_complemento,
    destinatario_municipio = EXCLUDED.destinatario_municipio,
    destinatario_codigo_municipio = EXCLUDED.destinatario_codigo_municipio,
    destinatario_pais = EXCLUDED.destinatario_pais,
    destinatario_codigo_pais = EXCLUDED.destinatario_codigo_pais,
    destinatario_telefone = EXCLUDED.destinatario_telefone,
    total_base_calculo_icms = EXCLUDED.total_base_calculo_icms,
    total_valor_icms = EXCLUDED.total_valor_icms,
    total_valor_icms_desonerado = EXCLUDED.total_valor_icms_desonerado,
    total_base_calculo_icms_st = EXCLUDED.total_base_calculo_icms_st,
    total_base_calculo_icms_st_retido = EXCLUDED.total_base_calculo_icms_st_retido,
    total_valor_icms_st = EXCLUDED.total_valor_icms_st,
    total_valor_icms_st_retido = EXCLUDED.total_valor_icms_st_retido,
    total_valor_produtos = EXCLUDED.total_valor_produtos,
    total_valor_frete = EXCLUDED.total_valor_frete,
    total_valor_seguro = EXCLUDED.total_valor_seguro,
    total_valor_desconto = EXCLUDED.total_valor_desconto,
    total_valor_ii = EXCLUDED.total_valor_ii,
    total_valor_ipi = EXCLUDED.total_valor_ipi,
    total_valor_pis = EXCLUDED.total_valor_pis,
    total_valor_cofins = EXCLUDED.total_valor_cofins,
    total_valor_outras_despesas = EXCLUDED.total_valor_outras_despesas,
    total_valor_nota = EXCLUDED.total_valor_nota,
    total_valor_tributos = EXCLUDED.total_valor_tributos,
    informacoes_complementares = EXCLUDED.informacoes_complementares,
    informacoes_fisco = EXCLUDED.informacoes_fisco,
    nr_observacoes = EXCLUDED.nr_observacoes,
    situacao = EXCLUDED.situacao,
    codigo_fornecedor = EXCLUDED.codigo_fornecedor,
    nota_manual = EXCLUDED.nota_manual`,

      params
    );
  }
  async insertLote(notasFiscais: NotaFiscal[], tenant_id: number): Promise<void> {
    for (const notaFiscal of notasFiscais) {
      const params = [
        // Dados básicos
        notaFiscal.naturezaOperacao || null,
        notaFiscal.nrNota || null,
        notaFiscal.serie || null,
        notaFiscal.modelo || null,
        notaFiscal.tipoAmbiente || null,
        notaFiscal.tipoOperacao || null,
        notaFiscal.operacao || null,
        notaFiscal.dataEmissao || null,
        notaFiscal.dataEntradaSaida || null,

        // Protocolo
        notaFiscal.protocolo.protocolo || null,
        notaFiscal.protocolo.chave || null,
        notaFiscal.protocolo.dataHoraRecebimento || null,
        notaFiscal.protocolo.tipoAmbiente || null,
        notaFiscal.protocolo.codigoStatusResposta || null,

        // Emitente
        notaFiscal.emitente.nome || null,
        notaFiscal.emitente.fantasia || null,
        notaFiscal.emitente.email || null,
        notaFiscal.emitente.cpf || null,
        notaFiscal.emitente.cnpj || null,
        notaFiscal.emitente.inscricaoNacional || null,
        notaFiscal.emitente.inscricaoMunicipal || null,
        notaFiscal.emitente.inscricaoEstadual || null,
        notaFiscal.emitente.inscricaoEstadualST || null,
        notaFiscal.emitente.codigoRegimeTributario || null,

        // Endereço Emitente
        notaFiscal.emitente.endereco.uf || null,
        notaFiscal.emitente.endereco.cep || null,
        notaFiscal.emitente.endereco.logradouro || null,
        notaFiscal.emitente.endereco.numero || null,
        notaFiscal.emitente.endereco.bairro || null,
        notaFiscal.emitente.endereco.complemento || null,
        notaFiscal.emitente.endereco.municipio || null,
        notaFiscal.emitente.endereco.codigoMunicipio || null,
        notaFiscal.emitente.endereco.pais || null,
        notaFiscal.emitente.endereco.codigoPais || null,
        notaFiscal.emitente.endereco.telefone || null,

        // Destinatário
        notaFiscal.destinatario.nome || null,
        notaFiscal.destinatario.fantasia || null,
        notaFiscal.destinatario.email || null,
        notaFiscal.destinatario.cpf || null,
        notaFiscal.destinatario.cnpj || null,
        notaFiscal.destinatario.inscricaoNacional || null,
        notaFiscal.destinatario.inscricaoMunicipal || null,
        notaFiscal.destinatario.inscricaoEstadual || null,
        notaFiscal.destinatario.inscricaoEstadualST || null,

        // Endereço Destinatário
        notaFiscal.destinatario.endereco.uf || null,
        notaFiscal.destinatario.endereco.cep || null,
        notaFiscal.destinatario.endereco.logradouro || null,
        notaFiscal.destinatario.endereco.numero || null,
        notaFiscal.destinatario.endereco.bairro || null,
        notaFiscal.destinatario.endereco.complemento || null,
        notaFiscal.destinatario.endereco.municipio || null,
        notaFiscal.destinatario.endereco.codigoMunicipio || null,
        notaFiscal.destinatario.endereco.pais || null,
        notaFiscal.destinatario.endereco.codigoPais || null,
        notaFiscal.destinatario.endereco.telefone || null,

        // Totais
        notaFiscal.total.baseCalculoIcms || 0,
        notaFiscal.total.valorIcms || 0,
        notaFiscal.total.valorIcmsDesonerado || 0,
        notaFiscal.total.baseCalculoIcmsST || 0,
        notaFiscal.total.baseCalculoIcmsSTRetido || 0,
        notaFiscal.total.valorIcmsST || 0,
        notaFiscal.total.valorIcmsSTRetido || 0,
        notaFiscal.total.valorProdutos || 0,
        notaFiscal.total.valorFrete || 0,
        notaFiscal.total.valorSeguro || 0,
        notaFiscal.total.valorDesconto || 0,
        notaFiscal.total.valorII || 0,
        notaFiscal.total.valorIPI || 0,
        notaFiscal.total.valorPIS || 0,
        notaFiscal.total.valorCOFINS || 0,
        notaFiscal.total.valorOutrasDespesas || 0,
        notaFiscal.total.valorNota || 0,
        notaFiscal.total.valorTotalTributos || 0,

        // Informações adicionais
        notaFiscal.informacoesComplementares || null,
        notaFiscal.informacoesFisco || null,
        notaFiscal.nrObservacoes || 0,

        // Loja (simplificado - assumindo que loja tem um id)
        notaFiscal.loja.codigo || null,

        // Tenant
        tenant_id,
      ];

      await DatabaseConnection.query(
        `INSERT INTO nota_fiscal (
                    natureza_operacao, nr_nota, serie, modelo, tipo_ambiente, tipo_operacao, operacao,
                    data_emissao, data_entrada_saida,
                    protocolo_numero, protocolo_chave, protocolo_data_hora_recebimento, protocolo_tipo_ambiente, protocolo_codigo_status_resposta,
                    emitente_nome, emitente_fantasia, emitente_email, emitente_cpf, emitente_cnpj, emitente_inscricao_nacional, 
                    emitente_inscricao_municipal, emitente_inscricao_estadual, emitente_inscricao_estadual_st, emitente_codigo_regime_tributario,
                    emitente_uf, emitente_cep, emitente_logradouro, emitente_numero, emitente_bairro, emitente_complemento,
                    emitente_municipio, emitente_codigo_municipio, emitente_pais, emitente_codigo_pais, emitente_telefone,
                    destinatario_nome, destinatario_fantasia, destinatario_email, destinatario_cpf, destinatario_cnpj, destinatario_inscricao_nacional,
                    destinatario_inscricao_municipal, destinatario_inscricao_estadual, destinatario_inscricao_estadual_st,
                    destinatario_uf, destinatario_cep, destinatario_logradouro, destinatario_numero, destinatario_bairro, destinatario_complemento,
                    destinatario_municipio, destinatario_codigo_municipio, destinatario_pais, destinatario_codigo_pais, destinatario_telefone,
                    total_base_calculo_icms, total_valor_icms, total_valor_icms_desonerado, total_base_calculo_icms_st, total_base_calculo_icms_st_retido,
                    total_valor_icms_st, total_valor_icms_st_retido, total_valor_produtos, total_valor_frete, total_valor_seguro, total_valor_desconto,
                    total_valor_ii, total_valor_ipi, total_valor_pis, total_valor_cofins, total_valor_outras_despesas, total_valor_nota, total_valor_tributos,
                    informacoes_complementares, informacoes_fisco, nr_observacoes, loja_id, tenant_id
                ) VALUES (
                    $1, $2, $3, $4, $5, $6, $7, 
                    $8,$9, $10, $11, $12, $13, $14,
                    $15, $16, $17, $18, $19, $20, $21, $22, $23, $24,
                    $25, $26, $27, $28, $29, $30, $31, $32, $33, $34, $35,
                    $36, $37, $38, $39, $40, $41, $42, $43, $44, $45,
                    $46, $47, $48, $49, $50, $51, $52, $53, $54, $55,
                    $56, $57, $58, $59, $60, $61, $62, $63, $64, $65,
                    $66, $67, $68, $69, $70, $71, $72, $73, $74, $75,
                    $76, $77, $78
                )`,
        params
      );
    }
  }
  async getAll(tenant_id: number): Promise<any> {
    const data = await DatabaseConnection.queryAll(
      `select f.cnpjcpf,f.nome,nfe.loja_id,nfe.serie,nfe.nr_nota ,nfe.data_emissao,nfe.total_valor_produtos,
      nfe.entrada_nota_etapa,
      nfe.lancamento_financeiro_etapa,
      nfe.alteracao_precos_etapa,
      nfe.romaneio_etapa,
      nfe.protocolo_chave

      from nota_fiscal_entrada nfe
      left join fornecedors f on
      nfe.codigo_fornecedor = f.codigo

      where nfe.tenant_id = $1 and f.tenant_id = $1`,
      [tenant_id]
    );
    return data;
  }

  async uploadXMLLote(lote: any, tenant_id: number): Promise<NotaFiscal[]> {
    let notas = [];
    // Define o diretório base de upload. Fica relativo ao diretório de trabalho
    // (e não a __dirname) para que o caminho seja o mesmo rodando via ts-node ou
    // pelo dist compilado — é nele que o volume do Docker é montado.
    const uploadBasePath = process.env.UPLOADS_DIR || path.resolve(process.cwd(), "uploads");

    // Define o diretório do tenant
    const tenantDir = path.join(uploadBasePath, String(tenant_id));

    // Cria o diretório se não existir
    await fs.mkdir(tenantDir, { recursive: true });

    // Salva apenas arquivos com extensão .xml
    for (const arquivo of lote) {
      const ext = path.extname(arquivo.originalname).toLowerCase();

      if (ext === ".xml") {
        const fileName = arquivo.originalname;
        const filePath = path.join(tenantDir, fileName);
        const xmlString = arquivo.buffer.toString("utf-8");
        if (xmlString.includes("<NFe") || xmlString.includes("<nfeProc")) {
          notas.push(NotaFiscalFactory.createFromXML(xmlString));
          await fs.writeFile(filePath, xmlString);
          await DatabaseConnection.query("INSERT INTO nota_fiscal_entrada_diretorio (arquivo, tenant_id) VALUES ($1, $2) ON CONFLICT (arquivo, tenant_id) DO NOTHING;", [fileName, tenant_id]);
        }
      }
    }
    return notas;
  }
}

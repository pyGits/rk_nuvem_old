import PDFDocument from "pdfkit";
import Loja from "../entity/Loja";
import { Recibo } from "../repository/ContaReceberReciboRepository";
import { maskMoney } from "../../masks/masks";

// Comprovante de recebimento. Gerado sob demanda a partir do que esta gravado,
// nunca guardado: reimprimir sai de graca e o papel nunca fica defasado do
// banco. Mesma forma do gerarRomaneio em NotaFiscalRepository - acumula os
// buffers do pdfkit e resolve base64, que e o que PDFService.exibirPDF espera.

// maskDateBR espera um Date; o pg devolve date ora como Date, ora como string
// 'YYYY-MM-DD' dependendo do caminho. Formatar errado aqui derruba a rota.
function formatarData(valor: any): string {
  if (!valor) return "";

  if (valor instanceof Date) {
    return `${String(valor.getDate()).padStart(2, "0")}/${String(valor.getMonth() + 1).padStart(2, "0")}/${valor.getFullYear()}`;
  }

  const [ano, mes, dia] = String(valor).substring(0, 10).split("-");
  return dia && mes && ano ? `${dia}/${mes}/${ano}` : String(valor);
}

// @types/pdfkit nao expoe o namespace PDFKit neste projeto; o tipo da instancia
// sai do proprio construtor.
type Documento = InstanceType<typeof PDFDocument>;

const COLUNAS = [
  { titulo: "Título", x: 40, largura: 130, alinhamento: "left" as const },
  { titulo: "Parc.", x: 175, largura: 35, alinhamento: "right" as const },
  { titulo: "Vencim.", x: 215, largura: 70, alinhamento: "right" as const },
  { titulo: "Valor", x: 290, largura: 75, alinhamento: "right" as const },
  // "Quitado" e nao "Recebido": a coluna mostra o abatimento (valor + desconto),
  // ou seja, quanto do titulo deixou de ser devido. A composicao esta nos totais.
  { titulo: "Quitado", x: 370, largura: 75, alinhamento: "right" as const },
  { titulo: "Saldo", x: 450, largura: 75, alinhamento: "right" as const },
];

function linhaDaTabela(doc: Documento, y: number, valores: string[], negrito = false): void {
  doc.font(negrito ? "Helvetica-Bold" : "Helvetica").fontSize(9);
  COLUNAS.forEach((coluna, i) => doc.text(valores[i], coluna.x, y, { width: coluna.largura, align: coluna.alinhamento }));
}

function totalizador(doc: Documento, y: number, rotulo: string, valor: number, negrito = false): void {
  doc.font(negrito ? "Helvetica-Bold" : "Helvetica").fontSize(negrito ? 11 : 9);
  doc.text(rotulo, 290, y, { width: 130, align: "right" });
  doc.text(maskMoney(valor), 425, y, { width: 100, align: "right" });
}

export default function gerarReciboPDF(recibo: Recibo, loja: Loja | null, emitidoEm: Date): Promise<string> {
  return new Promise((resolve, reject) => {
    const doc = new PDFDocument({ size: "A4", margin: 40 });
    const buffers: Buffer[] = [];

    doc.on("data", (data) => buffers.push(data));
    doc.on("end", () => resolve(Buffer.concat(buffers).toString("base64")));
    doc.on("error", reject);

    // Cabeçalho da loja
    doc.font("Helvetica-Bold").fontSize(14).text(loja?.nome || loja?.fantasia || "", 40, 40, { width: 380 });
    doc.font("Helvetica").fontSize(9).text(loja?.cnpjcpf ? `CNPJ/CPF: ${loja.cnpjcpf}` : "", 40, doc.y, { width: 380 });

    doc.font("Helvetica-Bold").fontSize(16).text(`RECIBO Nº ${String(recibo.reciboNumero).padStart(6, "0")}`, 380, 42, { width: 175, align: "right" });

    doc.moveTo(40, 88).lineTo(555, 88).stroke();

    doc.font("Helvetica-Bold").fontSize(12).text("RECIBO DE RECEBIMENTO", 40, 98);
    doc.font("Helvetica").fontSize(9);
    doc.text(`Data do recebimento: ${formatarData(recibo.dataPagamento)}          Emitido em: ${formatarData(emitidoEm)}`, 40, 116);

    doc.fontSize(10);
    doc.text(`Cliente: ${recibo.clienteCodigo}${recibo.clienteNome ? ` - ${recibo.clienteNome}` : ""}`, 40, 136);
    if (recibo.clienteCpf) doc.text(`CPF/CNPJ: ${recibo.clienteCpf}`, 40, doc.y);

    doc.font("Helvetica-Bold").fontSize(11).text(`Recebemos a importância de ${maskMoney(recibo.valorEmCaixa)}`, 40, doc.y + 8);
    doc.font("Helvetica").fontSize(9).text("referente aos títulos abaixo:", 40, doc.y + 2);

    // Títulos quitados
    let y = doc.y + 12;
    linhaDaTabela(
      doc,
      y,
      COLUNAS.map((coluna) => coluna.titulo),
      true
    );

    y += 14;
    doc.moveTo(40, y - 3).lineTo(555, y - 3).stroke();

    recibo.titulos.forEach((titulo) => {
      linhaDaTabela(doc, y, [titulo.codigo, String(titulo.prestacao), formatarData(titulo.dataVencimento), maskMoney(titulo.valorTitulo), maskMoney(titulo.valorRecebimento + titulo.descontoRecebimento), maskMoney(titulo.saldoTitulo)]);
      y += 13;
    });

    doc.moveTo(40, y + 2).lineTo(555, y + 2).stroke();
    y += 12;

    // Totais. O negrito fica no total pago - juros e multa entram em caixa mas
    // nao abatem o titulo, e o desconto abate sem entrar em caixa.
    totalizador(doc, y, "Valor recebido (abate)", recibo.valor);
    totalizador(doc, (y += 14), "(+) Juros", recibo.juros);
    totalizador(doc, (y += 14), "(+) Multa", recibo.multa);
    totalizador(doc, (y += 14), "(-) Desconto", recibo.desconto);
    totalizador(doc, (y += 18), "TOTAL PAGO", recibo.valorEmCaixa, true);

    y += 30;
    doc.font("Helvetica").fontSize(10);
    doc.text(`Forma de pagamento: ${recibo.formaPagamentoNome || recibo.formaPagamento || "-"}`, 40, y);

    // Dois saldos, ambos rotulados. O do recibo e congelado; o do cliente e de
    // agora - por isso a data de emissao aparece junto, senao uma 2a via de
    // meses depois mentiria sobre quanto o cliente deve.
    const saldoDoRecibo = recibo.titulos.reduce((total, titulo) => total + titulo.saldoTitulo, 0);
    doc.text(`Saldo dos títulos deste recibo: ${maskMoney(saldoDoRecibo)}`, 40, (y += 16));

    // Tarja de estorno: sem ela a reimpressao de um recibo estornado vira
    // comprovante de um pagamento que nao existe mais.
    if (recibo.estornado === 1 || recibo.estornadoParcial) {
      doc.save();
      doc.rotate(-20, { origin: [300, 400] });
      doc.font("Helvetica-Bold").fontSize(recibo.estornadoParcial ? 34 : 52).fillColor("red").opacity(0.35);
      doc.text(recibo.estornadoParcial ? "ESTORNADO PARCIALMENTE" : "ESTORNADO", 60, 380, { width: 500, align: "center" });
      doc.restore();
      doc.opacity(1).fillColor("black");
    }

    y += 60;
    doc.font("Helvetica").fontSize(10);
    doc.text("______________________________________", 40, y);
    doc.fontSize(9).text("Assinatura do recebedor", 40, (y += 14));
    doc.fontSize(8).fillColor("gray").text("Documento sem valor fiscal", 40, (y += 20));

    doc.end();
  });
}

import PDFDocument from "pdfkit";
import Loja from "../entity/Loja";
import { Recibo } from "../repository/ContaReceberReciboRepository";
import { maskMoney } from "../../masks/masks";

// Comprovante de recebimento em CUPOM 80mm, para a térmica do caixa (Elgin i9).
// Gerado sob demanda a partir do que está gravado, nunca guardado: reimprimir
// sai de graça e o papel nunca fica defasado do banco. Acumula os buffers do
// pdfkit e resolve base64, que é o que PDFService.exibirPDF espera.
//
// O que a i9 impõe ao layout:
//   - bobina de 80mm = 226.77pt, mas a área imprimível é de 72mm (576 dots a
//     203dpi). A margem de 12pt deixa a coluna em ~71,5mm; o que passar disso
//     sai cortado na lateral.
//   - 203dpi é pouco para corpo miúdo: abaixo de 8pt a térmica come o traço
//     fino e o texto sai lavado. 8pt é o piso do cupom.
//   - separador é fileira de "-" e não linha vetorial: traço de meio ponto vira
//     pontilhado irregular na cabeça térmica, caractere sai sempre igual.
const LARGURA_PAPEL = 226.77;
const MARGEM = 12;
const LARGURA = LARGURA_PAPEL - MARGEM * 2;

// Courier e não Helvetica: em cupom o que se lê são colunas de valores, e a
// monoespaçada alinha os centavos sozinha. 9pt dá 37 colunas na largura útil.
const CORPO = 9;
const MIUDO = 8;
const FONTE = "Courier";
const FONTE_NEGRITO = "Courier-Bold";
const COLUNAS = Math.floor(LARGURA / (0.6 * CORPO));
const REGUA = "-".repeat(COLUNAS);

// No par rótulo/valor o rótulo fica com 62% da linha e o valor com o resto,
// alinhado à direita. "SALDO APÓS PAGAMENTO:" é o rótulo mais longo que
// precisa caber em uma linha só - a divisão sai daí.
const LARGURA_ROTULO = LARGURA * 0.62;
const LARGURA_VALOR = LARGURA - LARGURA_ROTULO;

type Alinhamento = "left" | "center" | "right";

// O cupom é papel contínuo: a altura da página é o tamanho do conteúdo, que só
// se sabe depois de montar tudo. Por isso o comprovante é descrito como uma
// lista de blocos, medido em um documento descartável e só então desenhado no
// documento de verdade, já com a altura certa. Sem isso sobraria papel em
// branco no fim de todo recibo curto - ou o de muitos títulos quebraria em
// duas páginas no meio do resumo.
type Bloco =
  | { tipo: "texto"; texto: string; alinhamento?: Alinhamento; negrito?: boolean; tamanho?: number }
  | { tipo: "par"; rotulo: string; valor: string; negrito?: boolean; tamanho?: number }
  | { tipo: "separador" }
  | { tipo: "espaco"; altura: number };

// @types/pdfkit nao expoe o namespace PDFKit neste projeto; o tipo da instancia
// sai do proprio construtor.
type Documento = InstanceType<typeof PDFDocument>;

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

// Vencimento na linha do título vai abreviado (dd/mm/aa): com o ano cheio a
// linha "título + parcela + vencimento + valor" não cabe nas 37 colunas.
function dataCurta(valor: any): string {
  const completa = formatarData(valor);
  return completa.length === 10 ? `${completa.substring(0, 6)}${completa.substring(8)}` : completa;
}

function ehPassado(valor: any): boolean {
  const data = new Date(String(valor).substring(0, 10));
  const hoje = new Date();
  hoje.setHours(0, 0, 0, 0);
  return data.getTime() < hoje.getTime();
}

// O título é gravado preenchido ("000123") e o cadastro web usa "123". Na tela
// o operador vê sem os zeros; o cupom acompanha, senão o número que ele confere
// de olho não bate com o da grade.
function semZerosEsquerda(codigo: any): string {
  const texto = String(codigo ?? "").trim();
  if (!/^[0-9]+$/.test(texto)) return texto;
  return texto.replace(/^0+/, "") || "0";
}

function alturaDoBloco(doc: Documento, bloco: Bloco): number {
  if (bloco.tipo === "espaco") return bloco.altura;
  if (bloco.tipo === "separador") return doc.font(FONTE).fontSize(CORPO).heightOfString(REGUA, { width: LARGURA }) + 1;

  doc.font(bloco.negrito ? FONTE_NEGRITO : FONTE).fontSize(bloco.tamanho || CORPO);

  if (bloco.tipo === "texto") return doc.heightOfString(bloco.texto, { width: LARGURA, align: bloco.alinhamento || "left" }) + 1;

  // O par ocupa a maior das duas colunas: rótulo comprido quebra em duas linhas
  // em vez de escrever por cima do valor.
  return Math.max(doc.heightOfString(bloco.rotulo, { width: LARGURA_ROTULO }), doc.heightOfString(bloco.valor, { width: LARGURA_VALOR })) + 1;
}

function desenharBloco(doc: Documento, bloco: Bloco, y: number): void {
  if (bloco.tipo === "espaco") return;

  if (bloco.tipo === "separador") {
    doc.font(FONTE).fontSize(CORPO).text(REGUA, MARGEM, y, { width: LARGURA, align: "left" });
    return;
  }

  doc.font(bloco.negrito ? FONTE_NEGRITO : FONTE).fontSize(bloco.tamanho || CORPO);

  if (bloco.tipo === "texto") {
    doc.text(bloco.texto, MARGEM, y, { width: LARGURA, align: bloco.alinhamento || "left" });
    return;
  }

  doc.text(bloco.rotulo, MARGEM, y, { width: LARGURA_ROTULO, align: "left" });
  doc.text(bloco.valor, MARGEM + LARGURA_ROTULO, y, { width: LARGURA_VALOR, align: "right" });
}

function montarBlocos(recibo: Recibo, loja: Loja | null): Bloco[] {
  const blocos: Bloco[] = [];
  const estornado = recibo.estornado === 1 || recibo.estornadoParcial;

  // Tudo que o resumo imprime sai dos títulos do próprio recibo, com o saldo
  // congelado no momento do recebimento (saldoNoRecibo). É o que faz a 2ª via
  // repetir a 1ª mesmo que o cliente tenha pago ou comprado mais desde então.
  const saldoDepois = recibo.titulos.reduce((total, titulo) => total + titulo.saldoNoRecibo, 0);

  // O que o recebimento abateu. Em operação normal é o próprio valor pago - a
  // loja não trabalha com juros, multa nem desconto, e as linhas correspondentes
  // ficam fora do cupom. As duas exceções abaixo existem para o caso de um
  // recebimento antigo ou importado trazer esses valores gravados: sem elas o
  // cupom mostraria "anterior - pago" que não fecha com o saldo.
  const abatimento = recibo.valor + recibo.desconto;
  const acrescimo = recibo.juros + recibo.multa;
  const quitado = saldoDepois < 0.005;
  const nomeLoja = (loja?.nome || loja?.fantasia || "").toUpperCase();

  // Próxima cobrança: o vencimento mais antigo que continuou em aberto depois
  // deste pagamento. É o que faz o mesmo cupom servir a quem paga por semana,
  // por mês ou sem periodicidade nenhuma - em vez de supor a cadência, imprime
  // a data concreta que o cliente reconhece.
  const emAberto = recibo.titulos.filter((titulo) => titulo.saldoNoRecibo > 0.005).map((titulo) => titulo.dataVencimento);
  const proximoVencimento = emAberto.length ? emAberto.reduce((menor, atual) => (new Date(atual) < new Date(menor) ? atual : menor)) : null;

  blocos.push({ tipo: "espaco", altura: 2 });
  if (nomeLoja) blocos.push({ tipo: "texto", texto: nomeLoja, alinhamento: "center", negrito: true, tamanho: 10 });
  if (loja?.cnpjcpf) blocos.push({ tipo: "texto", texto: `CNPJ: ${loja.cnpjcpf}`, alinhamento: "center", tamanho: MIUDO });

  blocos.push({ tipo: "espaco", altura: 8 });
  blocos.push({ tipo: "texto", texto: "RECIBO DE PAGAMENTO", alinhamento: "center", negrito: true, tamanho: 10 });
  blocos.push({ tipo: "texto", texto: "CONVÊNIO", alinhamento: "center", negrito: true, tamanho: 10 });
  blocos.push({ tipo: "separador" });

  // Sem esta tarja a reimpressão de um recibo estornado vira comprovante de um
  // pagamento que não existe mais. Em cupom ela vai no topo, em linha cheia: a
  // diagonal da via A4 não sobrevive a 80mm de largura.
  if (estornado) {
    blocos.push({ tipo: "texto", texto: recibo.estornadoParcial ? "*** ESTORNADO PARCIALMENTE ***" : "*** RECIBO ESTORNADO ***", alinhamento: "center", negrito: true });
    blocos.push({ tipo: "separador" });
  }

  blocos.push({ tipo: "par", rotulo: "Recibo nº:", valor: String(recibo.reciboNumero).padStart(6, "0") });
  blocos.push({ tipo: "par", rotulo: "Data:", valor: formatarData(recibo.dataPagamento) });

  blocos.push({ tipo: "espaco", altura: 6 });
  blocos.push({ tipo: "texto", texto: "CLIENTE", negrito: true });
  blocos.push({ tipo: "texto", texto: `${semZerosEsquerda(recibo.clienteCodigo)}${recibo.clienteNome ? ` - ${recibo.clienteNome}` : ""}` });
  if (recibo.clienteCpf) blocos.push({ tipo: "texto", texto: `CPF/CNPJ: ${recibo.clienteCpf}` });
  blocos.push({ tipo: "separador" });

  // Os títulos são o que faz o mesmo cupom servir a quem paga por semana, por
  // mês ou sem cadência nenhuma: em vez de falar em "mensalidade", lista as
  // datas que o cliente reconhece.
  if (recibo.titulos.length) {
    blocos.push({ tipo: "texto", texto: `TÍTULOS QUITADOS (${recibo.titulos.length})`, negrito: true });
    recibo.titulos.forEach((titulo) => {
      // "Quitado" e não "recebido": a linha mostra o abatimento (valor +
      // desconto), ou seja, quanto daquele título deixou de ser devido.
      blocos.push({
        tipo: "par",
        rotulo: `${semZerosEsquerda(titulo.codigo)}/${String(titulo.prestacao).padStart(2, "0")} v.${dataCurta(titulo.dataVencimento)}`,
        valor: maskMoney(titulo.valorRecebimento + titulo.descontoRecebimento),
        tamanho: MIUDO,
      });
    });
    blocos.push({ tipo: "separador" });
  }

  blocos.push({ tipo: "texto", texto: "RESUMO DO CONVÊNIO", negrito: true });

  // Recibo estornado não tem "saldo anterior" que se possa reconstruir: o
  // estorno tirou este recebimento da conta do saldo, e somar o abatimento de
  // volta imprimiria uma dívida que o cliente nunca teve.
  if (!estornado) blocos.push({ tipo: "par", rotulo: "Saldo anterior:", valor: maskMoney(saldoDepois + abatimento) });

  blocos.push({ tipo: "par", rotulo: "Valor pago:", valor: maskMoney(recibo.valorEmCaixa) });
  if (acrescimo) blocos.push({ tipo: "par", rotulo: " (+) Juros/multa:", valor: maskMoney(acrescimo), tamanho: MIUDO });
  if (recibo.desconto) blocos.push({ tipo: "par", rotulo: " (-) Desconto:", valor: maskMoney(recibo.desconto), tamanho: MIUDO });
  blocos.push({ tipo: "par", rotulo: "Forma de pagamento:", valor: recibo.formaPagamentoNome || recibo.formaPagamento || "-" });

  blocos.push({ tipo: "separador" });
  blocos.push({ tipo: "par", rotulo: estornado ? "SALDO DOS TÍTULOS:" : "SALDO APÓS PAGAMENTO:", valor: maskMoney(saldoDepois), negrito: true });
  blocos.push({ tipo: "separador" });

  if (!estornado) {
    blocos.push({ tipo: "espaco", altura: 8 });
    blocos.push({ tipo: "texto", texto: quitado ? "CONVÊNIO QUITADO" : "PAGAMENTO PARCIAL", alinhamento: "center", negrito: true, tamanho: 10 });

    // Quem ficou devendo leva no papel a data da próxima cobrança.
    if (!quitado && proximoVencimento) {
      blocos.push({ tipo: "espaco", altura: 4 });
      blocos.push({
        tipo: "par",
        rotulo: ehPassado(proximoVencimento) ? "Em atraso desde:" : "Próx. vencimento:",
        valor: formatarData(proximoVencimento),
        tamanho: MIUDO,
      });
    }
  }

  blocos.push({ tipo: "espaco", altura: 10 });
  if (estornado) {
    blocos.push({ tipo: "texto", texto: "Este recebimento foi estornado e não vale como comprovante de pagamento.", alinhamento: "center", tamanho: MIUDO });
  } else {
    blocos.push({
      tipo: "texto",
      texto: `Recebemos do cliente acima identificado o valor de ${maskMoney(recibo.valorEmCaixa)}, referente ${quitado ? "à quitação de seu convênio" : "ao pagamento parcial de seu convênio"}.`,
      alinhamento: "center",
      tamanho: MIUDO,
    });
  }

  blocos.push({ tipo: "espaco", altura: 12 });
  blocos.push({ tipo: "texto", texto: "Obrigado pela preferência!", alinhamento: "center" });
  if (nomeLoja) {
    blocos.push({ tipo: "espaco", altura: 6 });
    blocos.push({ tipo: "texto", texto: nomeLoja, alinhamento: "center", negrito: true, tamanho: MIUDO });
  }

  blocos.push({ tipo: "espaco", altura: 8 });
  blocos.push({ tipo: "texto", texto: "Documento sem valor fiscal", alinhamento: "center", tamanho: MIUDO });
  // Avanço para o corte: a guilhotina da i9 corta acima da borda do papel, e
  // sem esta sobra a última linha sai na serrilha.
  blocos.push({ tipo: "espaco", altura: 40 });

  return blocos;
}

export default function gerarReciboPDF(recibo: Recibo, loja: Loja | null): Promise<string> {
  return new Promise((resolve, reject) => {
    const blocos = montarBlocos(recibo, loja);

    // Documento só para medir: mesmas fontes e mesmas larguras, então a altura
    // que ele calcula é a que o conteúdo vai ocupar de verdade. Nunca recebe
    // end(), nada é emitido a partir dele.
    const medidor = new PDFDocument({ size: [LARGURA_PAPEL, 100], margin: MARGEM });
    const alturas = blocos.map((bloco) => alturaDoBloco(medidor, bloco));
    const altura = Math.ceil(alturas.reduce((total, valor) => total + valor, 0)) + MARGEM * 2;

    const doc = new PDFDocument({ size: [LARGURA_PAPEL, altura], margin: MARGEM });
    const buffers: Buffer[] = [];

    doc.on("data", (data) => buffers.push(data));
    doc.on("end", () => resolve(Buffer.concat(buffers).toString("base64")));
    doc.on("error", reject);

    let y = MARGEM;
    blocos.forEach((bloco, i) => {
      desenharBloco(doc, bloco, y);
      y += alturas[i];
    });

    doc.end();
  });
}

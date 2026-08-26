import ContaReceberTitulo from "./ContaReceberTitulo";
import ContaReceberTituloList from "./ContaReceberTituloList";

// Documento do lancamento manual: gera N titulos (parcelas) a partir do valor,
// do numero de parcelas e do intervalo. Titulo vindo do PDV nao passa por aqui -
// ele ja chega parcelado do crediario.
export default class ContaReceber {
  constructor(
    public lojaId = 0,
    public clienteCodigo = "",
    public clienteCpf = "",
    public descricao = "",
    public valorNominal = 0,
    public parcelas = 1,
    public intervalo = 1,
    public tipoIntervalo = "mes",
    public dataEmissao = "",
    public dataVencimento = "",
    public codigo = "",
    public titulos = new ContaReceberTituloList()
  ) {}

  // As datas do modulo sao string 'YYYY-MM-DD'; so o calculo de vencimento
  // passa por Date, e volta ao formato aqui.
  static formatarData(data: Date): string {
    const mes = String(data.getMonth() + 1).padStart(2, "0");
    const dia = String(data.getDate()).padStart(2, "0");
    return `${data.getFullYear()}-${mes}-${dia}`;
  }

  atualizar() {
    this.gerarTitulos();
  }

  valorTotal(): number {
    return Number(this.valorNominal);
  }

  validate() {
    if (!this.lojaId) throw new Error("Loja não selecionada");
    if (String(this.clienteCodigo).trim() === "") throw new Error("Cliente não selecionado");
    if (this.descricao.trim() === "") throw new Error("Descrição obrigatória");
    if (this.valorTotal() <= 0) throw new Error("Total não pode ser 0 ou negativo");
    if (this.titulos.items.length === 0) throw new Error("Nenhum título gerado");
  }

  gerarTitulos() {
    if (this.valorNominal <= 0) throw new Error("Valor não pode ser 0 ou negativo");
    if (this.parcelas <= 0 || this.intervalo <= 0) throw new Error("Parcelas/intervalo inválidos");

    this.titulos.limpar();
    const valorParcela = Number((this.valorTotal() / this.parcelas).toFixed(2));

    for (let i = 0; i < this.parcelas; i++) {
      const vencimento = new Date(`${this.dataVencimento}T00:00:00`);
      if (this.tipoIntervalo === "dias") vencimento.setDate(vencimento.getDate() + this.intervalo * i);
      else vencimento.setMonth(vencimento.getMonth() + this.intervalo * i);

      // A ultima parcela absorve a diferenca do arredondamento para a soma das
      // parcelas fechar com o total lancado.
      const valor = i === this.parcelas - 1 ? Number((this.valorTotal() - valorParcela * (this.parcelas - 1)).toFixed(2)) : valorParcela;

      const titulo = new ContaReceberTitulo("", "", this.lojaId, this.clienteCodigo, this.clienteCpf, "", "", i + 1, "", "", this.dataEmissao, ContaReceber.formatarData(vencimento), valor, this.descricao, "MANUAL");
      this.titulos.adicionarTitulo(titulo);
    }
  }
}

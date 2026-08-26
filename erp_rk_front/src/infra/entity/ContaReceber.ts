import ContaReceberTitulo from "./ContaReceberTitulo";
import ContaReceberTituloList from "./ContaReceberTituloList";

// Lançamento manual: gera as parcelas a partir do valor, do número de parcelas
// e do intervalo. Título vindo do PDV não passa por aqui — ele já chega
// parcelado do crediário.
export default class ContaReceber {
  constructor(
    public lojaId = 0,
    public clienteCodigo = "",
    public clienteCpf = "",
    public clienteNome = "",
    public descricao = "",
    public valorNominal = 0,
    public parcelas = 1,
    public intervalo = 1,
    public tipoIntervalo = "mes",
    public dataEmissao = "",
    public dataVencimento = "",
    public titulos = new ContaReceberTituloList()
  ) {}

  static formatarData(data: Date): string {
    const mes = String(data.getMonth() + 1).padStart(2, "0");
    const dia = String(data.getDate()).padStart(2, "0");
    return `${data.getFullYear()}-${mes}-${dia}`;
  }

  valorTotal(): number {
    return Number(this.valorNominal);
  }

  // Chamada a cada mudança nos campos, para a grid de parcelas acompanhar.
  atualizar() {
    if (this.valorNominal <= 0 || this.parcelas <= 0 || this.intervalo <= 0 || !this.dataVencimento) {
      this.titulos.limpar();
      return;
    }
    this.gerarTitulos();
  }

  validate() {
    if (!this.lojaId) throw new Error("Selecione a loja");
    if (String(this.clienteCodigo).trim() === "") throw new Error("Selecione o cliente");
    if (this.descricao.trim() === "") throw new Error("Descrição obrigatória");
    if (this.valorTotal() <= 0) throw new Error("Valor não pode ser 0 ou negativo");
    if (!this.dataVencimento) throw new Error("Informe o vencimento");
    if (this.titulos.items.length === 0) throw new Error("Nenhuma parcela gerada");
  }

  gerarTitulos() {
    this.titulos.limpar();
    const valorParcela = Number((this.valorTotal() / this.parcelas).toFixed(2));

    for (let i = 0; i < this.parcelas; i++) {
      const vencimento = new Date(`${this.dataVencimento}T00:00:00`);
      if (this.tipoIntervalo === "dias") vencimento.setDate(vencimento.getDate() + this.intervalo * i);
      else vencimento.setMonth(vencimento.getMonth() + this.intervalo * i);

      // A última parcela absorve a diferença do arredondamento para a soma
      // fechar com o total lançado.
      const valor = i === this.parcelas - 1 ? Number((this.valorTotal() - valorParcela * (this.parcelas - 1)).toFixed(2)) : valorParcela;

      this.titulos.adicionarTitulo(
        new ContaReceberTitulo("", "", this.lojaId, this.clienteCodigo, this.clienteCpf, "", "", i + 1, "", "", this.dataEmissao, ContaReceber.formatarData(vencimento), valor, this.descricao, "MANUAL")
      );
    }
  }
}

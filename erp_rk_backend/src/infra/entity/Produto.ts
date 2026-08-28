import Estoque from "./Estoque";
import Preco from "./Preco";
export default class Produto {
  constructor(
    public codigo = "",
    public codigo_barras = "",
    public descricao = "",
    public secao = "",
    public fornecedor = "",
    public grupo = "",
    public subgrupo = "",
    public unidade = "UN",
    public forma_venda = "N",
    public ncm = "",
    public cest = "",
    public tributacao = "",
    public balanca = "",
    public balanca_validade = 0,
    public diversos = "",
    public ativo = "",
    public impfederal = "",
    public precos: Preco[] = [],
    public estoques: Estoque[] = []
  ) {}

  validate() {
    if (this.codigo_barras.trim() === "") throw new Error("Código de barras não pode estar em branco");
    if (this.descricao.trim() === "") throw new Error("Nome do produto em branco !");
    if (this.ncm.trim() === "") throw new Error("NCM Em branco !");
    if (this.ncm.trim() === "00000000") throw new Error("NCM inválido !");
    // NCM tem 8 digitos, sempre. O padStart de create() completa os curtos mas
    // nao corta os longos, e a coluna e varchar(8): sem esta linha o produto
    // morria no banco com "value too long", sem dizer qual campo.
    if (this.ncm.trim().length !== 8) throw new Error("NCM deve ter 8 dígitos !");
    if (this.tributacao.trim() === "") throw new Error("Tributação em branco !");
  }
  static create(data: any) {
    const ncm = String(data.ncm).replace(/\D/g, "").padStart(8, "0");
    const cest = String(data.cest).replace(/\D/g, "").padStart(7, "0");
    return new Produto(data.codigo, data.codigo_barras, data.descricao, data.secao, data.fornecedor, data.grupo, data.subgrupo, data.unidade, data.forma_venda, ncm, cest, data.tributacao, data.balanca, data.balanca_validade, data.diversos, data.ativo, data.impfederal, data.precos, data.estoques);
  }
}

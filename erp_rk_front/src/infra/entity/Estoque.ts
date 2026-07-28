import Loja from "./Loja";

export default class Estoque {
  constructor(public codigo_produto = "", public lojaId = "", public estoque = 0, public estoque_minimo = 0, public estoque_maximo = 0, public chave_xml = "", public loja: Loja = new Loja()) {}
}

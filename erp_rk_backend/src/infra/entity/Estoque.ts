import Loja from "./Loja";

export default class Estoque {
  constructor(public codigo_produto: string, public lojaId: number, public estoque: number, public estoque_minimo: number, public estoque_maximo: number, public chave_xml: string, public loja: Loja = new Loja()) {}
}

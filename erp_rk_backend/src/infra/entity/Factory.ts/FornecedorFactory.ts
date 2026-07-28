import Fornecedor from "../Fornecedor";
import { NotaFiscal } from "../NotaFiscal";

export default class FornecedorFactory {
  static createFromNotaFiscal(nota: NotaFiscal) {
    return new Fornecedor(
      "",
      nota.emitente.cnpj,
      nota.emitente.nome,
      nota.emitente.fantasia,
      nota.emitente.inscricaoEstadual,
      nota.emitente.endereco.uf,
      nota.emitente.inscricaoMunicipal,
      nota.emitente.endereco.telefone,
      "",
      "",
      nota.emitente.email,
      "",
      nota.emitente.endereco.cep,
      nota.emitente.endereco.logradouro,
      nota.emitente.endereco.municipio,
      nota.emitente.endereco.bairro,
      nota.emitente.endereco.complemento,
      Number(nota.emitente.endereco.codigoMunicipio)
    );
  }
}

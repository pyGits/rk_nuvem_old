// import Associacao from "../entity/Associacao";
import AssociacaoRepository from "../repository/AssociacaoRepository";
import { Associacao } from "../entity/NotaFiscalItem";

export default class AssociacaoController {
  constructor(readonly associacaoRepository: AssociacaoRepository) {}
  async insert(associacao: Associacao): Promise<Output> {
    associacao.validate();
    await this.associacaoRepository.insert(associacao);

    return { status: 201 };
  }
}
type Input = {
  data: any;
};
type Output = {
  status: number;
  data?: any;
};

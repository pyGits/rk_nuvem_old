import SequencialRepository from "../repository/SequencialRepository";

class SequencialUseCase {
  async gerarSequencial(input: { tabela: string; coluna: string; tenant_id: number }): Promise<string> {
    return SequencialRepository.get(input.tabela, input.coluna, input.tenant_id);
  }
}
export default new SequencialUseCase();

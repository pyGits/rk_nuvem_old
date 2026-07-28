import ContaPagarTitulo from "../entity/ContaPagarTitulo";
import ContaPagarTituloRepository, { ContaPagarTituloRepositoryApi } from "../repository/ContaPagarTituloRepository";
import ToastService from "./ToastService";

export class ContaPagarTituloService {
  contaPagarTituloRepository: ContaPagarTituloRepository;
  constructor() {
    this.contaPagarTituloRepository = new ContaPagarTituloRepositoryApi();
  }

  async update(titulo: ContaPagarTitulo) {
    titulo.validate();
    await this.contaPagarTituloRepository.update(titulo);
    ToastService.showSuccess("Título Atualizado Com Sucesso !");
  }
}

export default new ContaPagarTituloService();

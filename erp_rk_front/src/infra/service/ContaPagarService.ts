import ContaPagar from "../entity/ContaPagar";
import ContaPagarTituloList from "../entity/ContaPagarTituloList";
import ContaPagarRepository, { ContaPagarRepositoryApi } from "../repository/ContaPagarRepository";
import ContaPagarTituloRepository, { ContaPagarTituloRepositoryApi } from "../repository/ContaPagarTituloRepository";
import ToastService from "./ToastService";

class ContaPagarService {
  contaPagarRepository: ContaPagarRepository;
  contaPagarTituloRepository: ContaPagarTituloRepository;
  constructor() {
    this.contaPagarRepository = new ContaPagarRepositoryApi();
    this.contaPagarTituloRepository = new ContaPagarTituloRepositoryApi();
  }
  async getAllTitulos(filtro: any) {
    const list = await this.contaPagarTituloRepository.getAll(filtro);
    return list;
  }
  async insert(contaPagar: ContaPagar) {
    contaPagar.validate();
    await this.contaPagarRepository.insert(contaPagar);
    ToastService.showSuccess("Conta Inserida com Sucesso !");
  }

  async getByCodigo(codigo: string) {
    const conta = await this.contaPagarRepository.getByCodigo(codigo);
    return conta;
  }

  async getAll() {
    const list = await this.contaPagarRepository.getAll();
    return list;
  }
  async liquidarTitulos(titulos: ContaPagarTituloList) {
    await this.contaPagarTituloRepository.liquidar(titulos);
    ToastService.showSuccess("Títulos Pagos com sucesso !");
  }
  async estornarTitulos(titulos: ContaPagarTituloList) {
    titulos.estornarTitulos();
    await this.contaPagarTituloRepository.estornar(titulos);
    ToastService.showSuccess("Títulos Estornados Com Sucesso !");
  }
  async cancelarTitulos(titulos: ContaPagarTituloList) {
    titulos.cancelarTitulos();
    await this.contaPagarTituloRepository.cancelar(titulos);
    ToastService.showSuccess("Títulos Cancelados Com Sucesso !");
  }
}
export default new ContaPagarService();

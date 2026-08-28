import ContaReceber from "../entity/ContaReceber";
import ContaReceberTitulo from "../entity/ContaReceberTitulo";
import ContaReceberTituloList from "../entity/ContaReceberTituloList";
import RecebimentoTitulo from "../entity/RecebimentoTitulo";
import ContaReceberRepository, { ContaReceberRepositoryApi } from "../repository/ContaReceberRepository";
import ToastService from "./ToastService";

class ContaReceberService {
  contaReceberRepository: ContaReceberRepository;
  constructor() {
    this.contaReceberRepository = new ContaReceberRepositoryApi();
  }

  async getAllTitulos(filtro: any) {
    return await this.contaReceberRepository.getAll(filtro);
  }

  async getExtrato(filtro: any) {
    return await this.contaReceberRepository.getExtrato(filtro);
  }

  async insert(contaReceber: ContaReceber) {
    contaReceber.validate();
    await this.contaReceberRepository.insert(contaReceber);
    ToastService.showSuccess("Conta a receber lançada com sucesso !");
  }

  async receber(titulos: ContaReceberTituloList, recebimento: RecebimentoTitulo) {
    titulos.validarRecebimento(recebimento);
    const recibo = await this.contaReceberRepository.receber(titulos, recebimento);
    ToastService.showSuccess(`Recebimento lançado com sucesso ! Recibo nº ${recibo?.reciboNumero ?? ""}`);
    return recibo;
  }

  async getSaldoClientes(filtro: any) {
    return await this.contaReceberRepository.getSaldoClientes(filtro);
  }

  async getRecibos(filtro: any) {
    return await this.contaReceberRepository.getRecibos(filtro);
  }

  // Devolve o base64 do PDF; quem chama decide como exibir.
  async gerarRecibo(reciboId: string) {
    const recibo = await this.contaReceberRepository.gerarRecibo(reciboId);
    if (!recibo?.arquivo) throw new Error("Não foi possível gerar o recibo !");
    return recibo;
  }

  async estornarRecibo(reciboId: string) {
    await this.contaReceberRepository.estornarRecibo(reciboId);
    ToastService.showSuccess("Recibo estornado com sucesso !");
  }

  async estornar(titulos: ContaReceberTituloList) {
    titulos.validarEstornar();
    await this.contaReceberRepository.estornar(titulos);
    ToastService.showSuccess("Títulos estornados com sucesso !");
  }

  async cancelar(titulos: ContaReceberTituloList) {
    titulos.validarCancelar();
    await this.contaReceberRepository.cancelar(titulos);
    ToastService.showSuccess("Títulos cancelados com sucesso !");
  }

  async update(titulo: ContaReceberTitulo) {
    if (titulo.valor <= 0) throw new Error("Valor não pode ser 0 ou negativo !");
    if (!titulo.dataVencimento) throw new Error("Informe o vencimento !");
    await this.contaReceberRepository.update(titulo);
    ToastService.showSuccess("Título alterado com sucesso !");
  }
}

export default new ContaReceberService();

import FormaPagamento from "../entity/FormaPagamento";
import FormaPagamentoRepository, { FormaPagamentoRepositoryApi } from "../repository/FormaPagamentoRepository";
import ToastService from "./ToastService";

class FormaPagamentoService {
  formaPagamentoRepository: FormaPagamentoRepository;
  constructor() {
    this.formaPagamentoRepository = new FormaPagamentoRepositoryApi();
  }
  async delete(formaPagamento: FormaPagamento) {
    await this.formaPagamentoRepository.delete(formaPagamento);
    ToastService.showSuccess("Forma Pagamento deletada com sucesso !");
  }
  async insert(formaPagamento: FormaPagamento) {
    await this.formaPagamentoRepository.insert(formaPagamento);
    ToastService.showSuccess("Forma Pagamento inserida com sucesso !");
  }
  async update(formaPagamento: FormaPagamento) {
    await this.formaPagamentoRepository.update(formaPagamento);
    ToastService.showSuccess("Forma Pagamento atualizada com sucesso !");
  }
  async getAll() {
    const list = await this.formaPagamentoRepository.getAll();
    return list;
  }
}
export default new FormaPagamentoService();

import CategoriaFinanceira from "../entity/CategoriaFinanceira";
import CategoriaFinanceiraRepository, { CategoriaFinanceiraRepositoryApi } from "../repository/CategoriaFinanceiraRepository";
import ToastService from "./ToastService";

class CategoriaFinanceiraService {
  categoriaFinanceiraRepository: CategoriaFinanceiraRepository;
  constructor() {
    this.categoriaFinanceiraRepository = new CategoriaFinanceiraRepositoryApi();
  }
  async delete(categoriaFinanceira: CategoriaFinanceira) {
    await this.categoriaFinanceiraRepository.delete(categoriaFinanceira);
    ToastService.showSuccess("Categoria deletada com sucesso !");
  }
  async insert(categoriaFinanceira: CategoriaFinanceira) {
    await this.categoriaFinanceiraRepository.insert(categoriaFinanceira);
    ToastService.showSuccess("Categoria inserida com sucesso !");
  }
  async update(categoriaFinanceira: CategoriaFinanceira) {
    await this.categoriaFinanceiraRepository.update(categoriaFinanceira);
    ToastService.showSuccess("Categoria atualizada com sucesso !");
  }
  async getAll() {
    const list = await this.categoriaFinanceiraRepository.getAll();
    return list;
  }
  async getAllWithSubCategorias() {
    const list = await this.categoriaFinanceiraRepository.getAllWithSubCategorias();
    return list;
  }
  async getBalancete(filters: any) {
    const list = await this.categoriaFinanceiraRepository.getBalancete(filters);
    return list;
  }
}
export default new CategoriaFinanceiraService();

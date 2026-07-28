import SubCategoriaFinanceira from "../entity/SubCategoriaFinanceira";
import SubCategoriaFinanceiraRepository, { SubCategoriaFinanceiraRepositoryApi } from "../repository/SubCategoriaFinanceiraRepository";
import ToastService from "./ToastService";

class SubCategoriaFinanceiraService {
  subCategoriaFinanceiraRepository: SubCategoriaFinanceiraRepository;
  constructor() {
    this.subCategoriaFinanceiraRepository = new SubCategoriaFinanceiraRepositoryApi();
  }
  async getAllCategoriaWithSubCategoria() {
    const list = await this.subCategoriaFinanceiraRepository.getAllWithSubCategoria();
    return list;
  }
  async getAllByCategoria(codigo_categoria: string) {
    if (codigo_categoria.trim() === "") return;
    const list = await this.subCategoriaFinanceiraRepository.getAllByCategoria(codigo_categoria);
    return list;
  }
  async delete(subCategoriaFinanceira: SubCategoriaFinanceira) {
    await this.subCategoriaFinanceiraRepository.delete(subCategoriaFinanceira);
    ToastService.showSuccess("Categoria deletada com sucesso !");
  }
  async insert(subCategoriaFinanceira: SubCategoriaFinanceira) {
    await this.subCategoriaFinanceiraRepository.insert(subCategoriaFinanceira);
    ToastService.showSuccess("Categoria inserida com sucesso !");
  }
  async update(subCategoriaFinanceira: SubCategoriaFinanceira) {
    await this.subCategoriaFinanceiraRepository.update(subCategoriaFinanceira);
    ToastService.showSuccess("Categoria atualizada com sucesso !");
  }
}
export default new SubCategoriaFinanceiraService();

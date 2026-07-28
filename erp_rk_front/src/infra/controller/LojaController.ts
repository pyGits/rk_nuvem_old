import LojaRepository from "../repository/LojaRepository";

class LojaController {
  async getAll() {
    const res = await LojaRepository.getAll();
  }
}
export default new LojaController();

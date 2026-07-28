import CESTModel from "../../../../../erp_rk_shared/Entity/CESTModel";
import { ICESTRepository } from "../../Repository/CESTRepository";

interface GetCESTInput {
  codigo: string;
}

export default class GetCESTUseCase {
  constructor(private cestRepository: ICESTRepository) {}

  async execute(input: GetCESTInput): Promise<CESTModel | null> {
    return this.cestRepository.getByCodigo(input.codigo);
  }
}

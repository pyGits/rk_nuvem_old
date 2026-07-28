import NCMModel from "../../../../../erp_rk_shared/Entity/NCMModel";
import { INCMRepository } from "../../Repository/NCMRepository";

export interface GetNCMInput {
  codigo: string;
}

export interface GetNCMOutput {
  ncm: NCMModel | null;
}

export default class GetNCMUseCase {
  private ncmRepository: INCMRepository;

  constructor(ncmRepository: INCMRepository) {
    this.ncmRepository = ncmRepository;
  }

  async execute(input: GetNCMInput): Promise<GetNCMOutput> {
    const ncm = await this.ncmRepository.getByCodigo(input.codigo);

    return {
      ncm,
    };
  }
}

import NCMModel from "../../../../../erp_rk_shared/Entity/NCMModel";
import { INCMRepository, ListNCMFilter } from "../../Repository/NCMRepository";

export interface ListNCMInput {
  filter?: ListNCMFilter;
}

export interface ListNCMOutput {
  ncms: NCMModel[];
  total: number;
}

export default class ListNCMUseCase {
  private ncmRepository: INCMRepository;

  constructor(ncmRepository: INCMRepository) {
    this.ncmRepository = ncmRepository;
  }

  async execute(input: ListNCMInput): Promise<ListNCMOutput> {
    const ncms = await this.ncmRepository.getAll(input.filter);

    return {
      ncms,
      total: ncms.length,
    };
  }
}

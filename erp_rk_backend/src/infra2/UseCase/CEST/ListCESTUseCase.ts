import CESTModel from "../../../../../erp_rk_shared/Entity/CESTModel";
import { ICESTRepository, ListCESTFilter } from "../../Repository/CESTRepository";

export interface ListCESTInput {
  filter?: ListCESTFilter;
}

export interface ListCESTOutput {
  cests: CESTModel[];
  total: number;
}

export default class ListCESTUseCase {
  constructor(private cestRepository: ICESTRepository) {}

  async execute(input?: ListCESTInput): Promise<ListCESTOutput> {
    const cests = await this.cestRepository.getAll(input?.filter);

    return {
      cests,
      total: cests.length,
    };
  }
}

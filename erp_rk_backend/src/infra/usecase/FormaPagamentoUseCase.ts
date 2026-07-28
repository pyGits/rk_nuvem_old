import FormaPagamentoFactory from "../entity/Factory.ts/FormaPagamentoFactory";
import FormaPagamentoRepository from "../repository/FormaPagamentoRepository";
import SequencialRepository from "../repository/SequencialRepository";

export default class FormaPagamentoUseCase {
  constructor(readonly formaPagamentoRepository: FormaPagamentoRepository) {}
  async getAll(input: Input): Promise<Output> {
    const res = await this.formaPagamentoRepository.getAll(input.tenant_id);
    return { status: 200, data: res };
  }
  async insert(input: Input): Promise<Output> {
    const formaPagamento = FormaPagamentoFactory.create(input.body);
    formaPagamento.codigo = await SequencialRepository.get("forma_pagamento", "codigo", input.tenant_id);
    await this.formaPagamentoRepository.insert(formaPagamento, input.tenant_id);
    return { status: 201 };
  }
  async update(input: Input): Promise<Output> {
    const formaPagamento = FormaPagamentoFactory.create(input.body);
    await this.formaPagamentoRepository.update(formaPagamento, input.tenant_id);
    return { status: 200 };
  }
  async delete(input: Input): Promise<Output> {
    await this.formaPagamentoRepository.delete(input.codigo, input.tenant_id);
    return { status: 201 };
  }
}

type Input = {
  tenant_id: number;
  body?: any;
  codigo?: string;
};

type Output = {
  status: number;
  data?: any;
};

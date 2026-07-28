import UFs from "@/utils/UF.json";
import Cidades from "@/utils/Cidades.json";
import axios from "axios";
interface Estado {
  sigla: string;
  nome: string;
  cidades: string[];
}

interface Endereco {
  logradouro: string;
  cidade: string;
  uf: string;
  cep: string;
  bairro: string;
  complemento: string;

  // Getters e setters
  getLogradouro(): string;
  setLogradouro(logradouro: string): void;
  getCidade(): string;
  setCidade(cidade: string): void;
  getUf(): string;
  setUf(uf: string): void;
  getCep(): string;
  setCep(cep: string): void;
  getBairro(): string;
  setBairro(bairro: string): void;
  getComplemento(): string;
  setComplemento(complemento: string): void;
}
export default class EnderecoImpl implements Endereco {
  logradouro: string;
  cidade: string;
  uf: string;
  cep: string;
  bairro: string;
  complemento: string;
  listaUFs: Array<string>;
  listaCidades: any;

  constructor() {
    this.logradouro = "";
    this.cidade = "";
    this.uf = "";
    this.cep = "";
    this.bairro = "";
    this.complemento = "";
    this.listaUFs = UFs;
    this.listaCidades = [];
  }

  // Implementação dos getters e setters
  getLogradouro(): string {
    return this.logradouro;
  }

  setLogradouro(logradouro: string): void {
    this.logradouro = logradouro.trim();
    this.logradouro = this.logradouro.substring(0, 80).toUpperCase();
  }

  getCidade(): string {
    return this.cidade;
  }

  setCidade(cidade: string): void {
    this.cidade = cidade.trim();
    this.cidade = this.cidade.substring(0, 40).toUpperCase();
  }

  getUf(): string {
    return this.uf;
  }

  setUf(uf: string): void {
    this.uf = uf.trim();
    this.uf = this.uf.substring(0, 2).toUpperCase();

    // filtrar o array de cidades
    const estadoSelecionado = Cidades.estados.find(
      (estado: Estado) => estado.sigla === this.uf
    );
    this.listaCidades = estadoSelecionado?.cidades.map((cidade) =>
      cidade.toUpperCase()
    );
  }

  getCep(): string {
    return this.cep;
  }

  setCep(cep: string): void {
    this.cep = cep.trim();
    this.cep = this.cep.substring(0, 8).toUpperCase();
    this.cep = this.cep.replace(/[^0-9]/g, "");
  }

  getBairro(): string {
    return this.bairro;
  }

  setBairro(bairro: string): void {
    this.bairro = bairro.trim();
    this.bairro = this.bairro.substring(0, 40).toUpperCase();
  }

  getComplemento(): string {
    return this.complemento;
  }

  setComplemento(complemento: string): void {
    this.complemento = complemento.trim();
    this.complemento = this.complemento.substring(0, 30).toUpperCase();
  }

  async buscarEnderecoPorCep(): Promise<void> {
    const url = `https://viacep.com.br/ws/${this.cep}/json/`;

    try {
      const response: any = await fetch(url);
      const { logradouro, localidade, uf, bairro, complemento } =
        await response.json();

      this.setLogradouro(logradouro);
      this.setUf(uf);
      this.setCidade(localidade);
      this.setBairro(bairro);
      this.setComplemento(complemento);
    } catch (error) {
      this.setCep("");
      this.setLogradouro("");
      this.setUf("");
      this.setCidade("");
      this.setBairro("");
      this.setComplemento("");
      throw new Error("Não foi possível buscar o endereço pelo CEP informado.");
    }
  }
}

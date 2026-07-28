import { validarCpfCnpj, validarEmail } from "@/utils/validate";
import Vue from "vue";
const store = Vue.prototype.$store;

interface Pessoa {
  nome: string;
  cnpjcpf: string;
  fantasia: string;
  ierg: string;
  telefone: string;
  telefone2: string;
  celular: string;
  email: string;

  // Getters e setters
  getNome(): string;
  setNome(nome: string): void;
  getCnpjcpf(): string;
  setCnpjcpf(cnpjcpf: string): void;
  getFantasia(): string;
  setFantasia(fantasia: string): void;
  getIerg(): string;
  setIerg(ierg: string): void;
  getTelefone(): string;
  setTelefone(telefone: string): void;
  getTelefone2(): string;
  setTelefone2(telefone2: string): void;
  getCelular(): string;
  setCelular(celular: string): void;
  getEmail(): string;
  setEmail(email: string): void;
}

export default class PessoaImpl implements Pessoa {
  nome: string;
  cnpjcpf: string;
  fantasia: string;
  ierg: string;
  telefone: string;
  telefone2: string;
  celular: string;
  email: string;

  constructor() {
    this.nome = "";
    this.cnpjcpf = "";
    this.fantasia = "";
    this.ierg = "";
    this.telefone = "";
    this.telefone2 = "";
    this.celular = "";
    this.email = "";
  }

  getNome(): string {
    return this.nome;
  }

  setNome(nome: string): void {
    this.nome = nome.toUpperCase();
    this.nome = this.nome.substring(0, 80);
    this.fantasia = this.nome;
  }

  getCnpjcpf(): string {
    return this.cnpjcpf;
  }

  setCnpjcpf(cnpjcpf: string): void {
    this.cnpjcpf = cnpjcpf;
    this.cnpjcpf = cnpjcpf.replace(/[^0-9]/g, "");
    this.cnpjcpf = this.cnpjcpf.substring(0, 14);
  }

  getFantasia(): string {
    return this.fantasia;
  }

  setFantasia(fantasia: string): void {
    this.fantasia = fantasia.toUpperCase();
    this.fantasia = this.fantasia.substring(0, 60);
  }

  getIerg(): string {
    return this.ierg;
  }

  setIerg(ierg: string): void {
    this.ierg = ierg;
    this.ierg = this.ierg.replace(/[^0-9]/g, "");
    this.ierg = this.ierg.substring(0, 20);
  }

  getTelefone(): string {
    return this.telefone;
  }

  setTelefone(telefone: string): void {
    this.telefone = telefone;
    this.telefone = this.telefone.replace(/[^0-9]/g, "");
    this.telefone = this.telefone.substring(0, 12);
  }
  getTelefone2(): string {
    return this.telefone;
  }

  setTelefone2(telefone2: string): void {
    this.telefone2 = telefone2;
    this.telefone2 = this.telefone2.replace(/[^0-9]/g, "");
    this.telefone2 = this.telefone2.substring(0, 12);
  }

  getCelular(): string {
    return this.celular;
  }

  setCelular(celular: string): void {
    this.celular = celular;
    this.celular = this.celular.replace(/[^0-9]/g, "");
    this.celular = this.celular.substring(0, 12);
  }

  getEmail(): string {
    return this.email;
  }

  setEmail(email: string): void {
    this.email = email;
    this.email = this.email.replace(/\s+/g, "");
    this.email = this.email.substring(0, 80);
  }

  validaCNPJCPF() {
    const isValid = validarCpfCnpj(this.cnpjcpf);
    if (!isValid) {
      this.cnpjcpf = "";
    }
    return isValid;
  }
  validaEmail() {
    let isValid = false;
    if (this.email.trim() != "") {
      isValid = validarEmail(this.email);
    } else {
      isValid = true;
    }
    return isValid;
  }
}

import LojaModel from "./LojaModel";

export default class LojaCollectionModel {
  items: LojaModel[];
  constructor(public lojas: LojaModel[] = []) {
    this.items = lojas;
  }
}

export default class Sequencial {
  static encontrarProximoCodigoDisponivel(codigos: unknown[]): number {
    for (let i = 1; i <= codigos.length + 1; i++) {
      const encontrado = codigos.some(c => Number(c) === i);
      if (!encontrado) {
        return i;
      }
    }
    return codigos.length + 1;
  }
}

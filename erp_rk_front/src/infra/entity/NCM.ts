import NCMJson from '@/utils/NCM.json';

export default class NCM {
  static list() {
    return NCMJson.Nomenclaturas;
  }

  static findByNCM(ncm:string){
    const items = this.list();
  
    const ncmSearch = ncm.replace(/\D/g, '').padStart(8, '0');
  
    const matchedItem = items.find((item) => {
      const ncmItem = String(item.Codigo).replace(/\D/g, '').padStart(8, '0');
  
      return ncmItem === ncmSearch;
    });
  
    return matchedItem || null; // Retorna null se não encontrar
  }

  static filter(search:string) {
    const items = this.list();

    return items.filter((ncm) => {
      const codigoSemPonto = ncm.Codigo.replace(/\./g, '');
      return (
        codigoSemPonto.toLowerCase().includes(search.toLowerCase()) ||
        ncm.Descricao.toLowerCase().includes(search.toLowerCase())
      );
    });
  }
}

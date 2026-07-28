import CESTJson from '@/utils/CEST.json';

export default class CEST {
  static list() {
    return CESTJson;
  }

  static filter(search: string) {
    const items = this.list();
  
    const filteredItems = items.filter((item) => {
      const codigoSemPonto = String(item.CEST).replace(/\./g, '');
      return (
        codigoSemPonto.toLowerCase().includes(search.toLowerCase()) ||
        item.DESCRICAO.toLowerCase().includes(search.toLowerCase())
      );
    });
  
    return filteredItems;
  }
  static filterByNcmAndCest(ncm: string, cest: string) {
    const items = this.list();
  
    const ncmSearch = ncm.replace(/\D/g, '').padStart(8, '0');
    const cestSearch = cest.replace(/\D/g, '').padStart(7, '0'); // CEST geralmente tem 7 dígitos
  
    const matchedItem = items.find((item) => {
      const ncmItem = String(item.NCM).replace(/\D/g, '').padStart(8, '0');
      const cestItem = String(item.CEST).replace(/\D/g, '').padStart(7, '0');
  
      return ncmItem === ncmSearch && cestItem === cestSearch;
    });
  
    return matchedItem || null; // Retorna null se não encontrar
  }

  static filterByNCM(ncm: string) {
    const items = this.list();
  
    // Remove tudo que não for número e adiciona zeros à esquerda até 8 dígitos
    const ncmSearch = ncm.replace(/\D/g, '').padStart(8, '0');
  
  
    const filteredItems = items.filter((item) => {
      const ncmItem = String(item.NCM).replace(/\D/g, '').padStart(8, '0');
      return ncmItem.includes(ncmSearch);
    });
  
    return filteredItems;
  }
  
  
}

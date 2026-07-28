import Finalizadora from "../models/Finalizadora";
import Funcionario from "../models/Funcionario";
import Preco from "../models/Preco";
import Produto from "../models/Produto";
import Tributacao from "../models/Tributacao";

let cargaList: object[] = [];
export default {
  async verificaCargaStatus(req: any, res: any) {
    res.status(200).json(cargaList);
  },

  async finalizaCarga(req: any, res: any) {
    const { tenant_id } = req;
    const loja = req.query.loja;
    try {
      Produto.update({ carga_pendente: false }, { where: { tenant_id }, silent: true });
      Preco.update({ carga_pendente: false }, { where: { tenant_id, loja: loja }, silent: true });
      Finalizadora.update({ carga_pendente: false }, { where: { tenant_id } });
      Funcionario.update({ carga_pendente: false }, { where: { tenant_id } });
      Tributacao.update({ carga_pendente: false }, { where: { tenant_id } });
      res.status(200).json({ message: "Carga finalizada" });
    } catch (error) {
      res.status(400).json({ message: "Erro ao finalizar carga" });
    }
  },

  async enviaCargaCompleta(req: any, res: any) {
    const { tenant_id } = req;
    const lojas = req.body;
    lojas.map((l: any) => {
      //adiciona token somente se não existir no array
      if (!cargaList.some((c: any) => c.codigo === l.codigo && c.tenant_id === tenant_id)) {
        cargaList.push({
          tenant_id: tenant_id,
          codigo: l.codigo,
          carga: "COMPLETA",
        });
      }
    });
    res.status(200).json({ message: "Carga Solicitada !" });
  },
  async enviaCargaAlterados(req: any, res: any) {
    const { tenant_id } = req;
    const lojas = req.body;
    lojas.map((l: any) => {
      //adiciona token somente se não existir no array
      if (!cargaList.some((c: any) => c.codigo === l.codigo && c.tenant_id === tenant_id)) {
        cargaList.push({
          tenant_id: tenant_id,
          codigo: l.codigo,
          carga: "ALTERADOS",
        });
      }
    });
    res.status(200).json({ message: "Carga Solicitada !" });
  },

  async verificaCarga(req: any, res: any) {
    const { tenant_id } = req;
    const loja = req.params.loja;
    const isCargaPendenteCompleta = cargaList.find((c: any) => c.codigo === loja.toString() && c.tenant_id === tenant_id && c.carga === "COMPLETA");

    const isCargaPendenteAlterados = cargaList.find((c: any) => c.codigo === loja.toString() && c.tenant_id === tenant_id && c.carga === "ALTERADOS");

    const index = cargaList.findIndex((c: any) => c.codigo === loja.toString() && c.tenant_id === tenant_id);

    if (isCargaPendenteCompleta || isCargaPendenteAlterados) {
      if (index !== -1) {
        cargaList.splice(index, 1);
      }
      if (isCargaPendenteAlterados) {
        res.status(200).json({ message: "CARGA_ALTERADOS" });
      }
      if (isCargaPendenteCompleta) {
        res.status(200).json({ message: "CARGA_COMPLETA" });
      }
    } else {
      res.status(200).json({ message: "CARGA_NADA" });
    }
  },
};

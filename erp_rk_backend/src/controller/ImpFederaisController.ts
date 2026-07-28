import ImpFederais from "../models/ImpFederais";
import { getNextSequencial } from "./UtilsController";

export default {
    async insertImpFederal(req: any, res: any) {
      const { tenant_id } = req;
      const { codigo, nome, pis, cofins, cstEntrada, cstSaida } = req.body;
      try {
        await ImpFederais.create({ codigo: codigo, nome: nome, pis, cofins, cstEntrada, cstSaida , tenant_id: tenant_id });
        res.status(201).json({ message: "Imposto Federal Criado com sucesso!" });
      } catch (error) {
        res.status(400).json({ message: "Erro ao criar imposto federal: " + error });
      }
    },
    async updateImpFederal(req: any, res: any) {
      const { tenant_id } = req;
      const { codigo, nome, pis, cofins, cstEntrada, cstSaida } = req.body;
  
      await ImpFederais.update(
        { nome, pis, cofins, cstEntrada, cstSaida  },
        { where: { codigo: codigo, tenant_id: tenant_id } }
      );
  
      res.status(200).json({ message: "Imp Federal atualizada com sucesso !" });
    },
  

    async getImpFederais(req:any,res:any){
        const { tenant_id } = req;

        const impfederais = await ImpFederais.findAll({
          where: { tenant_id: tenant_id },
          order: [["codigo", "ASC"]],
        });
    
        res.status(200).json(impfederais);
    },


    async getImpFederal(req:any,res:any){
      const {tenant_id} = req;
      const codigo = req.params.codigo;

      if (codigo === "novo") {
        const sequencial = await getNextSequencial("imp_federais", "codigo", tenant_id);
        return res.status(200).json({ codigo: sequencial });
      } else {
        const secao = await ImpFederais.findOne({
          where: { codigo: codigo, tenant_id: tenant_id },
        });
        return res.status(200).json(secao);
      }
    }
}
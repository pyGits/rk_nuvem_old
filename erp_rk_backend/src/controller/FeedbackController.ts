import { QueryTypes } from "sequelize";
import sequelize from "../database/config";
import Feedback from "../models/Feedback";

export default {
  // Cliente logado envia o feedback.
  async enviar(req: any, res: any) {
    const { tenant_id } = req;
    const { mensagem, nota } = req.body;

    if (!mensagem || !mensagem.trim()) {
      return res.status(400).json({ message: "Escreva sua sugestão antes de enviar" });
    }

    try {
      await Feedback.create({
        tenant_id,
        mensagem: mensagem.trim(),
        nota: nota || null,
      });
      res.status(201).json({ message: "Feedback enviado, obrigado!" });
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: "Não foi possível enviar o feedback" });
    }
  },

  // Painel administrativo lê os feedbacks de todos os tenants.
  async listar(req: any, res: any) {
    try {
      const feedbacks = await sequelize.query(
        `
        SELECT f.id, f.mensagem, f.nota, f.lido, f.created_at,
               t.name AS tenant_nome, t.cnpjcpf AS tenant_cnpjcpf
        FROM feedbacks f
        LEFT JOIN tenants t ON t.id = f.tenant_id
        ORDER BY f.lido ASC, f.created_at DESC
        `,
        { type: QueryTypes.SELECT }
      );
      res.status(200).json(feedbacks);
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: "Erro ao listar os feedbacks" });
    }
  },

  async marcarLido(req: any, res: any) {
    try {
      const { id } = req.params;
      await Feedback.update({ lido: true }, { where: { id } });
      res.status(200).json({ message: "Feedback marcado como lido" });
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: "Erro ao atualizar o feedback" });
    }
  },
};

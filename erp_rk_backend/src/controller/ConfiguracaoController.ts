import Configuracao from "../models/Configuracao";
import { esqueceConfiguracao, normalizaJanelaSegundos } from "../infra/service/CargaAutomatica";

// Configurações do cliente (tela "Configurações do Sistema").
//
// A LEITURA é aberta a qualquer usuário logado de propósito: a tela de carga
// mostra "carga automática ligada" para explicar por que a carga aparece
// sozinha, e quem não é o login principal também precisa ver isso. Não há nada
// sensível aqui.
//
// A GRAVAÇÃO é do dono (somentePrincipal, na rota): mandar carga para o parque
// de lojas sozinho é decisão de quem responde pela empresa.

// Cliente que nunca abriu a tela não tem linha na tabela — e isso é o
// desligado. Devolver o default em vez de 404 deixa o front com um caminho só.
const PADRAO = {
  carga_automatica: false,
  carga_automatica_segundos: 60,
};

function paraResposta(registro: any) {
  if (!registro) return { ...PADRAO };

  return {
    carga_automatica: registro.getDataValue("carga_automatica") === true,
    carga_automatica_segundos: normalizaJanelaSegundos(
      registro.getDataValue("carga_automatica_segundos")
    ),
  };
}

export default {
  async getConfiguracao(req: any, res: any) {
    const { tenant_id } = req;

    const registro = await Configuracao.findOne({ where: { tenant_id } });
    res.status(200).json(paraResposta(registro));
  },

  async updateConfiguracao(req: any, res: any) {
    const { tenant_id } = req;
    const carga_automatica = req.body?.carga_automatica === true;
    const carga_automatica_segundos = normalizaJanelaSegundos(req.body?.carga_automatica_segundos);

    const registro: any = await Configuracao.findOne({ where: { tenant_id } });

    if (registro) {
      await Configuracao.update(
        { carga_automatica, carga_automatica_segundos },
        { where: { tenant_id } }
      );
    } else {
      await Configuracao.create({ tenant_id, carga_automatica, carga_automatica_segundos });
    }

    // Sem isto, ligar ou desligar só valeria depois que o cache do serviço
    // expirasse — e "desliguei e continuou mandando carga" é exatamente o tipo
    // de coisa que ninguém liga a um cache.
    esqueceConfiguracao(Number(tenant_id));

    console.log(
      `[CARGA][AUTO] configuracao gravada tenant=${tenant_id} ` +
        `ligada=${carga_automatica} janela=${carga_automatica_segundos}s`
    );

    res.status(200).json({
      message: "Configurações salvas com sucesso!",
      carga_automatica,
      carga_automatica_segundos,
    });
  },
};

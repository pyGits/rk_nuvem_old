import { LojaRepositoryPG } from "../../repository/LojaRepository";
import SefazService from "./SefazService";

/**
 * Agendador que sincroniza automaticamente as notas de entrada na SEFAZ, sem
 * precisar que ninguém abra a tela. Roda no boot e a cada intervalo configurado
 * (padrão 1 hora, conforme recomendação da SEFAZ para Distribuição de DFe).
 *
 * Sincroniza apenas lojas que:
 *  - possuem certificado + senha + UF cadastrados;
 *  - cujo certificado NÃO está vencido;
 *  - cuja última sincronização já passou do intervalo mínimo (throttle).
 */
export class SefazScheduler {
  private timer: NodeJS.Timeout | null = null;
  private rodando = false;
  private readonly lojaRepository = new LojaRepositoryPG();

  private intervaloMs(): number {
    return Number(process.env.SEFAZ_SYNC_INTERVAL_MS || 60 * 60 * 1000); // 1h
  }

  start() {
    if (String(process.env.SEFAZ_SCHEDULER_ENABLED || "true").toLowerCase() === "false") {
      console.log("⏸️  Agendador SEFAZ desativado (SEFAZ_SCHEDULER_ENABLED=false)");
      return;
    }
    const intervalo = this.intervaloMs();
    console.log(`⏰ Agendador SEFAZ ativo — sincroniza a cada ${Math.round(intervalo / 60000)} min`);

    // Primeira execução pouco depois do boot; depois, periodicamente.
    setTimeout(() => this.executar(), 30_000);
    this.timer = setInterval(() => this.executar(), intervalo);
  }

  stop() {
    if (this.timer) clearInterval(this.timer);
    this.timer = null;
  }

  async executar() {
    if (this.rodando) return; // evita sobreposição de execuções
    this.rodando = true;
    try {
      const lojas = await this.lojaRepository.getLojasParaSincronizarGlobal(this.intervaloMs());
      if (lojas.length === 0) return;
      console.log(`⏰ SEFAZ: sincronizando ${lojas.length} loja(s)...`);

      for (const loja of lojas) {
        try {
          const { ultimoNsu, novos } = await SefazService.sincronizarDistribuicao(loja);
          await this.lojaRepository.atualizarSincronizacao(loja.codigo, loja.tenant_id, ultimoNsu);
          if (novos > 0) console.log(`   loja ${loja.codigo} (tenant ${loja.tenant_id}): ${novos} nota(s) nova(s)`);
        } catch (error: any) {
          console.error(`   loja ${loja.codigo} (tenant ${loja.tenant_id}) falhou:`, error?.message || error);
        }
      }
    } catch (error) {
      console.error("Erro no agendador SEFAZ:", error);
    } finally {
      this.rodando = false;
    }
  }
}

export default new SefazScheduler();

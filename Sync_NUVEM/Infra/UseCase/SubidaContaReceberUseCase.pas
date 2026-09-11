unit SubidaContaReceberUseCase;

interface
uses System.Generics.Collections, ContaReceberRetaguardaRepository, ContaReceber;

type TSubidaContaReceberUseCase = class
  private
  FContaReceberRepository:IContaReceberRetaguardaRepository;
  // Ultimo resumo mostrado. A etapa era muda quando nao achava nada, e ai
  // "nenhum titulo pendente" e "o titulo nem chegou ao servidor" ficavam
  // indistinguiveis - nao dava para saber onde olhar. So aparece quando o
  // resumo muda, senao seriam doze linhas por minuto.
  FUltimoResumo:string;
  procedure resumir(titulos, enviados: integer);
  public
  procedure Executar;
  constructor create;
end;

implementation

uses System.SysUtils, uAPIRequest, uLogErro;

{ TSubidaContaReceberUseCase }

constructor TSubidaContaReceberUseCase.create;
begin
  FContaReceberRepository := TContaReceberRetaguardaRepository.create;
end;

// Sobe os titulos de convenio a partir de CONTAS_RECEBER, no banco do servidor.
// Mesmo contrato das demais subidas: le o que esta com NUVEM = 0, envia, e so
// marca NUVEM = 1 quando a nuvem confirma - se o POST falhar, o titulo volta no
// proximo ciclo.
//
// Antes a leitura era feita caixa a caixa, no CUPOM_CREDIARIO de cada PDV. Com
// a origem no servidor, caixa desligado ou fora da rede deixou de atrasar a
// subida, e o ciclo nao paga mais um timeout de conexao por PDV. Em troca, o
// titulo so aparece aqui depois que o RK_Sync o leva para o servidor.
procedure TSubidaContaReceberUseCase.Executar;
var
  titulos:TObjectList<TContaReceber>;
  titulo:TContaReceber;
  totalEnviados:integer;
begin
  totalEnviados := 0;

  try
    FContaReceberRepository.garantirColunaNuvem;

    uLogErro.Atividade('Procurando convenio pendente no servidor...');

    titulos := FContaReceberRepository.getPendentes;
    try
      if titulos.Count > 0 then
      begin
        uLogErro.Progresso(Format('CONTA_RECEBER: %d titulo(s) pendente(s)',
          [titulos.Count]));
        uLogErro.Atividade(Format('Enviando convenio (%d)...', [titulos.Count]));
      end;

      for titulo in titulos do
      begin
        if uAPIRequest.postContaReceber(titulo) then
        begin
          FContaReceberRepository.marcarEnviado(titulo.codigo, titulo.codigo_cupom);
          Inc(totalEnviados);
        end;
      end;

      resumir(titulos.Count, totalEnviados);
    finally
      titulos.Free;
    end;
  except
  on E:Exception do
  begin
    uLogErro.LogErro('SUBIDA_CONTA_RECEBER',
      Format('%s: %s', [E.ClassName, E.Message]));
  end;
  end;
end;

procedure TSubidaContaReceberUseCase.resumir(titulos, enviados: integer);
var
  resumo:string;
begin
  resumo := Format('titulos=%d enviados=%d', [titulos, enviados]);
  if resumo = FUltimoResumo then Exit;

  FUltimoResumo := resumo;

  uLogErro.Progresso('CONTA_RECEBER: ' + resumo);
  uLogErro.LogErro('CONTA_RECEBER_RESUMO', resumo);
end;

end.

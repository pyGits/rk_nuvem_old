unit SubidaContaReceberUseCase;

interface
uses CaixaRepository, CaixaModel, System.Generics.Collections,
     ContaReceberPDVRepository, ContaReceber;

type TSubidaContaReceberUseCase = class
  private
  FCaixaRepository:ICaixaRepository;
  FContaReceberPDVRepository:IContaReceberPDVRepository;
  // Ultimo resumo mostrado. A etapa era muda quando nao achava nada, e ai
  // "nenhum caixa cadastrado", "caixa sem titulo pendente" e "o titulo nem foi
  // gravado no PDV" ficavam indistinguiveis - nao dava para saber onde olhar.
  // So aparece quando o resumo muda, senao seriam doze linhas por minuto.
  FUltimoResumo:string;
  procedure resumir(caixas, titulos, enviados: integer);
  public
  procedure Executar;
  constructor create;
end;

implementation

uses System.SysUtils, uAPIRequest, uLogErro;

{ TSubidaContaReceberUseCase }

constructor TSubidaContaReceberUseCase.create;
begin
  FCaixaRepository := TCaixaRepository.create;
  FContaReceberPDVRepository := TContaReceberPDVRepository.create;
end;

// Sobe os titulos de convenio de cada PDV. Mesmo contrato das demais subidas:
// le o que esta com NUVEM = 0, envia, e so marca NUVEM = 1 quando a nuvem
// confirma - se o POST falhar, o titulo volta no proximo ciclo.
procedure TSubidaContaReceberUseCase.Executar;
var
  caixas:TObjectList<TCaixaModel>;
  caixa:TCaixaModel;
  titulos:TObjectList<TContaReceber>;
  titulo:TContaReceber;
  totalTitulos:integer;
  totalEnviados:integer;
begin
  totalTitulos := 0;
  totalEnviados := 0;

  caixas := FCaixaRepository.getAll;
  try
    // uma caixa fora do ar nao pode impedir a subida das demais
    for caixa in caixas do
    begin
      try
        // um caixa fora do ar demora ate o timeout da conexao: sem isso o
        // agente parece parado justamente na espera mais longa do ciclo
        uLogErro.Atividade(Format('Lendo convenio do caixa %s (%s)...', [caixa.codigo, caixa.ip]));

        FContaReceberPDVRepository.garantirColunaNuvem(caixa);

        titulos := FContaReceberPDVRepository.getPendentes(caixa);
        try
          Inc(totalTitulos, titulos.Count);

          if titulos.Count > 0 then
          begin
            uLogErro.Progresso(Format('CONTA_RECEBER: %d titulo(s) no caixa %s',
              [titulos.Count, caixa.codigo]));
            uLogErro.Atividade(Format('Enviando convenio do caixa %s (%d)...',
              [caixa.codigo, titulos.Count]));
          end;

          for titulo in titulos do
          begin
            // cupom orfao (sem o cabecalho gravado) nao tem COD_CAIXA: usa o
            // caixa que esta sendo lido.
            if Trim(titulo.caixa) = '' then
              titulo.caixa := caixa.codigo;

            if uAPIRequest.postContaReceber(titulo) then
            begin
              FContaReceberPDVRepository.marcarEnviado(caixa, titulo.codigo);
              Inc(totalEnviados);
            end;
          end;
        finally
          titulos.Free;
        end;
      except
      on E:Exception do
      begin
        uLogErro.LogErro('SUBIDA_CONTA_RECEBER_PDV',
          Format('Caixa %s (%s) | %s: %s', [caixa.codigo, caixa.ip, E.ClassName, E.Message]));
      end;
      end;
    end;
    resumir(caixas.Count, totalTitulos, totalEnviados);
  finally
    caixas.Free;
  end;
end;

procedure TSubidaContaReceberUseCase.resumir(caixas, titulos, enviados: integer);
var
  resumo:string;
begin
  resumo := Format('caixas=%d titulos=%d enviados=%d', [caixas, titulos, enviados]);
  if resumo = FUltimoResumo then Exit;

  FUltimoResumo := resumo;

  uLogErro.Progresso('CONTA_RECEBER: ' + resumo);
  uLogErro.LogErro('CONTA_RECEBER_RESUMO', resumo);

  // Sem caixa na lista o laco inteiro nao roda e nada e sequer tentado. E o
  // unico caso em que o problema esta na retaguarda, e nao no PDV.
  if caixas = 0 then
    uLogErro.Progresso(
      'CONTA_RECEBER: nenhum caixa cadastrado na retaguarda - a subida de ' +
      'convenio nao tem onde procurar');
end;

end.

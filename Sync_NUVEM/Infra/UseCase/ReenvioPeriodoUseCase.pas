unit ReenvioPeriodoUseCase;

interface
uses CaixaRepository, CaixaModel, System.Generics.Collections,
     ContaReceberPDVRepository;

// Reenvio manual de um periodo que ja subiu.
//
// Ate aqui, venda que subiu errada - ou que nunca subiu porque o agente da loja
// era anterior a alguma etapa - so voltava para a nuvem com UPDATE na mao no
// banco do cliente. Aqui o operador informa o periodo e o proprio agente
// devolve aquelas linhas para a fila.
//
// Nao existe caminho paralelo de envio: tudo o que este use case faz e zerar o
// NUVEM. Quem sobe continua sendo o ciclo do timer, com o mesmo contrato de
// sempre - le pendentes, envia, marca so o que a nuvem confirmou. Por isso o
// reenvio nao tem como duplicar registro nem furar a ordem das etapas, e um
// periodo grande escoa aos poucos em vez de segurar o agente.
//
// Duas origens, porque sao dois bancos: CUPOM/CUPOM_ITEM/CUPOM_FORMA ficam na
// retaguarda, e CUPOM_CREDIARIO (o convenio) so existe no banco de cada PDV.
type TReenvioPeriodoUseCase = class
  private
  FCaixaRepository:ICaixaRepository;
  FContaReceberPDVRepository:IContaReceberPDVRepository;
  function reenviarConvenio(dtInicio, dtFim: TDate): Integer;
  public
  // Devolve o total de linhas devolvidas para a fila.
  function Executar(dtInicio, dtFim: TDate): Integer;
  constructor create;
end;

implementation

uses System.SysUtils, uDmVenda, uLogErro;

{ TReenvioPeriodoUseCase }

constructor TReenvioPeriodoUseCase.create;
begin
  FCaixaRepository := TCaixaRepository.create;
  FContaReceberPDVRepository := TContaReceberPDVRepository.create;
end;

// Uma caixa fora do ar nao pode impedir o reenvio das demais - mesmo criterio
// da subida de convenio.
function TReenvioPeriodoUseCase.reenviarConvenio(dtInicio, dtFim: TDate): Integer;
var
  caixas:TObjectList<TCaixaModel>;
  caixa:TCaixaModel;
  afetados:Integer;
begin
  Result := 0;

  caixas := FCaixaRepository.getAll;
  try
    for caixa in caixas do
    begin
      try
        uLogErro.Atividade(Format('Reenvio: marcando convenio do caixa %s (%s)...',
          [caixa.codigo, caixa.ip]));

        afetados := FContaReceberPDVRepository.marcarPeriodoParaReenvio(caixa, dtInicio, dtFim);
        Inc(Result, afetados);

        if afetados > 0 then
          uLogErro.Progresso(Format('REENVIO: %d titulo(s) de convenio no caixa %s',
            [afetados, caixa.codigo]));
      except
      on E:Exception do
        uLogErro.LogErro('REENVIO_CONVENIO',
          Format('Caixa %s (%s) | %s: %s', [caixa.codigo, caixa.ip, E.ClassName, E.Message]));
      end;
    end;
  finally
    caixas.Free;
  end;
end;

function TReenvioPeriodoUseCase.Executar(dtInicio, dtFim: TDate): Integer;
var
  vendas:Integer;
  convenio:Integer;
begin
  vendas := uDmVenda.dmVenda.marcarPeriodoParaReenvio(dtInicio, dtFim);
  convenio := reenviarConvenio(dtInicio, dtFim);

  Result := vendas + convenio;

  uLogErro.Progresso(Format(
    'REENVIO %s a %s: %d linha(s) de venda e %d de convenio voltaram para a fila',
    [DateToStr(dtInicio), DateToStr(dtFim), vendas, convenio]));
end;

end.

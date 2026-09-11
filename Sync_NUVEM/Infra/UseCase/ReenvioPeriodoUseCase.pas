unit ReenvioPeriodoUseCase;

interface
uses ContaReceberRetaguardaRepository;

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
// Tudo no mesmo banco, o do servidor: CUPOM/CUPOM_ITEM/CUPOM_FORMA e tambem o
// convenio, que passou a ser lido de CONTAS_RECEBER e nao mais do
// CUPOM_CREDIARIO de cada PDV.
type TReenvioPeriodoUseCase = class
  private
  FContaReceberRepository:IContaReceberRetaguardaRepository;
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
  FContaReceberRepository := TContaReceberRetaguardaRepository.create;
end;

// Falha no convenio nao pode derrubar o reenvio da venda, que ja foi marcada
// quando se chega aqui: o que der errado fica no log e o operador repete.
function TReenvioPeriodoUseCase.reenviarConvenio(dtInicio, dtFim: TDate): Integer;
begin
  Result := 0;

  try
    uLogErro.Atividade('Reenvio: marcando convenio no servidor...');

    Result := FContaReceberRepository.marcarPeriodoParaReenvio(dtInicio, dtFim);

    if Result > 0 then
      uLogErro.Progresso(Format('REENVIO: %d titulo(s) de convenio', [Result]));
  except
  on E:Exception do
    uLogErro.LogErro('REENVIO_CONVENIO', Format('%s: %s', [E.ClassName, E.Message]));
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
